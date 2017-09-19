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
          date_parse(spot_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(spot_level.endtime,'%Y-%m-%d %H:%i:%s') as endTime

          from hive.dwh_qastage1.agg_report_spot_level_hourly spot_level
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

  dimension: siteName_hidden {
    description: "Site Name"
    type: string
    hidden: yes
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

  dimension: parkingGroupId_hidden {
    description: "Parking Group Id"
    type: string
    hidden: yes
    sql: ${TABLE}.parkingGroupName ;;
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

  dimension_group: endTime {
    description: "End Time"
    type: time
    sql: ${TABLE}.endTime ;;
  }

  measure: startTime_measure {
    description: "Start Time"
    type: string
    sql: ${startTime_time} ;;
  }

  measure: endTime_measure {
    description: "End Time"
    type: string
    sql: ${endTime_time};;
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
      # spots micro dashboard
      label: "See Spots - Occupancy on 15min interval"
      url: "/dashboards/137?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Space={{ parkingSpotId._value | url_encode}}&Starttime=after+{{ startTime_measure._value | url_encode }}&Endtime={{ startTime_measure._value | url_encode }}+for+1+hour"
    }
  }

}
