pragma solidity ^0.4.22;

contract Voting {
    // Number of blocks to challenge this block (10 minutes, 5 blocks per minute)
    uint constant private NUM_BLOCKS_TO_LOCK = 10 * 5;

    struct Stake {
        address staker;
        uint256 stake;
    }

    struct Value {
        string value;
        uint totalStake;
        uint numStakes;
        mapping (address => uint) ids;  // Sender address -> stakeId
        mapping (uint => Stake) stakes;  // stakeId -> Sender address, total staked
    }

    struct MultiValue {
        uint startingBlockIndex;
        uint lockingBlockIndex;
        bool isLocked;
        uint topValueId;  // Id of top value.
        uint numValues;
        mapping (string => uint) ids;  // value to valueId
        mapping (uint => Value) values;
    }

    mapping (address => uint256) private fees;
    mapping (string => MultiValue) private store;


    function lockMultiValue(MultiValue storage multiValue) private {
        multiValue.isLocked = true;
        // TODO: Distribute stake
    }

    function getMultiValue(string _key) private returns (MultiValue storage) {
        MultiValue storage multiValue = store[_key];
        if (multiValue.numValues == 0) {
            // new key
            return multiValue;
        }
        if (block.number >= multiValue.lockingBlockIndex) {
            lockMultiValue(multiValue);
        }
        return multiValue;
    }

    function put(string _key, string _value) public payable returns (bool) {
        require(msg.value > 0, "You need to stake money bro");
        // require(_key.length > 0, "Key can't be empty string");
        MultiValue storage multiValue = getMultiValue(_key);
        require(!multiValue.isLocked, "Can't use put on the locked key");
        if (multiValue.numValues == 0) {
            // new key
            multiValue.startingBlockIndex = block.number;
            multiValue.lockingBlockIndex = block.number + NUM_BLOCKS_TO_LOCK;
        }
        uint valueId = multiValue.ids[_value];
        if (valueId == 0) {
            // new value
            valueId = multiValue.numValues++;
            multiValue.ids[_value] = valueId;
            multiValue.values[valueId].value = _value; 
        }
        Value storage value = multiValue.values[valueId];
        value.totalStake += msg.value;
        uint stakeId = value.ids[msg.sender];
        if (stakeId == 0) {
            stakeId = value.numStakes++;
            value.ids[msg.sender] = stakeId;
            value.stakes[stakeId].staker = msg.sender;
        }
        value.stakes[stakeId].stake += msg.value;

        if (value.totalStake > multiValue.values[multiValue.topValueId].totalStake) {
            multiValue.topValueId = valueId;
        }

        return true;
    }

    function get(string _key) public returns (string value, bool isLocked) {
        // TODO: Figure out fees split
        MultiValue storage multiValue = getMultiValue(_key);
        if (multiValue.numValues > 0) {
            value = multiValue.values[multiValue.topValueId].value;
            isLocked = multiValue.isLocked;
        }
        emit GetEvent(_key, value, isLocked);
    }

    event GetEvent(string key, string value, bool isLocked);
}