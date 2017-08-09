view: realtime_parking {

  derived_table: {
    sql:
      SELECT parkingspotid,
             round((round(lat1,6)+round(lat2,6)+round(lat3,6)+round(lat4,6))/4, 6) as lat1,
             round((round(lng1,6)+round(lng2,6)+round(lng3,6)+round(lng4,6))/4, 6) as lng1,
             since,
             siteid,
             case occupancy when true then 1 else 0 end as occupancy_01
      FROM   hive.{{ _user_attributes['dwh_schema'] }}.dwh_parking_spot
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
