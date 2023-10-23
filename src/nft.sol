// SPDX-License-Identifier: GPL-3.0

// Author: Matt Hooft

pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {hextool} from "./hex.sol";

contract NFT is ERC721URIStorage, AccessControl {
    
    uint256 private nextTokenId;

    uint256 private cap;

    uint256 public totalSupply;

    string public currentTokenURI;

    bytes32 public constant _MINT = keccak256("_MINT");
    

    constructor(string memory tokenURI, uint256 initialCap) ERC721("NewNFT", "NFT") {
        currentTokenURI = tokenURI;
        cap = initialCap;
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mintNFT() public returns (uint256) {
        require(hasRole(_MINT, msg.sender), "You do not have the required role bruh");
        uint256 tokenId = ++nextTokenId;
        string memory newID = string.concat(currentTokenURI, hextool.toHex(hashUserAddress(tokenId)));
        _setTokenURI(tokenId, newID);
        _safeMint(msg.sender, tokenId);
        totalSupply = totalSupply + 1;
        require(totalSupply <= cap,"There is a supply cap bruh");
        return tokenId;
    }
    
    function burnNFT(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner,"You don't own this NFT bruh");
        _burn(tokenId);
        totalSupply = --totalSupply;
        
    }

    function setURI(string memory newURI) public returns (string memory) {
        currentTokenURI = newURI;
        return currentTokenURI;
    } 

    function hashID(uint256 ID) private pure returns (string memory) {
        bytes32 cid = keccak256(abi.encodePacked(ID));
        string memory s = hextool.toHex(cid);
        return s;
    }

    function userUpdateURI (uint256 tid) public returns (string memory) {
        address owner = _ownerOf(tid);
        require(msg.sender == owner, "You need to be the owner bruh");
        string memory i = string.concat(currentTokenURI, hextool.toHex(hashUserAddress(tid)));
        _setTokenURI(tid, i);
        return i;
    }

    function hashUserAddress (uint256 eid) public view returns (bytes32) {
        address userAddress = address(msg.sender);
        uint256 userEID = eid;
        bytes32 hashedAddress = keccak256(abi.encodePacked(userAddress, userEID));
        return hashedAddress;
    }

   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721URIStorage, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
    



}