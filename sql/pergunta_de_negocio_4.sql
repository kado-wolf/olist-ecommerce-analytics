-- % de atraso mudou ao longo do tempo?

with base_pedidos as ( 
	select
		to_char(cast(order_purchase_timestamp as date), 'YYYY-MM') as ano_mes,
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
	ano_mes,
	count(distinct(order_id)) contagem_pedidos,
	count(distinct case when status_entrega = 'Atraso' then order_id end) * 1.0 /
	nullif(count(distinct order_id), 0) * 100 as taxa_atraso
from
	base_pedidos
group by
	1
order by
	1 desc

-- Sim houve mudanças no % de atraso ao longo do tempo, tiveram meses com quase 19% de atraso e outros com 2%











	

