view: agg_report_spot {
  derived_table: {
    sql: SELECT DISTINCT(parkingspotid)
          , parkingspotname as parkingspotname
            FROM hive.dwh_qastage2.agg_report_spot_level_day
            ORDER BY parkingspotid
            ;;
  }

  dimension: parkingspotid {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.parkingspotid;;
  }

  dimension: parkingspotname {
    description: "Spot Name"
    type: string
    sql: ${TABLE}.parkingspotname ;;
    link: {
      label: "See daily occupancy %"
      url: "/dashboards/65?spot={{ parkingspotname._value | url_encode}}"
    }
  }
}
