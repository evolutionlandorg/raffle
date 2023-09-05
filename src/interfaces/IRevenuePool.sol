pragma solidity ^0.6.7;

interface IRevenuePool {
    function reward(address _token, uint256 _value, address _buyer) external;
}
