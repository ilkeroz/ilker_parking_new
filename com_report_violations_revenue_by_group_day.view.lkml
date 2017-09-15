view: com_report_violations_revenue_by_group_day {
derived_table: {
  sql: select
          parkingsiteid,
          parkingsitename,
          violationlist,
          violation,
          CAST(fine as DOUBLE) as violationrevenue,
          parkinggroupid,
          date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime,
          date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime
          from hive.dwh_qastage2.agg_report_group_level_day_demo
          cross join UNNEST(violationlist) as t (group_violation)
          cross join UNNEST(split(group_violation.violationtype,'='),split(CAST(group_violation.fine as VARCHAR),'=')) as v (violation,fine)
          where cardinality(violationlist) != 0
          order by starttime ASC
      ;;
}

dimension: siteid {
  description: "Site ID"
  type: string
  sql: ${TABLE}.parkingsiteid ;;
}

dimension: sitename {
  description: "Site Name"
  type: string
  sql: ${TABLE}.parkingsitename ;;
}

dimension: parkinggroupid {
  description: "Parking Group Id"
  type: string
  sql: ${TABLE}.parkinggroupid ;;
}

dimension: sitename_hidden {
  type: string
  hidden: yes
  sql: ${TABLE}.parkingsitename ;;
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

dimension: violationrevenue {
  description: "Violation"
  type: string
  sql: ${TABLE}.violationrevenue ;;
}

dimension_group: startTime {
  description: "Time"
  type: time
  sql: ${TABLE}.starttime ;;
}

dimension_group: endTime {
  description: "End Time"
  type: time
  sql: ${TABLE}.endtime ;;
}

measure: Violation_Revenue {
  type: sum
  sql:${violationrevenue};;
  link: {
    label: "See Spots Violations Revenue on 15min interval"
    url: "/dashboards/107?Group={{ parkinggroupid_hidden._value | url_encode}}&Site={{sitename_hidden._value | url_encode }}&Violation={{violation_hidden._value | url_encode}}&Starttime={{startTime_time._value | url_encode }}&Endtime={{ endTime_time._value | url_encode }}"
  }

  link: {
    # group hourly dashboard
    label: "See Group - Violations Revenue on hourly"
    url: "/dashboards/54?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Violation={{violation_hidden._value | url_encode}}&Time={{ startTime_date._value | url_encode }}"
  }

}

}
