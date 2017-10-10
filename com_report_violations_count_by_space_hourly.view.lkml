view: com_report_violations_count_by_space_hourly {
  derived_table: {
    sql: select objectid,
          siteid,
          parkinggroupname,
          sitename,
          violationlist,
          violation,
          parkinggroupid,
          parkingspotid,
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
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: violation {
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
  measure: count {
    type: count
#     sql:${violation};;

  }
}
