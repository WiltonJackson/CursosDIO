## Desafio Dio: Batalha Pokemon

### TECNOLOGIAS UTILIZADA
### SOLIDITY - GANACHE - REMIX IDE - METAMASK - IPFS - LEONARD.AI


## OBJETIVOS
1 Criar o contrato no Padrão ERC-721
2 Publicar na blockchain (utilizado o ganache para emulação)
3 Transferir Cards
4 Executar batalhas

## Melhorias propostas
Aqui estão algumas sugestões de funcionalidades adicionais e melhorias que podemos considerar:

# 1. Eventos
Adicionar eventos para registrar atividades importantes, como a criação de um novo guerreiro e batalhas, facilita o rastreamento e a auditoria das operações do contrato.

event GuerreiroCreated(uint indexed guerreiroId, string name, address indexed owner);
event BattleResult(uint indexed attackerId, uint indexed defenderId, bool attackerWon);

No contrato, podemos disparar esses eventos nas funções relevantes:


function createNewGuerreiro(string memory _name, address _to, string memory _img) public {
    require(msg.sender == gameOwner, "Apenas o dono do jogo pode criar novos guerreiros");
    uint id = guerreiros.length;
    guerreiros.push(Guerreiro(_name, 1, _img));
    _safeMint(_to, id);
    emit GuerreiroCreated(id, _name, _to);
}

function battle(uint _attackerId, uint _defenderId) public onlyOwnerOf(_attackerId) {
    require(_attackerId < guerreiros.length && _defenderId < guerreiros.length, "ID do guerreiro inválido");

    Guerreiro storage attacker = guerreiros[_attackerId];
    Guerreiro storage defender = guerreiros[_defenderId];

    bool attackerWon;
    if (attacker.level >= defender.level) {
        attacker.level += 2;
        defender.level += 1;
        attackerWon = true;
    } else {
        attacker.level += 1;
        defender.level += 2;
        attackerWon = false;
    }

    emit BattleResult(_attackerId, _defenderId, attackerWon);
}

# 2. Função de Transferência de Propriedade
Permitir que o dono do contrato transfira a propriedade a outra conta pode ser útil para o gerenciamento contínuo do contrato.

function transferOwnership(address newOwner) public {
    require(msg.sender == gameOwner, "Apenas o dono atual pode transferir a propriedade");
    require(newOwner != address(0), "Novo dono não pode ser o endereço zero");
    gameOwner = newOwner;
}
# 3. Adicionar uma função para atualizar as informações de um guerreiro, como seu nome ou imagem, pode ser útil para manutenção e personalização.

function updateGuerreiro(uint _guerreiroId, string memory _name, string memory _img) public onlyOwnerOf(_guerreiroId) {
    require(_guerreiroId < guerreiros.length, "ID do guerreiro inválido");
    Guerreiro storage guerreiro = guerreiros[_guerreiroId];
    guerreiro.name = _name;
    guerreiro.img = _img;
}

# 4. Função de Consulta
Adicionar funções de consulta para obter informações sobre guerreiros pode tornar a interação com o contrato mais fácil.

function getGuerreiro(uint _guerreiroId) public view returns (string memory name, uint level, string memory img) {
    require(_guerreiroId < guerreiros.length, "ID do guerreiro inválido");
    Guerreiro storage guerreiro = guerreiros[_guerreiroId];
    return (guerreiro.name, guerreiro.level, guerreiro.img);
}

# 5. Proteção Contra Overflow
implementando limites máximos de nível.

uint constant MAX_LEVEL = 100;
function battle(uint _attackerId, uint _defenderId) public onlyOwnerOf(_attackerId) {
    require(_attackerId < guerreiros.length && _defenderId < guerreiros.length, "ID do guerreiro inválido");

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




## Explicação do arquivo index.html
Explicação dos Componentes:
Conexão com Ethereum: O script se conecta à rede Ethereum usando web3.js e a carteira do MetaMask.

Funções do Contrato: createGuerreiro, updateGuerreiro, battle, e getGuerreiro chamam as funções do contrato inteligente.
Formulários HTML:
Cada formulário permite a interação com uma função específica do contrato.

Exibição de Resultados e Erros:
O <pre id="output"></pre> exibe mensagens de sucesso ou erro.

Passos para Uso:
Substitua os Placeholders:

Substitua 'YOUR_CONTRACT_ADDRESS' com o endereço do contrato inteligente implantado.
Substitua /* ABI array here */ com o ABI JSON do seu contrato.
