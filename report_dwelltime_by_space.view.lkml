view: report_dwelltime_by_space {
  derived_table: {
    sql: SELECT
          parkingspotid as parkingspotid
        , parkingspotname as parkingspotname
        , date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
        , mindwelltime as mindwelltime
        , maxdwelltime as maxdwelltime
        , avgdwelltime as avgdwelltime
        , medianfordwelltime as medianfordwelltime
      FROM hive.dwh_qastage2.agg_report_spot_level_micro_demo
      ORDER BY starttime
      ;;
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
    description: "Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension: mindwelltime {
    description: "Min Dwell Time"
    type: number
    sql: ${TABLE}.mindwelltime ;;
  }

  measure: Min_Dwell_Time {
    description: "Min Dwell Time"
    type: min
    sql: ${mindwelltime} ;;
  }

  dimension: maxdwelltime {
    description: "Max Dwell Time"
    type: number
    sql: ${TABLE}.maxdwelltime ;;
  }

  measure: Max_Dwell_Time {
    description: "Max Dwell Time"
    type: max
    sql: ${maxdwelltime} ;;
  }

  dimension: avgdwelltime {
    description: "Avg Dwell Time"
    type: number
    sql: ${TABLE}.avgdwelltime ;;
  }

  measure: Avg_Dwell_Time {
    description: "Avg Dwell Time"
    type: average
    sql: ${TABLE}.avgdwelltime ;;
  }

  dimension: medianfordwelltime {
    description: "Median for Dwell Time"
    type: number
    sql: ${TABLE}.medianfordwelltime ;;
  }

  measure: Median_Dwell_Time {
    description: "Median for Dwell Time"
    type: median
    sql: ${medianfordwelltime} ;;
  }
}
