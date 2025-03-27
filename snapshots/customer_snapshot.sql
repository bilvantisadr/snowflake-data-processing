{% snapshot customer_snapshot %}
  {{
    config(
      target_schema='oms',  
      target_database='dist',  
      unique_key='customer_id',  
      strategy='timestamp', 
      updated_at='updated_at' 
    )
  }}

  -- Select the source data (from the 'customers' table)
  select *
  from 
    {{source('tgt_layer', 'customers')}}  -- Reference to the 'customers' table in your source schema

{% endsnapshot %}
