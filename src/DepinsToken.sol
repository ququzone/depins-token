// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract DepinsToken is ERC20 {
    event ChangeMinter(address indexed minter);

    address public minter;

    constructor() ERC20("Depins", "DEPINS") {
        minter = msg.sender;
    }

    function changeMinter(address _minter) external {
        require(msg.sender == minter, "only minter");

        minter = _minter;
        emit ChangeMinter(_minter);
    }

    function mint(address _user, uint256 _amount) external {
        require(msg.sender == minter, "only minter");

        _mint(_user, _amount);
    }
}
