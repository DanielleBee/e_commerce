view: orders {
  sql_table_name: demo_db.orders ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    type: number
#     hidden: yes
    sql: CAST(${TABLE}.user_id AS DECIMAL) ;;
  }

  dimension: test {
    type: string
    sql: "Test" ;;
  }

  dimension_group: created {
    type: time
    datatype: datetime
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year]
    sql: ${TABLE}.created_at;;
  }

  dimension: created_date_formatted {
    sql: ${created_date} ;;
    html: {{ rendered_value | date: "%B %d, %Y" }};;
  }

  dimension_group: created_tz_test {
    type: time
    sql: CONVERT_TZ(${created_raw}, 'UTC', 'Americas/New_York');;
    }

#   dimension_group: time_between_ordered_and_returned {
#     type: time
#     sql_start: ${TABLE}.created_raw ;;
#     sql_end: now();;
#   }


parameter: starting_date  {
  type: date
}

parameter: ending_date {
  type: date
}

# dimension: date_start_filtered {
#   type: yesno
#   sql: {% if orders.date_start._is_filtered and orders.date_end._is_filtered %}
#  ( ${created_date} >= {% parameter date_start %}
#   AND
#   ${created_date} < {% parameter date_end %})
#   {% else %}
#   1=1
#   {% endif %}
#   ;;
# }

# on the existing explore
# sql_always_where:
# if date start or date end is filtered, then logic else 1=1
# created date < parameter date_end and created date >= parameter date start ;;
#or a yesno dimension and in the sql parameter we have that logic

filter: point_in_time {
  type: date
#   sql: ({% condition point_in_time %} date_start {% endcondition %} >= ${created_date}
#        AND (
#        {% condition point_in_time %} date_end {% endcondition %} < order_items.returned_date
#        OR order_items.returned_date IS NULL
#        )
#        );;

}

filter: point_in_time2 {
  type: date
  sql:  ${created_date} >= {% date_start point_in_time2 %}
  AND
  ${created_date} < {% date_end point_in_time2 %} ;;
}

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: is_complete {
    type: yesno
    sql: ${status} = 'complete' ;;
  }

####### Date Parameters Test ###########
  parameter: date_picker {
  type: unquoted
#   allowed_value: {
#     label: "Before 2018"
#     value: "Before_2018"
#   }
#   allowed_value: {
#     label: "10 Months Ago"
#     value: "10_months_ago"
#     }
#     allowed_value: {
#       label: "Week to date"
#       value: "this_week"
#     }
  }

############# THIS YEAR LOGIC ##############

#   filter: date_filter {
#     type: date
#   }
#   dimension: this_year_logic {
#     group_label: "Test"
#     type: yesno
#     sql: {% condition date_filter %} ${created_date} {% endcondition %}
#       ;;
#   }
#   measure: count_this_year {
#     type: count
#     filters: {
#       field: this_year_logic
#       value: "yes"
#     }
#   }

############# LAST YEAR LOGIC ##############

#     dimension: last_year_logic {
#       type: yesno
#       sql: {% condition date_filter %} DATE_ADD (${created_date}, interval -1 year) {% endcondition %}
#         ;;
#     }
#     measure: count_last_year {
#       type: count
#       filters: {
#         field: last_year_logic
#         value: "yes"
#       }
#     }

dimension_group: interval_minus_1_year {
  type: time
  datatype: datetime
  timeframes: [
    raw,
    time,
    date,
    week,
    month,
    quarter,
    year
  ]
  sql: interval(${TABLE}.created_at,-1) ;;
}

####################
filter: date_filter_test {
  type: date
}
###################

  measure: most_recent_order {
    type: date
    sql: MAX(${created_date}) ;;
  }

  measure: first_order {
    type: date
    sql: MIN(CASE WHEN ${status} = "complete" THEN (${created_date}) END) ;;
  }

#comment

  measure: running_total_count {
    type: running_total
    sql: ${count} ;;
  }
#
#   measure: count_filtered_meas {
#     type: count
#     drill_fields: [created_date,count]
#     sql: ${id} ;;
#     filters:  {
#       field: order_items.count
#       value: ">1"
#     }
#     }

  measure: count_disinct_test {
    type: number
    sql: count(distinct ${id}) filter (where ${status}='cancelled') ;;
  }

  measure: count_distinct_cancelled_orders {
    type: count_distinct
    sql: ${id} ;;
    filters: {
      field: status
      value: "cancelled"
    }
  }


  measure: count {
    type: count
    drill_fields: [created_date,count]
    link: {
      label: "Drill Details"
      url: "
      {% assign vis_config = '{
        \"type\": \"looker_bar\",
        \"x_axis_gridlines\" : false,
        \"y_axis_gridlines\" : true,
        \"show_view_names\" : false,
        \"show_y_axis_labels\" : true,
        \"show_y_axis_ticks\" : true,
        \"show_x_axis_label\" : true,
        \"show_x_axis_ticks\" : true,
        \"y_axis_scale_mode\" : \"linear\",
        \"plot_size_by_field\" : false,
        \"x_axis_reversed\" : false,
        \"y_axis_reversed\" : false,
        \"y_axis_tick_density\" : \"default\",
        \"y_axis_tick_density_custom\" : 5,
        \"limit_displayed_rows\" : false,
        \"legend_position\" : \"center\",
        \"font_size\" : \"10px\",
        \"series_types\" : {},
        \"point_style\" : \"none\",
        \"show_value_labels\" : true,
        \"label_density\" : 25,
        \"label_color\" : \"#A0318C\",
        \"x_axis_scale\": \"auto\",
        \"y_axis_combined\" : true,
        \"ordering\" : \"none\",
        \"show_null_labels\" : false,
        \"show_totals_labels\" : false,
        \"show_silhouette\" : false,
        \"totals_color\" : \"#808080\",
        \"collection_id\" : \"9d1da669-a6b4-4a4f-8519-3ea8723b79b5\",
        \"palette_id\" : \"53f185d2-c73c-4aa7-9b3e-c56a440c3743\",
        \"series_colors\" : {
          \"orders.count\" : \"#74A09F\"
         }
      }' %}
      {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=vis,pik"
    }
  }

#         \"trellis\": \"\",
#         \"stacking: '\"\",
#         \"color_application\" : {
#           \"collection_id\" : 9d1da669-a6b4-4a4f-8519-3ea8723b79b5,
#           \"palette_id\" : 53f185d2-c73c-4aa7-9b3e-c56a440c3743
#         }

######################### Multiple Values Parameter / Templated Filter Test ###############
#   parameter: partner_id {
#     type: unquoted
#   }
#
#   parameter: time_value {
#     type: number
#   }
#
#   parameter: time_type {
#     type: unquoted
#     allowed_value: { value: "DAY" }
#     allowed_value: { value: "MONTH" }
#     allowed_value: { value: "YEAR" }
#   }
#
#
#   dimension: has_checkins_at_partnerX {
#     description: "Member has checked in at least once at a specified partner in the past 3 months"
#     type: yesno
#     sql:${id} IN (SELECT member_id
#                               FROM checkins
#                               WHERE location_id IN ({% parameter partner_id %})
#                               AND CAST(datetime as date) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL {% parameter time_value %} {% parameter time_type %})  AND CURRENT_DATE()) ;;
#   }
#
#   dimension: has_urbangym_checkins {
#     description: "Member has checked in at least once at an UrbanGym partner in the past 3 months"
#     type: yesno
#     sql:${id} IN (SELECT member_id
#                               FROM checkins
#                               WHERE location_id IN (540,578,621,652,1744,3630,3631,14472,15618,15619)
#                               AND CAST(datetime as date) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH)  AND CURRENT_DATE()) ;;
#   }

  filter: order_id_picker {
    type: string
  }

  parameter: time_value {
    type: number
  }

  parameter: time_type {
    type: unquoted
    allowed_value: { value: "DAY" }
    allowed_value: { value: "MONTH" }
    allowed_value: { value: "YEAR" }
  }


#   dimension: test_dimension {
# #     description: "Member has checked in at least once at a specified partner in the past 3 months"
#     type: yesno
#     sql:${id} IN (SELECT id
#                               FROM users
#                               WHERE {% condition order_id_picker %} orders.id {% endcondition %}
#                               AND CAST(${created_raw} as date) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL {% parameter time_value %} {% parameter time_type %})  AND CURRENT_DATE()) ;;
#   }


}
