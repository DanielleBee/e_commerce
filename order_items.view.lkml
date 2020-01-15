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
    sql: (${TABLE}.sale_price) ;;
#     value_format_name: usd
  value_format: "#,##0"
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

############date templated filter test################
  dimension: date_satisfies_filter {
    type: yesno
#     hidden: yes
    sql: {% condition orders.date_filter_test %} ${orders.created_date} {% endcondition %} ;;
  }


  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
#     html: <center>{{rendered_value}}</center> ;;
    filters: {
      field: date_satisfies_filter
      value: "yes"
    }
  }
#####################


  measure: average_sale_price {
    type: average
    sql: ${sale_price} ;;
    #value_format: "0.0,\" K\""
    value_format_name: usd
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

##### RUNNING TOTALS TEST ###########

parameter:  running_total_metric_selector {
  type: string
  allowed_value: {
    label: "Total Sale Price"
    value: "total_sale_price"
  }
  allowed_value: {
    label: "Total Number of Orders"
    value: "total_number_of_orders"
  }
  allowed_value: {
    label: "Average Sale Price per Order"
    value: "average"
  }
}

measure: running_total_sale_price {
  type: running_total
  sql: ${total_sale_price} ;;
  value_format_name: usd_0
}

measure: average_order_value {
  type: number
  sql: (${order_items.total_sale_price}/${orders.count}) ;;
  value_format_name: usd_0
}

measure: running_total_measure {
  type: running_total
  value_format: "#,##0.00"
  direction: "column"
  sql: CASE
        WHEN {% parameter running_total_metric_selector %} = 'total_number_of_orders' THEN ${orders.count}
        WHEN {% parameter running_total_metric_selector %} = 'total_sale_price' THEN ${order_items.total_sale_price}
        WHEN {% parameter running_total_metric_selector %} = 'average_order_value' THEN (${order_items.total_sale_price}/${orders.count})
        ELSE NULL
END ;;
}
}
