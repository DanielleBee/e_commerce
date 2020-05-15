  view: users {
    sql_table_name: demo_db.users ;;

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }

    dimension_group: created {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        year
      ]
      sql: ${TABLE}.created_at ;;
    }

    dimension: first_name {
      type: string
      sql: ${TABLE}.first_name ;;
    }

#### sum a count_distinct test using a case/when
    measure: distinct_first_names  {
      type: count_distinct
      sql: ${first_name} ;;
    }

    measure: sum_distinct_first_names{
      type: sum_distinct
      sql_distinct_key: ${id} ;;
      sql: ${first_name} ;;
    }


#### end test
    dimension: last_name {
      type: string
      sql: ${TABLE}.last_name ;;
    }

    dimension: fullname {
      type: string
      sql: CONCAT(${first_name}, ' ,' ,${last_name}) ;;
      link: {
      label: "Drill Dashboard"
      url: "/dashboards/2?FullName={{ filterable_value }}"
      }
    }

    dimension: city {
      group_label: "Geography"
      type: string
      sql: ${TABLE}.city ;;
    }

    dimension: state {
      group_label: "Geography"
      type: string
      sql: ${TABLE}.state ;;
      link: {
        label: "Drill Dashboard"
        url: "/dashboards/2?State={{ value }}&FullName={{_filters['users.fullname'] | url_encode}}"
        icon_url: "data:image/png;base64,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"
      }
    }

    dimension: zip {
      group_label: "Geography"
      type: zipcode
      sql: ${TABLE}.zip ;;
    }

    dimension: country {
      group_label: "Geography"
      type: string
      sql: ${TABLE}.country ;;
    drill_fields: [state, city]
    }

    dimension: countrynameformaps {
      type: string
      map_layer_name: countries
      sql: CASE WHEN ${TABLE}.country = 'USA' THEN 'US' ELSE ${TABLE}.country END;;
#       view_label: "Demographic Information"
#       group_label: "Account Holder"
#       label: "Country"
    }

    dimension: age {
      type: number
      sql: ${TABLE}.age ;;
    }

    dimension: age2 {
      type: number
      sql: ${TABLE}.age - 10 ;;
    }

    dimension: age_tier {
      type: tier
      tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
      style: integer
      sql: ${age} ;;
    }

    dimension: gender {
      type: string
      sql: {% if users.email._in_query %}
      CONCAT(${TABLE}.gender,' - ', ${TABLE}.id)
      {% else %}
      ${TABLE}.gender
      {% endif %};;
    }

    dimension: email {
      type: string
      sql: ${TABLE}.email ;;
    }

    dimension: traffic_source {
      type: string
      sql: ${TABLE}.traffic_source ;;
    }

##Templated Filter Example added as part of office hours
##hidden yes/no filter that will be helpful and more reproducible
    dimension: traffic_source_filter {
      hidden:  yes
      type:  yesno
      sql:  {% condition incoming_traffic_source %}
        ${traffic_source} {% endcondition %};;
    }

    filter:incoming_traffic_source {
      type: string
      suggest_dimension:
      users.traffic_source
      suggest_explore: users
    }

    measure: changeable_count_measure {
      type: count_distinct
      sql: ${id} ;;
      filters: {
        field: traffic_source_filter
        value: "Yes"
      }
    }
    ##potentially better than the measure defined above because it's a count
    ##vs a count distinct can save time on a dashboard loading
    measure: changeable_count_measure_better {
      type: count
      filters: {
        field: traffic_source_filter
        value: "Yes"
      }
    }
##end of what was added from office hours

    dimension: latitude {
      type: number
      hidden:  yes
      sql: ${TABLE}.latitude ;;
    }

    dimension: longitude {
      type: number
      hidden: yes
      sql: ${TABLE}.longitude ;;
    }

    dimension: location {
      group_label: "Geography"
      type: location
      sql_latitude: ${latitude} ;;
      sql_longitude: ${longitude} ;;
    }

    measure: count {
      label: "Number of Users"
      type: count
      drill_fields: [id, first_name, last_name]
      value_format: "#,##0"
      html:
      {% if value > 50 %}
         <a href="{{link}}">
        <p style="color:green">{{value}} </p>
        {% else %}
        <p style="color:red">{{value}}</p></a>
        {% endif %}
        ;;
    }

    measure: female_count {
      label: "Number of Women"
      type: count_distinct
      sql: ${id} ;;
      filters: {
        field: gender
        value: "f"
      }
    }

    dimension: is_user_over_21 {
      type: yesno
      sql: ${age} > 21 ;;
    }

    measure: percent_of_total {
      type: percent_of_total
      sql: ${count} ;;
    }

#############################
    parameter: tier_bucket_size {
      type: string
    }

    parameter: dimension_picker {
      type: unquoted
      allowed_value: {
        value: "Age"
      }

      allowed_value: {
        value: "Age2"
      }
    }

    dimension: dynamic_tier {
#       type: number
      sql: {% assign my_array = tier_bucket_size._parameter_value | remove: "'" | split: "," %}
      {% assign sort = '-1' %}
      {% assign last_group_max_label = ' 0' %}

      {% if dimension_picker._parameter_value == 'age' %}

        case
        {%for element in my_array%}
        {% assign sort = sort | plus: 1 %}

        when ${age}<{{element}} then '{{last_group_max_label}} <= {{dimension_picker._parameter_value}} < {{element}}'
        {% assign last_group_max_label = element %}
        {%endfor%}
        {% assign sort = sort | plus: 1 %}

        when ${age}>={{last_group_max_label}} then '{{dimension_picker._parameter_value}}>= {{last_group_max_label}}'

        end

      {% elsif dimension_picker._parameter_value == 'age2' %}

      case
        {%for element in my_array%}
        {% assign sort = sort | plus: 1 %}

        when ${age2}<{{element}} then '{{last_group_max_label}} <= {{dimension_picker._parameter_value}} < {{element}}'
        {% assign last_group_max_label = element %}
        {%endfor%}
        {% assign sort = sort | plus: 1 %}

        when ${age2}>={{last_group_max_label}} then '{{dimension_picker._parameter_value}}>= {{last_group_max_label}}'

        end

      {% endif %}

      ;;

    }

# {% parameter dimension_picker._parameter_value %}
# TABLE.{% parameter dimension_picker %}

  }
