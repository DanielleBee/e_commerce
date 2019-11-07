view: products {
  sql_table_name: demo_db.products ;;

##Parameters Session from Office Hours on August 22
  parameter: select_product_detail {
    type: unquoted
    default_value: "department"
    allowed_value: {
      value: "department"
      label: "Department"
    }
    allowed_value: {
      value: "category"
      label: "Category"
    }
    allowed_value: {
      value: "brand"
      label: "Brand"
    }
  }

  dimension: product_hierarchy {
    label_from_parameter: select_product_detail
    type: string
    sql: ${TABLE}.{{ select_product_detail._parameter_value }}
      ;;
  }

##OR WE CAN SET THE PARAMETER THIS WAY
  dimension: product_hierarchy_better {
    label_from_parameter: select_product_detail
    type: string
    sql:
    {% if select_product_detail._parameter_value == 'department' %}
      ${department}
    {% elsif select_product_detail._parameter_value == 'category' %}
      ${category}
    {% else %}
      ${brand}
    {% endif %} ;;
  }

##Templated Filter Examples:
  filter: choose_a_category_to_compare {
    type: string
    suggest_explore: products
    suggest_dimension: products.category
  }

  dimension: category_comparator {
    type: string
    sql:
        CASE
WHEN {% condition choose_a_category_to_compare %}
${category}
{% endcondition %}
THEN ${category}
          ELSE 'All Other Categories'
        END
        ;;
  }
##End of Office Hours Parameters & Templated Filters Example

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
    value_format_name: usd
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
    link: {
      label: "Google Search"
      url: "http://www.google.com/search?q={{ value }}+Clothing"
      icon_url: "http://google.com/favicon.ico"
    }
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  measure: count {
    label: "Number of Products"
    type: count
#     drill_fields: [
#       id,
#       retail_price,
#       sku,
#       department,
#       brand,
#       name,
#       category
#     ]
    link: {
      label: "Drill to Explore"
      url: "/explore/e_commerce/products?fields=products.brand,products.id,products.retail_price,products.sku&f[products.department]={{ _filters['products.department'] | url_encode }}&f[products.brand]={{products.brand._value}}"
    }
  }

measure: total_retail_price {
  type:  sum
  sql: ${TABLE}.retail_price ;;
}
}
