- dashboard: week_start_day_dash
  title: Week Start Day
  layout: newspaper
  elements:
  - title: No Dimension Fill
    name: No Dimension Fill
    model: e_commerce
    explore: order_items
    type: looker_column
    fields: [orders.created_week, orders.count, users.gender]
    pivots: [users.gender]
    fill_fields: [orders.created_week]
    filters:
      orders.created_year: '2019'
    sorts: [orders.created_week desc, users.gender]
    limit: 500
    query_timezone: UTC
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    row: 0
    col: 0
    width: 8
    height: 6
  - title: Nov and Dec 2019 no dim fill
    name: Nov and Dec 2019 no dim fill
    model: e_commerce
    explore: order_items
    type: looker_column
    fields: [orders.created_week, orders.count, users.gender]
    pivots: [users.gender]
    filters:
      orders.created_month: 7 months
    sorts: [orders.created_week desc, users.gender]
    limit: 500
    query_timezone: UTC
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    row: 0
    col: 8
    width: 8
    height: 6
  - title: July 1 to Sept 30
    name: July 1 to Sept 30
    model: e_commerce
    explore: order_items
    type: looker_column
    fields: [orders.created_week, orders.count, users.gender]
    pivots: [users.gender]
    filters:
      orders.created_date: 2019/07/01 to 2019/09/30
    sorts: [orders.created_week desc, users.gender]
    limit: 500
    query_timezone: UTC
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    row: 0
    col: 16
    width: 8
    height: 6
