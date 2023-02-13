// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ERC721Drop} from "../ERC721Drop.sol";
import {IERC721MetadataUpgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC721MetadataUpgradeable.sol";
import {IERC2981Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {NFTMetadataRenderer} from "../utils/NFTMetadataRenderer.sol";
import {MetadataRenderAdminCheck} from "./MetadataRenderAdminCheck.sol";

/// @notice MirrorRenderer for metadata tracking support
contract MirrorRenderer is
    IMetadataRenderer,
    MetadataRenderAdminCheck
{

    // ====== STORAGE
    /// @notice Token information mapping storage
    mapping(address => address) public tokenInfos;

    // ====== EVENTS
    /// @notice Event for a new edition initialized
    /// @dev admin function indexer feedback
    event EditionInitialized(
        address indexed target,
        address indexed contractToTrack
    );    

    /// @notice Default initializer for edition data from a specific contract
    /// @param data data to init with
    function initializeWithData(bytes memory data) external {
        // data format: contractToTrack
        (address contractToTrack) = abi.decode(data, (address));

        tokenInfos[msg.sender] = contractToTrack;

        emit EditionInitialized({
            target: msg.sender,
            contractToTrack: contractToTrack
        });    
    }

    /// @notice Contract URI information getter
    /// @return contract uri (if set)
    function contractURI() external view override returns (string memory) {
        address contractToTrack = tokenInfos[msg.sender];
        return IMetadataRenderer(contractToTrack).contractURI();
    }

    /// @notice Token URI information getter
    /// @param tokenId to get uri for
    /// @return contract uri (if set)
    function tokenURI(uint256 tokenId)
        external
        view
        override
        returns (string memory)
    {
        address contractToTrack = tokenInfos[msg.sender];

        return IMetadataRenderer(contractToTrack).tokenURI(tokenId);
    }
}
