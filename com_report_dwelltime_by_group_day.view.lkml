view: com_report_dwelltime_by_group_day {
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
          date_parse(group_level.endtime,'%Y-%m-%d %H:%i:%s') as startTime
          from hive.dwh_qastage1.agg_report_group_level_day group_level
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
    sql: ${TABLE}.startTime ;;
  }

  dimension: groupAvgDwelltime {
    description: "Group Avg Dwell Time"
    type: number
    sql: ${TABLE}.groupAvgDwelltime;;

  }

  filter: Statistics {
    label: "Statistics"
    suggestions: ["Minimum","Maximum","Average"]
  }

  measure: DwellTime {
    type: number
    description: "Dwell Time"
    value_format: "0.00"
    sql: CASE WHEN {% condition Statistics %} 'Average' {% endcondition %} THEN ${com_report_dwelltime_by_group_day.Avg_Group_Dwelltime}
      WHEN {% condition Statistics %} 'Minimum' {% endcondition %} THEN ${com_report_dwelltime_by_group_day.Min_Group_Dwelltime}
      WHEN {% condition Statistics %} 'Maximum' {% endcondition %} THEN ${com_report_dwelltime_by_group_day.Max_Group_Dwelltime}
      END ;;
    link: {
      # group hourly dashboard
      label: "See Spots - Dwelltime on hourly"
      url: "/dashboards/124?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Time={{ startTime_date._value | url_encode }}&Statistics={{_filters['com_report_dwelltime_by_group_day.Statistics']}}"
    }
#   link: {
#     # spots day dashboard
#     label: "See Spots - Dwelltime on daily"
#     url: "/dashboards/123?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Time={{startTime_date._value | url_encode }}&Statistics={{_filters['com_report_dwelltime_by_group_day.Statistics']}}"
#   }
    link: {
      # group hourly dashboard
      label: "See Group - Dwelltime on hourly"
      url: "/dashboards/117?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Time={{ startTime_date._value | url_encode }}&Statistics={{_filters['com_report_dwelltime_by_group_day.Statistics']}}"
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
    sql: ${TABLE}.groupMaxDwelltime ;;
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
