view: com_turnover_with_threshold_by_space {
  derived_table: {
    sql: SELECT distinct(objectid) as objectid, siteid, sitename, parkingspotid,parkinggroupid,
      date_diff('hour',from_unixtime(starttimestamp/1000000),from_unixtime(endtimestamp/1000000)) as duration,
      from_unixtime(starttimestamp/1000000)  as startTime,
      from_unixtime(endtimestamp/1000000)  as endTime
      FROM hive.dwh_qastage2.dwh_parking_spot_report
      order by startTime
       ;;
  }

  measure: count {
    type: count_distinct
    sql: ${objectid} ;;
  }

  dimension: objectid {
    type: string
    sql: ${TABLE}.objectid ;;
  }

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: siteid_hidden {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: sitename {
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: parkinggroupid {
    type: string
    sql: ${TABLE}.parkinggroupid ;;
  }

  dimension: duration {
    type: number
    sql: ${TABLE}.duration ;;
  }

  dimension_group: startTime {
    type: time
    sql: ${TABLE}.startTime ;;
  }

  dimension_group: endTime {
    type: time
    sql: ${TABLE}.endTime ;;
  }

}
