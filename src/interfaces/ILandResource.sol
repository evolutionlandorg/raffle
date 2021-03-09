pragma solidity ^0.6.7;

interface ILandResource {
    function land2ResourceMineState(uint256 landId) external view returns (uint256,uint256,uint256,uint256,uint256,uint256);
	// function getBarItem(uint256 _tokenId, uint256 _index) external view returns (address, uint256, address);
    // function maxAmount() external view returns (uint256);
}
