-- Quem atrasa mais pedidos? 

-- 1. 10 piores vendedores por percentual de atraso


with base_sellers as (

select
	order_id,
	seller_id,
	sum(cast(price as decimal)) as preco,
	sum(cast(freight_value as decimal)) as valor_frete
from
	raw.order_items
group by
	1,2
),

resultado as (

select
	c.seller_id,
	count(distinct (a.order_id)) as contagem_de_pedidos,
	sum(flag_pedido_atrasado) as contagem_pedidos_atrasados,
	
round(
    (sum(flag_pedido_atrasado)::numeric / nullif(count (distinct a.order_id), 0)) * 100, 
    2
) as pct_atraso
	
from
	analise.pedidos_entregues a
inner join
	base_sellers b
	on a.order_id = b.order_id
inner join
	raw.sellers c
	on b.seller_id = c.seller_id
group by
	1

)

select
	*
from
	resultado
where
	contagem_de_pedidos >= 30 -- no minimo 30 pedidos pra contabilizar, o resultate não tem relevância
order by
	pct_atraso desc, contagem_pedidos_atrasados desc
limit
	10
	
-- O pior vendedor em percentual de atraso tem 32% de atraso em 43 pedidos. Apesar do número ruim, 43 pedidos ainda é uma amostragem baixa. 	
	
	
	