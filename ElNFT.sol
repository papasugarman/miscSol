Learn to code — free 3,000-hour curriculum

OCTOBER 14, 2021
/
#BLOCKCHAIN
How to Make an NFT in 14 Lines of Code
Nico
Nico
How to Make an NFT in 14 Lines of Code
If you're a developer who's interested in Blockchain development, you should know something about NFTs, or Non-Fungible Tokens. So in this article, we'll learn about the engineering behind them so you can start building your own.

At the end of the project, you will have your own Ethereum wallet with a new NFT in it. This tutorial is beginner-friendly and does not require any prior knowledge of the Ethereum network or smart contracts.

image-46
The NFT contract has only 14 lines of code
What is an NFT?
NFT stands for non-fungible token. This quote from ethereum.org explains it well:

NFTs are tokens that we can use to represent ownership of unique items. They let us tokenise things like art, collectibles, even real estate. They can only have one official owner at a time and they're secured by the Ethereum blockchain – no one can modify the record of ownership or copy/paste a new NFT into existence.

What is an NFT standard or ERC-721?
The ERC-721 is the most common NFT standard. If your Smart Contract implements certain standardized API methods, it can be called an ERC-721 Non-Fungible Token Contract.

These methods are specified in the EIP-721. Open-sourced projects like OpenZeppelin have simplified the development process by implementing the most common ERC standards as a reusable library.

What is minting an NFT?
By minting an NFT, you publish a unique token on a blockchain. This token is an instance of your Smart Contract.

Each token has a unique tokenURI, which contains metadata of your asset in a JSON file that conforms to certain schema. The metadata is where you store information about your NFT, such as name, image, description, and other attributes.

An example of the JSON file for the "ERC721 Metadata Schema" looks like this:

{
	"attributes": [
		{
			"trait_type": "Shape",
			"value": "Circle"
		},
		{
			"trait_type": "Mood",
			"value": "Sad"
		}
	],
	"description": "A sad circle.",
	"image": "https://i.imgur.com/Qkw9N0A.jpeg",
	"name": "Sad Circle"
}
How do I store my NFT's metadata?
There are three main ways to store an NFT's metadata.

First, you can store the information on-chain. In other word, you can extend your ERC-721 and store the metadata on the blockchain, which can be costly.

The second method is to use IPFS. And the third way is to simply have your API return the JSON file.

The first and second methods are usually preferred, since you cannot temper the underlying JSON file. For the scope of this project, we will opt for the third method.

For a good tutorial on using NFTs with IPFS, read this article by the Alchemy team.

What We'll Be Building
emotionalshapes
In this tutorial, we'll be creating and minting our own NFT. It is beginner-friendly and does not require any prior knowledge of the Ethereum network or smart contracts. Still, having a good grasp on those concepts will help you understand what is going on behind the scenes.

In an upcoming tutorial, we'll build a fully-functional React web app where you can display and sell your NFTs.

If you are just getting started with dApp development, begin by reading through the key topics and watch this amazing course by Patrick Collins.

This project is intentionally written with easily understandable code and is not suitable for production usage.

Prerequisites
Metamask
image-32
We need an Ethereum address to interact with our Smart Contract. We will be using Metamask as our wallet. It is a free virtual wallet that manages your Ethereum addresses. We will need it to send and receive transactions (read more on that here). For example, minting an NFT is a transaction.

Download their Chrome extension and their mobile app. We will need both as the Chrome extension does not display your NFTs.

image-34
Make sure to change the network to "Ropsten Test Network" for development purposes. You will need some Eth to cover the fees of deploying and minting your NFT. Head to the Ropsten Ethereum Faucet and enter your address. You should soon see some test Eth in your Metamask account.

image-35
Alchemy
To interact with the Ethereum Network, you will need to be connected to an Ethereum Node.

Running your own Node and maintaining the infrastructure is a project on its own. Luckily, there are nodes-as-a-service providers which host the infrastructure for you. There are many choices like Infura, BlockDaemon, and Moralis. We will be using Alchemy as our node provider.

Head over to their website, create an account, choose Ethereum as your network and create your app. Choose Ropsten as your network.

image-36
On your dashboard, click "view details" on your app, then click "view key". Save your http key somewhere as we will need that later.

image-38
NodeJS/NPM
We will be using NodeJS for the project. If you don't have it installed, follow this simple tutorial by freeCodeCamp.

Initialize the project
In your terminal, run this command to make a new directory for your project:

mkdir nft-project
cd nft-project
Now, let's make another directory, ethereum/, inside nft-project/ and initialize it with Hardhat. Hardhat is a dev tool that makes it easy to deploy and test your Ethereum software.

mkdir ethereum
cd ethereum
npm init
Answer the questions however you want. Then, run those commands to make a Hardhat project:

npm install --save-dev hardhat
npx hardhat
You will see this prompt:

888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

Welcome to Hardhat v2.0.8

? What do you want to do? …
  Create a sample project
❯ Create an empty hardhat.config.js
  Quit
Select create an empty hardhat.config.js. This will generate an empty hardhat.config.js file that we will later update.

For the web app, we will use Next.js to initialize a fully-functional web app. Go back to the root directory nft-project/ and initialize a boilerplate Next.js app called web:

cd ..
mkdir web
cd web
npx create-next-app@latest
Your project now looks like this:

nft-project/
	ethereum/
	web/
Awesome! We are ready to dive into some real coding.

How to Define Our .env Variables
Remember the Alchemy key we grabbed from our test project earlier? We will use that along with our Metamask account's public and private keys to interact with the blockchain.

Run the following commands, make a file called .env inside your ethereum/ directory, and install dotenv. We will use them later.

cd ..
cd ethereum
touch .env
npm install dotenv --save
For your .env file, put the key you have exported from Alchemy and follow those instructions to grab your Metamask's private key.

Here's your .env file:

DEV_API_URL = YOUR_ALCHEMY_KEY
PRIVATE_KEY = YOUR_METAMASK_PRIVATE_KEY
PUBLIC_KEY = YOUR_METAMASK_ADDRESS
The Smart Contract for NFTs
Go to the ethereum/ folder and create two more directories: contracts and scripts. A simple hardhat project contains those folders.

contracts/ contains the source files of your contracts
scripts/ contains the scripts to deploy and mint our NFTs
mkdir contracts
mkdir scripts
Then, install OpenZeppelin. OpenZeppelin Contract is an open-sourced library with pre-tested reusable code to make smart contract development easier.

npm install @openzeppelin/contracts
Finally, we will be writing the Smart Contract for our NFT. Navigate to your contracts directory and create a file titled EmotionalShapes.sol. You can name your NFTs however you see fit.

The .sol extension refers to the Solidity language, which is what we will use to program our Smart Contract. We will only be writing 14 lines of code with Solidity, so no worries if you haven't seen it before.

Start with this article to learn more about Smart Contract languages. You can also directly jump to this Solidity cheat sheet which contains the main syntax.

cd contracts
touch EmotionalShapes.sol
This is our Smart Contract:

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EmotionalShapes is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("CryptoApe", "CAPE") {}

    function _baseURI() internal pure override returns (string memory) {
        return "a URL";
    }

    function mint(address to)
        public returns (uint256)
    {
        require(_tokenIdCounter.current() < 3); 
        _tokenIdCounter.increment();
        _safeMint(to, _tokenIdCounter.current());

        return _tokenIdCounter.current();
    }
}