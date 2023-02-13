// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/forge-std/src/Script.sol";
import {MirrorRenderer} from "../src/metadata/MirrorRenderer.sol";

contract DeployCore is Script {

    function setUp() public {}

    function run() public {
        
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        new MirrorRenderer();

        vm.stopBroadcast();
    }
}


// ======= DEPLOY SCRIPTS =====

// source .env
// forge script script/MirrorRenderer.s.sol:DeployCore --rpc-url $GOERLI_RPC_URL --broadcast --verify  -vvvv
// forge script script/MirrorRenderer.s.sol:DeployCore --rpc-url $MAINNET_RPC_URL --broadcast --verify  -vvvv

