view: com_report_dwelltime_by_space_hourly {
  derived_table: {
    sql: select
          spot_level.parkingsiteid as siteId,
          spot_level.parkingsitename as siteName,
          spot_level.avgdwelltime as spotAvgDwelltime,
          spot_level.mindwelltime as spotMindwelltime,
          spot_level.maxdwelltime as spotMaxdwelltime,
          spot_level.mediandwelltime as spotMediandwelltime,
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
    sql: ${TABLE}.parkingSpotName ;;
  }

#   dimension: parkingSpotId_hidden {
#     description: "Parking Spot Id"
#     type: string
#     sql: ${TABLE}.parkingSpotId ;;
#   }

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

  dimension: spotAvgDwelltime {
    description: "Spot Avg Dwell Time"
    type: number
    sql: ${TABLE}.spotAvgDwelltime  ;;
  }

  filter: Statistics {
    label: "Statistics"
    suggestions: ["Minimum","Maximum","Average"]
  }

  measure: DwellTime {
    type: number
    description: "Dwell Time"
    value_format: "0.00"
    sql: CASE WHEN {% condition Statistics %} 'Average' {% endcondition %} THEN ${com_report_dwelltime_by_space_hourly.Avg_Spot_Dwelltime}
      WHEN {% condition Statistics %} 'Minimum' {% endcondition %} THEN ${com_report_dwelltime_by_space_hourly.Min_Spot_Dwelltime}
      WHEN {% condition Statistics %} 'Maximum' {% endcondition %} THEN ${com_report_dwelltime_by_space_hourly.Max_Spot_Dwelltime}
      END ;;
#     link: {
#       # spots micro dashboard
#       label: "See Spots - Dwelltime on 15min interval"
#       url: "/dashboards/125?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Space={{ parkingSpotId._value | url_encode}}&Starttime=after+{{ startTime_measure._value | url_encode }}&Endtime={{ startTime_measure._value | url_encode }}+for+1+hour&Statistics={{_filters['com_report_dwelltime_by_space_hourly.Statistics']}}"
#     }
  }

  measure: Avg_Spot_Dwelltime {
    description: "Spot Avg Dwell Time"
    type: average
    sql: ${spotAvgDwelltime} ;;
    value_format_name: decimal_2
  }

  dimension: spotMinDwelltime {
    description: "Spot Min Dwell Time"
    type: number
    sql: ${TABLE}.spotMinDwelltime  ;;

  }

  measure: Min_Spot_Dwelltime {
    description: "Spot Min Dwell Time"
    type: min
    sql: ${spotMinDwelltime} ;;
    value_format_name: decimal_2
  }

  dimension: spotMaxDwelltime {
    description: "Spot Max Dwell Time"
    type: number
    sql: ${TABLE}.spotMaxDwelltime  ;;
  }

  measure: Max_Spot_Dwelltime {
    description: "Spot Avg Dwell Time"
    type: max
    sql: ${spotMaxDwelltime} ;;
    value_format_name: decimal_2
  }

  dimension: spotMedianDwelltime {
    description: "Spot Median Dwell Time"
    type: number
    sql: ${TABLE}.spotMedianDwelltime  ;;
  }

  measure: Median_Spot_Dwelltime {
    description: "Spot Median Dwell Time"
    type: median
    sql: ${spotMedianDwelltime} ;;
    value_format_name: decimal_2
  }

}
