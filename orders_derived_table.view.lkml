view: orders_derived_table {
    derived_table: {
      sql:
          SELECT
            users.city  AS "city",
            orders.created AS "created_at"
            COUNT(DISTINCT orders.id ) AS "count"
            COUNT(DISTINCT orders.user_id) AS "count_of_users"
          FROM public.order_items  AS order_items
          LEFT JOIN public.orders  AS orders ON order_items.order_id = orders.id
          LEFT JOIN public.users  AS users ON orders.user_id = users.id
          GROUP BY 1
          ORDER BY 2 DESC
            ;;
    }
    dimension: city {
      type: string
      sql: ${TABLE}.city ;;
    }
    dimension: orders_count {
      type: number
      sql: ${TABLE}.count ;;
    }

    dimension_group: created {
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
      sql: ${TABLE}.created_at ;;
    }

    measure: average_count {
      type: average
      sql: ${orders_count} ;;
    }

    measure: count_of_users_prior_qtr {
      type: count_distinct
      sql: ${TABLE}.count_of_users WHERE ${created_quarter}-1 ;;
    }
  }
