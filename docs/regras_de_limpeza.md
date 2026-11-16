# SQL. Regras de Limpeza - Análise Inicial

- R1. Atraso só é medido em pedidos com status 'delivered'
- R2. Pedidos com status 'delivered' sem data de entrega (8 pedidos) irão ser excluídos da análise
- R3. Pedidos não entregues mas que possuem data de entrega (6 pedidos) irão ser excluídos da análise
- R4. Entrega no mesmo dia da data prometida será contada como 'No Prazo'.
- R5. Os meses que estão incompletos (3 primeiros meses da base, e 2 últimos) vão ficar inicialmente, pois os indicadores não se alteram com ou sem eles. Isso foi validado no arquivo "pergunta_de_negocio_5.sql".

- R5a. Os meses incompletos não poderão estar em análises mês a mês para não distorcer os comparativos. 
- R5b. Os meses incompletos precisa ser investigados em relação ao viés de sobrevivência, para não termos problemas de viés no modelo

# SQL. Criar view 