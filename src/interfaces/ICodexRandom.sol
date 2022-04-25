pragma solidity ^0.6.7;

interface ICodexRandom {
    function dn(uint _s, uint _number) external view returns (uint);
}
