pragma solidity ^0.6.7;

import "ds-stop/stop.sol";
import "zeppelin-solidity/proxy/Initializable.sol";
import "./interfaces/ISettingsRegistry.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/ILandBase.sol";
import "./interfaces/IInterstellarEncoder.sol";

contract ElementRafflePool is Initializable, DSStop {
    event SmallDraw(address user, uint256 number, IInterstellarEncoder.ObjectClass class);
    event LargeDraw(address user, uint256 number, IInterstellarEncoder.ObjectClass class);

    // 0x434f4e54524143545f4c414e445f424153450000000000000000000000000000
    bytes32 public constant CONTRACT_LAND_BASE = "CONTRACT_LAND_BASE";
    // 0x434f4e54524143545f4f424a4543545f4f574e45525348495000000000000000
    bytes32 public constant CONTRACT_OBJECT_OWNERSHIP = "CONTRACT_OBJECT_OWNERSHIP";
    // 0x434f4e54524143545f494e5445525354454c4c41525f454e434f444552000000
    bytes32 public constant CONTRACT_INTERSTELLAR_ENCODER = "CONTRACT_INTERSTELLAR_ENCODER";

    ISettingsRegistry public registry;

    modifier notContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        require(msg.sender == tx.origin, "Proxy contract not allowed");
        _;
    }

    function initialize(address _registry) public initializer {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
        registry = ISettingsRegistry(_registry);
    }

    function smallDraw(address element) notContract stoppable external {
        require(isValidToken(element), "Invalid");
        uint256 fee = 200e18;
        IERC20(element).transferFrom(msg.sender, address(this), fee);
        uint256 seed = _seed();
        uint256 number = seed % 1000;
        if (number == 0) {
            _reward(IInterstellarEncoder.ObjectClass.LAND);
            emit SmallDraw(msg.sender, number, IInterstellarEncoder.ObjectClass.LAND);
        } else if (number < 10 && number > 0) {
            _reward(IInterstellarEncoder.ObjectClass.APOSTLE);
            emit SmallDraw(msg.sender, number, IInterstellarEncoder.ObjectClass.APOSTLE);
        } else {
            emit SmallDraw(msg.sender, number, IInterstellarEncoder.ObjectClass.NaN);
        }
    }

    function largeDraw(address element) notContract stoppable external {
        require(isValidToken(element), "Invalid");
        uint256 fee = 1000e18;
        IERC20(element).transferFrom(msg.sender, address(this), fee);
        uint256 seed = _seed();
        uint256 number = seed % 100;
        if (number == 0) {
            _reward(IInterstellarEncoder.ObjectClass.LAND);
            emit LargeDraw(msg.sender, number, IInterstellarEncoder.ObjectClass.LAND);
        } else if (number < 10 && number > 0) {
            _reward(IInterstellarEncoder.ObjectClass.APOSTLE);
            emit LargeDraw(msg.sender, number, IInterstellarEncoder.ObjectClass.APOSTLE);
        } else {
            emit LargeDraw(msg.sender, number, IInterstellarEncoder.ObjectClass.NaN);
        }
    }

    function isValidToken(address token) public view returns (bool) {
        uint index = ILandBase(registry.addressOf(CONTRACT_LAND_BASE)).resourceToken2RateAttrId(token);
        return index > 0;
    }

    function _random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function _seed() internal view returns (uint rand) {
        rand = _random(
            string(
                abi.encodePacked(
                    block.timestamp,
                    blockhash(block.number - 1),
                    msg.sender
                )
            )
        );
    }

    function _reward(IInterstellarEncoder.ObjectClass _objectClass) internal {
        address self = address(this);
        address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        address interstellarEncoder = registry.addressOf(CONTRACT_INTERSTELLAR_ENCODER);
        for(uint i = 0; i < IERC721(ownership).balanceOf(self); i++) {
            uint256 tokenId = IERC721(ownership).tokenOfOwnerByIndex(self, i);
            if (IInterstellarEncoder(interstellarEncoder).getObjectClass(tokenId) == uint8(_objectClass)) {
                IERC721(ownership).transferFrom(self, msg.sender, tokenId);
            }
        }
    }

    function _isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}
