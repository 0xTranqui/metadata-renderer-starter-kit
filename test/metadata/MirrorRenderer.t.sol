// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {MirrorRenderer} from "../../src/metadata/MirrorRenderer.sol";
import {EditionMetadataRenderer} from "../../src/metadata/EditionMetadataRenderer.sol";
import {MetadataRenderAdminCheck} from "../../src/metadata/MetadataRenderAdminCheck.sol";
import {IMetadataRenderer} from "../../src/interfaces/IMetadataRenderer.sol";
import {DropMockBase} from "./DropMockBase.sol";
import {IERC721Drop} from "../../src/interfaces/IERC721Drop.sol";
import {Test} from "forge-std/Test.sol";
import {console2} from "forge-std/Console2.sol";

contract IERC721OnChainDataMock {
    IERC721Drop.SaleDetails private saleDetailsInternal;
    IERC721Drop.Configuration private configInternal;

    constructor(uint256 totalMinted, uint256 maxSupply, address metadataRenderer) {
        saleDetailsInternal = IERC721Drop.SaleDetails({
            publicSaleActive: false,
            presaleActive: false,
            publicSalePrice: 0,
            publicSaleStart: 0,
            publicSaleEnd: 0,
            presaleStart: 0,
            presaleEnd: 0,
            presaleMerkleRoot: 0x0000000000000000000000000000000000000000000000000000000000000000,
            maxSalePurchasePerAddress: 0,
            totalMinted: totalMinted,
            maxSupply: maxSupply
        });

        configInternal = IERC721Drop.Configuration({
            metadataRenderer: IMetadataRenderer(metadataRenderer),
            editionSize: 12,
            royaltyBPS: 1000,
            fundsRecipient: payable(address(0x163))
        });
    }

    function name() external returns (string memory) {
        return "MOCK NAME";
    }

    function saleDetails() external returns (IERC721Drop.SaleDetails memory) {
        return saleDetailsInternal;
    }

    function config() external returns (IERC721Drop.Configuration memory) {
        return configInternal;
    }
    
    function contractURI() external returns (string memory) {
        return configInternal.metadataRenderer.contractURI();
    }

    function tokenURI(uint256 tokenId) external returns (string memory) {
        return configInternal.metadataRenderer.tokenURI(tokenId);
    }
}

contract MirrorRendererTest is Test {
    // edition metadata renderer
    EditionMetadataRenderer public editionRenderer =
        new EditionMetadataRenderer();        

    string editionContractURI;
    string editionTokenURI;

    // mirror renderer
    MirrorRenderer public mirrorRenderer =
        new MirrorRenderer();

    IERC721OnChainDataMock mock = new IERC721OnChainDataMock({
        totalMinted: 10,
        maxSupply: type(uint64).max,
        metadataRenderer: address(editionRenderer)
    });

    function setUp() public {
        vm.startPrank(address(mock));        
        editionRenderer.initializeWithData(
            abi.encode("Description", "image", "animation")
        );             
        
        editionContractURI = editionRenderer.contractURI();
        editionTokenURI = editionRenderer.tokenURI(1);
        vm.stopPrank();     
    }

    function test_MirrorMetadataInits() public {

        // setting up mock for mirror renderer
        IERC721OnChainDataMock mock2 = new IERC721OnChainDataMock({
            totalMinted: 10,
            maxSupply: type(uint64).max,
            metadataRenderer: address(mirrorRenderer)
        });   

        vm.startPrank(address(mock2));
        bytes memory data = abi.encode(
            address(mock)
        );
        mirrorRenderer.initializeWithData(data);
        (address contractToTrack) = mirrorRenderer.tokenInfos(address(mock2));
        require(contractToTrack == address(mock), "we didnt initialize stuff correctly");
    }

    function test_ContractURI() public {
        // setting up mock for mirror renderer
        IERC721OnChainDataMock mock2 = new IERC721OnChainDataMock({
            totalMinted: 10,
            maxSupply: type(uint64).max,
            metadataRenderer: address(mirrorRenderer)
        });     

        vm.startPrank(address(mock2));
        bytes memory data = abi.encode(
            address(mock)
        );
        mirrorRenderer.initializeWithData(data);
        vm.stopPrank();
        vm.startPrank(address(0x123));
        require(keccak256(bytes(mock2.contractURI())) == keccak256(bytes(mock.contractURI())), "not tracked correctly");
    }    

    function test_TokenURI() public {
        // setting up mock for mirror renderer
        IERC721OnChainDataMock mock2 = new IERC721OnChainDataMock({
            totalMinted: 10,
            maxSupply: type(uint64).max,
            metadataRenderer: address(mirrorRenderer)
        });     

        vm.startPrank(address(mock2));
        bytes memory data = abi.encode(
            address(mock)
        );
        mirrorRenderer.initializeWithData(data);
        vm.stopPrank();
        vm.startPrank(address(0x123));
        require(keccak256(bytes(mock2.tokenURI(1))) == keccak256(bytes(mock.tokenURI(1))), "not tracked correctly");
    }        
}
