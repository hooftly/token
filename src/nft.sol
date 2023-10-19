// SPDX-License-Identifier: GPL-3.0

// Author: Matt Hooft

pragma solidity ^0.8.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721URIStorage {
    
    uint256 private nextTokenId;

    uint256 private cap;

    uint256 public totalSupply;

    string public currentTokenURI;

    bytes32 public constant _MINT = keccak256("_MINT");

    constructor(string memory tokenURI, uint256 initialCap) ERC721("NewNFT", "NFT") {
        currentTokenURI = tokenURI;
        cap = initialCap;
    }

    function mintNFT() public returns (uint256) {
        uint256 tokenId = nextTokenId++;
        _mint(msg.sender, tokenId);
        string memory newID = string.concat(currentTokenURI, hashID(tokenId));
        _setTokenURI(tokenId, newID);
        totalSupply = totalSupply + 1;
        require(totalSupply <= cap,"There is a supply cap");
        return tokenId;
    }
    
    function burnNFT(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner,"You don't own this NFT bruh");
        _burn(tokenId);
        totalSupply = totalSupply - 1;
        
    }

    function setURI(string memory newURI) public returns (string memory) {
        currentTokenURI = newURI;
        return currentTokenURI;
    } 

    function hashID(uint256 ID) public pure returns (string memory) {
        bytes32 cid = keccak256(abi.encodePacked(ID));
        string memory s = toHex(cid);
        return s;
    }

   
    function toHex(bytes32 data) public pure returns (string memory) {
		return string(abi.encodePacked("0x", toHex16(bytes16(data)), toHex16(bytes16(data << 128))));
	}

	function toHex16(bytes16 data) internal pure returns (bytes32 result) {
		result =
			(bytes32(data) & 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000) |
			((bytes32(data) & 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000) >> 64);
		result =
			(result & 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000) |
			((result & 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000) >> 32);
		result =
			(result & 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000) |
			((result & 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000) >> 16);
		result =
			(result & 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000) |
			((result & 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000) >> 8);
		result =
			((result & 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000) >> 4) |
			((result & 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00) >> 8);
		result = bytes32(
			0x3030303030303030303030303030303030303030303030303030303030303030 +
				uint256(result) +
				(((uint256(result) + 0x0606060606060606060606060606060606060606060606060606060606060606) >> 4) &
					0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F) *
				7
		);
	}



}