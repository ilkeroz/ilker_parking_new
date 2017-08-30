view: report_metrics_with_filters {
  derived_table: {
    sql: select    avg(group_level.occupancy) as Group_Occupancy,
          avg(group_level.avgrevenue) as Group_Revenue,
          avg(group_level.turnover) as Group_Turnover,
          avg(group_level.vacancy) as Group_Vacancy,
          avg(group_level.avgdwelltime) as Group_Dwelltime,
          group_level.siteid as siteid,
          group_level.sitename as sitename,
          avg(spot_level.occupancy) as Spot_Occupancy,
          avg(spot_level.avgrevenue) as Spot_Revenue,
          avg(spot_level.turnover) as Spot_Turnover,
          avg(spot_level.vacancy) as Spot_Vacancy,
          avg(spot_level.avgdwelltime) as Spot_Dwelltime,
          spot_level.handicapped as handicapped,
          spot_level.formfactor as formfactor,
          vehicleType as typeofvehicle,
         avg(CAST(group_fine as DOUBLE)) as group_violationfees,
          group_violation as group_violation,
          avg(CAST(space_fine as DOUBLE)) as space_violationfees,
          --space_violation as space_violation,
          spot_level.parkinggroupname as parkinggroupname,
          spot_level.parkinggroupid as parkinggroupid,
          spot_level.parkingspotname as parkingspotname,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as starttime

          from hive.dwh_qastage2.agg_report_group_level_micro group_level
          cross join UNNEST(violationfinelist) as t (group_violationfine)
          cross join UNNEST(split(group_violationfine.violationtype,'='),split(CAST(group_violationfine.fine as VARCHAR),'=')) as v (group_violation,group_fine)
          inner join hive.dwh_qastage2.agg_report_spot_level_micro spot_level
          cross join UNNEST(violationfinelist) as t (space_violationfine)
          cross join UNNEST(split(space_violationfine.violationtype,'='),split(CAST(space_violationfine.fine as VARCHAR),'=')) as v (space_violation,space_fine)
          cross join UNNEST(typeovehicle) as t (vehicleType)
          on group_level.siteid = spot_level.siteid
          and group_level.parkinggroupid = spot_level.parkinggroupid
          and group_level.starttime = spot_level.starttime
          group by
          group_level.siteid,
          group_level.sitename,
          spot_level.handicapped,
          spot_level.formfactor,
          vehicleType,
          group_violation,
          --space_violation,
          spot_level.parkinggroupname,
          spot_level.parkinggroupid,
          spot_level.parkingspotname,
          group_level.starttime
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

  dimension: parkinggroupname {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.parkinggroupname ;;
  }

  dimension: parkingspotname {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.parkingspotname ;;
  }

  dimension_group: starttime {
    description: "End Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension:  handicapped{
    description: "Handicapped"
    type: yesno
    sql: ${TABLE}.handicapped;;
  }

  dimension: formfactor {
    description: "Form Factor"
    type: string
    sql: ${TABLE}.formfactor ;;
  }

  dimension: typeofvehicle {
    description: "Vehicle Type"
    type: string
    sql: ${TABLE}.typeofvehicle ;;
  }

  dimension: violation {
    description: "Violation"
    type: string
    sql: ${TABLE}.group_violation ;;
  }

  measure: Occupancy {
    type: number
    description: "Occupancy"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
      or report_metrics_with_filters.typeofvehicle._is_filtered or report_metrics_with_filters.violation._is_filtered %}
            ${Avg_Spot_Occupancy}
         {% else %}
            ${Avg_Group_Occupancy}
         {% endif %} ;;
  }

  measure: Revenue {
    type: number
    description: "Revenue"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
      or report_metrics_with_filters.typeofvehicle._is_filtered or report_metrics_with_filters.violation._is_filtered  %}
            ${Avg_Spot_Revenue}
         {% else %}
            ${Avg_Group_Revenue}
         {% endif %} ;;
  }

  measure: Turnover {
    type: number
    description: "Turnover"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
      or report_metrics_with_filters.typeofvehicle._is_filtered or report_metrics_with_filters.violation._is_filtered  %}
            ${Avg_Spot_Turnover}
         {% else %}
            ${Avg_Group_Turnover}
         {% endif %} ;;
  }

  measure: Vacancy {
    type: number
    description: "Vacancy"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
      or report_metrics_with_filters.typeofvehicle._is_filtered or report_metrics_with_filters.violation._is_filtered  %}
            ${Avg_Spot_Vacancy}
         {% else %}
            ${Avg_Group_Vacancy}
         {% endif %} ;;
  }

  measure: DwellTime{
    type: number
    description: "DwellTime"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
      or report_metrics_with_filters.typeofvehicle._is_filtered or report_metrics_with_filters.violation._is_filtered  %}
            ${Avg_Spot_Dwelltime}
         {% else %}
            ${Avg_Group_Dwelltime}
         {% endif %} ;;
  }

  measure: ViolationFees{
    type: number
    description: "Violation Fees"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
      or report_metrics_with_filters.typeofvehicle._is_filtered or report_metrics_with_filters.violation._is_filtered  %}
            ${Sum_Space_Violationfees}
         {% else %}
            ${Sum_Group_Violationfees}
         {% endif %} ;;
  }

  measure: ViolationsCount{
    type: number
    description: "Violations Count"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
      or report_metrics_with_filters.typeofvehicle._is_filtered or report_metrics_with_filters.violation._is_filtered  %}
            ${Number_Space_Violations}
         {% else %}
            ${Number_Group_Violations}
         {% endif %} ;;
  }

  dimension: Group_Occupancy {
    description: "Group Occupancy"
    type: number
    sql: ${TABLE}.Group_Occupancy ;;
  }

  dimension: Spot_Occupancy {
    description: "Spot Occupancy"
    type: number
    sql: ${TABLE}.Spot_Occupancy ;;
  }

  measure: Avg_Group_Occupancy {
    description: "Group Occupancy"
    type: average
    sql: ${Group_Occupancy} ;;
  }

  measure: Avg_Spot_Occupancy {
    description: "Spot Occupancy"
    type: average
    sql: ${Spot_Occupancy} ;;
  }

  dimension: Group_Revenue {
    description: "Group Revenue"
    type: number
    sql: ${TABLE}.Group_Revenue ;;
  }

  measure: Avg_Group_Revenue {
    description: "Group Revenue"
    type: average
    sql: ${Group_Revenue} ;;
  }

  dimension: Spot_Revenue {
    description: "Spot Revenue"
    type: number
    sql: ${TABLE}.Spot_Revenue ;;
  }

  measure: Avg_Spot_Revenue {
    description: "Spot Revenue"
    type: average
    sql: ${Spot_Revenue} ;;
  }

  dimension: Group_Turnover {
    description: "Group Turnover"
    type: number
    sql: ${TABLE}.Group_Turnover ;;
  }

  measure: Avg_Group_Turnover {
    description: "Group Turnover"
    type: average
    sql: ${Group_Turnover} ;;
  }

  dimension: Spot_Turnover {
    description: "Spot Turnover"
    type: number
    sql: ${TABLE}.Spot_Turnover ;;
  }

  measure: Avg_Spot_Turnover {
    description: "Spot Turnover"
    type: average
    sql: ${Spot_Turnover} ;;
  }

  dimension: Group_Vacancy {
    description: "Group Vacancy"
    type: number
    sql: ${TABLE}.Group_Vacancy ;;
  }

  measure: Avg_Group_Vacancy {
    description: "Group Vacancy"
    type: average
    sql: ${Group_Vacancy} ;;
  }

  dimension: Spot_Vacancy {
    description: "Spot Vacancy"
    type: number
    sql: ${TABLE}.Spot_Vacancy ;;
  }

  measure: Avg_Spot_Vacancy {
    description: "Spot Vacancy"
    type: average
    sql: ${Spot_Vacancy} ;;
  }

  dimension: Group_Dwelltime {
    description: "Group Dwell Time"
    type: number
    sql: ${TABLE}.Group_Dwelltime ;;
  }

  measure: Avg_Group_Dwelltime {
    description: "Group Dwell Time"
    type: average
    sql: ${Group_Dwelltime} ;;
  }

  dimension: Spot_Dwelltime {
    description: "Spot Dwell Time"
    type: number
    sql: ${TABLE}.Spot_Dwelltime ;;
  }

  measure: Avg_Spot_Dwelltime {
    description: "Spot Dwell Time"
    type: average
    sql: ${Spot_Dwelltime} ;;
  }

  dimension: Group_Violationfees {
    description: "Group Violation Fees"
    type: number
    sql: ${TABLE}.Group_Violationfees ;;
  }

  measure: Sum_Group_Violationfees {
    description: "Group Violation Fees"
    type: sum
    sql: ${Group_Violationfees} ;;
  }

  dimension: Space_Violationfees {
    description: "Space Violation Fees"
    type: number
    sql: ${TABLE}.Space_Violationfees ;;
  }

  measure: Sum_Space_Violationfees {
    description: "Space Violation Fees"
    type: sum
    sql: ${Space_Violationfees} ;;
  }

  dimension: Group_Violation {
    description: "Group Violation count"
    type: string
    sql: ${TABLE}.group_violation ;;
  }

  measure: Number_Group_Violations {
    description: "Group Violations count"
    type: count_distinct
    sql: ${Group_Violation} ;;
  }

  dimension: Space_Violation {
    description: "Space Violation count"
    type: string
    sql: ${TABLE}.space_violation ;;
  }

  measure: Number_Space_Violations {
    description: "Space Violations count"
    type: count_distinct
    sql: ${Space_Violation} ;;
  }

}
