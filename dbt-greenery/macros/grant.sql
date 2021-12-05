{% macro grant(role, select=True) %}

    {% set sql %}
      {% if select %}
      grant select on {{ this }} to {{ role }};
      {% else %}
      grant usage on schema {{ schema }} to {{ role }};
      {% endif %}
    {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}