view: report_metrics_with_filters {
  derived_table: {
    sql: select group_level.occupancy as Group_Occupancy,
          group_level.avgrevenue as Group_Revenue,
          group_level.turnover as Group_Turnover,
          group_level.vacancy as Group_Vacancy,
          group_level.avgdwelltime as Group_Dwelltime,
          group_level.parkingsiteid as siteid,
          group_level.parkingsitename as sitename,
          spot_level.occupancy as Spot_Occupancy,
          spot_level.avgrevenue as Spot_Revenue,
          spot_level.turnover as Spot_Turnover,
          spot_level.vacancy as Spot_Vacancy,
          spot_level.avgdwelltime as Spot_Dwelltime,
          spot_level.handicap as handicapped,
          spot_level.formfactor as formfactor,
          --vehicleType as typeofvehicle,
          --violation as violation,
          spot_level.parkinggroupname as parkinggroupname,
          spot_level.parkinggroupid as parkinggroupid,
          spot_level.parkingspotname as parkingspotname,
          spot_level.parkingspotid as parkingspotid,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as starttime

          from hive.dwh_qastage2.agg_report_group_level_micro_demo group_level
          inner join hive.dwh_qastage2.agg_report_spot_level_micro_demo spot_level
          --cross join UNNEST(typeovehicle) as t (vehicleType)
          --cross join UNNEST(violationlist) as t (violationfine)
          --cross join UNNEST(split(violationfine.violationtype,'=')) as v (violation)
          on group_level.parkingsiteid = spot_level.parkingsiteid
          and group_level.parkinggroupid = spot_level.parkinggroupid
          and group_level.starttime = spot_level.starttime
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

  dimension: parkinggroupid {
    description: "Parking Group Id"
    type: string
    sql: ${TABLE}.parkinggroupid ;;
  }

  dimension: parkingspotname {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.parkingspotname ;;
  }

  dimension: parkingspotid {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.parkingspotid ;;
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

#   dimension: typeofvehicle {
#     description: "Vehicle Type"
#     type: string
#     sql: ${TABLE}.typeofvehicle ;;
#   }
#
#   dimension: violation {
#     description: "Violation"
#     type: string
#     sql: ${TABLE}.violation ;;
#   }

  measure: Occupancy {
    type: number
    description: "Occupancy"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered
       %}
            ${Avg_Spot_Occupancy}
         {% else %}
            ${Avg_Group_Occupancy}
         {% endif %} ;;
  }

  measure: Revenue {
    type: number
    description: "Revenue"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered %}
            ${Avg_Spot_Revenue}
         {% else %}
            ${Avg_Group_Revenue}
         {% endif %} ;;
  }

  measure: Turnover {
    type: number
    description: "Turnover"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered  %}
            ${Avg_Spot_Turnover}
         {% else %}
            ${Avg_Group_Turnover}
         {% endif %} ;;
  }

  measure: Vacancy {
    type: number
    description: "Vacancy"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered %}
            ${Avg_Spot_Vacancy}
         {% else %}
            ${Avg_Group_Vacancy}
         {% endif %} ;;
  }

  measure: DwellTime{
    type: number
    description: "DwellTime"
    sql: {% if report_metrics_with_filters.handicapped._is_filtered or report_metrics_with_filters.formfactor._is_filtered %}
            ${Avg_Spot_Dwelltime}
         {% else %}
            ${Avg_Group_Dwelltime}
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
    type: sum
    sql: ${Group_Turnover} ;;
  }

  dimension: Spot_Turnover {
    description: "Spot Turnover"
    type: number
    sql: ${TABLE}.Spot_Turnover ;;
  }

  measure: Avg_Spot_Turnover {
    description: "Spot Turnover"
    type: sum
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
    sql: ${TABLE}.Group_Dwelltime / 600000000 ;;
  }

  measure: Avg_Group_Dwelltime {
    description: "Group Dwell Time"
    type: average
    sql: ${Group_Dwelltime} ;;
  }

  dimension: Spot_Dwelltime {
    description: "Spot Dwell Time"
    type: number
    sql: ${TABLE}.Spot_Dwelltime / 600000000 ;;
  }

  measure: Avg_Spot_Dwelltime {
    description: "Spot Dwell Time"
    type: average
    sql: ${Spot_Dwelltime} ;;
  }

}
