USE ecommerce_wj;
SET FOREIGN_KEY_CHECKS = 1;

-- ====================================
-- 1. CLIENTES 
-- ====================================
INSERT INTO Cliente (nome, email, telefone, cpf, endereco) VALUES
('João Carlos Silva',       'joao.carlos@gmail.com',    '1198765-4321', '12345678901', 'Rua das Oficinas, 150 - São Paulo/SP'),
('Márcio Pereira',          'marcio.pereira@hotmail.com','2198765-4321', '23456789012', 'Av. Brasil, 2800 - Rio de Janeiro/RJ'),
('Roberto Oliveira',        'roberto.oli@outlook.com',   '1195544-3322', '34567890123', 'Rua do Mecânico, 89 - Guarulhos/SP'),
('Carlos Eduardo Santos',   'carlos.eduardo@uol.com.br','1199876-5432', '45678901234', 'Av. do Estado, 5000 - São Paulo/SP'),
('Fernanda Costa',          'nanda.costa@gmail.com',    '1191234-5678', '56789012345', 'Rua das Acácias, 320 - Osasco/SP'),
('Paulo Henrique',          'ph.mecanica@yahoo.com',    '1198765-1111', '67890123456', 'Estrada Velha de Campinas, 1200'),
('Antônio José',            'antoniojose@gmail.com',    '1194321-9876', '78901234567', 'Av. dos Autonomistas, 4500 - Osasco/SP'),
('Diego Almeida',           'diegoalmeida88@hotmail.com','1196655-4433', '89012345678', 'Rua Voluntários da Pátria, 890 - SP'),
('Lucas Mendes',            'lucas.mendes88@gmail.com', '1192233-4455', '90123456789', 'Av. Rebouças, 1500 - São Paulo/SP'),
('Rafael Souza',            'rafael.souza@hotmail.com', '1198877-6655', '01234567890', 'Marginal Tietê, km 18 - SP'),
('Eduardo Ferreira',        'eduferreira@gmail.com',    '1195544-7788', '11223344556', 'Av. Cupecê, 3000 - São Paulo/SP'),
('Marcelo Rocha',           'marcelo.rocha@uol.com.br', '1194433-2211', '22334455667', 'Rua Augusta, 2500 - São Paulo/SP');

-- ====================================
-- 2. TERCEIROS VENDEDORES 
-- ====================================
INSERT INTO Terceiro_Vendedor (razao_social, nome_fantasia, cnpj, email, telefone, comissao_percentual) VALUES
('Auto Peças Premium Ltda',      'Premium Parts',      '11222333000199', 'vendas@premiumparts.com.br', '1133332222', 14.00),
('Distribuidora Nakata',         'Nakata Oficial',     '22333444000188', 'parceria@nakata.com.br',     '1133334444', 12.50),
('Cofap Auto Peças',             'Cofap Store',        '33444555000177', 'loja@cofap.com.br',          '1133335555', 13.00),
('Bosch Service Partner',        'Bosch Auto',         '44555666000166', 'contato@boschauto.com.br',   '1133336666', 15.00),
('Magneti Marelli Brasil',       'Marelli Parts',      '55666777000155', 'vendas@marelli.com.br',      '1133337777', 14.50),
('DPaschoal Marketplace',        'DPaschoal',          '66777888000144', 'marketplace@dpaschoal.com.br','1633338888', 12.00);

-- ====================================
-- 3. FORNECEDORES 
-- ====================================
INSERT INTO Fornecedor (razao_social, cnpj, contato, telefone, email) VALUES
('Robert Bosch Ltda',              '60123456000123', 'Juliana Bosch',   '1133339999', 'juliana@bosch.com.br'),
('Nakata Automotiva SA',           '71234567000189', 'Marcelo Nakata',  '1133338888', 'marcelo@nakata.com.br'),
('Cofap Companhia Fabricadora',    '82345678000145', 'Renata Cofap',    '1133337777', 'renata@cofap.com.br'),
('Magneti Marelli Cofap',          '93456789000167', 'Carlos Marelli',  '1133336666', 'carlos@marelli.com.br'),
('Fras-le S.A.',                   '04567890000112', 'Ana Frasle',      '5133335555', 'ana@frasle.com.br'),
('Monroe Amortecedores',           '15678901000134', 'Paulo Monroe',    '1133334444', 'paulo@monroe.com.br'),
('Schaeffler Brasil (INA/FAG)',    '26789012000156', 'Roberto Schaeffler','1133332222','roberto@schaeffler.com.br');

-- ====================================
-- 4. LOCAIS DE ESTOQUE
-- ====================================
INSERT INTO Estoque (local, endereco) VALUES
('CD São Paulo - Zona Leste',   'Av. Amador Bueno da Veiga, 3000 - Penha/SP'),
('CD Guarulhos',                'Rod. Pres. Dutra, km 217 - Guarulhos/SP'),
('Loja Matriz - Mooca/SP',      'Rua da Mooca, 1500 - São Paulo/SP'),
('CD Campinas',                 'Rod. Anhanguera, km 104 - Campinas/SP');

-- ====================================
-- 5. 25 PRODUTOS 
-- ====================================
INSERT INTO Produto (nome, descricao, preco_venda, peso_gramas, altura_cm, largura_cm, comprimento_cm, ativo, idTerceiro_Vendedor) VALUES
('Pastilha Freio Dianteira Bosch Gol G5-G8',                'Cerâmica BB0502 - Jogo 4 peças', 289.90,  1500, 8,  15, 20, TRUE, 4),
('Amortecedor Dianteiro Cofap Fiat Toro 2016-2023',         'Par - GB48000',                 789.90,  9800, 65, 15, 15, TRUE, 3),
('Kit Embreagem Luk VW Gol 1.0 8v 2000-2014',              'Disco + platô + rolamento',     959.00,  7200, 35, 35, 10, TRUE, NULL),
('Filtro de Óleo Mann Filter Motor EA111 VW',              'W712/90',                       49.90,   320, 12,  8,  8, TRUE, NULL),
('Jogo Velas Ignição NGK Iridium Honda Civic 2017-2022',   'BKR6EIX-11 - 4 unid.',          279.90,  280, 10,  5,  5, TRUE, NULL),
('Correia Dentada Continental VW AP 2.0',                  'CT453 - Kit c/ tensor',         489.00,  1200, 25, 20, 10, TRUE, 1),
('Bateria Moura 60Ah M60GD',                               'Selada - 18 meses garantia',   589.00, 14800, 23, 18, 18, TRUE, NULL),
('Óleo Mobil Super 3000 5W30 Sintético 1L',                'API SN - Sintético',            52.90,   950, 25, 10,  5, TRUE, NULL),
('Pneu Aro 15 195/60R15 Pirelli Cinturato P1',             'Índice 88H',                   489.90,  9800, 65, 20, 20, TRUE, NULL),
('Disco Freio Fremax Civic 2017-2022 Dianteiro',           'Par ventilado BD5618',         489.00, 14200, 35, 35, 10, TRUE, 1),
('Bomba Combustível Bosch Palio/Siena 1.0 Fire',           '0580453456',                    789.00,  1200, 25, 12, 12, TRUE, 4),
('Radiador Valeo GM Onix/Prisma 2013-2019',                'Com ar condicionado',          789.00,  9800, 60, 80, 25, TRUE, NULL),
('Pastilha Traseira ATE Cerâmica HB20 2013-2023',          'Jogo 4 peças',                  259.90,  1400,  8, 15, 20, TRUE, NULL),
('Kit Suspensão Dianteira Nakata Corolla 2009-2014',       'Amortecedor + batente + coxim', 1249.00, 18500, 70, 25, 25, TRUE, 2),
('Filtro Ar Condicionado Tecfil HB20',                     'ACP-959',                       79.90,   280, 25, 20,  5, TRUE, NULL),
('Lâmpada LED H4 6000K 8000lm Par',                        'Canceller incluso',             289.00,   420, 12, 10,  8, TRUE, 1),
('Jogo Cabo Vela NGK Gol G5/G6 1.0',                        'Silicone alta resistência',     189.90,   580, 25, 15, 10, TRUE, NULL),
('Terminal Direção Axios Gol/Saveiro G5-G8',               'Lado direito',                  159.90,   680, 15, 10, 10, TRUE, NULL),
('Pivô Suspensão Viemar Ford Ka 2015-2021',                'Par',                           289.00,  1400, 20, 12, 12, TRUE, NULL),
('Jogo Junta Motor Sabó VW Gol 1.0 8v',                    'Completo',                      329.90,   980, 35, 25,  8, TRUE, NULL),
('Escapamento Traseiro Inox Celta 2010-2016',              'Ponteira esportiva',            689.00, 12500, 40, 30, 150, TRUE, 5),
('Farol Mascara Negra Onix 2017-2019 Lado Esquerdo',       'Original Arteb',               1099.00,  4200, 45, 35, 35, TRUE, NULL),
('Coxim Motor Axios Honda HR-V 2016-2022',                 'Dianteiro',                     389.90,  1800, 20, 15, 15, TRUE, NULL),
('Fluido Freio DOT4 TRW 500ml',                            'Válvula de alta performance',   39.90,   520, 20,  8,  8, TRUE, NULL),
('Par de Molas Esportivas Eibach Corolla 2015-2019',       '-3cm',                         1399.00,  9800, 45, 25, 25, TRUE, 1);

-- ====================================
-- 6. ESTOQUE 
-- ====================================
INSERT INTO Em_estoque (Produto_idProduto, Estoque_idEstoque, quantidade, reserva) VALUES
(1,1,180,25),(1,2,95,8),(1,3,120,15),
(2,1,68,12),(2,4,45,5),
(3,1,42,6),(3,2,38,4),
(4,1,350,45),(4,3,280,30),
(5,1,220,28),(5,2,180,15),
(6,1,98,10),(6,4,75,8),
(7,1,85,12),(7,2,62,7),
(8,1,450,60),(8,3,380,40),
(9,1,120,18),(9,2,95,10),
(10,1,88,14),(10,3,72,9),
(11,1,55,8),(11,4,42,5),
(12,1,48,7),(12,2,35,4),
(13,1,135,20),(13,3,110,12),
(14,1,32,5),(14,4,28,3),
(15,1,210,32),(15,2,180,22),
(16,1,95,15),
(17,1,180,25),
(18,1,140,18),
(19,1,88,12),
(20,1,165,22),
(21,1,52,8),
(22,1,78,10),
(23,1,65,9),
(24,1,290,38),
(25,1,38,6),(25,4,25,4);

-- ====================================
-- 7. RELAÇÃO PRODUTO ↔ FORNECEDOR
-- ====================================
INSERT INTO Produto_has_Fornecedor (Produto_idProduto, Fornecedor_idFornecedor, preco_custo, prazo_entrega_dias) VALUES
(1,1,189.00,2),(2,3,489.00,3),(3,4,659.00,4),(4,1,28.00,1),
(5,1,179.00,2),(6,2,289.00,3),(7,1,389.00,4),(8,1,32.00,1),
(9,1,329.00,3),(10,3,299.00,3),(11,1,489.00,3),(12,1,489.00,4),
(13,1,159.00,2),(14,2,789.00,5),(15,1,48.00,1),(16,1,189.00,2),
(17,1,98.00,2),(18,1,98.00,2),(19,1,189.00,3),(20,2,219.00,3),
(21,1,429.00,4),(22,1,689.00,5),(23,1,239.00,3),(24,1,24.00,1),
(25,1,899.00,6);

-- ====================================
-- 8. PEDIDOS + ITENS 
-- ====================================
INSERT INTO Pedido (idCliente, data_pedido, status, valor_total, forma_pagamento, codigo_rastreio) VALUES
(1,'2025-10-12','Entregue',  1138.90, 'Pix',      'BR123456789BR'),
(2,'2025-10-15','Enviado',    789.90, 'Cartão',   'BR987654321BR'),
(3,'2025-10-20','Em separação',1578.00,'Cartão',   NULL),
(4,'2025-11-01','Pago',       1958.00, 'Boleto',   NULL),
(5,'2025-11-03','Entregue',   289.90,  'Pix',      'BR111222333BR'),
(6,'2025-11-05','Pendente',   959.00,  'Cartão',   NULL),
(7,'2025-11-07','Cancelado',  589.00,  'Pix',      NULL),
(8,'2025-11-08','Enviado',    1438.90, 'Cartão',   'BR444555666BR'),
(9,'2025-11-10','Entregue',   489.00,  'Pix',      'BR777888999BR'),
(10,'2025-11-12','Pago',      1799.00, 'Cartão',   NULL),
(11,'2025-11-14','Em separação',879.80,'Pix',     NULL),
(1,'2025-11-15','Entregue',   679.70,  'Cartão',   'BR555666777BR'),
(4,'2025-11-16','Enviado',    1099.00, 'Cartão',   'BR888999000BR'),
(3,'2025-11-17','Pago',       1399.00, 'Pix',      NULL),
(5,'2025-11-18','Entregue',   329.90,  'Cartão',   'BR222333444BR');

-- Itens dos pedidos
INSERT INTO Produto_has_Pedido (Produto_idProduto, Pedido_idPedido, quantidade, preco_unitario_vendido, idTerceiro_Vendedor) VALUES
(1,1,2,289.90,NULL),(4,1,5,49.90,NULL),(8,1,4,52.90,NULL),
(2,2,1,789.90,3),
(3,3,1,959.00,NULL),(14,3,1,1249.00,2),
(3,4,1,959.00,NULL),(6,4,1,489.00,NULL),(1,4,2,289.90,NULL),
(1,5,1,289.90,NULL),
(3,6,1,959.00,NULL),
(7,7,1,589.00,NULL),
(2,8,1,789.90,3),(10,8,1,489.00,1),(15,8,1,79.90,NULL),
(9,9,1,489.90,NULL),
(14,10,1,1249.00,2),(16,10,2,289.00,1),
(1,11,3,289.90,NULL),(24,11,1,39.90,NULL),
(5,12,1,279.90,NULL),(17,12,2,189.90,NULL),
(22,13,1,1099.00,NULL),
(25,14,1,1399.00,1),
(20,15,1,329.90,NULL);

COMMIT;