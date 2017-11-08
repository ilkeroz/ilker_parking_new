view: aggregated_metrics {

  derived_table: {
    sql:
    select
    vlist.violationtype as violationtype,
 vlist.fine,
 reportid,
 reportlevel,
 starttime,
 endtime,
 typeovehicle,
 handicap,
 formfactor,
 areaoftype,
 businessuse,
 howmetered,
 reservation,
 parkingspotid,
 parkinggroupid,
 parkingsiteid,
 parkingspotname,
 parkinggroupname,
 parkingsitename,
 violationlist,
 minrevenue,
 maxrevenue,
 avgrevenue,
 medianrevenue,
totalrevenue,
turnover,
 case when cardinality(violationlist)>1 then totalrevenue/cast(cardinality(violationlist) as double) else totalrevenue end as totalrevenue_new,
 case when cardinality(violationlist)>1 then turnover/cast(cardinality(violationlist) as double) else turnover end as turnover_new,
 vacancy,
 occupancy,
 occupancyinmin,
 mindwelltime,
 maxdwelltime,
 avgdwelltime,
 mediandwelltime,
 totaldwelltime,
 totalevents,
 spotcount,
 currentbatch
from hive.dwh_qastage1.agg_report_spot_level_micro
CROSS join UNNEST(violationlist) as vl (vlist)
;;
  }

  dimension_group:  startTime{
    description: "Start Time"
    type: time
    sql: ${TABLE}.startTime ;;
  }

  dimension_group:  endTime{
    description: "End Time"
    type: time
    allow_fill: yes
    sql: ${TABLE}.endTime ;;
  }
  dimension_group:  endTime{
    description: "End Time Minute 15"
    type: time
    timeframes: [minute15]
    allow_fill: yes
    sql: ${TABLE}.endTime ;;
  }
  dimension: Occupancy {
    type: number
    description: "Occupancy"
    sql: ${TABLE}.Occupancy ;;
  }
  measure: occupancy_average {
    type: average
    description: "Occupancy"
    value_format_name: decimal_2
    sql: ${Occupancy} ;;
  }
  dimension: Revenue {
    type: number
    description: "Revenue"
    sql: ${TABLE}.Revenue ;;
  }
  measure: revenue_total {
    type: sum
    description: "Revenue"
    value_format_name: decimal_2
    sql: ${Revenue} ;;
  }
  dimension: Turnover {
    type: number
    description: "Turnover"
    sql: ${TABLE}.Turnover ;;
  }
  measure: turnover_total {
    type: sum
    description: "Turnover"
    sql: ${Turnover} ;;
  }
  dimension: Vacancy {
    type: number
    description: "Vacancy"
    sql: ${TABLE}.Vacancy ;;
  }
  measure: vacancy_average {
    type: average
    description: "Vacancy"
    value_format_name: decimal_2
    sql: ${Vacancy} ;;
  }
  dimension: AvgDwelltime {
    type: number
    description: "AvgDwelltime"
    sql: ${TABLE}.AvgDwelltime ;;
  }
  measure: dwelltime_average {
    type: average
    description: "AvgDwelltime"
    value_format_name: decimal_2
    sql: ${AvgDwelltime} ;;
  }
  dimension: MedianDwelltime {
    type: number
    description: "MedianDwelltime"
    sql: ${TABLE}.MedianDwelltime ;;
  }
  measure: dwelltime_median {
    type: average
    description: "MedianDwelltime"
    value_format_name: decimal_2
    sql: ${MedianDwelltime} ;;
  }
  dimension: MinDwelltime {
    type: number
    description: "Min_Dwelltime"
    sql: ${TABLE}.MinDwelltime ;;
  }
  measure: dwelltime_min {
    type: average
    description: "MinDwelltime"
    value_format_name: decimal_2
    sql: ${MinDwelltime} ;;
  }
  dimension: MaxDwelltime {
    type: number
    description: "MaxDwelltime"
    sql: ${TABLE}.MaxDwelltime ;;
  }
  measure: dwelltime_max {
    type: average
    description: "MaxDwelltime"
    value_format_name: decimal_2
    sql: ${MaxDwelltime} ;;
  }
  dimension: violationtype {
    description: "Violation Type"
    type: string
    sql: ${TABLE}.violationtype ;;
  }
  dimension: siteid {
    description: "Site ID"
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: site_name {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: groups {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.groupname ;;
  }

  dimension: parkinggroupid {
    description: "Parking Group Id"
    type: string
    sql: ${TABLE}.groupid ;;
  }

  dimension: parkingspotname {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.spotname ;;
  }

  dimension: parkingspotid {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.spotid ;;
  }
  dimension: handicap {
    description: "Handicapped"
    type: yesno
    sql: ${TABLE}.handicapped;;
  }
  dimension: formfactor {
    description: "Form Factor"
    type: string
    sql: ${TABLE}.formfactor ;;
  }
  dimension:  violationCount{
    type: number
    description: "ViolationCount"
    sql: ${TABLE}.violation_count ;;
  }
  measure: violationcount_total {
    type: sum
    description: "ViolationCount"
    sql: ${violationCount} ;;
  }
  dimension: typeofvehicle {
    description: "VehicleType"
    type: string
    sql: ${TABLE}.typeofvehicle ;;
  }
  dimension: reservation {
    description: "Reservation"
    type: yesno
    sql: ${TABLE}.reservation;;
  }
  dimension: businessuse {
    description: "BusinessUse"
    type: string
    sql: ${TABLE}.businessuse ;;
  }
  dimension: howmetered {
    description: "HowMetered"
    type: string
    sql: ${TABLE}.howmetered ;;
  }
  dimension: areaoftype {
    description: "AreaType"
    type: string
    sql: ${TABLE}.areaoftype ;;
  }
  dimension: data_minute_index {
    type: number
    sql: EXTRACT(HOUR FROM ${TABLE}.endTime)*60 +  EXTRACT(MINUTE FROM ${TABLE}.endTime)
      ;;
  }

  filter: start_minute {
    type: string
  }

  dimension: start_minute_indexed {
    type: number
    sql: (CAST( SPLIT_PART({% parameter start_minute %},':',1) AS integer )*60) + (CAST ( SPLIT_PART({% parameter start_minute %},':',2) AS integer )) ;;
  }

  filter: end_minute {
    type: string
  }

  dimension: end_minute_indexed {
    type: number
    sql: (CAST( SPLIT_PART({% parameter end_minute %},':',1) AS integer )*60) + (CAST ( SPLIT_PART({% parameter end_minute %},':',2) AS integer )) ;;
  }


  dimension: greater_than_start {
    type: yesno
    sql:
          ${data_minute_index} >= ${start_minute_indexed}
          ;;
  }

  dimension: less_than_end {
    type: yesno
    sql:
          ${data_minute_index} <= ${end_minute_indexed}
          ;;
  }

}
