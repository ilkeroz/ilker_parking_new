view: pavan_playground {
  derived_table: {
    sql: select
          group_level.occupancy as groupOccupancy,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          group_level.parkinggroupid as parkingGroupId,
          group_level.parkinggroupname as parkingGroupName,
          group_level.turnover as turnOver,
          group_level.avgdwelltime as avgDwellTime,
          group_level.totalrevenue as totalRevenue,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(group_level.endtime,'%Y-%m-%d %H:%i:%s') as endTime
          from hive.dwh_qastage1.agg_report_spot_level_micro group_level
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

  dimension: startTime {
    description: "Start Time"
    type :  date_time
    sql: ${TABLE}.startTime ;;
  }

  dimension: endTime {
    description: "End Time"
    type: date_time
    sql: ${TABLE}.endTime ;;
  }

  dimension: groupOccupancy {
    description: "Group Occupancy"
    type: number
    sql: ${TABLE}.groupOccupancy ;;

  }

  dimension: avgDwellTime {
    description: "Average Dwelltimer"
    type: number
    sql: ${TABLE}.avgDwellTime ;;

  }

  dimension: turnOver {
    description: "Turn Over"
    type: number
    sql: ${TABLE}.turnOver ;;

  }

  dimension: totalRevenue {
    description: "Total revenue"
    type: number
    sql: ${TABLE}.totalRevenue ;;

  }

  dimension: startTime_day {
    description: "Start time"
    type: date_day_of_week
    sql: ${TABLE}.startTime ;;

  }

  dimension: startTime_hour {
    description: "Start time hour"
    type: date_time_of_day
    sql: ${TABLE}.startTime ;;

  }

  measure: Sum_TurnOver {
    description: "Turnover sum"
    type: sum
    sql: ${turnOver} ;;

  }

  measure: Avg_DwellTime {
    description: "Average Dwelltime"
    type: average
    sql: ${avgDwellTime} ;;

  }

  measure: Sum_Revenue {
    description: "Revenue sum"
    type: sum
    sql: ${totalRevenue} ;;

  }
  measure: Avg_Group_Occupancy {
    description: "Group Avg Occupancy"
    type: average
    sql: ${groupOccupancy} ;;

  }

}
