view: min_max_order_dates {
  derived_table: {
    sql: SELECT users.id, MIN(orders.created_at), MAX(orders.created_at)
      FROM orders
      JOIN users ON orders.user_id = users.id
      GROUP BY users.id
       ;;
  }

  dimension: id {
    label: "User ID"
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: minorders_created_at {
    label: "First Order Date"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.`MIN(orders.created_at)` ;;
  }

  dimension_group: maxorders_created_at {
    label: "Most Recent Order"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.`MAX(orders.created_at)` ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  set: detail {
    fields: [id, minorders_created_at_time, maxorders_created_at_time]
  }
}
