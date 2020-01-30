- dashboard: relative_date_filter_test
  title: Relative Date Filter Test
  layout: newspaper


  elements:
    - name: hello_world
      model: e_commerce
      explore: order_items
      type: looker_single_record
      fields: [orders.status, users.city, users.id, users.first_name, users.email, orders.count]
      filters:
        users.id: '4519'
        orders.created_date: 'last 365 Days'
