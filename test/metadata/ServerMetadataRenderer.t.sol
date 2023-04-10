// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {ServerMetadataRenderer} from "../../src/metadata/ServerMetadataRenderer.sol";
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

contract ServerMetadataRendererTest is Test {
    // Server renderer set-up
    ServerMetadataRenderer public serverRenderer =
        new ServerMetadataRenderer();           

    string contractURI_Route;
    string tokenURI_Route;
    bytes initData;

    IERC721OnChainDataMock mock = new IERC721OnChainDataMock({
        totalMinted: 10,
        maxSupply: type(uint64).max,
        metadataRenderer: address(serverRenderer)
    });
    
    function setUp() public {
        vm.startPrank(address(mock));   
        contractURI_Route = "contractURI_Route/";
        tokenURI_Route = "tokenURI_Route/";      
        initData = abi.encode(
            contractURI_Route,
            tokenURI_Route
        );               
        serverRenderer.initializeWithData(initData);
        vm.stopPrank();     
    }

    function test_URIs(uint256 tokenId) public {  
        vm.startPrank(address(0x123));
        contractURI_Route = "contractURI_Route/";
        tokenURI_Route = "tokenURI_Route/";   
        require(keccak256(bytes(mock.contractURI())) == keccak256(bytes(contractURI_Route)), "not tracked correctly");
        require(keccak256(bytes(mock.tokenURI(tokenId))) == keccak256(bytes(tokenURI_Route)), "not tracked correctly");
    }     
}
