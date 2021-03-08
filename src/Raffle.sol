pragma solidity ^0.6.7;

import "ds-math/math.sol";
import "ds-stop/stop.sol";
import "./interfaces/ISettingsRegistry.sol";

contract Raffle is DSStop, DSMath {
    event Join(address indexed user, uint256 landId, uint256 amount);
    event Exit(address indexed user, uint256 landId, uint256 amount);
	// 0x434f4e54524143545f4f424a4543545f4f574e45525348495000000000000000
	bytes32 public constant CONTRACT_OBJECT_OWNERSHIP =
		"CONTRACT_OBJECT_OWNERSHIP";
	// 0x434f4e54524143545f52494e475f45524332305f544f4b454e00000000000000
	bytes32 public constant CONTRACT_RING_ERC20_TOKEN =
		"CONTRACT_RING_ERC20_TOKEN";

	bytes4 private constant _SELECTOR_TRANSFERFROM =
		bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
    bytes4 private constant _SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    struct Item {
        address user;
        uint256 balance;
    }

    uint256 public startTime;
    uint256 public endTime;
	ISettingsRegistry public registry;
    mapping(uint256 => Item) public lands;

    constructor(address _registry) public {
		registry = ISettingsRegistry(_registry);
    }

	function _safeTransferFrom(
		address token,
		address from,
		address to,
		uint256 value
	) private {
		(bool success, bytes memory data) =
			token.call(abi.encodeWithSelector(_SELECTOR_TRANSFERFROM, from, to, value)); // solhint-disable-line
		require(
			success && (data.length == 0 || abi.decode(data, (bool))),
			"Furnace: TRANSFERFROM_FAILED"
		);
	}

    function _safeTransfer(address token, address to, uint value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(_SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'Furnace: TRANSFER_FAILED');
    }

    function join(uint256 _landId, uint256 _amount) stoppable public {
        address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        address ring = registry.address(CONTRACT_RING_ERC20_TOKEN);
        _safeTransferFrom(ownership, msg.sender, address(this), _landId);
        _safeTransferFrom(ring, msg.sender, address(this), _amount);
        lands[_landId] = Item({
            user: msg.sender,
            balance: _amount
        });
        emit Join(msg.sender, _landId, _amount);
    }

    function change(uint256 _amount) stoppable public {
        Item storage item = lands[_landId];
        require(item.user == msg.sender, "RAFFLE: PERMISSION");
        address ring = registry.address(CONTRACT_RING_ERC20_TOKEN);
               
    }

    function exit(uint256 _landId) stoppable public {
        Item storage item = lands[_landId];
        require(item.user == msg.sender, "RAFFLE: PERMISSION");
        address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        address ring = registry.address(CONTRACT_RING_ERC20_TOKEN);
        _safeTransferFrom(ownership, address(this), msg.sender, _landId);
        _safeTransferFrom(ring, address(this), msg.sender, item.balance);
        emit Exit(msg.sender, _landId, item.balance);
        delete lands[_landId];
    }
}
