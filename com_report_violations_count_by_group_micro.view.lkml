view: com_report_violations_count_by_group {
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
          date_add('minute',15,from_unixtime(starttimestamp/1000000)) as endTime
          --,from_unixtime(endtimestamp/1000000) as endTime
          from hive.dwh_qastage1.dwh_parking_spot_report
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
     timeframes: [minute15]
    sql: ${TABLE}.startTime ;;
  }

  dimension_group: endTime {
    description: "Time"
    type: time
    timeframes: [minute15]
    sql: ${TABLE}.endTime ;;
  }

#   dimension_group: startTimeStamp {
#     description: "Time"
#     type: time
#     sql: ${TABLE}.startTimeStamp ;;
#   }



  measure: count {
    type: count
#     sql:${violation};;
    link: {
      label: "See Spots Violations count"
      url: "/dashboards/88?Group={{ parkinggroupid_hidden._value | url_encode}}&Site={{sitename_hidden._value | url_encode }}&Violation={{violation_hidden._value | url_encode}}&Time={{startTime__minute15._value | url_encode }}"
    }

  }

}
