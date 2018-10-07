pragma solidity ^0.4.22;

contract Voting {
    struct Stake {
        address staker;
        uint256 stake;
    }

    struct Value {
        string value;
        uint totalStake;
        uint numStakes;
        mapping (address => uint) ids;
        mapping (uint => Stake) stakes;
    }

    struct MultiValue {
        uint startingBlockIndex;
        bool isLocked;
        uint topValueId;
        uint numValues;
        mapping (string => uint) ids;
        mapping (uint => Value) values;
    }

    mapping (address => uint256) private fees;
    mapping (string => MultiValue) private store;


    function put(string _key, string _value) public payable {
        require(msg.value > 0, "You need to stake money bro");
        // require(_key.length > 0, "Key can't be empty string");
        MultiValue storage multiValue = store[_key];
        if (multiValue.numValues == 0) {
            // new key
            multiValue.startingBlockIndex = block.number;
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
        // multiValue.values[_value] = value;

        if (value.totalStake > multiValue.values[multiValue.topValueId].totalStake) {
            multiValue.topValueId = valueId;
        }
        // store[_key] = multiValue;
    }

    function get(string _key) public view returns (string value, bool isLocked) {
        // TODO: Figure out fees split
        MultiValue storage multiValue = store[_key];
        if (multiValue.numValues == 0) {
            return ("", false);
        }
        return (multiValue.values[multiValue.topValueId].value, multiValue.isLocked);
    }
}