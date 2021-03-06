view: com_report_violations_count_by_space {
  derived_table: {
    sql: select objectid,
          siteid,
          parkinggroupname,
          sitename,
          violationlist,
          violation,
          parkinggroupid,
          name,
          starttimestamp,
          endtimestamp,
          from_unixtime(starttimestamp/1000000) as startTime,
          from_unixtime(endtimestamp/1000000) as endTime
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

  dimension: parkinggroupname {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.parkinggroupname ;;
  }

  dimension: parkingspotid {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: violation {
    description: "Violation"
    type: string
    sql: ${TABLE}.violation ;;
  }

  dimension_group: endTime {
    description: "Time"
    type: time
    sql: ${TABLE}.endTime ;;
    timeframes: [minute15]
  }

  dimension_group: endTime_time {
    description: "Time"
    type: time
    sql: ${TABLE}.endTime ;;
  }

  measure: count {
    type: count
#     sql:${violation};;

  }
}
