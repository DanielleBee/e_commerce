# If necessary, uncomment the line below to include explore_source.
# include: "/**/e_commerce.model"

# view: ndt {
#   derived_table: {
#     explore_source: order_items {
#       column: fullname { field: users.fullname }
#       column: created_date { field: orders.created_date }
#       column: most_recent_order { field: orders.most_recent_order }
#       filters: {
#         field: users.state
#         value: "New York"
#       }
#     }
#   }
#   dimension: fullname {}
#   dimension: created_date {
#     type: date
#   }
#   dimension: most_recent_order {
#     type: number
#   }
# }
