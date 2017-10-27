view: report_on_metrics_with_filters {

  derived_table: {
    sql:
    select spot_micro.occupancy as Occupancy,
          spot_micro.totalrevenue as Revenue,
          spot_micro.turnover as Turnover,
          spot_micro.vacancy as Vacancy,
          spot_micro.avgdwelltime as AvgDwelltime,
          spot_micro.mediandwelltime as MedianDwelltime,
          spot_micro.mindwelltime as MinDwelltime,
          spot_micro.maxdwelltime as MaxDwelltime,
          spot_micro.parkingsiteid as siteid,
          spot_micro.parkingsitename as sitename,
          spot_micro.handicap as handicapped,
          spot_micro.formfactor as formfactor,
          array_join(spot_micro.typeovehicle,',','NA') as typeofvehicle,
          spot_micro.reservation as reservation,
          spot_micro.businessuse as businessuse,
          spot_micro.howmetered as howmetered,
          array_join(spot_micro.areaoftype,',','NA') as areaoftype,
          spot_micro.parkinggroupname as groupname,
          spot_micro.parkinggroupid as groupid,
          spot_micro.parkingspotname as spotname,
          spot_micro.parkingspotid as spotid,
          date_parse(starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endTime
          ,"violation_count"
          from
        hive.dwh_qastage1.agg_report_spot_level_micro spot_micro
        left join (

        WITH com_report_violations_count_by_space AS (select objectid,
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
        )
        SELECT
        DATE_FORMAT(DATE_TRUNC('MINUTE', DATE_ADD('minute', -1 * minute((com_report_violations_count_by_space.endTime)) % 15, (com_report_violations_count_by_space.endTime))),'%Y-%m-%d %H:%i:%s') AS "endTime15",
        com_report_violations_count_by_space.siteid,
        com_report_violations_count_by_space.sitename,
        com_report_violations_count_by_space.parkinggroupid,
        com_report_violations_count_by_space.parkinggroupname,
        com_report_violations_count_by_space.parkingspotid,
        COUNT(*) AS "violation_count"
        FROM com_report_violations_count_by_space
        GROUP BY 1,2,3,4,5,6
        ORDER BY 1 ) spot_report
        on spot_micro.parkingsiteid = spot_report.siteid
        and spot_micro.parkinggroupid = spot_report.parkinggroupid
        and spot_micro.parkingspotid = spot_report.parkingspotid
        and spot_report.endTime15 = spot_micro.endTime
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
