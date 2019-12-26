# - dashboard: lookml_dash_test
#   title: Lookml Dash Test
#   layout: tile
#   tile_size: 100

#   filters:

#   elements:
#     - name: hello_world
#       type: looker_column

- dashboard: table_viz_dashboard_download_test__api
  title: Table Viz Dashboard Download Test - API
  layout: newspaper
  elements:
  - title: table
    name: table
    model: e_commerce
    explore: order_items
    type: table
    fields: [orders.created_date, order_items.count, order_items.average_sale_price]
    fill_fields: [orders.created_date]
    sorts: [orders.created_date desc]
    limit: 500
    query_timezone: America/Los_Angeles
    row: 0
    col: 0
    width: 21
    height: 14
