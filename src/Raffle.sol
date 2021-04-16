pragma solidity ^0.6.7;

import "ds-math/math.sol";
import "ds-stop/stop.sol";
import "./interfaces/ISettingsRegistry.sol";
import "./interfaces/ILandResource.sol";
import "./interfaces/IERC223.sol";
import "./interfaces/IERC721.sol";

contract Raffle is DSStop, DSMath {
    event Join(uint256 indexed eventId, uint256 indexed landId, address user, uint256 amount, address subAddr, uint256 fromLandId, uint256 toLandId);
    event ChangeAmount(uint256 indexed eventId, uint256 indexed landId, address user, uint256 amount);
    event ChangeSubAddr(uint256 indexed eventId, uint256 indexed landId, address user, address subAddr);
    event Exit(uint256 indexed eventId, uint256 indexed landId, address user, uint256 amount);
    event Win(uint256 indexed eventId, uint256 indexed landId, address user, uint256 amount, address subAddr, uint256 fromLandId, uint256 toLandId);
    event Lose(uint256 indexed eventId, uint256 indexed landId, address user, uint256 amount, address subAddr);
    // 0x434f4e54524143545f4f424a4543545f4f574e45525348495000000000000000
    bytes32 public constant CONTRACT_OBJECT_OWNERSHIP = "CONTRACT_OBJECT_OWNERSHIP";
    // 0x434f4e54524143545f52494e475f45524332305f544f4b454e00000000000000
    bytes32 public constant CONTRACT_RING_ERC20_TOKEN = "CONTRACT_RING_ERC20_TOKEN";
    // 0x434f4e54524143545f4c414e445f5245534f5552434500000000000000000000
    bytes32 public constant CONTRACT_LAND_RESOURCE = "CONTRACT_LAND_RESOURCE";
    // 0x434f4e54524143545f524556454e55455f504f4f4c0000000000000000000000
    bytes32 public constant CONTRACT_REVENUE_POOL = "CONTRACT_REVENUE_POOL";
    bytes4 private constant _SELECTOR_TRANSFERFROM = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
    // Join Gold Rush Event minimum RING amount
    uint256 public constant MINI_AMOUNT = 1e18; 

    // user raffle info
    struct Item {
        address user;       // user address
        uint256 balance;    // user submit amount 
        address subAddr;    // crab dvm address for receiving new land
    }

    struct Conf {
        // Gold Rush start time 
        uint256 startTime;
        // Gold Rush end time 
        uint256 endTime;
        // Gold Rush lottery final time 
        uint256 finalTime;
        // Gold Rush lottery expire time     
        uint256 expireTime;
        // Gold Rush to land id 
        uint256 toLandId;
    }

    // Gold Rush begin from start block
    ISettingsRegistry public registry;
    address public supervisor;
    // Gold Rush from land id 
    uint256 public fromLandId;
    // EventID => Conf
    mapping(uint256 => Conf) public events;
    // EventID => LandID => Item
    mapping(uint256 => mapping(uint256 => Item)) public lands;


    modifier duration(uint256 _eventId) {
        Conf storage conf = events[_eventId];
       require(block.timestamp >= conf.startTime && block.timestamp < conf.endTime, "Raffle: NOT_DURATION"); 
       _;
    }

    constructor(address _registry, address _supervisor, uint256 _fromLandId) public {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
        registry = ISettingsRegistry(_registry);
        supervisor = _supervisor;
        fromLandId = _fromLandId;
    }

    function _safeTransferFrom(address token, address from, address to, uint256 value) private {
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(_SELECTOR_TRANSFERFROM, from, to, value)); // solhint-disable-line
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Raffle: TRANSFERFROM_FAILED");
    }
    
    // check the land is valid
    function check(uint256 _landId) view public returns (bool) {
        address landrs = registry.addressOf(CONTRACT_LAND_RESOURCE);
        ( , , , , uint256 totalMiners, ) = ILandResource(landrs).land2ResourceMineState(_landId);
        return totalMiners == 0;
    }

    /**
    @notice This function is used to join Gold Rust event through ETH/ERC20 Tokens
    @param _eventId event id which to join
    @param _landId  The land token id which to join
    @param _amount  The ring amount which to submit
    @param _subAddr The dvm address for receiving the new land
     */
    function join(uint256 _eventId, uint256 _landId, uint256 _amount, address _subAddr) stoppable duration(_eventId) public {
        address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        require(msg.sender == IERC721(ownership).ownerOf(_landId), "Raffle: FORBIDDEN");
        require(lands[_eventId][_landId].user == address(0), "Raffle: NOT_EMPTY");
        require(_amount >= MINI_AMOUNT, "Raffle: TOO_SMALL");
        {
            address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
            _safeTransferFrom(ring, msg.sender, address(this), _amount);
        }
        lands[_eventId][_landId] = Item({
            user: msg.sender,
            balance: _amount,
            subAddr: _subAddr
        });
        emit Join(_eventId, _landId, msg.sender, _amount, _subAddr, fromLandId, events[_eventId].toLandId);
    }

    function joins(uint256 _eventId, uint256[] calldata _landIds, uint256[] calldata _amounts, address[] calldata _subAddrs) external {
        require(_landIds.length == _amounts.length && _landIds.length == _subAddrs.length, "Raffle: INVALID_LENGTH");
        for(uint256 i = 0; i < _landIds.length; i++) {
            join(_eventId, _landIds[i], _amounts[i], _subAddrs[i]);
        }
    }


    /**
    @notice This function is used to change the ring stake amount 
    @param _eventId event id which to join
    @param _landId  The land token id which to join
    @param _amount  The new submit ring amount 
     */
    function changeAmount(uint256 _eventId, uint256 _landId, uint256 _amount) stoppable duration(_eventId) public {
        require(_amount >= MINI_AMOUNT, "Raffle: TOO_SMALL");
        Item storage item = lands[_eventId][_landId];
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
        emit ChangeAmount(_eventId, _landId, item.user, item.balance);
    }

    /**
    @notice This function is used to change the dvm address   
    @param _eventId event id which to join
    @param _landId  The land token id which to join
    @param _subAddr The new submit dvm address 
     */
    function changeSubAddr(uint256 _eventId, uint256 _landId, address _subAddr) stoppable duration(_eventId) public {
        Item storage item = lands[_eventId][_landId];
        require(item.user == msg.sender, "Raffle: FORBIDDEN");
        require(item.subAddr != _subAddr, "Raffle: SAME_SUBADDR");
        item.subAddr = _subAddr;
        emit ChangeSubAddr(_eventId, _landId, item.user, item.subAddr);
    }

    /**
    @notice This function is used to change the ring stake amount and dvm address   
    @param _eventId event id which to join
    @param _landId  The land token id which to join
    @param _amount  The new submit ring amount 
    @param _subAddr The new submit dvm address 
     */
    function change(uint256 _eventId, uint256 _landId, uint256 _amount, address _subAddr) public {
        changeAmount(_eventId, _landId, _amount);
        changeSubAddr(_eventId, _landId, _subAddr);
    }

    /**
    @notice This function is used to exit Gold Rush event
    @param _eventId event id which to join
    @param _landId  The land token id which to exit
     */
    function exit(uint256 _eventId, uint256 _landId) stoppable duration(_eventId) public {
        Item storage item = lands[_eventId][_landId];
        require(item.user == msg.sender, "Raffle: FORBIDDEN");
        address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
        _safeTransferFrom(ring, address(this), msg.sender, item.balance);
        emit Exit(_eventId, _landId, item.user, item.balance);
        delete lands[_eventId][_landId];
    }

    // This function is used to redeem prize after lottery
    // _hashmessage = hash("${address(this)}${fromLandId}${toLandId}${_eventId}${_landId}${_won}")
    // _v, _r, _s are from supervisor's signature on _hashmessage
    // while the _hashmessage is signed by supervisor
    function draw(uint256 _eventId, uint256 _landId, bool _won, bytes32 _hashmessage, uint8 _v, bytes32 _r, bytes32 _s) stoppable public {
        Conf storage conf = events[_eventId];
        require(supervisor == _verify(_hashmessage, _v, _r, _s), "Raffle: VERIFY_FAILED");
        require(keccak256(abi.encodePacked(address(this), fromLandId, conf.toLandId, _eventId, _landId, _won)) == _hashmessage, "Raffle: HASH_INVAILD");
        Item storage item = lands[_eventId][_landId];
        require(item.user == msg.sender, "Raffle: FORBIDDEN");
        address ring = registry.addressOf(CONTRACT_RING_ERC20_TOKEN);
        if (_won) {
            //TODO:: check Data
            require(block.timestamp >= conf.finalTime && block.timestamp < conf.expireTime, "Raffle: NOT_PRIZE OR EXPIRATION"); 
            address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
            require(check(_landId), "Raffle: INVALID_LAND");
            // return land to eve
            _safeTransferFrom(ownership, msg.sender, 0x96C53Cc5B77b6ef212C3db360DD3d4D33516787a, _landId);
            IERC223(ring).transfer(registry.addressOf(CONTRACT_REVENUE_POOL), item.balance, abi.encodePacked(bytes12(0), item.user));
            emit Win(_eventId, _landId, item.user, item.balance, item.subAddr, fromLandId, conf.toLandId);
            delete lands[_eventId][_landId];
        } else {
            require(block.timestamp >= conf.finalTime, "Raffle: NOT_PRIZE"); 
            _safeTransferFrom(ring, address(this), msg.sender, item.balance);
            emit Lose(_eventId, _landId, item.user, item.balance, item.subAddr);
            delete lands[_eventId][_landId];
        }
    }

    function setSupervisor(address _newSupervisor) public auth {
        supervisor = _newSupervisor;
    }

    function setEvent(uint256 _eventId, uint256 _toLandId, uint256 _start, uint256 _end, uint256 _final, uint256 _expire) public auth {
        events[_eventId] = Conf({
            startTime: _start,
            endTime: _end,
            finalTime: _final,
            expireTime: _expire,
            toLandId: _toLandId
        });
    }

    function _verify(bytes32 _hashmessage, uint8 _v, bytes32 _r, bytes32 _s) internal pure returns (address) {
        bytes memory prefix = "\x19EvolutionLand Signed Message:\n32";
        bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, _hashmessage));
        address signer = ecrecover(prefixedHash, _v, _r, _s);
        return signer;
    }
}
