pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./Raffle.sol";

contract RaffleTest is DSTest {
    Raffle raffle;

    function setUp() public {
        raffle = new Raffle();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
