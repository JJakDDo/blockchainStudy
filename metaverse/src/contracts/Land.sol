// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "../../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract Land is ERC721, Ownable{
  uint256 public cost = 1 ether;
  uint256 public maxSupply = 5;
  uint256 public totalSupply = 0;

  struct Building {
    string name;
    address owner;
    int256 posX;
    int256 posY;
    int256 posZ;
    uint256 sizeX;
    uint256 sizeY;
    uint256 sizeZ;
  }

  Building[] public buildings;

  constructor(string memory _name, string memory _symbol, uint256 _cost) ERC721(_name, _symbol) {
    cost = _cost;
    buildings.push(
      Building("City Hall", address(0x0), 0, 0, 0, 10, 10, 10)
    );
    buildings.push(
      Building("Stadium", address(0x0), 0, 10, 0, 10, 5, 3)
    );
    buildings.push(
      Building("University", address(0x0), 0, -10, 0, 10, 5, 3)
    );
    buildings.push(
      Building("Shopping Plaza 1", address(0x0), 10, 0, 0, 5, 25, 5)
    );
    buildings.push(
      Building("Shopping Plaza 2", address(0x0), -10, 0, 0, 5, 25, 5)
    );
  }

  function mint(uint256 _id) public payable{
    uint256 supply = totalSupply;
    require(supply < maxSupply, "Cannot mint more than max supply");
    require(buildings[_id - 1].owner == address(0x0), "The property is already owned by other");
    require(msg.value >= cost, "ETH is not enough");

    buildings[_id - 1].owner = msg.sender;
    totalSupply += 1;
    _safeMint(msg.sender, _id);
  } 

  function transferFrom(address from, address to, uint256 tokenId) public override {
    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

    buildings[tokenId - 1].owner = to;
    _transfer(from, to, tokenId);
  }

  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public override {
    require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

    buildings[tokenId - 1].owner = to;
    _safeTransfer(from, to, tokenId, _data);
  }

  function getBuildings() public view returns(Building[] memory) {
    return buildings;
  }

  function getBuilding(uint256 _id) public view returns(Building memory) {
    return buildings[_id - 1];
  }

  function withdraw() public onlyOwner () {
    payable(msg.sender).transfer(address(this).balance);
  }
}