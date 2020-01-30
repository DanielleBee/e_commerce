include: "users.view.lkml"

view: users_extended {
extends: [users]
dimension: age {
  sql: CASE WHEN ${TABLE}.age < 18 THEN null ELSE ${TABLE}.age END;;
}
}
