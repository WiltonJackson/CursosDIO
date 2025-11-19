CREATE SCHEMA ecommerce_wj_v2;
USE ecommerce_wj_v2;

SET FOREIGN_KEY_CHECKS = 1;

-- Cliente (PF ou PJ, nunca os dois ao mesmo tempo)
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    tipo_cliente ENUM('PF', 'PJ') NOT NULL,
    nome VARCHAR(100) NOT NULL,                -- Nome completo (PF) ou Nome Fantasia (PJ)
    razao_social VARCHAR(150),                 -- Obrigatório apenas para PJ
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cpf CHAR(11) UNIQUE DEFAULT NULL,
    cnpj CHAR(14) UNIQUE DEFAULT NULL,
    inscricao_estadual VARCHAR(20) DEFAULT NULL, -- útil para PJ
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    endereco TEXT,

    CONSTRAINT chk_cliente_tipo CHECK (
        (tipo_cliente = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL AND razao_social IS NULL)
        OR
        (tipo_cliente = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL AND razao_social IS NOT NULL)
    )
);

-- Meios de pagamento cadastrados do cliente (cartão, PIX, etc.)
CREATE TABLE Meio_Pagamento (
    idMeio_Pagamento INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    tipo ENUM('cartao_credito', 'cartao_debito', 'pix', 'boleto', 'transferencia', 'outro') NOT NULL,
    descricao VARCHAR(100) NOT NULL,           -- ex: "Cartão Nubank **** 1234" ou "PIX - chave@email.com"
    detalhes JSON,                              -- pode guardar token, últimos 4 dígitos, chave PIX, etc.
    padrao BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_cliente_meio (idCliente)
);

-- Pedido
CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    idMeio_Pagamento INT NULL,                  -- meio de pagamento salvo usado (pode ser NULL se avulso)
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pendente', 'Pago', 'Em separação', 'Enviado', 'Entregue', 'Cancelado') DEFAULT 'Pendente',
    forma_pagamento VARCHAR(50),                -- mantido para casos avulsos ou descrição livre
    valor_total DECIMAL(12,2) DEFAULT 0.00,
    valor_frete DECIMAL(10,2) DEFAULT 0.00,     -- adicionado (muito útil)
    endereco_entrega TEXT NOT NULL,             -- pode ser diferente do endereço do cliente
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (idMeio_Pagamento) REFERENCES Meio_Pagamento(idMeio_Pagamento),
    INDEX idx_pedido_cliente (idCliente),
    INDEX idx_pedido_status (status),
    INDEX idx_pedido_data (data_pedido)
);

-- Entrega (tabela separada - pode evoluir para 1:N no futuro se quiser split shipment)
CREATE TABLE Entrega (
    idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT NOT NULL,
    status_entrega ENUM('Não iniciado', 'Em separação', 'Separado', 'Enviado', 'Em trânsito', 'Entregue', 'Extraviado', 'Devolvido') DEFAULT 'Não iniciado',
    codigo_rastreio VARCHAR(50),
    transportadora VARCHAR(100),
    data_envio DATETIME NULL,
    data_previsao_entrega DATE NULL,
    data_entrega_real DATETIME NULL,
    custo_frete DECIMAL(10,2) DEFAULT 0.00,
    
    UNIQUE KEY uk_pedido (idPedido), -- garante 1:1 por enquanto
    FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_rastreio (codigo_rastreio),
    INDEX idx_status_entrega (status_entrega)
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

-- Produto
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
    idTerceiro_Vendedor INT NULL,

    FOREIGN KEY (idTerceiro_Vendedor) REFERENCES Terceiro_Vendedor(idTerceiro_Vendedor)
        ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_produto_nome (nome),
    INDEX idx_produto_vendedor (idTerceiro_Vendedor),
    INDEX idx_produto_ativo (ativo)
);

-- Produto × Fornecedor
CREATE TABLE Produto_has_Fornecedor (
    Produto_idProduto INT NOT NULL,
    Fornecedor_idFornecedor INT NOT NULL,
    preco_custo DECIMAL(10,2) NOT NULL,
    prazo_entrega_dias INT DEFAULT 7,
    
    PRIMARY KEY (Produto_idProduto, Fornecedor_idFornecedor),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto) ON DELETE CASCADE,
    FOREIGN KEY (Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor) ON DELETE CASCADE
);

-- Local de Estoque
CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    local VARCHAR(60) NOT NULL,
    endereco TEXT,
    INDEX idx_local (local)
);

-- Estoque físico
CREATE TABLE Em_estoque (
    Produto_idProduto INT NOT NULL,
    Estoque_idEstoque INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    reserva INT NOT NULL DEFAULT 0,
    lote VARCHAR(50),
    validade DATE,
    
    PRIMARY KEY (Produto_idProduto, Estoque_idEstoque),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto) ON DELETE CASCADE,
    FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque(idEstoque) ON DELETE CASCADE,
    INDEX idx_quantidade (quantidade)
);

-- Itens do pedido
CREATE TABLE Produto_has_Pedido (
    Produto_idProduto INT NOT NULL,
    Pedido_idPedido INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario_vendido DECIMAL(10,2) NOT NULL,
    idTerceiro_Vendedor INT NULL,
    
    PRIMARY KEY (Produto_idProduto, Pedido_idPedido),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto) ON DELETE RESTRICT,
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido) ON DELETE CASCADE,
    FOREIGN KEY (idTerceiro_Vendedor) REFERENCES Terceiro_Vendedor(idTerceiro_Vendedor) ON DELETE SET NULL,
    INDEX idx_pedido (Pedido_idPedido)
);
