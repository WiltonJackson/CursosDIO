## Projeto Jackson Token
Este projeto tem a finalidade de atender ao desafio do curso de Blockchain, demonstrando um código simples para emissão de criptomoedas na blockchain Ethereum.
Utilizamos uma testnet para execução código e criação das moedas, seguindo a ordem abaixo: Não vamos entrar em detlhes pois existem bons tutoriais disponiveis na internet:

1. Configuração da Carteira (neste caso utlizamos a metamask e adicionamos a rede sepholia testnet);
2. Utilizando um faucet enviamos moedas ETH para pagamento das taxas (lembrando que o ETH gerado pela faceut é apenas para test);
3. utilizando a ide REMIX criamos um arquivo com o codigo do contrato e compilamos o mesmo. Lembrando que é necessário apontar o editor REMIX para a nossa carteira metamask;
4. Ainda na ide Remix executamos o deploy do contrato;
5. tudo dando certo você receberá os tokens na sua carteira.


** links: **
Site da metamask (download da carteira): https://metamask.io/
Site Sepholia Faucet (Obter ETH para testes) : https://www.alchemy.com/faucets/ethereum-sepolia
Site Remix IDE (Editor): https://remix.ethereum.org/
Site Etherscan (Sepholia apenas para testes): https://sepolia.etherscan.io/



## Resumindo o Contrato Jackson Token ERC20
Este contrato é uma implementação básica do padrão ERC20, que inclui as funcionalidades essenciais para um token fungível na blockchain Ethereum. Cada função segue as diretrizes da interface ERC20 e inclui verificações para segurança e conformidade.

**1. Cabeçalho e Licença**

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity ^0.8.7;
  
SPDX-License-Identifier: Especifica a licença do código. Aqui, usamos a licença GPL-3.0, uma licença aberta.
Pragma: Define a versão do compilador Solidity que o contrato requer (^0.8.7). Isso indica que o código deve ser compilado com a versão 0.8.7 ou superior da série 0.8.

**2. Interface ERC20**

    interface ERC20Interface {
     	function totalSupply() external view returns (uint);
     	function balanceOf(address account) external view returns (uint);
     	function allowance(address owner, address spender) external view returns (uint);

    	function transfer(address recipient, uint amount) external returns (bool);
		function approve(address spender, uint amount) external returns (bool);
    	function transferFrom(address sender, address recipient, uint amount) external returns(bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
	}
A interface ERC20Interface define o padrão ERC20 que qualquer token deve seguir.
Funções:
totalSupply(): Retorna o total de tokens em circulação.
balanceOf(address account): Retorna o saldo de tokens de uma conta.
allowance(address owner, address spender): Retorna o limite de tokens que um spender pode gastar da conta do owner.
transfer(address recipient, uint amount): Transfere tokens do remetente para o destinatário.
approve(address spender, uint amount): Aprova um spender para gastar uma quantidade específica de tokens.
transferFrom(address sender, address recipient, uint amount): Permite que tokens sejam transferidos de uma conta por outra, desde que tenha aprovação.
Eventos:
Transfer: Disparado quando tokens são transferidos.
Approval: Disparado quando uma aprovação é estabelecida via approve.

**3. Implementação do Contrato JacksonToken**

	contract JacksonToken is ERC20Interface {
    	string public name = "Jackson Coin";
   	 string public symbol = "JCK";
    	uint8 public decimals = 8; // Casas decimais padrão
   	 uint private _totalSupply; // Quantidade total de tokens

Variáveis do Contrato:
name: Nome do token.
symbol: Símbolo do token, que aparece em exchanges e carteiras.
decimals: Define o número de casas decimais para o token (8 neste caso, similar a satoshis para Bitcoin).
_totalSupply: Armazena o total de tokens criados.

    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) private allowed;

Mappings:
balances: Armazena o saldo de cada endereço (carteira).
allowed: Armazena a quantidade que um spender é permitido gastar em nome de um owner.

**4. Construtor**


    constructor() {
        _totalSupply = 1000000 * 10 ** uint(decimals); // Definindo o total de tokens com casas decimais
        balances[msg.sender] = _totalSupply; // Atribuindo todos os tokens ao criador do contrato
        emit Transfer(address(0), msg.sender, _totalSupply); // Emitindo evento de transferência inicial
    }
Construtor:
Define o total de tokens (_totalSupply) considerando as casas decimais.
Atribui todos os tokens ao criador do contrato (msg.sender).
Emite um evento Transfer do endereço zero para o criador, representando a criação dos tokens.

**5. Implementação das Funções ERC20**

    function totalSupply() public view override returns (uint) {
        return _totalSupply;
    }
totalSupply(): Retorna o total de tokens disponíveis no contrato.


    function balanceOf(address account) public view override returns (uint) {
        return balances[account];
    }
balanceOf(address account): Retorna o saldo de uma conta específica.

    function allowance(address owner, address spender) public view override returns (uint) {
        return allowed[owner][spender];
    }
allowance(address owner, address spender): Retorna a quantidade de tokens que um spender pode gastar da conta do owner.

    function transfer(address recipient, uint amount) public override returns (bool) {
        require(recipient != address(0), "Endereço inválido");
        require(amount <= balances[msg.sender], "Saldo insuficiente");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
transfer(address recipient, uint amount):
Transfere amount de tokens para recipient.
Verifica se o destinatário é válido e se o remetente tem saldo suficiente.
Atualiza os saldos e emite o evento Transfer.
solidity
Copiar código
    function approve(address spender, uint amount) public override returns (bool) {
        require(spender != address(0), "Endereço inválido");

        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
approve(address spender, uint amount):
Aprova spender para gastar amount de tokens da conta do remetente.
Emite o evento Approval.

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
transferFrom(address sender, address recipient, uint amount):
Permite que msg.sender transfira tokens de sender para recipient.
Verifica que o remetente e o destinatário são válidos, que há saldo suficiente e que o limite aprovado não foi excedido.
Atualiza os saldos, reduz o limite aprovado e emite o evento Transfer.


## Não custa pedir :) 
Se este exemplo te ajudou e você quiser doar algumas criptos de verdade, sinta-se a vontade. vai  ajudar muito nos meus projetos futuros.

**Etherium:** 0xD492cE3FFd39B27cE7Ed42C8976E2cA449978677
**Bitcoin:** bc1qde729nprulnatvfymfprda9xpjfjel2ldp5n80
**BNB:** 0xD492cE3FFd39B27cE7Ed42C8976E2cA449978677


