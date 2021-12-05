{% macro id_from_url(url_string) %}
    split_part({{ url_string }}, '/product/', 2)
{% endmacro %}