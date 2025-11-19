# Suzano - Análise de Dados com Power BI
## Construa um Projeto Lógico de Banco de Dados do Zero

Descrição do Desafio  
Para este cenário você irá utilizar seu esquema conceitual, criado no desafio do módulo de modelagem de BD com modelo ER, para criar o esquema lógico para o contexto de uma oficina. Neste desafio, você definirá todas as etapas. Desde o esquema até a implementação do banco de dados. Sendo assim, neste projeto você será o protagonista. Tenha os mesmos cuidados, apontados no desafio anterior, ao modelar o esquema utilizando o modelo relacional.

Após a criação do esquema lógico, realize a criação do Script SQL para criação do esquema do banco de dados. Posteriormente, realize a persistência de dados para realização de testes. Especifique ainda queries mais complexas do que apresentadas durante a explicação do desafio. Sendo assim, crie queries SQL com as cláusulas abaixo:

- Recuperações simples com SELECT Statement;  
- Filtros com WHERE Statement;  
- Crie expressões para gerar atributos derivados;  
- Defina ordenações dos dados com ORDER BY;  
- Condições de filtros aos grupos – HAVING Statement;  
- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados;  

### Diretrizes
- Não há um mínimo de queries a serem realizadas;  
- Os tópicos supracitados devem estar presentes nas queries;  
- Elabore perguntas que podem ser respondidas pelas consultas;  
- As cláusulas podem estar presentes em mais de uma query;  
- O projeto deverá ser adicionado a um repositório do Github para futura avaliação do desafio de projeto.  
- Adicione ao Readme a descrição do projeto lógico para fornecer o contexto sobre seu esquema lógico apresentado.  

# Entregas
## DER
![DER BANCO OFICINA_WJ](https://github.com/WiltonJackson/CursosDIO/blob/master/Curso-SuzanoAnalisedeDadoscomPowerBI/Desafio_4/imagens/Diagrama_v1.png)

## Resumo das características operacionais implantadas no banco 

| Nº | Item                                         | Explicação                                                             |
|----|----------------------------------------------|------------------------------------------------------------------------------------------|
| 1  | Agendamento completo                         | Calendário com horário exato, equipe/mecânico, status e lembretes                        |
| 2  | Orçamento com aprovação digital              | Token único + link para cliente aprovar/rejeitar por WhatsApp                            |
| 3  | Valor total da OS calculado automaticamente  | Triggers atualizam o valor sempre que adiciona/altera serviço ou peça                    |
| 4  | Pacotes de serviços (revisões, combos)       | Venda de vários serviços + peças com preço fechado                                       |
| 5  | Checklist digital obrigatório por serviço    | Mecânico só fecha OS se marcar tudo + foto quando exigido                                |
| 6  | Controle de garantia automática              | Registro de garantia por serviço/peça com validade em data e km                          |
| 7  | Controle de estoque inteligente              | Estoque mínimo, preço de custo/venda, alerta de reposição                                |
| 8  | Número da OS único e sequencial              | Campo pronto para gerar OS-2025-0001, OS-2025-0002 etc.                                  |
| 9  | Status completo da OS                        | Orçamento → Aguardando aprovação → Aprovado → Em execução → Concluído                    |
| 10 | Vinculação com agendamento                   | OS pode nascer de um agendamento já marcado                                              |
| 11 | Histórico de KM de entrada/saída             | Controle perfeito de revisões preventivas futuras                                        |
| 12 | Origem do cliente                            | Saber se veio de Google, indicação, Instagram etc.                                       |
| 13 | Campos de auditoria (criado_em, etc.)        | Todas as tabelas principais já têm timestamp automático                                  |
| 14 | Desconto por item                            | Possibilidade de dar desconto em serviço ou peça individual                              |
| 15 | Bloqueio de horários por equipe/mecânico     | Evita overbooking (lógica feita na aplicação usando os dados do agendamento)             |



###  Pergunta: Quais são os 10 clientes mais recentes?

```sql
SELECT nome, telefone, data_cadastro 
FROM cliente 
ORDER BY data_cadastro DESC 
LIMIT 10;
```
### pergunta: Quais veículos precisam de revisão (mais de 8.000 km desde última OS)?

```sql
SELECT v.placa, c.nome, v.km_atual, MAX(os.km_entrada) AS ultimo_km_servico,
       (v.km_atual - MAX(os.km_entrada)) AS km_desde_ultimo_servico
FROM veiculo v
JOIN cliente c ON v.id_cliente = c.id_cliente
LEFT JOIN ordem_servico os ON os.id_veiculo = v.id_veiculo AND os.status_os = 'Concluído'
GROUP BY v.id_veiculo
HAVING km_desde_ultimo_servico > 8000 OR ultimo_km_servico IS NULL;
```

### Pergunta: Qual o faturamento por mecânico em 2025 (até hoje)?
```sql
SELECT 
    m.nome AS mecanico,
    e.nome_equipe,
    COUNT(os.id_os) AS os_concluidas,
    ROUND(SUM(os.valor_total), 2) AS faturamento,
    ROUND(SUM(os.valor_total) / COUNT(os.id_os), 2) AS ticket_medio
FROM ordem_servico os
JOIN mecanico m ON os.id_mecanico_responsavel = m.id_mecanico
LEFT JOIN equipe e ON m.id_equipe = e.id_equipe
WHERE os.status_os = 'Concluído' AND YEAR(os.data_emissao) = 2025
GROUP BY m.id_mecanico
ORDER BY faturamento DESC;
```

### Pergunta: Quais equipes tiveram ticket médio acima de R$ 1.200,00 em OS concluídas?
```sql
SELECT 
    e.nome_equipe,
    COUNT(os.id_os) AS total_os,
    ROUND(AVG(os.valor_total), 2) AS ticket_medio
FROM ordem_servico os
JOIN mecanico m ON os.id_mecanico_responsavel = m.id_mecanico
JOIN equipe e ON m.id_equipe = e.id_equipe
WHERE os.status_os = 'Concluído'
GROUP BY e.id_equipe
HAVING ticket_medio > 1200
ORDER BY ticket_medio DESC;
```

### Pergunta: Ranking dos serviços mais rentáveis (lucro = venda - custo peças - mão de obra)

```sql
SELECT 
    sr.descricao,
    COUNT(oss.id_servico) AS vezes_vendido,
    ROUND(SUM(oss.preco_unitario * oss.quantidade), 2) AS total_vendido,
    ROUND(SUM(oss.preco_unitario * oss.quantidade) - SUM(oss.quantidade * sr.preco_mao_obra), 2) AS lucro_bruto
FROM os_servico oss
JOIN servico_referencia sr ON oss.id_servico = sr.id_servico
JOIN ordem_servico os ON oss.id_os = os.id_os
WHERE os.status_os = 'Concluído'
GROUP BY sr.id_servico
ORDER BY lucro_bruto DESC
LIMIT 10;
```

### Clientes que mais gastaram em 2025 (com junção de 4 tabelas)

```sql
SELECT 
    c.nome,
    c.telefone,
    COUNT(os.id_os) AS visitas,
    ROUND(SUM(os.valor_total), 2) AS total_gasto,
    ROUND(AVG(os.valor_total), 2) AS ticket_medio
FROM cliente c
JOIN veiculo v ON c.id_cliente = v.id_cliente
JOIN ordem_servico os ON v.id_veiculo = os.id_veiculo
WHERE os.status_os = 'Concluído' AND YEAR(os.data_emissao) = 2025
GROUP BY c.id_cliente
ORDER BY total_gasto DESC;
```

### Peças com estoque crítico (abaixo do mínimo)

```sql
SELECT 
    codigo, 
    descricao, 
    quantidade_estoque, 
    estoque_minimo,
    (estoque_minimo - quantidade_estoque) AS precisa_comprar
FROM peca 
WHERE quantidade_estoque < estoque_minimo AND ativo = 1
ORDER BY precisa_comprar DESC;
```

### Agendamentos do dia atual com status e mecânico
```sql
SELECT 
    a.data_hora_inicio,
    c.nome AS cliente,
    v.placa,
    COALESCE(m.nome, 'Não atribuído') AS mecanico,
    a.status
FROM agendamento a
JOIN veiculo v ON a.id_veiculo = v.id_veiculo
JOIN cliente c ON v.id_cliente = c.id_cliente
LEFT JOIN mecanico m ON a.id_mecanico = m.id_mecanico
WHERE DATE(a.data_hora_inicio) = CURDATE()
ORDER BY a.data_hora_inicio;
```


