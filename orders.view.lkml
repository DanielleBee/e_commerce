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

####### Date Parameters Test ###########
  parameter: date_picker {
  type: date_time
  allowed_value: {
    label: "Before 2018"
    value: "before 2018-01-01"
  }
  allowed_value: {
    label: "10 Months Ago"
    value: "10 months ago"
    }
    allowed_value: {
      label: "Week to date"
      value: "this week"
    }
  }

#   dimension: date_with_param {
#     label_from_parameter: date_picker
#     sql:
#     CASE
#       WHEN {% parameter date_picker %} = 'Yesterday'
#         THEN ${created_date}::VARCHAR
#       WHEN {% parameter ${date_picker} %} = 'This Week'
#         THEN ${created_week}::VARCHAR
#       WHEN {% parameter date_picker %} = 'This Month'
#         THEN ${created_month}::VARCHAR
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

  measure: most_recent_order {
    type: date
    sql: MAX(${created_date}) ;;
  }

  measure: count {
    type: count
  }
}
