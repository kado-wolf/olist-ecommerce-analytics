-- 1. Quantos pedidos existem e qual período a base cobre? Algum mês parece incompleto?

-- Total de pedidos

select count(distinct(order_id)) as contagem_pedidos from raw.orders -- 99. 441 pedidos

-- Total de pedidos por ano e mês

select
	to_char(cast(order_purchase_timestamp as date), 'YYYY-MM') as ano_mes_compra,
	count(distinct(order_id)) as contagem_pedidos
from
	raw.orders
group by
	1
order by
	1 asc
	
-- após a análise por ano e mês, percebemos que os 3 primeiros meses da base e os 2 últimos tem uma volumetria muito menor que a média dos outros meses.
-- 69.8 vs 4.954
