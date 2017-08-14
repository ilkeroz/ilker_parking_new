view: agg_report_group {
  derived_table: {
    sql: SELECT DISTINCT(parkinggroupid)
          , parkinggroupname as parkinggroupname
            FROM hive.dwh_qastage2.agg_report_group_level_day
            ORDER BY parkinggroupid
            ;;
  }

  dimension: parkinggroupid {
    description: "Parking Group Id"
    type: string
    sql: ${TABLE}.parkinggroupid;;
  }

  dimension: parkinggroupname {
    description: "Group Name"
    type: string
    sql: ${TABLE}.parkinggroupname ;;
    link: {
      label: "See daily occupancy %"
      url: "/dashboards/53?group={{ parkinggroupname._value | url_encode}}"
    }
  }
}
