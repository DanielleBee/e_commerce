connection: "thelook"
# include: "*.view"
# include: "*dashboard.lookml"
include: "/**/*.view"
include: "/**/*.dashboard.lookml"
include: "/*.strings.json"
# include: "manifest.lkml"

# datagroup: orders_datagroup {
#   sql_trigger: SELECT COUNT(*) FROM ${orders_derived_table.SQL_TABLE_NAME};;
#   max_cache_age: "24 hours"
# }

datagroup: daily_refresh {
  sql_trigger: SELECT currentdate() ;;
  max_cache_age: "24 hours"
}

# explore: ndt {}

explore: order_items {
  join: orders {
  sql_on: ${orders.id} = ${order_items.order_id};;
    type: left_outer
    relationship: many_to_one
  }

  join: users {
    sql_on: ${users.id} = ${orders.user_id} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: min_max_order_dates {
    sql_on: ${min_max_order_dates.id}=${orders.user_id} ;;
    type: left_outer
    relationship: one_to_many
  }

  join: user_order_facts {
    sql_on: ${user_order_facts.user_id} = ${users.id} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: inventory_items {
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
    fields: []
    type: left_outer
    relationship: one_to_one
  }

  join: products {
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
    type: left_outer
    relationship: many_to_one
  }
  join: row_total_dt {
    sql_on: ${row_total_dt.created_week} = ${orders.created_week} ;;
    relationship: many_to_one
    type: left_outer
  }
}

explore: min_max_order_dates {}

explore: orders_derived_table {}

explore: products {
#   fields: [ALL_FIELDS*, -products.brand]
}

explore: orders {
#   sql_always_where:  {% if orders.date_granularity._parameter_value == "'Last Month'" %}
#           ((( orders.created_at ) >= ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-%m-01')),INTERVAL -1 month))) AND ( orders.created_at ) < ((DATE_ADD(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-%m-01')),INTERVAL -1 month),INTERVAL 1 month)))))
#         {% elsif orders.date_granularity._parameter_value == "'This Year'" %}
#           ((( orders.created_at ) >= ((TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')))) AND ( orders.created_at ) < ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')),INTERVAL 1 year)))))
#         {% elsif orders.date_granularity._parameter_value == "'Last Year'" %}
#           ((( orders.created_at ) >= ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')),INTERVAL -1 year))) AND ( orders.created_at ) < ((DATE_ADD(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')),INTERVAL -1 year),INTERVAL 1 year)))))
#         {% else %}
#         1=1
#         {% endif %} ;;
  join: row_total_dt {
    sql_on: ${row_total_dt.created_week} = ${orders.created_week} ;;
    relationship: many_to_one
    type: left_outer
  }
}

# sql_always_where:
#     CASE
#     WHEN {{ orders.date_granularity._parameter_value }} = 'Last Month'
#       THEN ((( orders.created_at ) >= ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-%m-01')),INTERVAL -1 month))) AND ( orders.created_at ) < ((DATE_ADD(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-%m-01')),INTERVAL -1 month),INTERVAL 1 month)))))
#     WHEN {{ orders.date_granularity._parameter_value }} = 'This Year'
#       THEN ((( orders.created_at ) >= ((TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')))) AND ( orders.created_at ) < ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')),INTERVAL 1 year)))))
#     WHEN {{ orders.date_granularity._parameter_value }} = 'Last Year'
#       THEN ((( orders.created_at ) >= ((DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')),INTERVAL -1 year))) AND ( orders.created_at ) < ((DATE_ADD(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(NOW()),'%Y-01-01')),INTERVAL -1 year),INTERVAL 1 year)))))
#     ELSE 1=1
#     END;;


#   sql_always_where:
#   {% if orders.starting_date._is_filtered or orders.ending_date._is_filtered %}
#   (${created_date} >= {{ orders.starting_date._parameter_value }}
#   AND
#   ${created_date} < {{ orders.ending_date._parameter_value }})
#   {% else %}
#   1=1
#   {% endif %};;
# sql_always_where: {% condition orders.date_granularity %} orders.created_at {% endcondition %} ;;
# }

#   sql_always_where:
#   {% if orders.date_picker._parameter_value == 'Before_2018' %}
#     ${created_date} < (CONVERT_TZ(TIMESTAMP('2018-01-01'),'America/Los_Angeles','UTC'))
#   {% elsif orders.date_picker._parameter_value == '10_months_ago' %}
#     ${created_date} >= ((CONVERT_TZ(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles')),'%Y-%m-01')),INTERVAL -10 month),'America/Los_Angeles','UTC'))) AND (orders.created_at ) < ((CONVERT_TZ(DATE_ADD(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles')),'%Y-%m-01')),INTERVAL -10 month),INTERVAL 1 month),'America/Los_Angeles','UTC')))
#   {% else 1=1 %}
#   {% endif %}
# ;;

# sql_always_where: {% condition orders.date_picker %} orders.created_at {% endcondition %} ;;

#{% elsif orders.date_picker._parameter_value == 'this_week' %}
#     ${created_date} >= ((CONVERT_TZ(TIMESTAMP(DATE(DATE_ADD(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles')),INTERVAL (0 - MOD((DAYOFWEEK(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles'))) - 1) - 1 + 7, 7)) day))),'America/Los_Angeles','UTC'))) AND (orders.created_at ) < ((CONVERT_TZ(DATE_ADD(TIMESTAMP(DATE(DATE_ADD(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles')),INTERVAL (0 - MOD((DAYOFWEEK(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles'))) - 1) - 1 + 7, 7)) day))),INTERVAL 1 week),'America/Los_Angeles','UTC')))

explore: user_order_facts { }

# explore: users {
#   view_name: users  ## Important to define the view_name in base explore if extending
#   fields: [ALL_FIELDS*]


############### COHORT ANALYSIS TEST #################
#   explore: users {
#     join: orders {
#       sql_on: ${orders.user_id} = ${users.id} ;;
#       relationship : one_to_many
#     }
#
#     join: order_items {
#       sql_on: ${order_items.order_id} = ${orders.id} ;;
#       relationship : one_to_many
#     }
#
#     join: user_cohort_size {
#       sql_on: ${user_cohort_size.created_month} = ${users.created_month};;
#       relationship: many_to_one
#     }
#
#     join: inventory_items {
#       sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
#       fields: []
#       type: left_outer
#       relationship: one_to_one
#     }
#
#     join: products {
#       sql_on: ${products.id} = ${inventory_items.product_id} ;;
#       type: left_outer
#       relationship: many_to_one
#     }
#     }

####### Parameterized derived table to calculate cohort size
    view: user_cohort_size {
      derived_table: {
      sql:
       SELECT
       DATE_FORMAT(CONVERT_TZ(u.created_at,'UTC','America/Los_Angeles'),'%Y-%m') AS created_month
       , COUNT(*) as cohort_size
       FROM users u
       WHERE
       -- Insert filters here using a condition statement, you may add as many filters as desired
       {% condition users.age %} u.age {% endcondition %}
       AND {% condition users.state %} u.state {% endcondition %}
       GROUP BY 1 ;;
      }

        dimension: created_month {
          primary_key: yes
        }

        dimension: cohort_size {
          type: number
        }

        measure: total_cohort_size {
          type: sum
          sql: ${cohort_size} ;;
        }

        measure: total_revenue_over_total_cohort_size {
          type: number
          sql: ${order_items.total_sale_price} / ${total_cohort_size} ;;
          value_format_name: usd
        }
}




#   join: orders {
#     type: left_outer
#     sql_on: ${orders.user_id} = ${users.id} ;;
#     relationship: one_to_many
#   }
#
#   join: order_items {
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#     type: left_outer
#     relationship: one_to_many
#   }
#
#   join: inventory_items {
#     sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
#     type: left_outer
#     relationship: one_to_one
#   }
#
#   join: products {
#     sql_on: ${products.id} = ${inventory_items.product_id} ;;
#     type: left_outer
#     relationship: many_to_one
#   }
#
#}

##### Basic example of extended explore.
# explore: users_extended {
#   extends: [users]
# }

##### More advanced extended explores example where we are adding a new extended
##### explore that references the 'users_extended' view instead of 'user.'
##### This allows the fields to be referenced as ${users.field} not
##### ${users_extended.field} as well as preserves the join that has a reference
##### to a field defined as ${user.id}.

# explore: users_new {
#   extends: [users]
#   from: users_extended
# }

##### Extended Explore Example with a Self-Join

# explore: buyers_and_sellers {
#   view_label: "Sellers"
#   extends: [users_new]
#   label: "Sellers and Buyers"
#   join: Buyers {
#     from: users_extended
#     sql_on: ${Buyers.id} = ${users.id} ;;
#     relationship: many_to_one
#   }
# }
