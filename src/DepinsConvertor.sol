// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {MerkleProof} from "@openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol";

interface MintableToken {
    function mint(address _user, uint256 _amount) external;
}

contract DepinsConvertor {
    event Claim(address indexed account, uint256 amount);

    uint256 public immutable foundationAmount;
    bytes32 public root;
    address public depins;
    address public foundation;
    mapping(address => bool) public claimed;

    constructor(bytes32 _root, address _depins, address _foundation, uint256 _foundationAmount) {
        root = _root;
        depins = _depins;
        foundation = _foundation;
        foundationAmount = _foundationAmount;
    }

    function claimFoundation() external {
        require(!claimed[foundation], "claimed");

        claimed[foundation] = true;
        MintableToken(depins).mint(foundation, foundationAmount);
        emit Claim(foundation, foundationAmount);
    }

    function claim(address _account, uint256 _amount, bytes32[] calldata proof) external {
        require(!claimed[_account], "claimed");
        bytes32 node = keccak256(abi.encodePacked(_account, _amount));
        require(MerkleProof.verify(proof, root, node), "invalid proof");

        claimed[_account] = true;

        uint256 _foundationAmount = _amount * 10 / 100;
        uint256 _userAmount = _amount - _foundationAmount;

        MintableToken _depins = MintableToken(depins);
        _depins.mint(_account, _userAmount);
        _depins.mint(foundation, _foundationAmount);
        emit Claim(_account, _amount);
    }
}
