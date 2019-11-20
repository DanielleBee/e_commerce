connection: "thelook"
include: "*.view"

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
}

explore: products {
  fields: [ALL_FIELDS*, -products.brand]
}

explore: orders {
  sql_always_where: {% condition orders.date_picker %} orders.created_at {% endcondition %} ;;
}

# sql_always_where: {% if orders.date_picker._parameter_value == 'before 2018-01-01' %}
# orders.created_date < (CONVERT_TZ(TIMESTAMP('2018-01-01'),'America/Los_Angeles','UTC')
# {% else %}
# orders.created_date >= ((CONVERT_TZ(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles')),'%Y-%m-01')),INTERVAL -10 month),'America/Los_Angeles','UTC'))) AND (orders.created_at ) < ((CONVERT_TZ(DATE_ADD(DATE_ADD(TIMESTAMP(DATE_FORMAT(DATE(CONVERT_TZ(NOW(),'UTC','America/Los_Angeles')),'%Y-%m-01')),INTERVAL -10 month),INTERVAL 1 month),'America/Los_Angeles','UTC')))
# {% endif %}
# ;;

explore: user_order_facts { }

explore: users {
  view_name: users  ## Important to define the view_name in base explore if extending
  fields: [ALL_FIELDS*]

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
#   join:  distribution_centers {
#     sql_on: ${distribution_centers.id} = ${inventory_items.distribution_center_id} ;;
#     type: left_outer
#     relationship: many_to_one
# }
}

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
