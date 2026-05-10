create or refresh materialized view stg_erp__categories(
    category_pk int comment 'Primary key for the categories table'
    , category_name string comment 'Category name'
    , category_description string comment 'Category description'
    , constraint not_null_category_pk expect (category_pk is not null) on violation fail update
    , constraint unique_category_pk expect (pk_count = 1) on violation fail update
)
comment 'Staging table for product categories data'
as 
with
    source_data as (
        select *
        from raw.erp_northwind.categories
    )

    , renamed as (
        select
            cast(id as int) as category_pk
            , cast(categoryname as string) as category_name
            , cast(description as string) as category_description
            , count(id) over(
                partition by id
            ) as pk_count
        from source_data
    )

select *
from renamed
