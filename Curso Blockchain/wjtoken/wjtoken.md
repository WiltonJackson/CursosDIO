## Resumo sobre o codigo do arquivo wjtoken.sol
###### Este código é um fork do arquivo disponibilizado pela DIO no Modulo 03 Desenvolvimento com Solidity/Curso 02 Desenvolvimento de Smart Contracts/Criando a sua primeira criptomoeda da Rede Ethereum disponivel em http://github.com/digitalinnovationone/formacao-blockchain-dio/blob/main/Modulo%2003%20Desenvolvimento%20com%20Solidity/Curso%2002%20Desenvolvimento%20de%20Smart%20Contracts/Criando%20a%20sua%20primeira%20criptomoeda%20da%20Rede%20Ethereum/DIOToken.sol
### 1. Interface IERC20

A interface `IERC20` define os padrões mínimos que um contrato ERC-20 deve seguir. Ela inclui as seguintes funções e eventos:

-   **Funções de visualização (getters)**:
    
    -   `totalSupply()`: Retorna o total de tokens em circulação.
    -   `balanceOf(address account)`: Retorna o saldo de tokens de um determinado endereço.
    -   `allowance(address owner, address spender)`: Retorna a quantidade máxima de tokens que um `spender` (gastador) pode gastar do saldo do `owner` (proprietário).
-   **Funções principais**:
    
    -   `transfer(address recipient, uint256 amount)`: Transfere uma quantidade específica de tokens para o `recipient`.
    -   `approve(address spender, uint256 amount)`: Aprova um `spender` para gastar até uma quantidade específica de tokens do saldo do `msg.sender`.
    -   `transferFrom(address sender, address recipient, uint256 amount)`: Transfere tokens de um `sender` para um `recipient`, usando a quantidade permitida.
-   **Eventos**:
    
    -   `Transfer(address indexed from, address indexed to, uint256 value)`: Emitido quando ocorre uma transferência de tokens.
    -   `Approval(address indexed owner, address indexed spender, uint256)`: Emitido quando uma aprovação é concedida para que um `spender` gaste tokens de um `owner`.

### 2. Contrato WJToken

O contrato `WJToken` implementa a interface `IERC20` e define o comportamento do token.

-   **Constantes**:
    
    -   `name`: Nome do token ("WJ TOKEN").
    -   `symbol`: Símbolo do token ("WJ").
    -   `decimals`: Número de casas decimais do token (18, que é padrão para ERC-20).
-   **Mapeamentos**:
    
    -   `balances`: Armazena os saldos de cada endereço.
    -   `allowed`: Armazena as permissões de gastos de tokens entre diferentes endereços (`owner` e `delegate`).
-   **Variável totalSupply_**:
    
    -   Define a quantidade total de tokens criados (inicialmente 10 ether, que equivale a 10 * 10^18 unidades de token).
-   **Construtor**:
    
    -   O construtor é executado quando o contrato é implantado na blockchain e define o saldo inicial do `msg.sender` (a conta que implanta o contrato) como a quantidade total de tokens (`totalSupply_`).
-   **Funções principais**:
    
    -   `totalSupply()`: Retorna o total de tokens disponíveis.
    -   `balanceOf(address tokenOwner)`: Retorna o saldo de tokens de um endereço especificado.
    -   `transfer(address receiver, uint256 numTokens)`: Transfere tokens do `msg.sender` para o `receiver`, emitindo o evento `Transfer`.
    -   `approve(address delegate, uint256 numTokens)`: Permite que um `delegate` gaste tokens do `msg.sender`, emitindo o evento `Approval`.
    -   `allowance(address owner, address delegate)`: Retorna a quantidade de tokens que um `delegate` está autorizado a gastar do saldo do `owner`.
    -   `transferFrom(address owner, address buyer, uint256 numTokens)`: Permite que um `delegate` transfira tokens de um `owner` para um `buyer`, usando a quantidade de tokens aprovada anteriormente, e emite o evento `Transfer`.

### Análise de Funcionamento

1.  **Transferências**: As funções `transfer` e `transferFrom` realizam transferências de tokens entre contas, ajustando os saldos de forma adequada e emitindo eventos para registrar as transações na blockchain.
    
2.  **Aprovação e Gastos**: A função `approve` é usada para permitir que um terceiro (`delegate`) gaste tokens do `msg.sender`. A função `allowance` verifica o limite dessa permissão, e `transferFrom` realiza a transferência dentro dos limites permitidos.
    
3.  **Eventos**: Os eventos `Transfer` e `Approval` são importantes para que as transações e aprovações sejam registradas na blockchain e possam ser monitoradas por interfaces de usuário e outras aplicações.
    

Este contrato segue o padrão ERC-20, que é amplamente usado para criar tokens fungíveis em redes como Ethereum, o que garante compatibilidade com carteiras, exchanges e outras infraestruturas que suportam esse padrão.

--------------------------
### Alterações aplicadas no arquivo original: 
-   **Uso da Biblioteca OpenZeppelin**:
    
    -   Importamos módulos do OpenZeppelin como `ERC20`, `ERC20Burnable`, `Ownable`, e `Pausable` para adicionar funcionalidades robustas, segurança, e conformidade com os padrões do ERC-20.
-   **Mint e Burn**:
    
    -   Adicionamos a função `mint` que permite ao proprietário do contrato criar novos tokens.
    -   `ERC20Burnable` já fornece uma função `burn` para destruição de tokens.
-   **Controle de Acesso com Ownable**:
    
    -   Funções sensíveis como `mint`, `pause`, e `unpause` são restritas ao proprietário do contrato (`onlyOwner`), usando o padrão `Ownable` para gerenciamento de acesso.
-   **Pausabilidade**:
    
    -   Adicionamos funções `pause` e `unpause` que permitem ao proprietário pausar ou despausar as transferências de tokens em caso de emergências, utilizando o módulo `Pausable`.
-   **Eficiência e Segurança**:
    
    -   O contrato herda otimizações e verificações de segurança diretamente das implementações do OpenZeppelin, que são amplamente auditadas e confiáveis.
-   **Documentação**:
    
    -   O código é claro e conciso, com funções bem definidas e uso de boas práticas para gerenciamento de supply e transferência de tokens.