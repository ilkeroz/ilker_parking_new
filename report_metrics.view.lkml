view: report_metrics {
# Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
          siteid as siteid
        , sitename as sitename
        , parkinggroupid as parkinggroupid
        , parkinggroupname as parkinggroupname
        , parkingspotid as parkingspotid
        , parkingspotname as parkingspotname
        , date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
        , avg(occupancy) as occupancy
        , avg(avgrevenue) as revenue
        , sum(turnover) as turnover
        , avg(vacancy) as vacancy
        , avg(avgdwelltime) as dwelltime
        , violation as violation
        , count() as violationscount
      FROM hive.dwh_qastage2.agg_report_spot_level_micro
      cross join UNNEST(violationfinelist) as t (violationfine)
      cross join UNNEST(split(violationfine.violationtype,'=')) as v (violation)
      group by siteid,sitename,parkinggroupid,parkinggroupname,parkingspotid,parkingspotname,starttime,violation
      ORDER BY starttime
      ;;
  }

  dimension: siteid {
    description: "Site Id"
    type: string
    sql: ${TABLE}.siteid
      ;;
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
    description: "Parking Space Id"
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: parkingspotname {
    description: "Parking Space Name"
    type: string
    sql: ${TABLE}.parkingspotname ;;
  }

  dimension_group: starttime {
    description: "Start Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension: occupancy {
    description: "Occupancy"
    type: number
    sql: ${TABLE}.occupancy ;;
  }

  measure: Occupancy {
    description: "Occupancy"
    type: average
    sql: ${occupancy} ;;
  }

  dimension: revenue {
    description: "Revenue"
    type: number
    sql: ${TABLE}.revenue ;;
  }

  measure: Revenue {
    description: "Revenue"
    type: average
    sql: ${revenue} ;;
  }

  dimension: turnover {
    description: "Turnover"
    type: number
    sql: ${TABLE}.turnover ;;
  }

  measure: Turnover {
    description: "Turnover"
    type: sum
    sql: ${turnover} ;;
  }

  dimension: vacancy {
    description: "Vacancy"
    type: number
    sql: ${TABLE}.vacancy ;;
  }

  measure: Vacancy {
    description: "Vacancy"
    type: average
    sql: ${vacancy} ;;
  }

  dimension: dwelltime {
    description: "Dwell Time"
    type: number
    sql: ${TABLE}.dwelltime ;;
  }

  measure: DwellTime {
    description: "Dwell Time"
    type: average
    sql: ${dwelltime} ;;
  }

  dimension: violationscount {
    description: "Violations"
    type: number
    sql: ${TABLE}.violationscount ;;
  }

  measure: Violations {
    description: "Violations"
    type: count_distinct
    sql: ${violationscount} ;;
  }
}
