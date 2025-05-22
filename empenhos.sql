WITH produtos_agg AS ( 
  SELECT itm.minnro,
         itm.minano,
         STRING_AGG(DISTINCT pro.prddescricao, ' - ') AS prddescricoes
    FROM wco.tbitemin itm
    JOIN wun.tbproduto pro 
      ON pro.prdcodigo = itm.prdcodigo
GROUP BY itm.minnro, itm.minano )

SELECT emp.empnro,
       emp.loaano,
       lic.licnro,
       lic.licano,
       lic.licdata,
       lic.licsituacao,
       pa.prddescricoes,
       uni.uninomerazao,
       uni.unicpfcnpj,
       uni.uninomefantasia,
       INITCAP(log.lognome) AS logradouro,
       cid.cidnome,
       est.estsigla,
       est.estnome
  FROM wco.tbparlic par
  JOIN wco.tblicitacao lic
    ON par.minnro = lic.minnro
   AND par.minano = lic.minano
   AND par.clicodigo = lic.clicodigo
  JOIN produtos_agg pa
    ON pa.minnro = lic.minnro
   AND pa.minano = lic.minano
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
 WHERE par.minnro = 1
   AND par.minano = 2025
   AND emp.clicodigo = 2668
GROUP BY emp.empnro,
         emp.loaano,
         lic.licnro,
         lic.licano,
         lic.licdata,
         lic.licsituacao,
         pa.prddescricoes,
         uni.uninomerazao,
         uni.unicpfcnpj,
         uni.uninomefantasia,
         log.lognome,
         cid.cidnome,
         est.estsigla,
         est.estnome
