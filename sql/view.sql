-- Criação de uma view para análise de pedidos entregues

create schema if not exists analise;

create or replace view analise.pedidos_entregues as

select
	order_id,
	customer_id,
	order_status,
	cast(order_purchase_timestamp as date) as order_purchase_date,
	to_char(cast(order_purchase_timestamp as date),'YYYY-MM') as ano_mes_compra,
	cast(order_approved_at as timestamp) as order_approved_at,
	cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_date,
	cast(order_delivered_customer_date as timestamp) as order_delivered_customer_date,
	cast(order_estimated_delivery_date as date) as order_estimated_delivery_date,
	
case
	when cast(order_delivered_customer_date as date) <= cast(order_estimated_delivery_date as date) then 0 -- não atrasou
	else 1 -- atrasou
end as flag_pedido_atrasado,

case
	when to_char(cast(order_purchase_timestamp as date), 'YYYY-MM') in ('2016-09', '2016-10', '2016-12', '2018-09', '2018-10') then 1
    else 0
end as flag_mes_incompleto,

(cast(order_delivered_customer_date as date)- cast(order_estimated_delivery_date as date)) as dias_de_atraso -- negativo = entregue antes do prazo

from
	raw.orders 
where
	order_status = 'delivered'
	and order_delivered_customer_date is not null
	

















