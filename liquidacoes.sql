SELECT 
    emp.empnro,
    emp.loaano,
    liq.liqsequencia,
    TO_CHAR(ROUND(liq.liqvalor::NUMERIC, 2), 'FM999999990D00') AS valor_liquidado,
    lic.licnro,
    lic.licano,
    modalidade.moddescricao,
    lic.licdata,
    lic.licsituacao,
    
    STRING_AGG(pro.prdcodigo || ' - ' || pro.prddescricao, ' | ') AS itens,
    
    uni.uninomerazao,
    uni.unicpfcnpj,
    uni.uninomefantasia,
    INITCAP(log.lognome) AS logradouro,
    cid.cidnome,
    est.estsigla,
    est.estnome,

    CASE 
        WHEN cid.cidcodigo = ANY (ARRAY[
            8982, 8364, 8374, 9057, 8375, 8987, 8984, 8997, 8998, 8991,
            7730, 9059, 8770, 8995, 9061, 9058, 9060, 8986, 7735
        ]) THEN 'Sim'
        ELSE 'Não'
    END AS COREDE

FROM weo.tbempenho emp
JOIN weo.tbliquidacao liq
    ON liq.empnro = emp.empnro
   AND liq.loaano = emp.loaano
   AND liq.clicodigo = emp.clicodigo
   and liq.liqtipo =1
JOIN wco.tblicitacao lic
    ON emp.minnro = lic.minnro
   AND emp.minano = lic.minano
   
   AND emp.clicodigo = lic.clicodigo
JOIN wco.tbitemin itm
    ON itm.minnro = lic.minnro
   AND itm.minano = lic.minano
   AND itm.clicodigo = lic.clicodigo
JOIN wun.tbproduto pro
    ON pro.prdcodigo = itm.prdcodigo
JOIN wun.tbunico uni
    ON uni.unicodigo = emp.unicodigo
JOIN wun.tbunicoendereco une
    ON une.unicodigo = uni.unicodigo
JOIN wun.tblogradouro log
    ON log.logcodigo = une.logcodigo
JOIN wun.tbcidade cid
    ON cid.cidcodigo = une.cidcodigo
JOIN wun.tbestado est
    ON est.estcodigo = cid.estcodigo
JOIN wco.tbmodalidade modalidade
    ON modalidade.modcodigo = lic.modcodigo

WHERE emp.clicodigo = 2668 
  
GROUP BY 
    emp.empnro,
    emp.loaano,
    liq.liqsequencia,
    liq.liqvalor,
    lic.licnro,
    lic.licano,
    modalidade.moddescricao,
    lic.licdata,
    lic.licsituacao,
    uni.uninomerazao,
    uni.unicpfcnpj,
    uni.uninomefantasia,
    log.lognome,
    cid.cidnome,
    est.estsigla,
    est.estnome,
    cid.cidcodigo

ORDER BY emp.empnro, liq.liqsequencia
