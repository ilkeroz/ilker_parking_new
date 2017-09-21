view: com_turnover_with_threshold_by_space_hourly {
  derived_table: {
    sql: SELECT distinct(objectid) as objectid, siteid, sitename, parkinggroupid, parkingspotid,
      date_diff('hour',from_unixtime(starttimestamp/1000000),from_unixtime(endtimestamp/1000000)) as duration,
      from_unixtime(starttimestamp/1000000)  as startTime,
      from_unixtime(endtimestamp/1000000)  as endTime
      FROM hive.dwh_qastage1.dwh_parking_spot_report
      where endtimestamp != 0 and objectid != ''
      order by startTime
 ;;
  }

  measure: count {
    type: count_distinct
    sql:${objectid};;
#     link: {
#       label: "See Spots - Turnover on hourly"
#       url: "/dashboards/144?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{startTime_time._value | url_encode }}&Duration={{_filters['com_turnover_with_threshold_by_group_hourly.duration'] }}"
#     }
    link: {
      # group monthly dashboard
      label: "See Group - Turnover on micro"
      url: "/dashboards/156?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{ endFullHour._value | url_encode }}+for+1+hour&Threshold={{_filters['com_turnover_with_threshold_by_group_day.duration'] }}"
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

  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: duration {
    type: number
    sql: ${TABLE}.duration ;;
  }

  dimension_group: startTime {
    type: time
    sql: ${TABLE}.startTime ;;
#     timeframes: [hour]
  }

  dimension_group: endTime {
    type: time
    sql: ${TABLE}.endTime ;;
#     timeframes: [hour]
  }

  dimension: startFullHour {
    description: "Time"
    type: string
    sql:CONCAT(${startTime_hour}, ':00:00')  ;;
  }

  dimension: endFullHour {
    description: "Time"
    type: string
    sql:CONCAT(${endTime_hour}, ':00:00')  ;;
  }

}
