-- qual a diferença do percentual de atraso geral com e sem os meses com pouca volumetria? (3 primeiros e 2 últimos)

-- Qual a diferença na taxa de atraso com e sem os meses de pouco volume?

with base_pedidos as (
    select
        order_id,
        to_char(cast(order_purchase_timestamp as date), 'YYYY-MM') as ano_mes_compra,
        case
            when cast(order_delivered_customer_date as date)
                 <= cast(order_estimated_delivery_date as date) then 'No Prazo'  
            else 'Atraso'
        end as status_entrega,
        
        case
            when to_char(cast(order_purchase_timestamp as date), 'YYYY-MM')
                 in ('2016-09', '2016-10', '2016-12', '2018-09', '2018-10') then 1
            else 0
        end as flag_mes_incompleto
        
    from raw.orders
    where order_status = 'delivered' -- pedido entregue
      and order_delivered_customer_date is not null  
)
select

    round(100.0 * count(*) filter (where status_entrega = 'Atraso')
          / count(*), 2) as taxa_geral,
          
    -- só meses completos

    round(100.0 * count(*) filter (where status_entrega = 'Atraso' and flag_mes_incompleto = 0)
          / nullif(count(*) filter (where flag_mes_incompleto = 0), 0), 2) as taxa_sem_meses_incompletos
          
from base_pedidos;
	
-- Taxa geral ficou 6.77% e Taxa sem meses incompletos ficou em 6.79%



