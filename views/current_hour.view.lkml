view: current_hour {
    derived_table: {
      publish_as_db_view: yes
      datagroup_trigger: danielle_every_hour
      indexes: ["current_hour"]
      sql: SELECT HOUR(NOW()) as current_hour
        ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: current_hour {
      type: number
      sql: ${TABLE}.current_hour ;;
    }

    set: detail {
      fields: [current_hour]
    }
  }
