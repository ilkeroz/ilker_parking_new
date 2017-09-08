view: com_report_dwelltime_by_group {
  derived_table: {
    sql: select
          group_level.avgdwelltime as groupAvgDwelltime,
          group_level.mindwelltime as groupMinDwelltime,
          group_level.maxdwelltime as groupMaxDwelltime,
          group_level.medianfordwelltime as groupMedianDwelltime,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          group_level.parkinggroupid as parkingGroupId,
          group_level.parkinggroupname as parkingGroupName,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime
          from hive.dwh_qastage2.agg_report_group_level_micro_demo group_level
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

  dimension: siteName_hidden {
    description: "Site Name"
    type: string
    hidden: yes
    sql: ${TABLE}.siteName ;;
  }

  dimension: parkingGroupName_hidden {
    description: "Parking Group Name"
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
    sql: ${TABLE}.startTime ;;
  }

  dimension: groupAvgDwelltime {
    description: "Group Avg Dwell Time"
    type: number
    sql: ${TABLE}.groupAvgDwelltime / 600000 ;;
  }

  filter: Statistics {
    label: "Statistics"
    suggestions: ["Minimum","Maximum","Average"]
  }

  measure: DwellTime {
    type: number
    description: "Dwell Time"
    sql: CASE WHEN {% condition Statistics %} 'Average' {% endcondition %} THEN ${com_report_dwelltime_by_group.Avg_Group_Dwelltime}
      WHEN {% condition Statistics %} 'Minimum' {% endcondition %} THEN ${com_report_dwelltime_by_group.Min_Group_Dwelltime}
      WHEN {% condition Statistics %} 'Maximum' {% endcondition %} THEN ${com_report_dwelltime_by_group.Max_Group_Dwelltime}
      END ;;
    link: {
      label: "See Spots Dwelltime"
      url: "/dashboards/83?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupName_hidden._value | url_encode}}&Time={{_filters['com_report_dwelltime_by_group.startTime_time'] }}&Statistics={{_filters['com_report_dwelltime_by_group.Statistics']}}"
    }
  }

  measure: Avg_Group_Dwelltime {
    description: "Group Avg Dwell Time"
    type: average
    sql: ${groupAvgDwelltime} ;;
  }

  dimension: groupMindwelltime {
    description: "Group Min Dwell Time"
    type: number
    sql: ${TABLE}.groupMindwelltime / 600000 ;;
  }

  measure: Min_Group_Dwelltime {
    description: "Group Min Dwell Time"
    type: min
    sql: ${groupMindwelltime} ;;
  }

  dimension: groupMaxDwelltime {
    description: "Group Max Dwell Time"
    type: number
    sql: ${TABLE}.groupMaxDwelltime / 600000 ;;
  }

  measure: Max_Group_Dwelltime {
    description: "Group Max Dwell Time"
    type: max
    sql: ${groupMaxDwelltime} ;;
  }

  dimension: groupMedianDwelltime {
    description: "Group Median Dwell Time"
    type: number
    sql: ${TABLE}.groupMedianDwelltime / 600000 ;;
  }

  measure: Median_Group_Dwelltime {
    description: "Group Median Dwell Time"
    type: median
    sql: ${groupMedianDwelltime} ;;
  }

}
