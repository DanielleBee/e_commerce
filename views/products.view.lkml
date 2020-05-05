view: products {
  sql_table_name: demo_db.products ;;

############## PARAMETERS TEST FOR KHALIL - where if only one department selected on dashboard tile the other will show null

#parameter filter.  The dashboard filter of type: field will map to this field
  parameter: main_filter {
    description: "Parameter test to see if we can hide results of the value that's not selected"
    type: string
    allowed_value: {
      label: "SKU - 0001"
      value: "00014335f9fbc45859b87fb101a6b7ab"
    }
    allowed_value: {
      label: "SKU - 0955"
      value: "09557786d8d9d95a14605caa550d22c9"
    }
    allowed_value: {
      label: "SKU - 0001 & SKU - 0955"
      value: "Both"
    }
  }

# Sets of 2 dimensions, one for OES and another for OEI.  We use the liquid variable {{ main_filter._parameter_value  }} to insert the "value" from the Parameter Filter.  Then we do the opposite CASE WHEN condition for the duplicate dimension
  dimension: name_0001 {
    label: "name"
    type: string
    sql:  CASE WHEN  {{ main_filter._parameter_value  }} = '00014335f9fbc45859b87fb101a6b7ab' THEN ${name}
          WHEN {{ main_filter._parameter_value  }} = 'Both' Then ${name}
          ELSE NULL END
        ;;
  }
  dimension: name_0955 {
    label: "name"
    type: string
    sql:  CASE WHEN  {{ main_filter._parameter_value  }} = '09557786d8d9d95a14605caa550d22c9' THEN ${name}
          WHEN {{ main_filter._parameter_value  }} = 'Both' Then ${name}
          ELSE NULL END
        ;;
  }
  dimension: sku_0001 {
    label: "sku"
    type: string
    sql:  CASE WHEN  {{ main_filter._parameter_value  }} = '00014335f9fbc45859b87fb101a6b7ab' THEN ${sku}
          WHEN {{ main_filter._parameter_value  }} = 'Both' Then ${sku}
          ELSE NULL END
        ;;
  }
  dimension: sku_0955 {
    label: "sku"
    type: string
    sql:  CASE WHEN  {{ main_filter._parameter_value  }} = '09557786d8d9d95a14605caa550d22c9' THEN ${sku}
          WHEN {{ main_filter._parameter_value  }} = 'Both' Then ${sku}
          ELSE NULL END
        ;;
  }
################# End Parameters Test for Khalil ########################

##############  Parameters Session from Office Hours on August 22  ##################
  parameter: select_product_detail {
    description: "Product granularity with parameter set up with allowed values"
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

  dimension: product_hierarchy_2 {
    hidden: yes
    label_from_parameter: select_product_detail
    description: "To be used with the Select Product Detail parameter - {{ select_product_detail._parameter_value }} in sql"
    type: string
    sql: ${TABLE}.{{ select_product_detail._parameter_value }}
      ;;
  }

##OR WE CAN SET THE PARAMETER THIS WAY
  dimension: product_hierarchy {
    label_from_parameter: select_product_detail
    description: "To be used with the Select Product Detail parameter - conditional logic with liquid variables in the sql"
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
    description: "Templated filter example to compare one category vs all others"
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
############## End of Office Hours Parameters & Templated Filters Example #################

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
    }
#     link: {
#       label: "Google Search"
#       url: "http://www.google.com/search?q={{ value }}+Clothing"
#       icon_url: "http://google.com/favicon.ico"
#     }

  measure: brand_count {
    type: count_distinct
    sql: ${brand} ;;
  }

  dimension: name {
#     label: "Item Name"
    type: string
    sql: ${TABLE}.item_name ;;
    html:{{ value | newline_to_br  }};;
  }

  dimension: liquid_test_blank_first_line {
    type: string
    sql:
    CONCAT
    (CONCAT('\n', "-Category: ", ${category}, '\n'),
    CASE WHEN ${category} = "Accessories"
    THEN CONCAT("-Brand: ", ${brand}, '\n')
    ELSE '' END);;
    html:{{ value | newline_to_br  }};;
  }

  dimension: liquid_test_2 {
    type: string
    sql:
    CONCAT
    (CONCAT("-Category: ", ${category}, '\n'),
    CASE WHEN ${category} = "Accessories"
    THEN CONCAT("-Brand: ", ${brand}, '\n')
    ELSE '' END);;
    html:{{ value | newline_to_br  }};;
  }

  dimension: category {
    type: string
    sql: CONCAT(${TABLE}.category, " ", ${TABLE}.category, " ", ${TABLE}.category) ;;
    html: {% assign words = {{value}} | split: ' ' %}
{% assign numwords = 0 %}
{% for word in words %}
{{ word }}
{% assign numwords = numwords | plus: 1 %}
{% assign mod = numwords | modulo: 3 %}
{% if mod == 0 %}
<br>
{% endif %}
{% endfor %} ;;
  }

  measure: count {
    label: "Count of Products"
        drill_fields: [
      id,
      retail_price,
      sku,
      department,
      brand,
      name,
      category
    ]
    type: count
  }

  measure: count_with_link_param {
    type: count
    link: {
      label: "Drill to Explore"
      url: "/explore/e_commerce/products?fields=products.brand,products.id,products.retail_price,products.sku&f[products.department]={{ _filters['products.department'] | url_encode }}&f[products.brand]={{products.brand._value}}"
    }
  }

#     label: "Number of Products"

measure: total_retail_price {
  type:  sum
  sql: ${TABLE}.retail_price ;;
  value_format_name: usd_0
}
}
