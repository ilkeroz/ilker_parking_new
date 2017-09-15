view: com_report_violations_revenue_by_space {
  derived_table: {
    sql: select
          parkingsiteid,
          parkingsitename,
          violationlist,
          violation,
          CAST(fine as DOUBLE) as violationrevenue,
          parkinggroupid,
          parkingspotid,
          date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime,
          date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime
          from hive.dwh_qastage2.agg_report_spot_level_micro_demo
          cross join UNNEST(violationlist) as t (space_violation)
          cross join UNNEST(split(space_violation.violationtype,'='),split(CAST(space_violation.fine as VARCHAR),'=')) as v (violation,fine)
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
    sql: ${TABLE}.starttime ;;
  }

  dimension_group: endTime {
    description: "End Time"
    type: time
    sql: ${TABLE}.endtime ;;
  }

  dimension: violationrevenue {
    description: "Violation"
    type: string
    sql: ${TABLE}.violationrevenue ;;
  }

  measure: Violation_Fine {
    type: sum
    sql:${violationrevenue};;
  }
}
