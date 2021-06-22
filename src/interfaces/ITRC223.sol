pragma solidity =0.4.24;

interface ITRC223 {
    function transferAndFallback(address to, uint amount, bytes data) external returns (bool ok);

    function transferFromAndFallback(address from, address to, uint256 amount, bytes data) external returns (bool ok);
}
