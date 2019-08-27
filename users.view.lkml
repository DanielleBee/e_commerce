  view: users {
    sql_table_name: public.users ;;

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
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

    dimension: first_name {
      type: string
      sql: ${TABLE}.first_name ;;
    }

    dimension: last_name {
      type: string
      sql: ${TABLE}.last_name ;;
    }

    dimension: full_name {
      type: string
      sql: ${first_name} || ' ' || ${last_name} ;;
    }

    dimension: city {
      type: string
      sql: ${TABLE}.city ;;
    }

    dimension: state {
      type: string
      sql: ${TABLE}.state ;;
    }

    dimension: zip {
      type: zipcode
      sql: ${TABLE}.zip ;;
    }

    dimension: country {
      type: string
      sql: ${TABLE}.country ;;
    }

    dimension: age {
      type: number
      sql: ${TABLE}.age ;;
    }

    dimension: age_tier {
      type: tier
      tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
      style: integer
      sql: ${age} ;;
    }

    dimension: gender {
      type: string
      sql: ${TABLE}.gender ;;
    }

    dimension: email {
      type: string
      sql: ${TABLE}.email ;;
    }

    dimension: traffic_source {
      type: string
      sql: ${TABLE}.traffic_source ;;
    }

##Templated Filter Example added as part of office hours
##hidden yes/no filter that will be helpful and more reproducible
    dimension: traffic_source_filter {
      hidden:  yes
      type:  yesno
      sql:  {% condition incoming_traffic_source %}
        ${traffic_source} {% endcondition %};;
    }

    filter:incoming_traffic_source {
      type: string
      suggest_dimension:
      users.traffic_source
      suggest_explore: users
    }

    measure: changeable_count_measure {
      type: count_distinct
      sql: ${id} ;;
      filters: {
        field: traffic_source_filter
        value: "Yes"
      }
    }
    ##potentially better than the measure defined above because it's a count
    ##vs a count distinct can save time on a dashboard loading
    measure: changeable_count_measure_better {
      type: count
      filters: {
        field: traffic_source_filter
        value: "Yes"
      }
    }
##end of what was added from office hours

    dimension: latitude {
      type: number
      sql: ${TABLE}.latitude ;;
    }

    dimension: longitude {
      type: number
      sql: ${TABLE}.longitude ;;
    }

    dimension: location {
      type: location
      sql_latitude: ${latitude} ;;
      sql_longitude: ${longitude} ;;
    }

    dimension: distance_from_distribution_center {
      type: distance
      start_location_field: distribution_centers.location
      end_location_field: users.location
      units: miles
    }

    measure: count {
      type: count
      drill_fields: [id, first_name, last_name]
    }

    measure: men_count {
      type: count
      filters: {
        field: gender
        value: "Male"
      }
    }

    measure: female_count {
      type: count
      filters: {
        field: gender
        value: "Female"
      }
    }
  }
