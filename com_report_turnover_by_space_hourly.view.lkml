view: com_report_turnover_by_space_hourly {
  derived_table: {
    sql: select
          spot_level.parkingsiteid as siteId,
          spot_level.parkingsitename as siteName,
          spot_level.turnover as spotTurnover,
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

  dimension_group: endTime {
    description: "End Time"
    type: time
    sql: ${TABLE}.endTime ;;
  }

  dimension: spotTurnover {
    type: number
    sql: ${TABLE}.spotTurnover ;;
  }

  measure: Avg_Spot_Turnover {
    description: "Spot Avg Turnover"
    type: average
    sql: ${spotTurnover} ;;
#     link: {
#       # group micro dashboard
#       label: "See Spots - Turnover on 15min interval"
#       url: "/dashboards/62?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Space={{ parkingSpotId_hidden._value | url_encode}}&starttime=after+{{ startTime_time._value | url_encode }}&endtime=before+{{ endTime_time._value | url_encode }},{{ endTime_time._value | url_encode }}"
#     }
  }

}
