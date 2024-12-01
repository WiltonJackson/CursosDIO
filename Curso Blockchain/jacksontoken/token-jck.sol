// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

// Definindo a interface ERC20 conforme o padrão
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

// Implementação do contrato JacksonToken que segue o padrão ERC20
contract JacksonToken is ERC20Interface {
    string public name = "Jackson Coin";
    string public symbol = "JCK";
    uint8 public decimals = 8; // Casas decimais padrão
    uint private _totalSupply; // Quantidade total de tokens

    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) private allowed;

    constructor() {
        _totalSupply = 1000000 * 10 ** uint(decimals); // Definindo o total de tokens com casas decimais
        balances[msg.sender] = _totalSupply; // Atribuindo todos os tokens ao criador do contrato
        emit Transfer(address(0), msg.sender, _totalSupply); // Emitindo evento de transferência inicial
    }

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint) {
        return balances[account];
    }

    function allowance(address owner, address spender) public view override returns (uint) {
        return allowed[owner][spender];
    }

    function transfer(address recipient, uint amount) public override returns (bool) {
        require(recipient != address(0), "Endereço inválido");
        require(amount <= balances[msg.sender], "Saldo insuficiente");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) public override returns (bool) {
        require(spender != address(0), "Endereço inválido");

        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
        require(sender != address(0), "Endereço inválido");
        require(recipient != address(0), "Endereço inválido");
        require(amount <= balances[sender], "Saldo insuficiente");
        require(amount <= allowed[sender][msg.sender], "Limite de transferência excedido");

        balances[sender] -= amount;
        allowed[sender][msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}

