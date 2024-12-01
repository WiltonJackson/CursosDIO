// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CardGame is ERC721 {

    struct Guerreiro {
        string name;
        uint level;
        string img;
    }

    Guerreiro[] public guerreiros;
    address public gameOwner;
    uint constant MAX_LEVEL = 100;

    // Eventos para registrar atividades importantes
    event GuerreiroCreated(uint indexed guerreiroId, string name, address indexed owner);
    event BattleResult(uint indexed attackerId, uint indexed defenderId, bool attackerWon);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Construtor que define o dono do jogo e cria o token ERC721
    constructor () ERC721 ("BRAZUCA", "BCA") {
        gameOwner = msg.sender;
    } 

    // Modificador para garantir que apenas o dono de um guerreiro possa realizar determinadas ações
    modifier onlyOwnerOf(uint _guerreiroId) {
        require(ownerOf(_guerreiroId) == msg.sender, "Apenas o dono pode batalhar com este guerreiro");
        _;
    }

    // Modificador para garantir que apenas o dono do jogo possa realizar determinadas ações
    modifier onlyGameOwner() {
        require(msg.sender == gameOwner, "Apenas o dono do jogo pode realizar essa acao");
        _;
    }

    // Função para criar um novo guerreiro
    function createNewGuerreiro(string memory _name, address _to, string memory _img) public onlyGameOwner {
        uint id = guerreiros.length;
        guerreiros.push(Guerreiro(_name, 1, _img));
        _safeMint(_to, id);
        emit GuerreiroCreated(id, _name, _to);
    }

    // Função de batalha entre dois guerreiros
    function battle(uint _attackerId, uint _defenderId) public onlyOwnerOf(_attackerId) {
        require(_attackerId < guerreiros.length && _defenderId < guerreiros.length, "ID do guerreiro invalido");

        Guerreiro storage attacker = guerreiros[_attackerId];
        Guerreiro storage defender = guerreiros[_defenderId];

        if (attacker.level >= defender.level) {
            if (attacker.level + 2 > MAX_LEVEL) attacker.level = MAX_LEVEL;
            else attacker.level += 2;
            if (defender.level + 1 > MAX_LEVEL) defender.level = MAX_LEVEL;
            else defender.level += 1;
        } else {
            if (attacker.level + 1 > MAX_LEVEL) attacker.level = MAX_LEVEL;
            else attacker.level += 1;
            if (defender.level + 2 > MAX_LEVEL) defender.level = MAX_LEVEL;
            else defender.level += 2;
        }

        emit BattleResult(_attackerId, _defenderId, attacker.level > defender.level);
    }

    // Função para transferir a propriedade do contrato para outro endereço
    function transferOwnership(address newOwner) public onlyGameOwner {
        require(newOwner != address(0), "Novo dono nao pode ser o endereco zero");
        emit OwnershipTransferred(gameOwner, newOwner);
        gameOwner = newOwner;
    }

    // Função para atualizar o nome e imagem de um guerreiro
    function updateGuerreiro(uint _guerreiroId, string memory _name, string memory _img) public onlyOwnerOf(_guerreiroId) {
        require(_guerreiroId < guerreiros.length, "ID do guerreiro invalido");
        Guerreiro storage guerreiro = guerreiros[_guerreiroId];
        guerreiro.name = _name;
        guerreiro.img = _img;
    }

    // Função de consulta para obter informações sobre um guerreiro
    function getGuerreiro(uint _guerreiroId) public view returns (string memory name, uint level, string memory img) {
        require(_guerreiroId < guerreiros.length, "ID do guerreiro invalido");
        Guerreiro storage guerreiro = guerreiros[_guerreiroId];
        return (guerreiro.name, guerreiro.level, guerreiro.img);
    }
}
