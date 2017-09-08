view: report_occupancy_by_group_and_interval {
  derived_table: {
    sql: select
          group_level.occupancy as groupAvgOccupancy,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          spot_level.occupancy as spotAvgOccupancy,
          spot_level.parkinggroupname as parkingGroupName,
          spot_level.parkinggroupid as parkingGroupId,
          spot_level.parkingspotid as parkingSpotId,
          spot_level.parkingspotname as parkingSpotName,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime

          from hive.dwh_qastage2.agg_report_group_level_micro_demo group_level
          inner join hive.dwh_qastage2.agg_report_spot_level_micro_demo spot_level
          on group_level.parkingsiteid = spot_level.parkingsiteid
          and group_level.parkinggroupid = spot_level.parkinggroupid
          and group_level.starttime = spot_level.starttime
          order by starttime ASC
      ;;
  }

  dimension: siteId {
    description: "Site ID"
    type: string
    sql: ${TABLE}.siteId ;;
  }

  dimension: siteName {
    description: "Site Name"
    type: string
    sql: ${TABLE}.siteName ;;
  }

  dimension: parkingGroupName {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.parkingGroupName ;;
  }

  dimension: parkingSpotName {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.parkingSpotName ;;
  }

  dimension: parkingSpotId {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.parkingSpotId ;;
  }

  dimension_group: startTime {
    description: "End Time"
    type: time
    sql: ${TABLE}.startTime ;;
  }

  measure: Avg_Occupancy {
    type: number
    description: "Avg Occupancy"
    sql: {% if report_occupancy_by_group_and_interval.parkingSpotName._is_filtered %}
            ${Avg_Spot_Occupancy}
         {% else %}
            ${Avg_Group_Occupancy}
         {% endif %} ;;
  }

  dimension: groupAvgOccupancy {
    description: "Group Avg Occupancy"
    type: number
    sql: ${TABLE}.groupAvgOccupancy ;;
  }

  measure: Avg_Group_Occupancy {
    description: "Group Avg Occupancy"
    type: average
    sql: ${groupAvgOccupancy} ;;
  }

  dimension: spotAvgOccupancy {
    description: "Spot Avg Occupancy"
    type: number
    sql: ${TABLE}.spotAvgOccupancy ;;
  }

  measure: Avg_Spot_Occupancy {
    description: "Spot Avg Occupancy"
    type: average
    sql: ${spotAvgOccupancy} ;;
  }

}
