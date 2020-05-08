view: row_total_dt {
   derived_table: {
    sql: SELECT DATE_FORMAT(TIMESTAMP(DATE(DATE_ADD(orders.created_at,INTERVAL (0 - MOD((DAYOFWEEK(orders.created_at) - 1) - 1 + 7, 7)) day))), '%Y-%m-%d') as created_week,  count(orders.id) as total_count
      FROM orders
      GROUP BY created_week
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: created_week {
    type: string
    sql: ${TABLE}.created_week ;;
  }

  dimension: total_count {
    type: number
    sql: ${TABLE}.total_count ;;
  }

  set: detail {
    fields: [created_week, total_count]
  }
}
