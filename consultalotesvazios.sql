WITH ocupados AS (
    SELECT 
        los.loscodigo AS codigo_lote,
        los.losidentificador AS identificador,
        cem.cemnome AS nome_cemiterio,
        u.unicpfcnpj AS cpf_cnpj_responsavel,
        u.uninomerazao AS nome_responsavel,
        u.unicodigo AS unicodigo_responsavel,
        CASE 
            WHEN li.lsicodigo != 3 
                 AND s.sepdatasepultamento > CURRENT_DATE - INTERVAL '3 years' 
            THEN 1 
            ELSE 0 
        END AS validacao_restricao
    FROM wce.tblotesepultura los
    JOIN wce.tbcemiterio cem ON los.cemcodigo = cem.cemcodigo
    LEFT JOIN wce.tblotesepultproprietario pro ON los.loscodigo = pro.loscodigo
    LEFT JOIN wun.tbunico u ON pro.unicodigo = u.unicodigo
    LEFT JOIN wce.tbsepultamento s ON s.loscodigo = los.loscodigo
    LEFT JOIN wce.tblotesepulturaitem li ON los.loscodigo = li.loscodigo 
                                         AND li.blccodigo = 181 
                                         AND li.itmcodigo = 1
    WHERE los.cemcodigo IN (3, 4)
        AND los.lostipo = 0
        AND los.lossituacao = 1
        AND u.unicodigo NOT IN (1052365, 103608)
    GROUP BY los.loscodigo, cem.cemnome, uninomerazao, unicpfcnpj, u.unicodigo, li.lsicodigo, s.sepdatasepultamento
), 
livres AS (
    SELECT 
        los.loscodigo AS codigo_lote,
        los.losidentificador AS identificador,
        cem.cemnome AS nome_cemiterio,
        u.unicpfcnpj AS cpf_cnpj_responsavel,
        u.uninomerazao AS nome_responsavel,
        u.unicodigo AS unicodigo_responsavel
    FROM wce.tblotesepultura los
    JOIN wce.tbcemiterio cem ON los.cemcodigo = cem.cemcodigo
    LEFT JOIN wce.tblotesepultproprietario pro ON los.loscodigo = pro.loscodigo
    LEFT JOIN wun.tbunico u ON pro.unicodigo = u.unicodigo
    WHERE los.cemcodigo IN (3, 4)
        AND los.lostipo = 0
        AND los.lossituacao = 0
        AND NOT EXISTS (
            SELECT 1 
            FROM wce.tbsepultamento s2 
            WHERE s2.loscodigo = los.loscodigo
        )
    GROUP BY los.loscodigo, cem.cemnome, uninomerazao, unicpfcnpj, u.unicodigo
)

SELECT 
    l.codigo_lote,
    l.identificador,
    l.nome_cemiterio,
    l.cpf_cnpj_responsavel,
    l.nome_responsavel,
    l.unicodigo_responsavel
FROM livres l
WHERE l.nome_responsavel ILIKE 'muni%' OR l.nome_responsavel ILIKE 'desc%'

UNION ALL

SELECT 
    o.codigo_lote,
    o.identificador,
    o.nome_cemiterio,
    o.cpf_cnpj_responsavel,
    o.nome_responsavel,
    o.unicodigo_responsavel
FROM ocupados o
WHERE o.validacao_restricao = 1

ORDER BY nome_responsavel asc
