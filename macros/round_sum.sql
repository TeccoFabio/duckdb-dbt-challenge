{% macro round_sum(column_name) %}
    ROUND(SUM({{column_name}}), 2)
{% endmacro %}