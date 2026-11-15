-- Dos pedidos entregues, qual % chegou depois da data prometida para o cliente?

with base_pedidos as ( 
	select
		order_id,
		case
			when cast(order_delivered_customer_date as date) < cast(order_estimated_delivery_date AS DATE) THEN 'No Prazo'
			else 'Atraso'
		end
			as status_entrega
		from
			raw.orders
		where
			order_status = 'delivered'
)

select
	count(distinct case when status_entrega = 'Atraso' then order_id end) * 1.0 /
	nullif(count(distinct order_id), 0) as taxa_atraso
from
	base_pedidos

-- 6% dos pedidos foram entregues depois da data estimada












	

