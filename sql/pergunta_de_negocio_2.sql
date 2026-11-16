-- Quantos pedidos foram entregues? 

select count(distinct(order_id)) from raw.orders where order_status = 'delivered' -- 96.478 pedidos entregues

-- Regra de Atraso

-- 1 -> Para ser considerado atraso o pedido tem que ter sido entregue (verificar cancelados)
-- 2 -> O cálculo vai ser baseado nas seguintes colunas: order_delivered_customer_date e order_estimated_delivery_date.

-- Query resumida pra analisar o atraso

with base_pedidos as ( 

select
	order_id,
	case 
		when cast(order_delivered_customer_date as date) <= cast(order_estimated_delivery_date as date) then 'No Prazo'
		else 'Atraso'
	end
		as status_entrega
from
	raw.orders 
where
	order_status = 'delivered'
)

select count(distinct(order_id)) from base_pedidos where status_entrega = 'Atraso'

-- temos 10.792 pedidos com atraso











	

