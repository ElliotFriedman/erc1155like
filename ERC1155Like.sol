/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
/// forked off of solmate 
abstract contract ERC1155Like {
    /*///////////////////////////////////////////////////////////////
                                  EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /*///////////////////////////////////////////////////////////////
                             METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*///////////////////////////////////////////////////////////////
                              ERC1155Like STORAGE
    //////////////////////////////////////////////////////////////*/

    mapping(uint256 => uint256) private _totalSupply;

    mapping(uint256 => mapping(address => uint256)) public balanceOf;

    mapping(uint256 => mapping(address => mapping(address => uint256))) public allowance;

    /*///////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function totalSupply(uint256 index) public view returns (uint256) {
        return _totalSupply[index];
    }

    /*///////////////////////////////////////////////////////////////
                              ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(uint256 index, address spender, uint256 amount) public virtual returns (bool) {
        allowance[index][msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(uint256 index, address to, uint256 amount) public virtual returns (bool) {
        balanceOf[index][msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[index][to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        uint256 index,
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        if (allowance[index][from][msg.sender] != type(uint256).max) {
            allowance[index][from][msg.sender] -= amount;
        }

        balanceOf[index][from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[index][to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /*///////////////////////////////////////////////////////////////
                       INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(uint256 index, address to, uint256 amount) internal virtual {
        _totalSupply[index] += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[index][to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(uint256 index, address from, uint256 amount) internal virtual {
        balanceOf[index][from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            _totalSupply[index] -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}
