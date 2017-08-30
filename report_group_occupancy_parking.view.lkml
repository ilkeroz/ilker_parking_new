view: report_group_occupancy_parking {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select group_level.occupancy as Group_Occupancy,
          group_level.minrevenue as Group_Min_Revenue,
          group_level.maxrevenue as Group_Max_Revenue,
          group_level.avgrevenue as Group_Avg_Revenue,
          group_level.medianforrevenue as Group_Median_Revenue,
          group_level.siteid as siteid,
          group_level.sitename as sitename,
          spot_level.occupancy as Spot_Occupancy,
          spot_level.minrevenue as Spot_Min_Revenue,
          spot_level.maxrevenue as Spot_Max_Revenue,
          spot_level.avgrevenue as Spot_Avg_Revenue,
          spot_level.medianforrevenue as Spot_Median_Revenue,
          spot_level.handicapped as handicapped,
          spot_level.formfactor as formfactor,
          vehicleType as typeofvehicle,
          spot_level.parkinggroupname as parkinggroupname,
          spot_level.parkinggroupid as parkinggroupid,
          spot_level.parkingspotname as parkingspotname,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as starttime

          from hive.dwh_qastage2.agg_report_group_level_day group_level
          inner join hive.dwh_qastage2.agg_report_spot_level_day spot_level
          cross join UNNEST(typeovehicle) as t (vehicleType)
          on group_level.siteid = spot_level.siteid
          and group_level.parkinggroupid = spot_level.parkinggroupid
          and group_level.starttime = spot_level.starttime
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

  filter: Metrics {
    label: "Metrics"
    suggestions: ["Occupancy","Revenue","Turnover"]
  }

  filter: Statistics {
    label: "Statistics"
    suggestions: ["Min","Max","Avg","Median"]
  }

#   measure: Occupancy {
#     type: number
#     description: "Occupancy"
#     sql: CASE WHEN {% condition Statistics %} 'Min' {% endcondition %} THEN ${report_group_occupancy_parking.Min_Group_Occupancy}
#     WHEN {% condition Statistics %} 'Max' {% endcondition %} THEN ${report_group_occupancy_parking.Max_Group_Occupancy}
#     WHEN {% condition Statistics %} 'Avg' {% endcondition %} THEN ${report_group_occupancy_parking.Avg_Group_Occupancy}
#     WHEN {% condition Statistics %} 'Median' {% endcondition %} THEN ${report_group_occupancy_parking.Median_Group_Occupancy}
#     END ;;
#   }

  dimension: Group_Occupancy {
    description: "Group Occupancy"
    type: number
    sql: ${TABLE}.Group_Occupancy ;;
  }

  dimension: Group_Min_Revenue {
    description: "Group Min Revenue"
    type: number
    sql: ${TABLE}.Group_Min_Revenue ;;
  }

  dimension: Group_Max_Revenue {
    description: "Group Max Revenue"
    type: number
    sql: ${TABLE}.Group_Max_Revenue ;;
  }

  dimension: Group_Avg_Revenue {
    description: "Group Avg Revenue"
    type: number
    sql: ${TABLE}.Group_Avg_Revenue ;;
  }

  dimension: Group_Median_Revenue {
    description: "Group Median Revenue"
    type: number
    sql: ${TABLE}.Group_Median_Revenue ;;
  }

  dimension: Spot_Occupancy {
    description: "Spot Occupancy"
    type: number
    sql: ${TABLE}.Spot_Occupancy ;;
  }

  dimension: Spot_Min_Revenue {
    description: "Spot Min Revenue"
    type: number
    sql: ${TABLE}.Spot_Min_Revenue ;;
  }

  dimension: Spot_Max_Revenue {
    description: "Spot Max Revenue"
    type: number
    sql: ${TABLE}.Spot_Max_Revenue ;;
  }

  dimension: Spot_Avg_Revenue {
    description: "Spot Avg Revenue"
    type: number
    sql: ${TABLE}.Spot_Avg_Revenue ;;
  }

  dimension: Spot_Median_Revenue {
    description: "Spot Median Revenue"
    type: number
    sql: ${TABLE}.Spot_Median_Revenue ;;
  }

  measure: Avg_Group_Occupancy {
    description: "Avg Group Occupancy"
    type: average
    sql: ${Group_Occupancy} ;;
  }

  measure: Min_Group_Occupancy {
    description: "Min Group Occupancy"
    type: min
    sql: ${Group_Occupancy} ;;
  }

  measure: Max_Group_Occupancy {
    description: "Max Group Occupancy"
    type: max
    sql: ${Group_Occupancy} ;;
  }

  measure: Median_Group_Occupancy {
    description: "Median Group Occupancy"
    type: median
    sql: ${Group_Occupancy} ;;
  }

#   measure: Avg_Spot_Occupancy {
#     description: "Spot Occupancy"
#     type: average
#     sql: ${Spot_Occupancy} ;;
#   }

#   measure: Min_Spot_Occupancy {
#     description: "Min Spot Occupancy"
#     type: min
#     sql: ${Spot_Occupancy} ;;
#   }
#
#   measure: Max_Spot_Occupancy {
#     description: "Max Spot Occupancy"
#     type: max
#     sql: ${Spot_Occupancy} ;;
#   }
#
#   measure: Median_Spot_Occupancy {
#     description: "Median Spot Occupancy"
#     type: median
#     sql: ${Spot_Occupancy} ;;
#   }
}
