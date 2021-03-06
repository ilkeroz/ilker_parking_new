view: com_turnover_with_threshold_by_space_micro {
 derived_table: {
  sql: SELECT objectid, siteid, sitename, parkinggroupid, name, parkinggroupname,
      date_diff('hour',from_unixtime(starttimestamp/1000000),from_unixtime(endtimestamp/1000000)) as duration,
      from_unixtime(starttimestamp/1000000)  as startTime,
      from_unixtime(endtimestamp/1000000)  as endTime
      FROM hive.dwh_qastage1.dwh_parking_spot_report
      where endtimestamp != 0  and parkingspotid != ''
      order by startTime
 ;;
}

measure: count {
  type: count
#   sql:${objectid};;
#     link: {
#       label: "See Spots - Turnover on 15min interval"
#       url: "/dashboards/144?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{startTime_year._value | url_encode }}&Duration={{_filters['com_turnover_with_threshold_by_group_micro.duration'] }}"
#     }
}

dimension: objectid {
  type: string
  sql: ${TABLE}.objectid ;;
}

dimension: parkinggroupid {
  type: string
  sql: ${TABLE}.parkinggroupid ;;
}

 dimension: parkinggroupname {
    type: string
    sql: ${TABLE}.parkinggroupname ;;
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
    sql: ${TABLE}.name ;;
  }

dimension: duration {
  type: number
  sql: ${TABLE}.duration ;;
}

dimension_group: startTime {
  type: time
  sql: ${TABLE}.startTime ;;
  timeframes: [minute15]
}

dimension_group: endTime {
  type: time
  sql: ${TABLE}.endTime ;;
  timeframes: [minute15]
}

  dimension_group: endTime_time {
    type: time
    sql: ${TABLE}.endTime ;;
  }

}
