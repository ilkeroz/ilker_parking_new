view: report_on_metrics {
  derived_table: {
    sql:
    select spot_micro.occupancy as Occupancy,
      (case when cardinality(spot_micro.violationlist)>1 then spot_micro.totalrevenue/cast(cardinality(spot_micro.violationlist) as double) else totalrevenue end) as Revenue,
      (case when cardinality(spot_micro.violationlist)>1 then spot_micro.turnover/cast(cardinality(spot_micro.violationlist) as double) else turnover end) as Turnover,
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
          date_parse(spot_micro.starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(spot_micro.endtime,'%Y-%m-%d %H:%i:%s') as endTime,
          date_parse(spot_micro.currentbatch,'%Y-%m-%d') as currentbatch,
          "violationrevenue",
          "violationcount",
          "violationtype"
          from
        hive.dwh_qastage1.agg_report_spot_level_micro spot_micro
        left join (
        WITH com_report_violations_revenue_by_space AS (select
          parkingsiteid,
          parkingsitename,
          violationlist,
          space_violation.violationtype as violationtype,
          CAST(space_violation.fine as DOUBLE) as violationrevenue,
          space_violation.violationcount as violationcount,
          parkinggroupid,
          parkinggroupname,
          parkingspotid,
          parkingspotname,
          date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime,
          date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime,
          date_parse(currentbatch,'%Y-%m-%d') as currentbatch
          from hive.dwh_qastage1.agg_report_spot_level_micro
          cross join UNNEST(violationlist) as t (space_violation)
          order by starttime ASC
      )
        SELECT
        DATE_FORMAT((com_report_violations_revenue_by_space.endtime), '%Y-%m-%d %T') AS "endTime",
      com_report_violations_revenue_by_space.parkingsiteid as siteid,
      com_report_violations_revenue_by_space.parkingsitename as sitename,
      com_report_violations_revenue_by_space.parkinggroupid as parkinggroupid,
      com_report_violations_revenue_by_space.parkinggroupname as parkinggroupname,
      com_report_violations_revenue_by_space.parkingspotid as parkingspotid,
      com_report_violations_revenue_by_space.parkingspotname as parkingspotname,
      com_report_violations_revenue_by_space.violationtype as violationtype,
        COALESCE(SUM(com_report_violations_revenue_by_space.violationrevenue), 0) AS "violationrevenue",
        COALESCE(SUM(com_report_violations_revenue_by_space.violationcount), 0) AS "violationcount"
        FROM com_report_violations_revenue_by_space

        GROUP BY 1,2,3,4,5,6,7,8
        ORDER BY 1 DESC

        ) spot_report
        on spot_micro.parkingsiteid = spot_report.siteid
        and spot_micro.parkingsitename = spot_report.sitename
        and spot_micro.parkinggroupid = spot_report.parkinggroupid
        and spot_micro.parkinggroupname = spot_report.parkinggroupname
        and spot_micro.parkingspotid = spot_report.parkingspotid
        and spot_micro.parkingspotname = spot_report.parkingspotname
        and spot_report.endTime = spot_micro.endTime
          ;;
    sql_trigger_value: select case when date_format(current_timestamp,'%i') between '00' and '14' then '00' when date_format(current_timestamp,'%i') between '15' and '29' then '15' when date_format(current_timestamp,'%i') between '30' and '44' then '30' else '45' end ;;
  }

  dimension_group:  currentbatch{
    description: "Current Batch"
    type: time
    sql: ${TABLE}.currentbatch ;;
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
  measure: revenue_parking {
    type: sum
    description: "Revenue"
    value_format_name: decimal_2
    sql: ${Revenue} ;;
  }
  measure: revenue_total {
    type: number
    description: "Revenue"
    value_format_name: decimal_2
    sql: ${revenue_parking} + ${revenue_violations};;
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
    type: median
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
    type: min
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
    type: max
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
  dimension: violationtype {
    description: "Violation Type"
    type: string
    sql: ${TABLE}.violationtype ;;
  }
  dimension:  violationrevenue{
    type: number
    description: "violationrevenue"
    sql: ${TABLE}.violationrevenue ;;
  }
  measure: revenue_violations {
    type: sum
    description: "violationrevenue"
    value_format_name: decimal_2
    sql: ${violationrevenue} ;;
  }
  measure: violationfee_overstay {
    type: sum
    description: "violationrevenue"
    value_format_name: decimal_2
    sql: ${violationrevenue} ;;
    filters: {
      field: violationtype
      value: "max-time-exceeded"
    }
  }
  measure: violationfee_noparking {
    type: sum
    description: "violationrevenue"
    value_format_name: decimal_2
    sql: ${violationrevenue} ;;
    filters: {
      field: violationtype
      value: "no-parking"
    }
  }
  measure: violationfee_poorlyparked {
    type: sum
    description: "violationrevenue"
    value_format_name: decimal_2
    sql: ${violationrevenue} ;;
    filters: {
      field: violationtype
      value: "ppv"
    }
  }
  dimension:  violationcount{
    type: number
    description: "violationcount"
    sql: ${TABLE}.violationcount ;;
  }
  measure: violationcount_total {
    type: sum
    description: "violationcount"
    sql: ${violationcount} ;;
  }

  measure: violationcount_overstay {
    type: sum
    description: "violationcount"
    sql: ${violationcount} ;;
    filters: {
      field: violationtype
      value: "max-time-exceeded"
    }
  }
  measure: violationcount_noparking {
    type: sum
    description: "violationcount"
    sql: ${violationcount} ;;
    filters: {
      field: violationtype
      value: "no-parking"
    }
  }
  measure: violationcount_poorlyparked {
    type: sum
    description: "violationcount"
    sql: ${violationcount} ;;
    filters: {
      field: violationtype
      value: "ppv"
    }
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
    sql: EXTRACT(HOUR FROM ( ${TABLE}.endTime  AT TIME ZONE '{{ _query._query_timezone }}'))*60 +  EXTRACT(MINUTE FROM ( ${TABLE}.endTime  AT TIME ZONE '{{ _query._query_timezone }}')) ;;
    # sql: EXTRACT(HOUR FROM ${TABLE}.endTime)*60 +  EXTRACT(MINUTE FROM ${TABLE}.endTime);;
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
