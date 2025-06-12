SELECT 
  procodigo,
  itmconteudo,
  CASE 
    WHEN '2' = ANY (string_to_array(itmconteudo, ',')) THEN 1
    ELSE 0
  END AS contem_valor_2
FROM wpt.tbprocessobloco
WHERE procodigo = 659443
  AND blccodigo = 531
  AND itmcodigo = 10
