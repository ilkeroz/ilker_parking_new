view: com_report_occupancy_by_group_hourly {
  derived_table: {
    sql: select
          group_level.occupancy as groupOccupancy,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          group_level.parkinggroupid as parkingGroupId,
          group_level.parkinggroupname as parkingGroupName,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime
          from hive.dwh_qastage2.agg_report_group_level_hourly_demo group_level
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
    sql: ${TABLE}.parkingGroupId ;;
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
      label: "See Spots - Occupancy"
      url: "/dashboards/102?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&starttime={{startTime_time._value | url_encode }}&endtime={{ endTime_time._value | url_encode }}"
    }
    link: {
      # group micro dashboard
      label: "See Group - Occupancy on 15min interval"
      url: "/dashboards/62?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&starttime=after+{{ startTime_time._value | url_encode }}&endtime=before+{{ endTime_time._value | url_encode }},{{ endTime_time._value | url_encode }}"
    }
  }

}
