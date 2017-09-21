view: com_turnover_with_threshold_by_group {
  derived_table: {
    sql: SELECT distinct(objectid) as objectid, siteid, sitename, parkinggroupid,
      date_diff('minute',from_unixtime(starttimestamp/1000000),from_unixtime(endtimestamp/1000000)) as duration,
      from_unixtime(starttimestamp/1000000)  as startTime,
      from_unixtime(endtimestamp/1000000)  as endTime
      FROM hive.dwh_qastage2.dwh_parking_spot_report
      order by startTime
 ;;
  }

  measure: count {
    description: "Turnover"
    type: count_distinct
    sql:${objectid};;
    link: {
      label: "See Spots Turnover"
      url: "/dashboards/85?Group={{ parkinggroupid_hidden._value | url_encode}}&Site={{sitename_hidden._value | url_encode }}&Time={{startTime_date._value | url_encode }}&Duration={{_filters['com_turnover_with_threshold_by_group.duration'] }}"
    }

  }

  dimension: objectid {
    type: string
    sql: ${TABLE}.objectid ;;
  }

  dimension: parkinggroupid {
    type: string
    sql: ${TABLE}.parkinggroupid ;;
  }

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: sitename_hidden {
    type: string
    hidden: yes
    sql: ${TABLE}.sitename ;;
  }

  dimension: sitename {
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: parkinggroupid_hidden {
    type: string
    hidden: yes
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
