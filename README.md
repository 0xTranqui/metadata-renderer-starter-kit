# Metadata Renderer Starter Kit
This is repo is a fork of the [zora-drops-contracts](https://github.com/ourzora/zora-drops-contracts) repo and provides a basic setup for experimenting with writing your own custom metadata renderers. This code is NOT AUDITED, use at your own risk

## Process
1. Deploy an Edition with placeholder image data on Zora. Links to [testnet](https://testnet.zora.co/create) + [mainnet](https://zora.co/create) create flows
2. Create a simple renderer contract that follows this [IMetadataRenderer interface](https://github.com/ourzora/zora-drops-contracts/blob/main/src/interfaces/IMetadataRenderer.sol). Can inclue as little as `function tokenURI(uint256 _tokenId) public view returns (string memory)` & `function contractURI() public view returns (string memory)`
3. On the Zora drop contract you deployed, go to Etherscan and call the `setMetadataRenderer` write function with values `newRenderer` (your contract address) and `setupRenderer` (with value `0x` if you don't need to initialize anything).

## Helpful links
1. [2 hour loom](https://www.loom.com/share/1732d511e8424153b1c8ca6177cc14dd) tutorial (0:00 - 21:19 external metadata renderer overview, 21:19-2:02:14 writing + testing + deploying your own). Links to [Renderer](https://goerli.etherscan.io/address/0x83C9fb9690CeAF0c63F045d7049dF504300cAd81) + [Zora Drop](https://goerli.etherscan.io/address/0x4177c3872f770ed047bee5db849d069ff5e40836) deployed in this tutorial
1. [50 min loom](https://www.loom.com/share/41e341482bbd4b58a6ee223952447b14) tutorial on using remix to write/test/deploy your own renderer. This tutorial focuses on onchain svgs. Links to [Renderer](https://goerli.etherscan.io/address/0x6B9061902a086B7E2293abd4eCd10550BAD15f78) + [Zora Drop](https://goerli.etherscan.io/address/0xff72a23a005773067633a357ea0b1768f3cb6ff6) deployed in this tutorial
1. [EditionMetadataRenderer](https://github.com/ourzora/zora-drops-contracts/blob/main/src/metadata/EditionMetadataRenderer.sol) by [ZORA](https://twitter.com/ourZORA)
1. [NounChecksRendererV1](https://etherscan.io/address/0x072762fe5b884ad9eac9a5119976a80544c9f833#code) by [@ripe0x](https://twitter.com/ripe0x)
1. [ContractReaderLiveValues](https://www.contractreader.io/contract/0xE7CB743319C9b7C194D31636494cadE4fD4D4d27#code) by [@backseats_eth](https://twitter.com/backseats_eth)
   
### Local development

1. Install [Foundry](https://github.com/foundry-rs/foundry)
1. `yarn install`
1. `git submodule init && git submodule update`
1. `yarn build`
