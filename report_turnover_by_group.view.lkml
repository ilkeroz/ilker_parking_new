view: report_turnover_by_group {
  derived_table: {
    sql: select
          group_level.turnover as groupTurnover,
          group_level.siteid as siteId,
          group_level.sitename as siteName,
          spot_level.turnover as spotTurnover,
          spot_level.parkinggroupname as parkingGroupName,
          spot_level.parkinggroupid as parkingGroupId,
          spot_level.parkingspotid as parkingSpotId,
          spot_level.parkingspotname as parkingSpotName,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime

          from hive.dwh_qastage2.agg_report_group_level_micro group_level
          inner join hive.dwh_qastage2.agg_report_spot_level_micro spot_level
          on group_level.siteid = spot_level.siteid
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

  dimension_group: startTime {
    description: "End Time"
    type: time
    sql: ${TABLE}.startTime ;;
  }

  measure: Turnover {
    type: number
    description: "Turnover"
    sql: {% if report_turnover_by_group.parkingSpotName._is_filtered %}
            ${Spot_Turnover}
         {% else %}
            ${Group_Turnover}
         {% endif %} ;;
  }

  dimension: groupTurnover {
    description: "Group Turnover"
    type: number
    sql: ${TABLE}.groupTurnover ;;
  }

  measure: Group_Turnover{
    description: "Group Turnover"
    type: sum
    sql: ${groupTurnover} ;;
  }

  dimension: spotTurnover {
    description: "Spot Turnover"
    type: number
    sql: ${TABLE}.spotTurnover ;;
  }

  measure: Spot_Turnover {
    description: "Spot Turnover"
    type: sum
    sql: ${spotTurnover} ;;
  }

}
