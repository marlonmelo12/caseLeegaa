-- Questão 15
SELECT nome, bairro FROM usuario WHERE nome LIKE '%Alberto Roberto%';

UPDATE usuario 
SET bairro = 'Perdizes'
WHERE nome = 'Alberto Roberto';

SELECT nome, bairro FROM usuario WHERE nome = 'Alberto Roberto';


-- Questão 20
ALTER TABLE obra ADD COLUMN valor_livro DECIMAL(10,2);
UPDATE obra SET valor_livro = valor_unitario;

-- Questão 23
ALTER TABLE obra DROP COLUMN valor_livro;

-- Questão 32
SELECT 
    o.id AS id_obra,
    o.titulo AS obra,
    o.valor_unitario,
    a.nome AS autor,
    e.nome AS editora,
    g.nome AS genero
FROM obra o
LEFT JOIN autor a ON o.autor_id = a.id
LEFT JOIN editora e ON o.editora_id = e.id
LEFT JOIN genero g ON o.genero_id = g.id
WHERE o.valor_unitario > 90.00
ORDER BY o.valor_unitario DESC;


-- Questão 37
SELECT 
    cep,
    COUNT(logradouro) AS quantidade_logradouros,
    string_agg(logradouro, '; ') AS logradouros
FROM usuario
GROUP BY cep
ORDER BY quantidade_logradouros DESC, cep;


-- Questão 38
SELECT 
    logradouro,
    COUNT(*) AS quantidade_usuarios,
    string_agg(nome, ', ') AS usuarios
FROM usuario
GROUP BY logradouro
ORDER BY quantidade_usuarios DESC;


-- Questão 39
SELECT 
    r.id AS id_reserva,
    o.titulo AS obra,
    u.nome AS usuario,
    f.nome AS funcionario_responsavel,
    r.data_reserva,
    r.hora_reserva,
    r.status_reserva
FROM reserva r
LEFT JOIN obra o ON r.obra_id = o.id
LEFT JOIN usuario u ON r.usuario_id = u.id
LEFT JOIN funcionario f ON r.funcionario_id = f.id
WHERE r.data_reserva = '2011-08-18'
    AND r.hora_reserva = '15:00:00';


-- Questão 43
SELECT 
    u.nome AS usuario,
    o.titulo AS livro,
    a.nome AS autor,
    e.data_saida,
    e.data_prevista_entrega,
    DATE '2013-02-03' AS data_referencia,
    (DATE '2013-02-03' - e.data_prevista_entrega) AS dias_atraso,
    (DATE '2013-02-03' - e.data_prevista_entrega) * 5.00 AS multa_total,
    fn.nome AS funcionario_emprestimo
FROM emprestimo e
LEFT JOIN usuario u ON e.usuario_id = u.id
LEFT JOIN obra o ON e.obra_id = o.id
LEFT JOIN autor a ON o.autor_id = a.id
LEFT JOIN funcionario fn ON e.funcionario_emprestimo_id = fn.id
WHERE e.data_devolucao IS NULL
  AND e.data_prevista_entrega < DATE '2013-02-03'
ORDER BY dias_atraso DESC;

select * from emprestimo;

-- Questão 51


-- Questão 53
-- View para relatório de atendimentos
CREATE OR REPLACE VIEW relatorio_atendimentos_funcionario AS
SELECT 
    f.id AS funcionario_id,
    f.nome AS funcionario_nome,
    d.nome AS departamento,
    c.nome AS cargo,
    -- Empréstimos realizados
    COUNT(DISTINCT CASE 
        WHEN e.funcionario_emprestimo_id = f.id THEN e.id 
    END) AS total_emprestimos,
    -- Devoluções registradas
    COUNT(DISTINCT CASE 
        WHEN e.funcionario_devolucao_id = f.id THEN e.id 
    END) AS total_devolucoes,
    -- Reservas atendidas
    COUNT(DISTINCT r.id) AS total_reservas,
    -- Total de atendimentos
    (COUNT(DISTINCT CASE WHEN e.funcionario_emprestimo_id = f.id THEN e.id END) +
     COUNT(DISTINCT CASE WHEN e.funcionario_devolucao_id = f.id THEN e.id END) +
     COUNT(DISTINCT r.id)) AS total_atendimentos
FROM funcionario f
LEFT JOIN departamento d ON f.departamento_id = d.id
LEFT JOIN cargo c ON f.cargo_id = c.id
LEFT JOIN emprestimo e ON (
    f.id = e.funcionario_emprestimo_id OR 
    f.id = e.funcionario_devolucao_id
)
LEFT JOIN reserva r ON f.id = r.funcionario_id
GROUP BY f.id, f.nome, d.nome, c.nome
ORDER BY total_atendimentos DESC;

	-- Consultar a view
SELECT * FROM relatorio_atendimentos_funcionario;


-- Questão 56 
SELECT e.nome AS editora, o.titulo AS obra, o.valor_unitario FROM obra o
LEFT JOIN editora e ON o.editora_id = e.id
ORDER BY e.nome DESC;

UPDATE obra 
SET valor_unitario = valor_unitario * 1.16
WHERE editora_id = (
    SELECT id FROM editora WHERE nome = 'Saraiva'
);