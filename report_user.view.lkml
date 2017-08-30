view: report_user {

  # sql_table_name: hive.{{ _user_attributes['platform'] }}.tester ;;
  derived_table: {
    sql:
    select distinct s.*
    from   hive.{{ _user_attributes['platform'] }}.dwh_user s
    }

  dimension: userid {
    description: "User ID"
    type: string
    sql: ${TABLE}.userid ;;
  }

  dimension: orgid {
    description: "Org ID"
    type: string
    sql: ${TABLE}.orgid ;;
  }

  dimension: name {
    description: "Name"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: email {
    description: "Email"
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: roles {
    description: "Roles"
    type: string
    sql: ${TABLE}.roles ;;
  }

  dimension: created {
    description: "Created"
    type: string
    sql: ${TABLE}.created ;;
  }

  dimension: updated {
    description: "Updated"
    type: string
    sql: ${TABLE}.updated ;;
  }
}
