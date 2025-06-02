WITH MaxOdomesano AS (
    SELECT MAX(odomesano) AS max_odomesano
    FROM wfp.tbperiodofolha
    WHERE clicodigo IN (2668, 11732)
),

ProcessoEntregue AS (
    SELECT DISTINCT r.unicodigo
    FROM wpt.tbhistoricoprocesso h
    JOIN wpt.tbprocesso p ON p.procodigo = h.procodigo
    JOIN wpt.tbrequerente r ON p.procodigo = r.procodigo
    JOIN wpt.tbprocessobloco b ON p.procodigo = b.procodigo
    JOIN wpt.tbprocessofluxodinamico f ON p.procodigo = f.procodigo
    WHERE p.proano = EXTRACT (YEAR FROM CURRENT_DATE)
    AND p.subcodigo = 805
    AND h.histipo = 6
    AND h.parcodigo = 2
    AND b.blccodigo = 208
    AND b.itmcodigo = 24
    AND f.pfddescricaosituacaoatual IS NULL
),

ProcessoIndeferido AS (
    SELECT DISTINCT r.unicodigo
    FROM wpt.tbhistoricoprocesso h
    JOIN wpt.tbprocesso p ON p.procodigo = h.procodigo
    JOIN wpt.tbrequerente r ON p.procodigo = r.procodigo
    JOIN wpt.tbprocessobloco b ON p.procodigo = b.procodigo
    JOIN wpt.tbprocessofluxodinamico f ON p.procodigo = f.procodigo
    WHERE p.proano = EXTRACT (YEAR FROM CURRENT_DATE)
    AND p.subcodigo = 805
    AND h.histipo = 6
    AND h.parcodigo = 1
    AND b.blccodigo = 208
    AND b.itmcodigo = 24
    AND f.pfddescricaosituacaoatual IS NULL
)

SELECT 
    f.unicodigo,
    f.clicodigo,
    CASE f.clicodigo
        WHEN 2668 THEN 'Prefeitura'
        WHEN 11732 THEN 'Fundação Municipal da Saúde'
    END AS clicodigo_label,
    f.fcncodigo,
    f.funcontrato,
    uni.uninomerazao,
    f.cltcodigo,
    l.cltdescricao,
    CASE
        WHEN e.unicodigo IS NOT NULL THEN 'ENTREGUE'
        ELSE 'NÃO ENTREGUE'
    END AS situacao,
    
     CASE
        WHEN e.unicodigo IS NOT NULL THEN MAX(p.procodigo)
        ELSE NULL
    END AS procodigo,
    
    CASE
        WHEN e.unicodigo IS NOT NULL THEN MAX(p.pronumero) || '/' || MAX(p.proano)
        ELSE NULL
    END AS processo,
    
   
    CASE
        WHEN e.unicodigo IS NOT NULL THEN '1'
        ELSE '2'
    END AS situacao_codigo
    
FROM
    wfp.tbfuncontrato f
JOIN wun.tbunico uni ON uni.unicodigo = f.unicodigo
JOIN wfp.tblocais l ON f.clicodigo = l.clicodigo AND f.cltcodigo = l.cltcodigo
LEFT JOIN ProcessoEntregue e ON e.unicodigo = f.unicodigo
LEFT JOIN ProcessoIndeferido i ON i.unicodigo = f.unicodigo
LEFT JOIN wpt.tbrequerente r ON r.unicodigo = uni.unicodigo
LEFT JOIN wpt.tbprocesso p ON p.procodigo = r.procodigo AND p.proano = EXTRACT(YEAR FROM CURRENT_DATE) AND p.subcodigo = 805

WHERE
    f.clicodigo IN (2668, 11732)
    AND f.odomesano IN (SELECT max_odomesano FROM MaxOdomesano)
    AND f.funsituacao IN (1, 2)
    AND f.funtipocontrato IN (1, 8, 9)
    AND f.fundataadmissao < TO_DATE('01/01/' || EXTRACT(YEAR FROM CURRENT_DATE), 'DD/MM/YYYY')

    AND l.odomesano = (SELECT max_odomesano FROM MaxOdomesano)
    and regcodigo  not in (9,11)


GROUP BY 
    f.unicodigo, f.clicodigo, f.fcncodigo, f.funcontrato, uni.uninomerazao, f.cltcodigo, l.cltdescricao, e.unicodigo, i.unicodigo
ORDER BY uni.uninomerazao
