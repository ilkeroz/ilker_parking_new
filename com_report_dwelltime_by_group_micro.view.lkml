view: com_report_dwelltime_by_group {
  derived_table: {
    sql: select
          group_level.avgdwelltime as groupAvgDwelltime,
          group_level.mindwelltime as groupMinDwelltime,
          group_level.maxdwelltime as groupMaxDwelltime,
          group_level.mediandwelltime as groupMedianDwelltime,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          group_level.parkinggroupid as parkingGroupId,
          group_level.parkinggroupname as parkingGroupName,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(group_level.endtime,'%Y-%m-%d %H:%i:%s') as endTime
          from hive.dwh_qastage1.agg_report_group_level_micro group_level
          order by starttime DESC
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

  dimension: siteName_hidden {
    description: "Site Name"
    type: string
    hidden: yes
    sql: ${TABLE}.siteName ;;
  }

  dimension: parkingGroupId_hidden {
    description: "Parking Group Id"
    type: string
    hidden: yes
    sql: ${TABLE}.parkingGroupName ;;
  }

  dimension: parkingGroupId {
    description: "Parking Group Id"
    type: string
    sql: ${TABLE}.parkingGroupId ;;
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

  dimension: groupAvgDwelltime {
    description: "Group Avg Dwell Time"
    type: number
    sql: ${TABLE}.groupAvgDwelltime  ;;

  }

  filter: Statistics {
    label: "Statistics"
    suggestions: ["Minimum","Maximum","Average"]
  }

  measure: DwellTime {
    type: number
    description: "Dwell Time"
    value_format: "0.00"
    sql: CASE WHEN {% condition Statistics %} 'Average' {% endcondition %} THEN ${com_report_dwelltime_by_group.Avg_Group_Dwelltime}
      WHEN {% condition Statistics %} 'Minimum' {% endcondition %} THEN ${com_report_dwelltime_by_group.Min_Group_Dwelltime}
      WHEN {% condition Statistics %} 'Maximum' {% endcondition %} THEN ${com_report_dwelltime_by_group.Max_Group_Dwelltime}
      END ;;
    link: {
      label: "See Spots - Dwelltime on 15min interval"
      url: "/dashboards/125?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Time={{ endTime_time_time._value | url_encode }}+for+1+hour&Statistics={{_filters['com_report_dwelltime_by_group.Statistics']}}"
    }
  }

  measure: Avg_Group_Dwelltime {
    description: "Group Avg Dwell Time"
    type: average
    sql: ${groupAvgDwelltime} ;;
    value_format_name: decimal_2
  }


  dimension: groupMindwelltime {
    description: "Group Min Dwell Time"
    type: number
    sql: ${TABLE}.groupMindwelltime  ;;
  }

  measure: Min_Group_Dwelltime {
    description: "Group Min Dwell Time"
    type: min
    sql: ${groupMindwelltime} ;;
    value_format_name: decimal_2
  }

  dimension: groupMaxDwelltime {
    description: "Group Max Dwell Time"
    type: number
    sql: ${TABLE}.groupMaxDwelltime  ;;
  }

  measure: Max_Group_Dwelltime {
    description: "Group Max Dwell Time"
    type: max
    sql: ${groupMaxDwelltime} ;;
    value_format_name: decimal_2
  }

  dimension: groupMedianDwelltime {
    description: "Group Median Dwell Time"
    type: number
    sql: ${TABLE}.groupMedianDwelltime ;;
  }

  measure: Median_Group_Dwelltime {
    description: "Group Median Dwell Time"
    type: median
    sql: ${groupMedianDwelltime} ;;
    value_format_name: decimal_2
  }

}
