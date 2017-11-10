view: com_report_violations_revenue_by_space {
  derived_table: {
    sql: select
          parkingsiteid,
          parkingsitename,
          violationlist,
          space_violation.violationtype as violationtype,
          CAST(space_violation.fine as DOUBLE) as violationrevenue,
          parkinggroupid,
          parkingspotid,
          date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime,
          date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime
          from hive.dwh_qastage1.agg_report_spot_level_micro
          cross join UNNEST(violationlist) as t (space_violation)
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
  dimension: violationtype {
    description: "Violation Type"
    type: string
    sql: ${TABLE}.violationtype ;;
  }
  dimension: violationrevenue {
    description: "Violation"
    type: number
    sql: ${TABLE}.violationrevenue ;;
  }

  measure: Violation_Fine {
    type: sum
    sql:${violationrevenue};;
  }
}
