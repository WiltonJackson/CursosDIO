pragma solidity ^0.8.0;

// Importações da OpenZeppelin para funcionalidades padrão e segurança.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract WJToken is ERC20, ERC20Burnable, Ownable, Pausable {
    // Definindo o total de tokens que será criado na implantação.
    uint256 private constant INITIAL_SUPPLY = 15 ether; // 15 tokens com 18 casas decimais.

    // Construtor: cria o token com o nome, símbolo e realiza o mint do supply inicial para o deployer (msg.sender).
    constructor() ERC20("WJ Token", "WJ") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    // Função para criar novos tokens. Restrita ao owner do contrato.
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    // Função para pausar todas as transferências de tokens. Restrita ao owner.
    function pause() external onlyOwner {
        _pause();
    }

    // Função para despausar as transferências de tokens. Restrita ao owner.
    function unpause() external onlyOwner {
        _unpause();
    }

    // Sobrescrevendo a função _beforeTokenTransfer para incluir a lógica de pausabilidade.
    function _beforeTokenTransfer(address from, address to, uint256 amount) 
        internal 
        whenNotPaused 
        override 
    {
        super._beforeTokenTransfer(from, to, amount);
    }

    // Função de burn já implementada pela OpenZeppelin (ERC20Burnable) para destruição de tokens.
    // Os tokens queimados são removidos permanentemente do supply total.
}
