WITH produtos_agg AS ( 
  SELECT itm.minnro,
         itm.minano,
         STRING_AGG(DISTINCT pro.prddescricao, ' - ') AS prddescricoes
    FROM wco.tbitemin itm
    JOIN wun.tbproduto pro ON pro.prdcodigo = itm.prdcodigo
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
       uni.uninomefantasia
  FROM wco.tbparlic par
  JOIN wco.tblicitacao lic
    ON par.minnro = lic.minnro
   AND par.minano = lic.minano
  JOIN produtos_agg pa
    ON pa.minnro = lic.minnro
   AND pa.minano = lic.minano
  JOIN wun.tbunico uni
    ON par.unicodigo = uni.unicodigo
  JOIN weo.tbempenho emp
    ON emp.minnro = lic.minnro
   AND emp.minano = lic.minano
   and par.clicodigo = emp.clicodigo
   AND par.minnro = emp.minnro
   AND par.minano = emp.minano
 WHERE par.minnro = 1
   AND par.minano = 2025
GROUP BY emp.empnro,
         emp.loaano,
         lic.licnro,
         lic.licano,
         lic.licdata,
         lic.licsituacao,
         pa.prddescricoes,
         uni.uninomerazao,
         uni.unicpfcnpj,
         uni.uninomefantasia
