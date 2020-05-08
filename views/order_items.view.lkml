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

  dimension: order_returned {
    type: yesno
    sql: ${returned_date} IS NOT NULL ;;
  }

  dimension: sale_price {
    label: "Sale Price"
    type: number
    sql: (${TABLE}.sale_price) ;;
#     value_format_name: usd
  value_format: "#,##0"
  }

  dimension: price_range {
    label: "price_range"
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

  dimension: price_range_2 {
    type: string
    label: "Price Range"
    sql: CASE
    WHEN (${orders.status} LIKE 'complete' AND ${sale_price} < 20) THEN 'cheap'
    WHEN ${orders.status} LIKE 'complete' AND ${sale_price} >= 20 AND ${sale_price} < 100 THEN 'normal'
    WHEN ${orders.status} LIKE 'complete' AND ${sale_price} >= 100 THEN 'pricey'
    ELSE 'blah'
    END
    ;;
  }

  measure: count {
    label: "number_of_items_ordered"
    type: count
    drill_fields: [
      id,
      returned_time,
      sale_price,
      products.name
    ]
  }

  dimension: discounted_sale_price {
    type: number
    sql: CASE WHEN ${sale_price}>100 THEN ${sale_price}*0.85 END;;
    value_format_name: usd
  }

  measure: total_discounted_sale_price {
    type: sum
    sql: ${discounted_sale_price} ;;
  }

  measure: total_sale_price {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
    html: {{ orders.status._rendered_value | unescape  }}: Text String {{ rendered_value }} ;;
  }

  measure: percent_diff_sale_and_discount {
    type: string
#     value_format_name: percent_0
    sql:
    CASE WHEN ((${total_sale_price}-${total_discounted_sale_price})/nullif(${total_sale_price},0))*100 < 20
    THEN ROUND(((${total_sale_price}-${total_discounted_sale_price})/nullif(${total_sale_price},0))*100,2)
    ELSE CONCAT(ROUND(((${total_sale_price}-${total_discounted_sale_price})/nullif(${total_sale_price},0))*100,4),"%")
    END
    ;;
}

  measure: percent_diff_test {
    type: number
    sql: (${total_sale_price}-${total_discounted_sale_price})/nullif(${total_sale_price},0) ;;
    value_format: "[<0.2000]0.00%;[>=0.2000]0%;0%"
  }
# sql: CASE WHEN ${order_id}<10 THEN ROUND(1.32,1) ELSE ROUND(1.32,0) END ;;
#     html:
#     {% if value < .01 %}
#     {{ rendered_value | value_format: "0.00%" }}
#     {% else %}
#     {{rendered_value | value_format: "0%"   }}
#     {% endif %}
# ;;

############date templated filter test################
  dimension: date_satisfies_filter {
    description: "Templated filter to be used with total sale price measure"
    type: yesno
#     hidden: yes
    sql: {% condition orders.date_filter_test %} ${orders.created_date} {% endcondition %} ;;
  }


  measure: total_sale_price_filtered_measure {
    description: "To be used with Date Satisfies Filter filter"
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
#     html: <center>{{rendered_value}}</center> ;;
    filters: {
      field: date_satisfies_filter
      value: "yes"
    }
  }

################ Conditional Filtered Measure ########

#   measure: total_sale_price_conditional_filter2 {
#     type: number
#     sql: {% if order_items.returned_date._in_query %} SUM(order_items.sale_price)
#     {% elsif orders.created_date._in_query and orders.status == 'cancelled' %} SUM(order_items.sale_price)
#     {% else %} SUM(order_items.sale_price)
#     {% endif %};;
#     value_format_name: usd
#   }

  measure: total_sale_price_conditional_filter3 {
    group_label: "Conditional Filtered Measure Test"
    type: sum
    sql: {% if order_items.returned_date._in_query %} ${sale_price}
          {% elsif orders.created_date._in_query and orders.status == 'cancelled' %} ${sale_price}
          {% else %} ${sale_price}
          {% endif %};;
    value_format_name: usd
  }

  measure: total_sale_priceA {
    group_label: "Conditional Filtered Measure Test"
    type: sum
    sql: ${sale_price};;
    value_format_name: usd
  }

  measure: total_sale_priceB {
    group_label: "Conditional Filtered Measure Test"
    type: sum
    sql: ${sale_price};;
    filters: {
      field: orders.status
      value: "cancelled"
    }
    value_format_name: usd
  }


  measure: total_sale_price_conditional_filter {
    group_label: "Conditional Filtered Measure Test"
    type: number
    sql: {% if order_items.returned_date._in_query %} ${total_sale_priceA}
          {% elsif orders.created_date._in_query %} ${total_sale_priceB}
          {% else %} ${total_sale_priceA}
          {% endif %};;
    value_format_name: usd
  }


  measure: percent_of_total_sale_price{
    type: percent_of_total
    sql: ${total_sale_price} ;;
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

  measure: most_expensive_item {
    type: max
    sql: ${sale_price} ;;
  }

  measure: html_test_placeholder {
    type: count
    html:
      <p><div>
      Hamilton is a musical with music, lyrics, and book by Lin-Manuel Miranda. It is inspired by the 2004 biography Alexander Hamilton by historian Ron Chernow. The musical tells the story of American Founding Father Alexander Hamilton through music that draws heavily from hip hop, as well as R&B, pop, soul, and traditional-style show tunes; the show also incorporates color-conscious casting of non-white actors as the Founding Fathers and other historical figures.[1][2][3] Through this use of modern storytelling methods, Hamilton has been described as being about "America then, as told by America now."[4] The show premiered at the Public Theater Off-Broadway on February 17, 2015, where its engagement was sold out;[5] it won eight Drama Desk Awards, including Outstanding Musical. It then transferred to the Richard Rodgers Theatre on Broadway, opening on August 6, 2015, where it received uniformly positive reviews and strikingly high box office sales.[6] At the 2016 Tony Awards, Hamilton received a record-setting 16 nominations, eventually winning 11 awards, including Best Musical. It received the 2016 Pulitzer Prize for Drama.
      </div></p>
    ;;
  }

##### RUNNING TOTALS TEST ###########

parameter:  running_total_metric_selector {
  label: "running_total_metric_selector"
  type: string
  allowed_value: {
    label: "total_sale_price"
    value: "total_sale_price"
  }
  allowed_value: {
    label: "total_orders"
    value: "total_number_of_orders"
  }
  allowed_value: {
    label: "Average Sale Price per Order"
    value: "average"
  }
}

measure: running_total_measure {
#   label_from_parameter: running_total_metric_selector
label: "{% if running_total_metric_selector._parameter_value == \"'total_number_of_orders'\" %} {{ _user_attributes['first_name'] }}
{% elsif running_total_metric_selector._parameter_value == \"'total_sale_price'\" %} {{ _user_attributes['last_name'] }}
{% else %} Product Group
{% endif %}"
  type: running_total
  value_format: "#,##0.00"
  direction: "column"
  sql: CASE
  WHEN {% parameter running_total_metric_selector %} = 'total_number_of_orders' THEN ${orders.count}
  WHEN {% parameter running_total_metric_selector %} = 'total_sale_price' THEN ${order_items.total_sale_price}
  WHEN {% parameter running_total_metric_selector %} = 'average' THEN (${order_items.total_sale_price}/${orders.count})
  ELSE NULL
  END ;;
}

  measure: running_total_sale_price {
    type: running_total
    sql: ${total_sale_price} ;;
    value_format_name: usd_0
  }

  measure: average_order_value {
    type: number
    sql: (${order_items.total_sale_price}/${orders.count}) ;;
    value_format_name: usd
  }

#   label: "{% if running_total_metric_selector._parameter_value == 'total_sale_price' %} Total Sale Price
#   {% elsif running_total_metric_selector._parameter_value == 'total_number_of_orders' %} Running Order Total
#   {% else %} Running Total {% endif %}"
}
