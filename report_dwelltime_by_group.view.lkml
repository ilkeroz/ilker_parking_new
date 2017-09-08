view: report_dwelltime_by_group {
  derived_table: {
    sql: select
          group_level.avgdwelltime as groupAvgDwelltime,
          group_level.mindwelltime as groupMindwelltime,
          group_level.maxdwelltime as groupMaxdwelltime,
          group_level.medianfordwelltime as groupMediandwelltime,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          spot_level.avgdwelltime as spotAvgDwelltime,
          spot_level.mindwelltime as spotMindwelltime,
          spot_level.maxdwelltime as spotMaxdwelltime,
          spot_level.mediandwelltime as spotMediandwelltime,
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

  measure: Avg_DwellTime {
    type: number
    description: "Avg DwellTime"
    sql: {% if report_dwelltime_by_group.parkingSpotName._is_filtered %}
            ${Avg_Spot_Dwelltime}
         {% else %}
            ${Avg_Group_Dwelltime}
         {% endif %} ;;
  }

  measure: Min_DwellTime {
    type: number
    description: "Min DwellTime"
    sql: {% if report_dwelltime_by_group.parkingSpotName._is_filtered %}
            ${Min_Spot_Dwelltime}
         {% else %}
            ${Min_Group_Dwelltime}
         {% endif %} ;;
  }

  measure: Max_DwellTime {
    type: number
    description: "Max DwellTime"
    sql: {% if report_dwelltime_by_group.parkingSpotName._is_filtered %}
            ${Max_Spot_Dwelltime}
         {% else %}
            ${Max_Group_Dwelltime}
         {% endif %} ;;
  }

  measure: Median_DwellTime {
    type: number
    description: "Median DwellTime"
    sql: {% if report_dwelltime_by_group.parkingSpotName._is_filtered %}
            ${Median_Spot_Dwelltime}
         {% else %}
            ${Median_Group_Dwelltime}
         {% endif %} ;;
  }

  dimension: groupAvgDwelltime {
    description: "Group Avg Dwell Time"
    type: number
    sql: ${TABLE}.groupAvgDwelltime / 600000 ;;
  }

  measure: Avg_Group_Dwelltime {
    description: "Group Avg Dwell Time"
    type: average
    sql: ${groupAvgDwelltime} ;;
  }

  dimension: spotAvgDwelltime {
    description: "Spot Avg Dwell Time"
    type: number
    sql: ${TABLE}.spotAvgDwelltime / 600000 ;;
  }

  measure: Avg_Spot_Dwelltime {
    description: "Spot Avg Dwell Time"
    type: average
    sql: ${spotAvgDwelltime} ;;
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

  dimension: groupMedianDwelltime {
    description: "Group Median Dwell Time"
    type: number
    sql: ${TABLE}.groupMedianDwelltime / 600000 ;;
  }

  measure: Median_Group_Dwelltime {
    description: "Group Avg Dwell Time"
    type: median
    sql: ${groupMedianDwelltime} ;;
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
