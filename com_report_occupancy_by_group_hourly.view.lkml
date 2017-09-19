view: com_report_occupancy_by_group_hourly {
  derived_table: {
    sql: select
          group_level.occupancy as groupOccupancy,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          group_level.parkinggroupid as parkingGroupId,
          group_level.parkinggroupname as parkingGroupName,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(group_level.endtime,'%Y-%m-%d %H:%i:%s') as endTime
          from hive.dwh_qastage1.agg_report_group_level_hourly group_level
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
    sql: ${TABLE}.startTime ;;
  }

  dimension_group: endTime {
    description: "End Time"
    type: time
    sql: ${TABLE}.endTime ;;
  }

  dimension: groupOccupancy {
    description: "Group Occupancy"
    type: number
    sql: ${TABLE}.groupOccupancy ;;
  }

  measure: Avg_Group_Occupancy {
    description: "Group Avg Occupancy"
    type: average
    sql: ${groupOccupancy} ;;
    link: {
      label: "See Spots - Occupancy on hourly"
      url: "/dashboards/136?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Starttime=after+{{startTime_time._value | url_encode }}&Endtime=before+{{ endTime_time._value | url_encode }},{{ endTime_time._value | url_encode }}"
    }
    link: {
      # group micro dashboard
      label: "See Group - Occupancy on 15min interval"
      url: "/dashboards/131?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Starttime=after+{{ startTime_time._value | url_encode }}&Endtime=before+{{ endTime_time._value | url_encode }},{{ endTime_time._value | url_encode }}"
    }
  }

}
