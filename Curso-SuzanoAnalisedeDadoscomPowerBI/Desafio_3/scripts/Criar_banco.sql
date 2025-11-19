CREATE SCHEMA ecommerce_wj;
USE ecommerce_wj;


-- Habilita chaves estrangeiras (caso esteja desativado)
SET FOREIGN_KEY_CHECKS = 1;

-- Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cpf CHAR(11) UNIQUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    endereco TEXT
);

-- Pedido
CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Pago', 'Em separação', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    forma_pagamento VARCHAR(50),
    codigo_rastreio VARCHAR(50),
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Terceiro - Vendedor (marketplace)
CREATE TABLE Terceiro_Vendedor (
    idTerceiro_Vendedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(100),
    cnpj CHAR(14) UNIQUE NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    comissao_percentual DECIMAL(5,2) DEFAULT 15.00,
    ativo BOOLEAN DEFAULT TRUE
);

-- Fornecedor
CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    cnpj CHAR(14) UNIQUE,
    contato VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- Produto (tabela principal)
CREATE TABLE Produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    descricao TEXT,
    preco_venda DECIMAL(10,2) NOT NULL,
    peso_gramas INT,
    altura_cm DECIMAL(6,2),
    largura_cm DECIMAL(6,2),
    comprimento_cm DECIMAL(6,2),
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Quem vende este produto no marketplace (pode ser NULL se for estoque próprio da loja)
    idTerceiro_Vendedor INT NULL,
    
    FOREIGN KEY (idTerceiro_Vendedor) REFERENCES Terceiro_Vendedor(idTerceiro_Vendedor)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Tabela de relacionamento Produto x Fornecedor (um produto pode ter vários fornecedores)
CREATE TABLE Produto_has_Fornecedor (
    Produto_idProduto INT NOT NULL,
    Fornecedor_idFornecedor INT NOT NULL,
    preco_custo DECIMAL(10,2) NOT NULL,
    prazo_entrega_dias INT DEFAULT 7,
    
    PRIMARY KEY (Produto_idProduto, Fornecedor_idFornecedor),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Local de Estoque (CDs, lojas físicas, etc.)
CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    local VARCHAR(45) NOT NULL,        -- ex: "CD São Paulo", "Loja Rio", "Armazém RJ"
    endereco TEXT
);

-- Estoque físico detalhado (lotes, quantidade real, etc.)
CREATE TABLE Em_estoque (
    Produto_idProduto INT NOT NULL,
    Estoque_idEstoque INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    reserva INT NOT NULL DEFAULT 0,    -- quantidade já reservada para pedidos
    lote VARCHAR(50),
    validade DATE,
    
    PRIMARY KEY (Produto_idProduto, Estoque_idEstoque),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque(idEstoque)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Relacionamento N:M entre Pedido e Produto (itens do pedido)
CREATE TABLE Produto_has_Pedido (
    Produto_idProduto INT NOT NULL,
    Pedido_idPedido INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario_vendido DECIMAL(10,2) NOT NULL,   -- preço no momento da compra
    idTerceiro_Vendedor INT NULL,                    -- de quem foi comprado (se terceiros)
    
    PRIMARY KEY (Produto_idProduto, Pedido_idPedido),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (idTerceiro_Vendedor) REFERENCES Terceiro_Vendedor(idTerceiro_Vendedor)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Índices úteis para performance
CREATE INDEX idx_pedido_cliente ON Pedido(idCliente);
CREATE INDEX idx_pedido_status ON Pedido(status);
CREATE INDEX idx_produto_nome ON Produto(nome);
CREATE INDEX idx_produto_vendedor ON Produto(idTerceiro_Vendedor);
CREATE INDEX idx_estoque_local ON Estoque(local);