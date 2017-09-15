view: com_report_dwelltime_by_space_monthly {
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
          date_parse(spot_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime

          from hive.dwh_qastage2.agg_report_spot_level_micro_demo spot_level
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

dimension: parkingGroupId_hidden {
  description: "Parking Group Id"
  type: string
  hidden: yes
  sql: ${TABLE}.parkingGroupId ;;
}

dimension: parkingSpotId {
  description: "Parking Spot Id"
  type: string
  sql: ${TABLE}.parkingSpotId ;;
}

dimension: parkingSpotId_hidden {
  description: "Parking Spot Id"
  type: string
  sql: ${TABLE}.parkingSpotId ;;
}

dimension_group: startTime {
  description: "Start Time"
  type: time
  sql: ${TABLE}.startTime ;;
}

dimension: spotAvgDwelltime {
  description: "Spot Avg Dwell Time"
  type: number
  sql: ${TABLE}.spotAvgDwelltime / 600000 ;;
}

filter: Statistics {
  label: "Statistics"
  suggestions: ["Minimum","Maximum","Average"]
}

measure: DwellTime {
  type: number
  description: "Dwell Time"
  value_format: "0.00"
  sql: CASE WHEN {% condition Statistics %} 'Average' {% endcondition %} THEN ${com_report_dwelltime_by_space_monthly.Avg_Spot_Dwelltime}
      WHEN {% condition Statistics %} 'Minimum' {% endcondition %} THEN ${com_report_dwelltime_by_space_monthly.Min_Spot_Dwelltime}
      WHEN {% condition Statistics %} 'Maximum' {% endcondition %} THEN ${com_report_dwelltime_by_space_monthly.Max_Spot_Dwelltime}
      END ;;
  link: {
    # group hourly dashboard
    label: "See Spots - Dwelltime on hourly"
    url: "/dashboards/54?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Space={{ parkingSpotId_hidden._value | url_encode}}&Time={{ startTime_date._value | url_encode }}&Statistics={{_filters['com_report_dwelltime_by_space_monthly.Statistics']}}"
  }
}

measure: Avg_Spot_Dwelltime {
  description: "Spot Avg Dwell Time"
  type: average
  sql: ${spotAvgDwelltime} ;;
}

dimension: spotMinDwelltime {
  description: "Spot Min Dwell Time"
  type: number
  sql: ${TABLE}.spotMinDwelltime / 600000 ;;

}

measure: Min_Spot_Dwelltime {
  description: "Spot Min Dwell Time"
  type: min
  sql: ${spotMinDwelltime} ;;
}

dimension: spotMaxDwelltime {
  description: "Spot Max Dwell Time"
  type: number
  sql: ${TABLE}.spotMaxDwelltime / 600000 ;;
}

measure: Max_Spot_Dwelltime {
  description: "Spot Avg Dwell Time"
  type: max
  sql: ${spotMaxDwelltime} ;;
}

dimension: spotMedianDwelltime {
  description: "Spot Median Dwell Time"
  type: number
  sql: ${TABLE}.spotMedianDwelltime / 600000 ;;
}

measure: Median_Spot_Dwelltime {
  description: "Spot Median Dwell Time"
  type: median
  sql: ${spotMedianDwelltime} ;;
}

}
