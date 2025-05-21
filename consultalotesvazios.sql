WITH ocupados AS (
SELECT 
    los.loscodigo AS codigo_lote,
    los.losidentificador AS identificador,
    cem.cemnome AS nome_cemiterio,
    u.unicpfcnpj AS cpf_cnpj_responsavel,
    u.uninomerazao AS nome_responsavel,
    u.unicodigo AS unicodigo_responsavel,
    CASE WHEN li.lsicodigo != 3 AND s.sepdatasepultamento > CURRENT_DATE - INTERVAL '3 years' THEN 1 ELSE 0 END AS validacao_restricao

FROM wce.tblotesepultura los

JOIN wce.tbcemiterio cem ON los.cemcodigo = cem.cemcodigo

LEFT JOIN wce.tblotesepultura ss on ss.loslote = los.loscodigo and ss.cemcodigo in (3,4) and ss.lostipo = 1

LEFT JOIN wce.tblotesepultproprietario pro ON los.loscodigo = pro.loscodigo

LEFT JOIN wun.tbunico u ON pro.unicodigo = u.unicodigo

LEFT JOIN wce.tbsepultamento s ON s.loscodigo = los.loscodigo

LEFT JOIN wce.tblotesepulturaitem li ON los.loscodigo = li.loscodigo AND li.blccodigo = 181 AND li.itmcodigo = 1

WHERE los.cemcodigo IN (3, 4)
    AND los.lostipo = 0
    AND los.lossituacao = 1
    and u.unicodigo not in (1052365, 103608)
GROUP BY los.loscodigo, cem.cemnome, uninomerazao, unicpfcnpj, u.unicodigo, li.lsicodigo, s.sepdatasepultamento
), livres as (
    SELECT 
    los.loscodigo AS codigo_lote,
    los.losidentificador AS identificador,
    cem.cemnome AS nome_cemiterio,
    u.unicpfcnpj AS cpf_cnpj_responsavel,
    u.uninomerazao AS nome_responsavel,
    u.unicodigo AS unicodigo_responsavel

FROM wce.tblotesepultura los

JOIN wce.tbcemiterio cem ON los.cemcodigo = cem.cemcodigo

LEFT JOIN wce.tblotesepultura ss on ss.loslote = los.loscodigo and ss.cemcodigo in (3,4) and ss.lostipo = 1

LEFT JOIN wce.tblotesepultproprietario pro ON los.loscodigo = pro.loscodigo

LEFT JOIN wun.tbunico u ON pro.unicodigo = u.unicodigo


WHERE los.cemcodigo IN (3, 4)
    AND los.lostipo = 0
    and los.lossituacao = 0

GROUP BY los.loscodigo, cem.cemnome, uninomerazao, unicpfcnpj, u.unicodigo
)

select l.* from livres l

union all
select
o.codigo_lote,
o.identificador,
o.nome_cemiterio,
o.cpf_cnpj_responsavel,
o.nome_responsavel,
o.unicodigo_responsavel

from ocupados o
where o.validacao_restricao = 1
