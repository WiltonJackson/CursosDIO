CREATE DATABASE IF NOT EXISTS oficina_wj 
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oficina_wj;

-- =====================================================
-- 1. Cliente
-- =====================================================
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    endereco TEXT,
    origem ENUM('Indicação','Google','Instagram','Facebook','Site','Retorno','Outros') DEFAULT 'Retorno',
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    INDEX idx_cliente_telefone (telefone),
    INDEX idx_cliente_nome (nome)
) ENGINE=InnoDB;

-- =====================================================
-- 2. Veículo
-- =====================================================
CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    placa CHAR(7) NOT NULL UNIQUE,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano YEAR NOT NULL,
    km_atual INT DEFAULT 0,
    cor VARCHAR(30),
    observacoes TEXT,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE RESTRICT,
    INDEX idx_placa (placa)
) ENGINE=InnoDB;

-- =====================================================
-- 3. Equipe e Mecânico
-- =====================================================
CREATE TABLE equipe (
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    nome_equipe VARCHAR(100) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE mecanico (
    id_mecanico INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    id_equipe INT NULL,
    especialidade VARCHAR(100),
    ativo BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_mecanico_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe) ON DELETE SET NULL
) ENGINE=InnoDB;

-- =====================================================
-- 4. Catálogo de Serviços e Pacotes
-- =====================================================
CREATE TABLE servico_referencia (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,           -- ex: TROCA-OLEO
    descricao VARCHAR(255) NOT NULL,
    preco_mao_obra DECIMAL(10,2) NOT NULL,
    tempo_estimado_minutos INT NOT NULL DEFAULT 60,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- Pacotes (ex: Revisão 10.000km, Freios Completos)
CREATE TABLE pacote_servico (
    id_pacote INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_total DECIMAL(10,2) NOT NULL,
    valido_ate DATE NULL,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

CREATE TABLE pacote_item (
    id_pacote INT,
    id_servico INT,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (id_pacote, id_servico),
    FOREIGN KEY (id_pacote) REFERENCES pacote_servico(id_pacote) ON DELETE CASCADE,
    FOREIGN KEY (id_servico) REFERENCES servico_referencia(id_servico)
) ENGINE=InnoDB;

-- =====================================================
-- 5. Peças e Estoque
-- =====================================================
CREATE TABLE peca (
    id_peca INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(30) UNIQUE NOT NULL,
    descricao VARCHAR(255) NOT NULL,
    preco_custo DECIMAL(10,2) DEFAULT 0.00,
    preco_venda DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    estoque_minimo INT DEFAULT 5,
    fornecedor VARCHAR(150),
    ativo BOOLEAN DEFAULT TRUE,
    INDEX idx_peca_codigo (codigo)
) ENGINE=InnoDB;

-- =====================================================
-- 6. Agendamento (o coração do sistema!)
-- =====================================================
CREATE TABLE agendamento (
    id_agendamento INT AUTO_INCREMENT PRIMARY KEY,
    id_veiculo INT NOT NULL,
    id_mecanico INT NULL,
    id_equipe INT NULL,
    data_hora_inicio DATETIME NOT NULL,
    data_hora_fim_previsto DATETIME NOT NULL,
    tempo_previsto_minutos INT NOT NULL,
    status ENUM('Agendado','Confirmado','Chegou','Em Execução','Concluído','No-Show','Cancelado') DEFAULT 'Agendado',
    observacoes TEXT,
    lembrete_enviado BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_agendamento_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    CONSTRAINT fk_agendamento_mecanico FOREIGN KEY (id_mecanico) REFERENCES mecanico(id_mecanico),
    CONSTRAINT fk_agendamento_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),
    INDEX idx_agendamento_data (data_hora_inicio),
    INDEX idx_agendamento_status (status)
) ENGINE=InnoDB;

-- =====================================================
-- 7. Ordem de Serviço
-- =====================================================
CREATE TABLE ordem_servico (
    id_os INT AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT NULL,
    numero_os VARCHAR(20) UNIQUE NOT NULL,           -- ex: OS-2025-0123
    id_veiculo INT NOT NULL,
    id_mecanico_responsavel INT NULL,
    id_equipe INT NULL,
    data_emissao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_conclusao DATETIME NULL,
    km_entrada INT NOT NULL,
    km_saida INT NULL,
    valor_total DECIMAL(12,2) DEFAULT 0.00,
    status_os ENUM('Orçamento','Aguardando Aprovação','Aprovado','Em Execução','Concluído','Faturado','Cancelado') DEFAULT 'Orçamento',
    observacoes_cliente TEXT,
    diagnostico TEXT,
    recomendacoes TEXT,
    CONSTRAINT fk_os_veiculo FOREIGN KEY (id_veiculo) REFERENCES veiculo(id_veiculo),
    CONSTRAINT fk_os_agendamento FOREIGN KEY (id_agendamento) REFERENCES agendamento(id_agendamento),
    CONSTRAINT fk_os_mecanico FOREIGN KEY (id_mecanico_responsavel) REFERENCES mecanico(id_mecanico),
    CONSTRAINT fk_os_equipe FOREIGN KEY (id_equipe) REFERENCES equipe(id_equipe),
    INDEX idx_numero_os (numero_os),
    INDEX idx_os_status (status_os)
) ENGINE=InnoDB;

-- =====================================================
-- 8. Itens da OS (serviços e peças)
-- =====================================================
CREATE TABLE os_servico (
    id_os INT,
    id_servico INT,
    id_pacote INT NULL,               -- se veio de pacote
    quantidade DECIMAL(10,2) DEFAULT 1,
    preco_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY (id_os, id_servico),
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE,
    FOREIGN KEY (id_servico) REFERENCES servico_referencia(id_servico),
    FOREIGN KEY (id_pacote) REFERENCES pacote_servico(id_pacote)
) ENGINE=InnoDB;

CREATE TABLE os_peca (
    id_os INT,
    id_peca INT,
    quantidade DECIMAL(10,2) NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    PRIMARY KEY (id_os, id_peca),
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE,
    FOREIGN KEY (id_peca) REFERENCES peca(id_peca)
) ENGINE=InnoDB;

-- =====================================================
-- 9. Checklist Digital Obrigatório
-- =====================================================
CREATE TABLE checklist_template (
    id_checklist INT AUTO_INCREMENT PRIMARY KEY,
    id_servico INT,
    descricao VARCHAR(255) NOT NULL,
    obrigatorio BOOLEAN DEFAULT TRUE,
    exige_foto BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_servico) REFERENCES servico_referencia(id_servico) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE checklist_execucao (
    id_execucao INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    id_checklist INT NOT NULL,
    concluido BOOLEAN DEFAULT FALSE,
    foto_url VARCHAR(500) NULL,
    observacao TEXT,
    data_execucao DATETIME NULL,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE,
    FOREIGN KEY (id_checklist) REFERENCES checklist_template(id_checklist)
) ENGINE=InnoDB;

-- =====================================================
-- 10. Garantia
-- =====================================================
CREATE TABLE garantia (
    id_garantia INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    tipo ENUM('Serviço','Peça') NOT NULL,
    id_servico INT NULL,
    id_peca INT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    km_inicio INT NOT NULL,
    km_valido INT NOT NULL,           -- ex: +5.000 km
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- 11. Aprovação Digital do Orçamento
-- =====================================================
CREATE TABLE aprovacao_orcamento (
    id_aprovacao INT AUTO_INCREMENT PRIMARY KEY,
    id_os INT NOT NULL,
    token VARCHAR(64) UNIQUE NOT NULL,
    data_envio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_aprovacao DATETIME NULL,
    status ENUM('Pendente','Aprovado','Reprovado','Parcial') DEFAULT 'Pendente',
    valor_aprovado DECIMAL(12,2) NULL,
    ip_aprovacao VARCHAR(45),
    user_agent TEXT,
    FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE
) ENGINE=InnoDB;

-- =====================================================
-- Triggers: Atualiza valor_total automaticamente
-- =====================================================
DELIMITER $$
CREATE TRIGGER trg_atualiza_valor_os_insert AFTER INSERT ON os_servico
FOR EACH ROW
BEGIN
    UPDATE ordem_servico os
    SET valor_total = (
        SELECT COALESCE(SUM((s.quantidade * s.preco_unitario) - s.desconto),0)
        FROM os_servico s WHERE s.id_os = NEW.id_os
    ) + (
        SELECT COALESCE(SUM((p.quantidade * p.preco_unitario) - p.desconto),0)
        FROM os_peca p WHERE p.id_os = NEW.id_os
    )
    WHERE os.id_os = NEW.id_os;
END$$

CREATE TRIGGER trg_atualiza_valor_os_update AFTER UPDATE ON os_servico
FOR EACH ROW
BEGIN
    UPDATE ordem_servico os
    SET valor_total = (
        SELECT COALESCE(SUM((s.quantidade * s.preco_unitario) - s.desconto),0)
        FROM os_servico s WHERE s.id_os = NEW.id_os
    ) + (
        SELECT COALESCE(SUM((p.quantidade * p.preco_unitario) - p.desconto),0)
        FROM os_peca p WHERE p.id_os = NEW.id_os
    )
    WHERE os.id_os = NEW.id_os;
END$$

CREATE TRIGGER trg_atualiza_valor_os_peca AFTER INSERT OR UPDATE OR DELETE ON os_peca
FOR EACH ROW
BEGIN
    DECLARE os_id INT;
    IF (TG_OP = 'DELETE') THEN SET os_id = OLD.id_os;
    ELSE SET os_id = NEW.id_os; END IF;

    UPDATE ordem_servico os
    SET valor_total = (
        SELECT COALESCE(SUM((s.quantidade * s.preco_unitario) - s.desconto),0)
        FROM os_servico s WHERE s.id_os = os_id
    ) + (
        SELECT COALESCE(SUM((p.quantidade * p.preco_unitario) - p.desconto),0)
        FROM os_peca p WHERE p.id_os = os_id
    )
    WHERE os.id_os = os_id;
END$$
DELIMITER ;
