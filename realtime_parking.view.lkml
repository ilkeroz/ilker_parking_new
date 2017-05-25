view: realtime_parking {

  derived_table: {
    sql:
      SELECT parkingspotid,(lat1+lat2+lat3+lat4)/4 as lat1, (lng1+lng2+lng3+lng4)/4 as lng1, since, siteid,
             case occupancy when true then 1 else 0 end as occupancy_01
      FROM   dwh_parking_spot
      WHERE  lat1 != 0
      AND    lng1 != 0
      ;;
  }

  suggestions: yes

  dimension: parkingspotid {
    type: string
    label: "Spot Id"
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: lat1 {
    type: number
    sql: ${TABLE}.lat1 ;;
  }

  dimension: lng1 {
    type: number
    sql: ${TABLE}.lng1 ;;
  }

  dimension: occupancy_01 {
    type: number
    sql: ${TABLE}.occupancy_01 ;;
  }

  dimension: since {
    type: number
    sql: ${TABLE}.since ;;
  }

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: parked_event_location {
    type: location
    sql_latitude: ROUND(${lat1},8) ;;
    sql_longitude: ROUND(${lng1},8) ;;
  }

  measure: count_all {
    type: count_distinct
    sql: ${parkingspotid} ;;
  }

  measure: count_occupied {
    type: sum
    sql: ${occupancy_01} ;;
  }
}
