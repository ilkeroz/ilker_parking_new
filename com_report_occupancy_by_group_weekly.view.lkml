view: com_report_occupancy_by_group_weekly {
  derived_table: {
    sql: select
          group_level.occupancy as groupAvgOccupancy,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          group_level.parkinggroupid as parkingGroupId,
          group_level.parkinggroupname as parkingGroupName,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime
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

  dimension: groupAvgOccupancy {
    description: "Group Avg Occupancy"
    type: number
    sql: ${TABLE}.groupAvgOccupancy ;;

  }

  measure: Occupancy {
    type: average
    description: "Occupancy"
    sql: ${groupAvgOccupancy};;
    link: {
      # spots day dashboard
      label: "See Spots - Dwelltime on daily"
      url: "/dashboards/134?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Time={{startTime_week._value | url_encode }}"
    }
    link: {
      # group hourly dashboard
      label: "See Group - Dwelltime on day"
      url: "/dashboards/129?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Time={{ startTime_week._value | url_encode }}+for+7+days"
    }
  }
}
