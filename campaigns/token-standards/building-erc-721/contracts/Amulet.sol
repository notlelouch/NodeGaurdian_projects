// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IERC165.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC721Metadata.sol";
import "./interfaces/IERC721TokenReceiver.sol";

/**
 * @dev ERC-721 token contract.
 */
contract Amulet  is IERC721, IERC721Metadata   {

    string public constant name = "Amulet"; 
    string public constant symbol = "AMULET"; 

    address private immutable creator;

    uint256 private nextId;
    mapping(uint => string) private uris;
    mapping(address => uint256) balance;
    mapping(uint256 => address) owner;

    mapping(uint256 => address) approved;
    mapping(address => mapping(address => bool)) approvedForAll;

    // event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    // event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    // event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
    
    event Hello(string name, bytes4 aba);
    constructor() {
        creator = msg.sender;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_tokenId < nextId, "Invalid token");
        return uris[_tokenId];
    }

    function ownerOf(uint256 _tokenId) external view returns (address){
        require(_tokenId < nextId, "Invalid token");
        return owner[_tokenId];
    }

    function balanceOf(address _owner) external view returns (uint256){
        require(_owner != address(0), "Invalid address");
        return balance[_owner];
    }

    function mint(address _owner, string calldata _uri) external returns (uint256) {
        require(msg.sender == creator, "Only the creator can mint!");
        owner[nextId] = _owner;
        balance[_owner]++;
        uris[nextId] = _uri;

        emit Transfer(address(0), _owner, nextId);

        return nextId++;
    }


    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return (
            interfaceId == type(IERC165).interfaceId || 
            interfaceId == type(IERC721).interfaceId || 
            interfaceId == type(IERC721Metadata).interfaceId);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        require(_tokenId < nextId, "Invalid token");
        return approved[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return approvedForAll[_owner][_operator];
    }

    function approve(address _approved, uint256 _tokenId) override external {
        require(
            owner[_tokenId] == msg.sender ||
                approvedForAll[owner[_tokenId]][msg.sender],
                "Not approved!"
        );

        approved[_tokenId] = _approved;

        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) override external {
        require(_operator != address(0), "Invalid address!");
        approvedForAll[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public override {
        require(_to != address(0), "Invalid recipient");
        require(_tokenId < nextId, "Invalid token");
        require(owner[_tokenId] == _from, "Not owner");
        if (msg.sender != _from && msg.sender != approved[_tokenId]) {
            require(approvedForAll[_from][msg.sender], "Not approved!");
        }

        owner[_tokenId] = _to;
        balance[_from]--;
        balance[_to]++;

        approved[_tokenId] = address(0);

        emit Transfer(_from, _to, _tokenId);
    }

    function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes memory _data
    ) public  {
        transferFrom(_from, _to, _tokenId);
        if (_to.code.length > 0) {
            try
                IERC721TokenReceiver(_to).onERC721Received(
                    msg.sender,
                    _from,
                    _tokenId,
                    _data
                )
            returns (bytes4 selector) {
                emit Hello("selector", selector);
                emit Hello("IERC selector", IERC721TokenReceiver.onERC721Received.selector);
                require(
                    selector == IERC721TokenReceiver.onERC721Received.selector,
                    "Invalid receiver"
                );
            } catch {
                revert("Invalid receiverrrrr");
            }
        }
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public  {
        bytes memory testData = abi.encodePacked("test data");
        safeTransferFrom(_from, _to, _tokenId, testData);
    }

}
