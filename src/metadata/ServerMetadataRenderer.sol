// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {IERC721Drop} from "../interfaces/IERC721Drop.sol";
import {ERC721Drop} from "../ERC721Drop.sol";
import {IERC721MetadataUpgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC721MetadataUpgradeable.sol";
import {IERC2981Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {NFTMetadataRenderer} from "../utils/NFTMetadataRenderer.sol";
import {MetadataRenderAdminCheck} from "./MetadataRenderAdminCheck.sol";

/// @notice ServerMetadataRenderer for
contract ServerMetadataRenderer is
    IMetadataRenderer,
    MetadataRenderAdminCheck
{

    // ===== TYPES

    struct Routes {
        string tokenURIRoute;
        string contractURIRoute;
    }

    // ===== STORAGE

    mapping(address => Routes) public routeInfo;

    // ===== EVENTS

    event RoutesUpdated(
        address indexed target,
        string indexed contractURIRoute,
        string indexed tokenURIRoute
    );

    // ===== URI Update Functionality

    /// @notice Initializer for server route data from a specific contract
    /// @param data data to init with
    function initializeWithData(bytes memory data) external {
        // data format: contractURIRoute, tokenURIRoute
        (string memory contractURIRoute, string memory tokenURIRoute) = abi.decode(data, (string, string));

        routeInfo[msg.sender].contractURIRoute = contractURIRoute;
        routeInfo[msg.sender].tokenURIRoute = tokenURIRoute;

        emit RoutesUpdated({
            target: msg.sender,
            contractURIRoute: contractURIRoute,
            tokenURIRoute: tokenURIRoute
        });  
    }      

    /// @notice Update token/contractURI routes
    /// @param target zora drop to target
    /// @param contractURIRoute new contractURI route
    /// @param tokenURIRoute new tokenURI route
    function updateURIs(
        address target,
        string memory contractURIRoute,
        string memory tokenURIRoute
    ) external requireSenderAdmin(target) {        
        routeInfo[target].contractURIRoute = contractURIRoute;
        routeInfo[target].tokenURIRoute = tokenURIRoute;

        emit RoutesUpdated({
            target: target,
            contractURIRoute: contractURIRoute,
            tokenURIRoute: tokenURIRoute
        });
    }    

    // ===== URI Getters

    /// @notice Contract URI information getter
    /// @return contract uri (if set)
    function contractURI() external view override returns (string memory) {
        return routeInfo[msg.sender].contractURIRoute;
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
        return routeInfo[msg.sender].tokenURIRoute;
    }  
}
