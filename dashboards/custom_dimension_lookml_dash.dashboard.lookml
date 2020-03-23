# - dashboard: merge_result_with_custom_dim
#   title: merge result with custom dim
#   layout: newspaper
#   elements:
#   - name: New Tile
#     title: New Tile
#     merged_queries:
#     - model: e_commerce
#       explore: order_items
#       type: table
#       fields: [orders.created_date, orders.count, orders.running_total_count, calculation_1]
#       fill_fields: [orders.created_date]
#       sorts: [orders.created_date desc]
#       limit: 500
#       dynamic_fields: [{dimension: calculation_1, label: Calculation 1, expression: "${orders.created_date}>date(2019,12,1)",
#           value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
#           _type_hint: yesno}]
#       query_timezone: America/Los_Angeles
#       join_fields: []
#     - model: e_commerce
#       explore: order_items
#       type: table
#       fields: [orders.created_date, order_items.total_sale_priceA, order_items.total_sale_priceB,
#         order_items.total_sale_price_conditional_filter, order_items.total_sale_price_conditional_filter3]
#       fill_fields: [orders.created_date]
#       sorts: [orders.created_date desc]
#       limit: 500
#       query_timezone: America/Los_Angeles
#       join_fields:
#       - field_name: orders.created_date
#         source_field_name: orders.created_date
#     type: looker_grid
#     series_types: {}
#     row: 0
#     col: 0
#     width: 8
#     height: 6
