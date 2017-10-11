view: com_turnover_with_threshold_by_group_hourly {
  derived_table: {
    sql: SELECT objectid, siteid, sitename, parkinggroupid,parkinggroupname,
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
      label: "See Spots - Turnover on 15min interval"
      url: "/dashboards/162?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupname_hidden._value | url_encode}}&Time={{endFullHour._value | url_encode }}+for+1+hour&Duration={{_filters['com_turnover_with_threshold_by_group_micro.duration'] }}"
    }
#     link: {
#       label: "See Spots - Turnover on hourly"
#       url: "/dashboards/161?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupid_hidden._value | url_encode}}&Time={{endFullHour._value | url_encode }}+for+1+hour&Threshold={{_filters['com_turnover_with_threshold_by_group_hourly.duration'] }}"
#     }
    link: {
      # group monthly dashboard
      label: "See Group - Turnover on 15min interval"
      url: "/dashboards/156?Site={{ sitename_hidden._value | url_encode}}&Group={{ parkinggroupname_hidden._value | url_encode}}&Time={{ endFullHour._value | url_encode }}+for+1+hour&Threshold={{_filters['com_turnover_with_threshold_by_group_hourly.duration'] }}"
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

  dimension: parkinggroupname_hidden {
    type: string
    hidden: yes
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
