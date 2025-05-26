   SELECT emp.empnro
        , emp.loaano
        ,REPLACE(TO_CHAR(ROUND(liq.liqvalor::NUMERIC, 2), 'FM999999990.00'), '.', ',') AS valor_liquidado
        , lic.licnro
        , lic.licano
        , lic.licdata
        , lic.licsituacao
        , pro.prdcodigo
        , pro.prddescricao
        , uni.uninomerazao
        , uni.unicpfcnpj
        , uni.uninomefantasia
        , INITCAP ( log.lognome ) AS logradouro
        , cid.cidnome
        , est.estsigla
        , est.estnome
        ,  CASE 
               WHEN cid.cidcodigo IN ( 8982
                            , 8364
                            , 8374
                            , 9057
                            , 8375
                            , 8987
                            , 8984
                            , 8997
                            , 8998
                            , 8991
                            , 7730
                            , 9059
                            , 8770
                            , 8995
                            , 9061
                            , 9058
                            , 9060
                            , 8986
                            , 7735 ) THEN 'Sim'
               ELSE 'Não' END AS COREDE
     FROM wco.tbparlic par
     JOIN wco.tblicitacao lic
       ON par.minnro = lic.minnro
      AND par.minano = lic.minano
      AND par.clicodigo = lic.clicodigo
     JOIN wco.tbitemin itm
       ON itm.minnro = lic.minnro
      AND itm.minano = lic.minano
      AND itm.clicodigo = lic.clicodigo
     JOIN wun.tbproduto pro
       ON pro.prdcodigo = itm.prdcodigo
     JOIN wun.tbunico uni
       ON par.unicodigo = uni.unicodigo
     JOIN wun.tbunicoendereco une
       ON une.unicodigo = uni.unicodigo
     JOIN wun.tblogradouro log
       ON log.logcodigo = une.logcodigo
     JOIN wun.tbcidade cid
       ON cid.cidcodigo = une.cidcodigo
     JOIN wun.tbestado est
       ON est.estcodigo = cid.estcodigo
     JOIN weo.tbempenho emp
       ON emp.minnro = lic.minnro
      AND emp.minano = lic.minano
      AND emp.clicodigo = par.clicodigo
      AND emp.minnro = par.minnro
      AND emp.minano = par.minano
     JOIN weo.tbliquidacao liq
       ON liq.empnro = emp.empnro
      AND liq.loaano = emp.loaano
      AND liq.clicodigo = emp.clicodigo
    WHERE emp.clicodigo = 2668
      AND liq.clicodigo = 2668
      and emp.empnro   = 1
     
      
 ORDER BY emp.empnro
        , pro.prddescricao
