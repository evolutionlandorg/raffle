pragma solidity ^0.6.7;

import "ds-math/math.sol";
import "ds-stop/stop.sol";
import "zeppelin-solidity/proxy/Initializable.sol";
import "./interfaces/ISettingsRegistry.sol";
import "./interfaces/ILandResource.sol";
import "./interfaces/IERC223.sol";

contract Raffle is Initializable, DSStop, DSMath {
    event Join(uint256 indexed landId, address user, uint256 amount, address subAddr);
    event ChangeAmount(uint256 indexed landId, address user, uint256 amount);
    event ChangeSubAddr(uint256 indexed landId, address user, address subAddr);
    event Exit(uint256 indexed landId, address user, uint256 amount);
    event Win(uint256 indexed landId, address user, uint256 amount, address subAddr);
    event Lose(uint256 indexed landId, address user, uint256 amount, address subAddr);
    // 0x434f4e54524143545f4f424a4543545f4f574e45525348495000000000000000
    bytes32 public constant CONTRACT_OBJECT_OWNERSHIP = "CONTRACT_OBJECT_OWNERSHIP";
    // 0x434f4e54524143545f52494e475f45524332305f544f4b454e00000000000000
    bytes32 public constant CONTRACT_RING_ERC20_TOKEN = "CONTRACT_RING_ERC20_TOKEN";
    // 0x434f4e54524143545f4c414e445f5245534f5552434500000000000000000000
    bytes32 public constant CONTRACT_LAND_RESOURCE = "CONTRACT_LAND_RESOURCE";
    // 0x434f4e54524143545f524556454e55455f504f4f4c0000000000000000000000
    bytes32 public constant CONTRACT_REVENUE_POOL = "CONTRACT_REVENUE_POOL";
    bytes4 private constant _SELECTOR_TRANSFERFROM = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
    // Gold Rush begin from start block
    uint256 public constant startBlock = 0;
    // Gold Rush end before end block
    uint256 public constant endBlock = 9947228;
    // Gold Rush lottery fininal block
    uint256 public constant finalBlock = 10000000;
    // Join Gold Rush Event minimum RING amount
    uint256 public constant MINI_AMOUNT = 1 ether; 

    // user raffle info
    struct Item {
        address user;       // user address
        uint256 balance;    // user submit amount 
        address subAddr;    // crab dvm address for receiving new land
    }

	ISettingsRegistry public registry;
	address public supervisor;
	uint256 public networkId;
    mapping(uint256 => Item) public lands;

    modifier duration() {
       require(block.number >= startBlock && block.number < endBlock, "Raffle: NOT_DURATION"); 
       _;
    }

    modifier finished() {
       require(block.number >= finalBlock, "Raffle: NOT_FINISH"); 
       _;
    }

    function initialize(address _registry, address _supervisor, uint256 _networkId) public initializer {
	owner = msg.sender;
	emit LogSetOwner(msg.sender);
	registry = ISettingsRegistry(_registry);
        supervisor = _supervisor;
        networkId = _networkId;
    }

    function _safeTransferFrom(address token, address from, address to, uint256 value) private {
	(bool success, bytes memory data) = token.call(abi.encodeWithSelector(_SELECTOR_TRANSFERFROM, from, to, value)); // solhint-disable-line
	require(success && (data.length == 0 || abi.decode(data, (bool))), "Furnace: TRANSFERFROM_FAILED");
    }
    
    // check the land is valid
    function check(uint256 _landId) view public returns (bool) {
        address landrs = registry.addressOf(CONTRACT_LAND_RESOURCE);
        ( , , , , uint256 totalMiners, ) = ILandResource(landrs).land2ResourceMineState(_landId);
        return totalMiners == 0;
    }

    /**
    @notice This function is used to join Gold Rust event through ETH/ERC20 Tokens
    @param _landId  The land token id which to join
    @param _amount  The ring amount which to submit
    @param _subAddr The dvm address for receiving the new land
     */
    function join(uint256 _landId, uint256 _amount, address _subAddr) stoppable duration public {
        require(lands[_landId].user == address(0), "Raffle: NOT_EMPTY");
        require(_amount >= MINI_AMOUNT, "Raffle: TOO_SMALL");
        require(check(_landId), "Raffle: INVALID_LAND");
        address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
        _safeTransferFrom(ownership, msg.sender, address(this), _landId);
        _safeTransferFrom(ring, msg.sender, address(this), _amount);
        lands[_landId] = Item({
            user: msg.sender,
            balance: _amount,
            subAddr: _subAddr
        });
        emit Join(_landId, msg.sender, _amount, _subAddr);
    }


    /**
    @notice This function is used to change the ring stake amount 
    @param _landId The land token id which to join
    @param _amount The new submit ring amount 
     */
    function changeAmount(uint256 _landId, uint256 _amount) stoppable duration public {
        require(_amount >= MINI_AMOUNT, "Raffle: TOO_SMALL");
        Item storage item = lands[_landId];
        require(item.user == msg.sender, "Raffle: FORBIDDEN");
        require(item.balance != _amount, "Raffle: SAME_AMOUNT");
        address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
        if (_amount > item.balance) {
            uint256 diff = sub(_amount, item.balance);
            _safeTransferFrom(ring, msg.sender, address(this), diff);
        } else {
            uint256 diff = sub(item.balance, _amount);
            _safeTransferFrom(ring, address(this), msg.sender, diff);
        }
        item.balance = _amount;
        emit ChangeAmount(_landId, item.user, item.balance);
    }

    /**
    @notice This function is used to change the dvm address   
    @param _landId The land token id which to join
    @param _amount The new submit ring amount 
     */
    function changeSubAddr(uint256 _landId, address _subAddr) stoppable duration public {
        Item storage item = lands[_landId];
        require(item.user == msg.sender, "Raffle: FORBIDDEN");
        require(item.subAddr != _subAddr, "Raffle: SAME_SUBADDR");
        item.subAddr = _subAddr;
        emit ChangeSubAddr(_landId, item.user, item.subAddr);
    }

    /**
    @notice This function is used to exit Gold Rush event
    @param _landId The land token id which to join
     */
    function exit(uint256 _landId) stoppable duration public {
        Item storage item = lands[_landId];
        require(item.user == msg.sender, "Raffle: FORBIDDEN");
        address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
        _safeTransferFrom(ownership, address(this), msg.sender, _landId);
        _safeTransferFrom(ring, address(this), msg.sender, item.balance);
        emit Exit(_landId, item.user, item.balance);
        delete lands[_landId];
    }

    // This function is used to redeem prize after lottery
    // _hashmessage = hash("${address(this)}${networkId}${_landId}${_won}")
    // _v, _r, _s are from supervisor's signature on _hashmessage
    // while the _hashmessage is signed by supervisor
    function draw(uint256 _landId, bool _won, bytes32 _hashmessage, uint8 _v, bytes32 _r, bytes32 _s) stoppable finished public {
	require(supervisor == _verify(_hashmessage, _v, _r, _s), "Raffle: VERIFY_FAILED");
	require(keccak256(abi.encodePacked(address(this), networkId, _landId, _won)) == _hashmessage, "Raffle: HASH_INVAILD");
        Item storage item = lands[_landId];
        require(item.user == msg.sender, "Raffle: FORBIDDEN");
        address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
        if (_won) {
            //TODO:: check Data
            IERC223(ring).transfer(registry.addressOf(CONTRACT_REVENUE_POOL), item.balance, abi.encodePacked(bytes12(0), item.user));
            emit Win(_landId, item.user, item.balance, item.subAddr);
            delete lands[_landId];
        } else {
            address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
            _safeTransferFrom(ownership, address(this), msg.sender, _landId);
            _safeTransferFrom(ring, address(this), msg.sender, item.balance);
            emit Lose(_landId, item.user, item.balance, item.subAddr);
            delete lands[_landId];
        }
    }

    function changeSupervisor(address _newSupervisor) public auth {
	supervisor = _newSupervisor;
    }

    function _verify(bytes32 _hashmessage, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
	bytes memory prefix = "\x19EvolutionLand Signed Message:\n32";
	bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hashmessage));
	address signer = ecrecover(prefixedHash, _v, _r, _s);
	return signer;
    }
}
