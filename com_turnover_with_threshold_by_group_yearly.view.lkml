view: com_turnover_with_threshold_by_group_yearly {
  derived_table: {
    sql: SELECT objectid, siteid, sitename, parkinggroupid,
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
    link: {
      label: "See Spots - Turnover on monthly"
      url: "/dashboards/158?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{endTime_year._value | url_encode }}&Threshold={{_filters['com_turnover_with_threshold_by_group_yearly.duration'] }}"
    }
#     link: {
#       label: "See Spots - Turnover on yearly"
#       url: "/dashboards/157?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{endTime_year._value | url_encode }}&Threshold={{_filters['com_turnover_with_threshold_by_group_yearly.duration'] }}"
#     }
    link: {
      # group monthly dashboard
      label: "See Group - Turnover on monthly"
      url: "/dashboards/152?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{ endTime_year._value | url_encode }}&Threshold={{_filters['com_turnover_with_threshold_by_group_yearly.duration'] }}"
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
