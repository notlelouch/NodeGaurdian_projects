// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IERC721.sol";
import "./interfaces/IAmuletPouch.sol";

/**
 * @dev ERC-721 Token Receiver token contract.
 */
contract AmuletPouch  {
    address public amuletContract;

    struct WithdrawalRequest {
        address requester;
        uint256 tokenId;
        uint256 numVotes;
        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => WithdrawalRequest) public withdrawalRequests;
    mapping(address => bool) public members;
    uint256 public totalMembersCount;
    uint256 public nextRequestId;

   event WithdrawRequested(address indexed requester, uint256 indexed tokenId, uint256 indexed requestId);
    event WithdrawApproved(uint256 requestId);

    constructor(address _amuletContract) {
        amuletContract = _amuletContract;
    }

    modifier onlyMember() {
        require(members[msg.sender], "Sender is not a member");
        _;
    }

    function isMember(address _user) external view returns (bool) {
        return members[_user];
    }

    function totalMembers() external view returns (uint256) {
        return totalMembersCount;
    }

    function withdrawRequest(uint256 _requestId) external  returns (address, uint256) {
        WithdrawalRequest storage request = withdrawalRequests[_requestId];
        // request.requester = msg.sender;
        // request.numVotes = 0;
        // // request.hasVoted = false;
        // request.tokenId = nextRequestId;
        return (request.requester, request.tokenId);
    }

    // function setWithdrawRequests(uint256 _requestId, )

    function numVotes(uint256 _requestId) external view  returns (uint256) {
        return withdrawalRequests[_requestId].numVotes;
    }

    function voteFor(uint256 _requestId) external  onlyMember {
        WithdrawalRequest storage request = withdrawalRequests[_requestId];
        require(!request.hasVoted[msg.sender], "Already voted");
        require(_requestId < nextRequestId, "Request does not exist");

        request.hasVoted[msg.sender] = true;
        request.numVotes++;
    }

    function withdraw(uint256 _requestId) external  onlyMember {
        
        WithdrawalRequest storage request = withdrawalRequests[_requestId];
        require(request.numVotes * 2 > totalMembersCount, "Request has not received majority vote");
        require(msg.sender == request.requester, "Sender is not the requester associated with '_requestId'");
        require(_requestId < nextRequestId, "Request does not exist");

        IERC721(amuletContract).approve(request.requester, request.tokenId);
        IERC721(amuletContract).safeTransferFrom(address(this), request.requester, request.tokenId);
        emit WithdrawApproved(_requestId);
        delete withdrawalRequests[_requestId];
    }

    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns (bytes4) {
        require(msg.sender == amuletContract, "Caller shuld be amulet contract");
        if (!members[_from]) {
            members[_from] = true;
            totalMembersCount++;
        }
        if (_data.length > 0) {
            uint256 requestedTokenId = abi.decode(_data, (uint256));
            WithdrawalRequest storage request = withdrawalRequests[nextRequestId];
            request.requester = _from;
            request.numVotes = 1;
            // request.hasVoted = false;
            request.tokenId = requestedTokenId;
            // getNextRequestId();
            emit WithdrawRequested(_from, requestedTokenId, nextRequestId);
            // getNextRequestId();
            nextRequestId ++;
        }
        return this.onERC721Received.selector;
    }


    function getNextRequestId() internal returns (uint256) {
        nextRequestId++;
        return nextRequestId;
    }
}