pragma solidity ^0.6.7;

interface IERC223 {
    function transfer(address to, uint amount, bytes calldata data) external returns (bool ok);

    function transferFrom(address from, address to, uint256 amount, bytes calldata data) external returns (bool ok);
}
