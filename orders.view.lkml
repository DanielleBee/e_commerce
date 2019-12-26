view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    type: number
    hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: created {
    type: time
    datatype: datetime
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

  dimension_group: created_tz_test {
    type: time
    sql: CONVERT_TZ(${created_raw}, 'utc', 'Americas/New_York');;
    }


####### Date Parameters Test ###########
  parameter: date_picker {
  type: unquoted
  allowed_value: {
    label: "Before 2018"
    value: "Before_2018"
  }
  allowed_value: {
    label: "10 Months Ago"
    value: "10_months_ago"
    }
    allowed_value: {
      label: "Week to date"
      value: "this_week"
    }
  }

#   dimension: date_with_param {
#     label_from_parameter: date_picker
#     sql:
#     CASE
#       WHEN {% parameter date_picker %} = 'before 2018-01-01'
#         THEN ${created_date}::VARCHAR
#       WHEN {% parameter date_picker %} = 'This Week'
#         THEN ${created_week}
#       WHEN {% parameter date_picker %} = '10 months ago'
#         THEN ${created_date}
#       ELSE NULL
#     END ;;
#   }

###################

  dimension: created_date_formatted {
    sql: ${created_date} ;;
    html: {{ rendered_value | date: "%B %d, %Y" }};;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_complete {
    type: yesno
    sql: ${status} = 'complete' ;;
  }

############# THIS YEAR LOGIC ##############

  filter: date_filter {
    type: date
  }
  dimension: this_year_logic {
    group_label: "Test"
    type: yesno
    sql: {% condition date_filter %} ${created_date} {% endcondition %}
      ;;
  }
  measure: count_this_year {
    type: count
    filters: {
      field: this_year_logic
      value: "yes"
    }
  }

############# LAST YEAR LOGIC ##############

    dimension: last_year_logic {
      type: yesno
      sql: {% condition date_filter %} DATE_ADD (${created_date}, interval -1 year) {% endcondition %}
        ;;
    }
    measure: count_last_year {
      type: count
      filters: {
        field: last_year_logic
        value: "yes"
      }
    }



dimension_group: interval_minus_1_year {
  type: time
  datatype: datetime
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql: interval(${TABLE}.created_at,-1) ;;
}

  measure: most_recent_order {
    type: date
    sql: MAX(${created_date}) ;;
  }

  measure: count {
    type: count
    drill_fields: [user_id,users.age]
  }
}
