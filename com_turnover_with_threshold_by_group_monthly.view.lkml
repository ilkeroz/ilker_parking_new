view: com_turnover_with_threshold_by_group_monthly {
  derived_table: {
    sql: SELECT objectid, siteid, sitename, parkinggroupid, parkinggroupname,
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
    description: "Turnover"
#     sql:${objectid};;
    link: {
      label: "See Spots - Turnover on weekly"
      url: "/dashboards/159?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{endTime_month._value | url_encode }}&Threshold={{_filters['com_turnover_with_threshold_by_group_monthly.duration'] }}"
    }
#     link: {
#       label: "See Spots - Turnover on monthly"
#       url: "/dashboards/158?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{endTime_month._value | url_encode }}&Threshold={{_filters['com_turnover_with_threshold_by_group_monthly.duration'] }}"
#     }
    link: {
      # group monthly dashboard
      label: "See Group - Turnover on weekly"
      url: "/dashboards/153?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{ endTime_month._value | url_encode }}&Threshold={{_filters['com_turnover_with_threshold_by_group_monthly.duration'] }}"
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
