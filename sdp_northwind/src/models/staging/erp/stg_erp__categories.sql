create or refresh materialized view `${target_catalog}`.`${staging_schema}`.stg_erp__categories(
    category_pk int comment 'Primary key for the categories table'
    , category_name string comment 'Category name'
    , category_description string comment 'Category description'
    , pk_count int comment 'Data quality column to check for duplicates'
    , constraint not_null_category_pk expect (category_pk is not null) on violation fail update
    , constraint unique_category_pk expect (pk_count = 1) on violation fail update
)
comment 'Staging table for product categories data'
as
with
    source_data as (
        select *
        from `${raw_catalog}`.`${erp_source_schema}`.categories
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
