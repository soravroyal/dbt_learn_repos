{% set stage_name = 'my_dbt_internal_stage2' %}
{% set db = 'snowflake_dt' %}
{% set schema = 'public' %}
{% set stage_type = 'internal' %}
{% set file_format = "type = csv SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY='\"'" %}

-- Create the internal stage with file format
{{ create_snowflake_internal_stage(
    db=db,
    schema=schema,
    name=stage_name,
    file_format=file_format
) }}

;WITH staged AS(
    SELECT   
        metadata$filename AS filename_,
        metadata$file_row_number AS row_,

        -- Assuming the file is CSV, first column is $1
        $1 AS column1,
        $2 AS column2
    FROM @{{ db }}.{{ schema }}.{{ stage_name }}
)
SELECT * FROM staged