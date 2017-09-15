view: com_report_occupancy_by_space_hourly {
  derived_table: {
    sql: select
          spot_level.parkingsiteid as siteId,
          spot_level.parkingsitename as siteName,
          spot_level.occupancy as spotOccupancy,
          spot_level.parkinggroupname as parkingGroupName,
          spot_level.parkinggroupid as parkingGroupId,
          spot_level.parkingspotid as parkingSpotId,
          spot_level.parkingspotname as parkingSpotName,
          date_parse(spot_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime

          from hive.dwh_qastage2.agg_report_spot_level_micro_hourly spot_level
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
    sql: ${TABLE}.parkingSpotId ;;
  }

  dimension_group: startTime {
    description: "Start Time"
    type: time
    sql: ${TABLE}.startTime ;;
  }

  dimension: spotOccupancy {
    type: number
    sql: ${TABLE}.spotOccupancy ;;
  }

  measure: Avg_Spot_Occupancy {
    description: "Spot Avg Occupancy"
    type: average
    sql: ${spotOccupancy} ;;
    link: {
      # group micro dashboard
      label: "See Spots - Dwelltime on 15min interval"
      url: "/dashboards/62?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Space={{ parkingSpotId_hidden._value | url_encode}}&starttime=after+{{ startTime_time._value | url_encode }}&endtime=before+{{ endTime_time._value | url_encode }},{{ endTime_time._value | url_encode }}"
    }
  }

}
