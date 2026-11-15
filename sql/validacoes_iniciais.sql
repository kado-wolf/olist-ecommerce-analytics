-- 0. Validações iniciais -- Regras

-- 1. Existem pedidos com status de entregue, mas sem data de entrega?

select
	count(distinct(order_id)) as contagem_pedidos
from
	raw.orders
where
	order_status = 'delivered'
	and order_delivered_customer_date is null 
	
-- sim, existe 8 pedidos com essa situaão. 
	
-- 2. Existem pedidos que não estão com status de entregue, e tem data de entrega?
	
select
	order_id,
	order_status
from
	raw.orders
where
	order_status <> 'delivered'
	and order_delivered_customer_date is not null 
group by	
	1,2

-- Sim existem 6 pedidos com essa situação.

-- 3. O order_id é unico? 
	
select
	count(*) as contagem_total,
	count(distinct(order_id)) as contagem_pedidos
from
	raw.orders
	
-- Sim, a contagem distinta ou contagem total dá o mesmo número (99.441)



























