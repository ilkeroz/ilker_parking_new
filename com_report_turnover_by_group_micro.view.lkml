view: com_report_turnover_by_group {
 derived_table: {
  sql: select
          group_level.turnover as groupTurnover,
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
  timeframes: [minute15]
  sql: ${TABLE}.startTime ;;
}

  dimension_group: endTime {
    description: "End Time"
    type: time
    timeframes: [minute15]
    sql: ${TABLE}.endTime ;;
  }

dimension: groupTurnover {
  description: "Group Turnover"
  type: number
  sql: ${TABLE}.groupTurnover ;;

}

measure: Group_Turnover {
  description: "Group Turnover"
  type: sum
  sql: ${groupTurnover} ;;
    link: {
      label: "See Spots - Turnover on 15min interval"
      url: "/dashboards/149?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Starttime=after+{{startTime_minute15._value | url_encode }}&Endtime=before+{{ endTime_minute15._value | url_encode }},{{ endTime_minute15._value | url_encode }}"
    }
}

}
