{% macro round_sum(column) %}
    ROUND(SUM({{column}}), 2)
{% endmacro %}