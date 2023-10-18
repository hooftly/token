// SPDX-License-Identifier: GPL-3.0

// Author: Matt Hooft

pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {

    
    uint256 private nextTokenId;

    uint256 private cap = 5;

    uint256 public totalSupply;

    string public currentTokenURI;


    constructor(string memory tokenURI) ERC721("NewNFT", "NFT") {
        currentTokenURI = tokenURI;
    }

    function mintNFT() public returns (uint256) {
        uint256 tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
        
        string memory newID = string.concat(currentTokenURI, Strings.toString(tokenId));
        _setTokenURI(tokenId, newID);
        
        totalSupply = totalSupply + 1;
        require(totalSupply <= cap,"There is a supply cap");
        return tokenId;
    }
    
    function burnNFT(uint256 tokenId) public {
        _burn(tokenId);
        totalSupply = totalSupply - 1;
    }

    function setURI(string memory newURI) public returns (string memory) {
        currentTokenURI = newURI;
        return currentTokenURI;
    } 

    function transfer(address from, address to, uint256 tokenId) internal {
        _transfer(from, to, tokenId);
    }



}