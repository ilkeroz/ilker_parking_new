view: com_report_violations_count_by_group_hourly {
 derived_table: {
  sql: select objectid,
          siteid,
          sitename,
          violationlist,
          violation,
          parkinggroupid,
          starttimestamp,
          endtimestamp,
          from_unixtime(starttimestamp/1000000) as startTime,
          date_add('hour',1,from_unixtime(starttimestamp/1000000)) as endTime
          from hive.dwh_qastage2.dwh_parking_spot_report
          cross join UNNEST(violationlist) as t (group_violation)
          cross join UNNEST(split(group_violation.violationtype,'=')) as v (violation)
          where cardinality(violationlist) != 0
          order by starttime ASC
      ;;
}

dimension: siteid {
  description: "Site ID"
  type: string
  sql: ${TABLE}.siteid ;;
}

dimension: sitename {
  description: "Site Name"
  type: string
  sql: ${TABLE}.sitename ;;
}

dimension: parkinggroupid {
  description: "Parking Group Id"
  type: string
  sql: ${TABLE}.parkinggroupid ;;
}

dimension: sitename_hidden {
  type: string
  hidden: yes
  sql: ${TABLE}.sitename ;;
}

dimension: parkinggroupid_hidden {
  type: string
  hidden: yes
  sql: ${TABLE}.parkinggroupid ;;
}

dimension: violation {
  description: "Violation"
  type: string
  sql: ${TABLE}.violation ;;
}

dimension: violation_hidden {
  description: "Violation"
  type: string
  sql: ${TABLE}.violation ;;
}

dimension_group: startTime {
  description: "Time"
  type: time
  sql: ${TABLE}.startTime ;;
}

  dimension_group: endTime {
    description: "Time"
    type: time
    sql: ${TABLE}.endTime ;;
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

measure: count {
  type: count_distinct
  sql:${violation};;
#   link: {
#     label: "See Group Violations count on 15min interval"
#     url: "/dashboards/90?Group={{ parkinggroupid_hidden._value | url_encode}}&Site={{sitename_hidden._value | url_encode }}&Violation={{violation_hidden._value | url_encode}}&Starttime=after+{{startFullHour | url_encode}}&Endtime=before+{{endFullHour | url_encode}},{{endFullHour | url_encode}}"
#   }

}

}
