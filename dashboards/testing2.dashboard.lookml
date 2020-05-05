- dashboard: examples_for_customers_2
  title: Examples for Customers
  layout: newspaper
  elements:
  - title: Month's Value as % of its Year
    name: Month's Value as % of its Year
    model: e_commerce
    explore: order_items
    type: looker_grid
    fields: [orders.created_year, orders.created_month, orders.count]
    filters:
      orders.created_year: after 2018/07/04
    sorts: [orders.created_year]
    limit: 500
    dynamic_fields: [{table_calculation: totals_calc, label: totals_calc, expression: "if(\n\
          \  NOT(${orders.created_year} = offset(${orders.created_year},1)),\n   \
          \ sum(offset_list(${orders.count},-11,12)),null)", value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        table_calculation: total_by_year, label: total_by_year, expression: 'max(offset_list(${totals_calc},
          0, 12))', value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number}, {table_calculation: percent_of_given_year, label: Percent
          of Given Year, expression: "${orders.count}/${total_by_year}", value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, _type_hint: number}]
    query_timezone: America/Los_Angeles
    show_totals: true
    show_row_totals: true
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_cell_visualizations:
      orders.count:
        is_active: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields: [calculation_2, calculation_4, totals_calc, total_by_year]
    series_types: {}
    listen:
      Status: orders.status
    row: 0
    col: 0
    width: 8
    height: 6
  - title: Stacked Percentage Vis
    name: Stacked Percentage Vis
    model: e_commerce
    explore: order_items
    type: looker_column
    fields: [products.category, products.department, order_items.average_sale_price,
      orders.created_year]
    pivots: [orders.created_year]
    fill_fields: [orders.created_year]
    sorts: [products.category, orders.created_year]
    limit: 500
    dynamic_fields: [{table_calculation: average_sale_price_revised, label: Average
          Sale Price - Revised, expression: "if(${products.category}=\"Sweaters\"\
          ,\n\n(sum(if(${products.category}=\"Sweaters\",${order_items.average_sale_price},0))),\n\
          \n(if(${products.category}=\"Jeans\",\n\n(sum(if(${products.category}=\"\
          Jeans\",${order_items.average_sale_price},0))),\n\n${order_items.average_sale_price})))\n\
          \n      \n   ", value_format: !!null '', value_format_name: usd, _kind_hint: measure,
        _type_hint: number}, {table_calculation: calculation_3, label: Calculation
          3, expression: "${order_items.average_sale_price}/sum(${order_items.average_sale_price})",
        value_format: !!null '', value_format_name: percent_2, _kind_hint: measure,
        _type_hint: number}, {table_calculation: identifies_duplicate_categories,
        label: Identifies Duplicate Categories, expression: 'match(${products.category},${products.category})',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
        _type_hint: number}, {table_calculation: does_match_function_match_row_number,
        label: 'Does Match Function Match Row Number?', expression: 'if(NOT(${identifies_duplicate_categories}=row()),no,yes)',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
        _type_hint: yesno}]
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: 2016 - calculation_3,
            id: 2016 - calculation_3, name: '2016'}, {axisId: 2017 - calculation_3,
            id: 2017 - calculation_3, name: '2017'}, {axisId: 2018 - calculation_3,
            id: 2018 - calculation_3, name: '2018'}, {axisId: 2019 - calculation_3,
            id: 2019 - calculation_3, name: '2019'}], showLabels: true, showValues: true,
        maxValue: !!null '', minValue: !!null '', unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
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
    stacking: percent
    limit_displayed_rows: false
    legend_position: center
    label_value_format: 0.00\%
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_points_if_no: [does_match_function_match_row_number]
    hidden_fields: [identifies_duplicate_categories, products.department, average_sale_price_revised,
      calculation_3]
    listen:
      Status: orders.status
    row: 0
    col: 8
    width: 8
    height: 6
  - title: Row Totals for Table Calcs
    name: Row Totals for Table Calcs
    model: e_commerce
    explore: order_items
    type: looker_grid
    fields: [products.category, products.total_retail_price, orders.created_quarter]
    pivots: [orders.created_quarter]
    fill_fields: [orders.created_quarter]
    filters:
      orders.created_year: after 2019/01/02
    sorts: [products.total_retail_price desc 0, orders.created_quarter]
    limit: 500
    total: true
    row_total: right
    dynamic_fields: [{table_calculation: calculation_3, label: Calculation 3, expression: "${products.total_retail_price}*0.15",
        value_format: !!null '', value_format_name: decimal_2, _kind_hint: measure,
        _type_hint: number}, {table_calculation: row_total, label: Row Total, expression: 'sum(pivot_row(${calculation_3}))',
        value_format: !!null '', value_format_name: decimal_1, _kind_hint: supermeasure,
        _type_hint: number}]
    query_timezone: America/Los_Angeles
    series_types: {}
    listen:
      Status: orders.status
    row: 0
    col: 16
    width: 8
    height: 6
  - title: Conditional Running Total testing a long title to see if i can wrap it
    name: Conditional Running Total testing a long title to see if i can wrap it
    model: e_commerce
    explore: order_items
    type: looker_column
    fields: [orders.created_month, orders.status, orders.count]
    sorts: [orders.created_month desc]
    limit: 500
    dynamic_fields: [{table_calculation: overall_running_total, label: Overall Running
          Total, expression: 'running_total(${orders.count})', value_format: !!null '',
        value_format_name: usd_0, _kind_hint: measure, _type_hint: number}, {table_calculation: running_total_by_status,
        label: Running Total by Status, expression: "if(\n  ${orders.status} = \"\
          complete\", running_total(if(${orders.status} = \"complete\", ${orders.count},\
          \ null)),\n    \n    if(${orders.status} = \"cancelled\",running_total(if(${orders.status}\
          \ = \"cancelled\", ${orders.count}, null)),\n      \n      if(${orders.status}\
          \ = \"pending\",running_total(if(${orders.status} = \"pending\", ${orders.count},\
          \ null)),null)\n))", value_format: !!null '', value_format_name: usd_0,
        _kind_hint: measure, _type_hint: number}]
    listen:
      Status: orders.status
    row: 6
    col: 0
    width: 8
    height: 6
  - title: Running Totals by Status
    name: Running Totals by Status
    model: e_commerce
    explore: order_items
    type: table
    fields: [orders.created_month, orders.status, orders.count]
    sorts: [orders.created_month desc]
    limit: 500
    dynamic_fields: [{table_calculation: overall_running_total, label: Overall Running
          Total, expression: 'running_total(${orders.count})', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        table_calculation: running_total_by_status, label: Running Total by Status,
        expression: "if(\n  ${orders.status} = \"complete\", running_total(if(${orders.status}\
          \ = \"complete\", ${orders.count}, null)),\n    \n    if(${orders.status}\
          \ = \"cancelled\",running_total(if(${orders.status} = \"cancelled\", ${orders.count},\
          \ null)),\n      \n      if(${orders.status} = \"pending\",running_total(if(${orders.status}\
          \ = \"pending\", ${orders.count}, null)),null)\n))", value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        table_calculation: calculation_3, label: Calculation 3, expression: 'sum(offset_list(${orders.count},
          -1 * (row() - ${group_start_row}), row() - ${group_start_row} + 1))', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, _type_hint: number}, {
        table_calculation: group_start_row, label: Group Start Row, expression: 'match(${orders.status},
          ${orders.status})', value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: number}, {table_calculation: next_group_start_row,
        label: Next Group Start Row, expression: 'count(${orders.status}) - match(${orders.status},
          offset(${orders.status}, count(${orders.status}) - row()*2 + 1)) + 2', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: dimension, _type_hint: number}]
    listen:
      Status: products.category
    row: 6
    col: 8
    width: 8
    height: 6
  filters:
  - name: Untitled Filter
    title: Untitled Filter
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: e_commerce
    explore: order_items
    listens_to_filters: []
    field: orders.date_picker
  - name: Status
    title: Status
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: e_commerce
    explore: orders
    listens_to_filters: []
    field: orders.status
