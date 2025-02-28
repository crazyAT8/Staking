Here is a standard 30-day coin staking smart contract written in Solidity. 
This contract allows users to stake ERC-20 tokens and earn rewards after a 30-day lock-in period.

# H1 Features:
- Users can stake any amount of token.
- Funds are locked for 30 days form the staking time.
- After 30 days, users can withdraw their staked amount along with a fixed reward.
- The comtract owmer can fund the contract with rewards.
- Basic security checks are included.

-----------------------------------------------------------------------------------------------------

# H1 How It Works:
1. Deploy the contract, passing the ERC-20 token address as _stakingToken.
2. Owner funds rewards using fundRewards(uint256 _amount).
3. Users stake tokens by calling stake(uint256 _amount).
4. Tokens are locked for 30 days.
5. Users withdraw after 30 days to receive their staked amount + 10% reward.

------------------------------------------------------------------------------------------------------

# H1 Security Considerations:
1. Uses OpenZeppelin's IERC20 for safe token interactions.
2. Prevents multiple stakes per user.
3. Ensures rewards are available before withdrawal.
4. Owner-only control over reward funding.
5. Prevents reentrancy by marking stakes as withdrawn before transfers.
6. Would you like any modifications, such as variable reward rates or multiple staking entries per user?