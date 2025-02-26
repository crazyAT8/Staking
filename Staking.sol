// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingContract is Ownable {
    IERC20 public stakingToken;

    uint256 public constant LOCK_PERIOD = 30 days;
    uint256 public constant REWARD_RATE = 10; // 10% fixed reward per stake

    struct Stake {
        uint256 amount;
        uint256 startTime;
        bool withdrawn;
    }

    mapping(address => Stake) public stakes;
    uint256 public totalStaked;
    uint256 public totalRewardsFunded;

    event Staked(address indexed user, uint256 amount, uint256 timestamp);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward, uint256 timestamp);
    event RewardsFunded(address indexed owner, uint256 amount);

    constructor(address _stakingToken) Ownable(msg.sender) {
        require(_stakingToken != address(0), "Invalid token address");
        stakingToken = IERC20(_stakingToken);
    }

    function stake(uint256 _amount) external {
        require(_amount > 0, "Cannot stake 0");
        require(stakes[msg.sender].amount == 0, "Already staked");

        stakingToken.transferFrom(msg.sender, address(this), _amount);
        stakes[msg.sender] = Stake(_amount, block.timestamp, false);
        totalStaked += _amount;

        emit Staked(msg.sender, _amount, block.timestamp);
    }

    function withdraw() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No active stake");
        require(block.timestamp >= userStake.startTime + LOCK_PERIOD, "Stake is still locked");
        require(!userStake.withdrawn, "Already withdrawn");

        uint256 reward = (userStake.amount * REWARD_RATE) / 100;
        require(reward <= totalRewardsFunded, "Insufficient rewards");

        uint256 totalAmount = userStake.amount + reward;
        stakingToken.transfer(msg.sender, totalAmount);

        userStake.withdrawn = true;
        totalRewardsFunded -= reward;
        totalStaked -= userStake.amount;

        emit Withdrawn(msg.sender, userStake.amount, reward, block.timestamp);
    }

    function fundRewards(uint256 _amount) external onlyOwner {
        require(_amount > 0, "Amount must be greater than 0");
        stakingToken.transferFrom(msg.sender, address(this), _amount);
        totalRewardsFunded += _amount;

        emit RewardsFunded(msg.sender, _amount);
    }

    function getStakeInfo(address _user) external view returns (uint256, uint256, bool) {
        Stake storage userStake = stakes[_user];
        return (userStake.amount, userStake.startTime, userStake.withdrawn);
    }
}
