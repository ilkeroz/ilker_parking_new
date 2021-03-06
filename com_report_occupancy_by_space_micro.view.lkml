view: com_report_occupancy_by_space_micro {
derived_table: {
  sql: select
          spot_level.parkingsiteid as siteId,
          spot_level.parkingsitename as siteName,
          spot_level.occupancy as spotOccupancy,
          spot_level.parkinggroupname as parkingGroupName,
          spot_level.parkinggroupid as parkingGroupId,
          spot_level.parkingspotid as parkingSpotId,
          spot_level.parkingspotname as parkingSpotName,
          date_parse(spot_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(spot_level.endtime,'%Y-%m-%d %H:%i:%s') as endTime

          from hive.dwh_qastage1.agg_report_spot_level_micro spot_level
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

dimension: parkingGroupId {
  description: "Parking Group Id"
  type: string
  sql: ${TABLE}.parkingGroupId ;;
}

dimension: parkingSpotId {
  description: "Parking Spot Id"
  type: string
  sql: ${TABLE}.parkingSpotName ;;
}

dimension_group: startTime {
  description: "Start Time"
  type: time
  timeframes: [minute15]
  sql: ${TABLE}.startTime ;;
}

  dimension_group: startTime_time {
    description: "Start Time"
    type: time
    sql: ${TABLE}.startTime ;;
  }

  dimension_group: endTime {
    description: "End Time"
    type: time
    timeframes: [minute15]
    sql: ${TABLE}.endTime ;;
  }

  dimension_group: endTime_time {
    description: "End Time"
    type: time
    sql: ${TABLE}.endTime ;;
  }

dimension: spotOccupancy {
  type: number
  sql: ${TABLE}.spotOccupancy ;;
}

measure: Avg_Spot_Occupancy {
  description: "Spot Avg Occupancy"
  type: average
  sql: ${spotOccupancy} ;;
  value_format_name: decimal_2
}

}
