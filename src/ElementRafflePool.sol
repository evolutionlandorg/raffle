pragma solidity ^0.6.7;

import "ds-stop/stop.sol";
import "zeppelin-solidity/proxy/Initializable.sol";
import "./interfaces/ISettingsRegistry.sol";
import "./interfaces/IERC20.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/ILandBase.sol";
import "./interfaces/ICodexRandom.sol";
import "./interfaces/IInterstellarEncoder.sol";

contract ElementRafflePool is Initializable, DSStop {
    event SmallDraw(address user, uint256 number, IInterstellarEncoder.ObjectClass class);
    event LargeDraw(address user, uint256 number, IInterstellarEncoder.ObjectClass class);

    bytes32 private constant CONTRACT_LAND_BASE = "CONTRACT_LAND_BASE";
    bytes32 private constant CONTRACT_RANDOM_CODEX = "CONTRACT_RANDOM_CODEX";
    bytes32 private constant CONTRACT_OBJECT_OWNERSHIP = "CONTRACT_OBJECT_OWNERSHIP";
    bytes32 private constant CONTRACT_INTERSTELLAR_ENCODER = "CONTRACT_INTERSTELLAR_ENCODER";

    // small draw fee
    uint256 public smallDrawFee = 10e18;
    // large draw fee
    uint256 public largeDrawFee = 100e18;

    ISettingsRegistry public registry;
    // element token address
    address public element;

    modifier notContract() {
        require(!_isContract(msg.sender), "Contract not allowed");
        require(msg.sender == tx.origin, "Proxy contract not allowed");
        _;
    }

    function initialize(address _registry, address _element) public initializer {
        owner = msg.sender;
        emit LogSetOwner(msg.sender);
        registry = ISettingsRegistry(_registry);
        require(isValidToken(_element), "Invalid element");
        element = _element;
    }

    function setFee(uint _smallDrawFee, uint _largeDrawFee) external auth {
        smallDrawFee = _smallDrawFee;
        largeDrawFee = _largeDrawFee;
    }

    // do a small draw
    // must approve `smallDrawFee` at least before draw
    function smallDraw() notContract stoppable external {
        IERC20(element).transferFrom(msg.sender, address(this), smallDrawFee);
        address random = registry.addressOf(CONTRACT_RANDOM_CODEX);
        uint seed = _seed();
        uint randomness = ICodexRandom(random).dn(seed, 1000);
        if (randomness == 0) {
            _reward(IInterstellarEncoder.ObjectClass.LAND);
            emit SmallDraw(msg.sender, randomness, IInterstellarEncoder.ObjectClass.LAND);
        } else if (randomness < 10 && randomness > 0) {
            _reward(IInterstellarEncoder.ObjectClass.APOSTLE);
            emit SmallDraw(msg.sender, randomness, IInterstellarEncoder.ObjectClass.APOSTLE);
        } else {
            emit SmallDraw(msg.sender, randomness, IInterstellarEncoder.ObjectClass.NaN);
        }
    }

    // do a large draw
    // must approve `largeDrawFee` at least before draw
    function largeDraw() notContract stoppable external {
        IERC20(element).transferFrom(msg.sender, address(this), largeDrawFee);
        address random = registry.addressOf(CONTRACT_RANDOM_CODEX);
        uint seed = _seed();
        uint randomness = ICodexRandom(random).dn(seed, 100);
        if (randomness == 0) {
            _reward(IInterstellarEncoder.ObjectClass.LAND);
            emit LargeDraw(msg.sender, randomness, IInterstellarEncoder.ObjectClass.LAND);
        } else if (randomness < 10 && randomness > 0) {
            _reward(IInterstellarEncoder.ObjectClass.APOSTLE);
            emit LargeDraw(msg.sender, randomness, IInterstellarEncoder.ObjectClass.APOSTLE);
        } else {
            emit LargeDraw(msg.sender, randomness, IInterstellarEncoder.ObjectClass.NaN);
        }
    }

    // balanceOf this Lands and Apostles
    function balanceOfEVO() public view returns (uint256 lands, uint apostles) {
        address self = address(this);
        address objectOwnership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        address interstellarEncoder = registry.addressOf(CONTRACT_INTERSTELLAR_ENCODER);
        uint balance = IERC721(ownership).balanceOf(self);
        for(uint i = 0; i < balance; i++) {
            uint256 tokenId = ERC721(objectOwnership).tokenOfOwnerByIndex(self, i);
            if (IInterstellarEncoder(interstellarEncoder).getObjectClass(tokenId) == uint8(IInterstellarEncoder.ObjectClass.LAND)) {
                lands = lands.add(1);
            } else if (IInterstellarEncoder(interstellarEncoder).getObjectClass(tokenId) == uint8(IInterstellarEncoder.ObjectClass.APOSTLE)) {
                apostles = apostles.add(1);
            }
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
                    gasleft(),
                    block.difficulty,
                    block.coinbase,
                    block.gaslimit
                )
            )
        );
    }

    function _reward(IInterstellarEncoder.ObjectClass _objectClass) internal {
        address self = address(this);
        address ownership = registry.addressOf(CONTRACT_OBJECT_OWNERSHIP);
        address interstellarEncoder = registry.addressOf(CONTRACT_INTERSTELLAR_ENCODER);
        uint balance = IERC721(ownership).balanceOf(self);
        for(uint i = 0; i < balance; i++) {
            uint256 tokenId = IERC721(ownership).tokenOfOwnerByIndex(self, i);
            if (IInterstellarEncoder(interstellarEncoder).getObjectClass(tokenId) == uint8(_objectClass)) {
                IERC721(ownership).transferFrom(self, msg.sender, tokenId);
                return;
            }
        }

        revert("nothing");
    }

    function _isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }
}
