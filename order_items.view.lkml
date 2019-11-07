view: order_items {
  sql_table_name: demo_db.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_id {
    type: number
    hidden: no
    sql: ${TABLE}.order_id ;;
  }

  dimension: inventory_item_id {
    type: number
    hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
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

  dimension_group: shipped {
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
    sql: ${TABLE}.shipped_at ;;
  }

  dimension_group: delivered {
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
    sql: ${TABLE}.delivered_at ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension: price_range {
    case: {
      when: {
        sql: ${sale_price} < 20 ;;
        label: "Inexpensive"
      }
      when: {
        sql: ${sale_price} >= 20 AND ${sale_price} < 100 ;;
        label: "Normal"
      }
      when: {
        sql: ${sale_price} >= 100 ;;
        label: "Expensive"
      }
      else: "Unknown"
    }
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: count {
    label: "Number of Items Ordered"
    type: count
    drill_fields: [
      id,
      created_time,
      shipped_time,
      delivered_time,
      returned_time,
      sale_price,
      status,
      products.name
    ]
  }

  dimension: discounted_sale_price {
    type: number
    sql: ${sale_price} * 0.8;;
    value_format_name: usd
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    html: <center>{{rendered_value}}</center> ;;
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: total_profit {
    type: number
    value_format_name: usd
    sql: ${total_sale_price} - ${products.total_retail_price} ;;
  }

  measure: percent_test  {
    type: number
    sql: ${total_profit}/${total_sale_price}*-1;;
    value_format_name: percent_0
  }

  measure: least_expensive_item {
    type: min
    sql: ${sale_price} ;;
  }

#   measure: test_measure_sum {
#     type: number
#     sql: ${total_profit}+${total_sale_price} ;;
#    link:
#   }

  measure: most_expensive_item {
    type: max
    sql: ${sale_price} ;;
  }
}
