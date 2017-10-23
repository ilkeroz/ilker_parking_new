view: pavan_playground {
  derived_table: {
    sql: select
          group_level.occupancy as groupOccupancy,
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
          group_level.parkinggroupid as parkingGroupId,
          group_level.parkinggroupname as groups,
          group_level.turnover as turnOver,
          group_level.avgdwelltime as dwelltime,
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

  dimension_group: startTime {
    convert_tz: no
    description: "Start Time"
    type :  time
    timeframes: [date,hour, time,time_of_day]
    sql: ${TABLE}.startTime ;;
  }

#   dimension_group: created {
#     #X# group_label:"Order Date"
#     type: time
#     timeframes: [time, time_of_day, hour, date, week, month, year, hour_of_day, day_of_week, month_num, raw, week_of_year, minute15]
#     sql: ${TABLE}.created_at ;;
#   }

  dimension: data_minute_index {
    type: number
    sql: EXTRACT(HOUR FROM ${TABLE}.startTime)*60 +  EXTRACT(MINUTE FROM ${TABLE}.startTime)
      ;;
  }

  filter: start_minute {
    type: string
  }

  dimension: start_minute_indexed {
    type: number
    sql: (CAST( SPLIT_PART({% parameter start_minute %},':',1) AS integer )*60) + (CAST ( SPLIT_PART({% parameter start_minute %},':',2) AS integer )) ;;
  }

  filter: end_minute {
    type: string
  }

  dimension: end_minute_indexed {
    type: number
    sql: (CAST( SPLIT_PART({% parameter end_minute %},':',1) AS integer )*60) + (CAST ( SPLIT_PART({% parameter end_minute %},':',2) AS integer )) ;;
  }


  dimension: greater_than_start {
    type: yesno
    sql:
          ${data_minute_index} >= ${start_minute_indexed}
          ;;
  }

  dimension: less_than_end {
    type: yesno
    sql:
          ${data_minute_index} <= ${end_minute_indexed}
          ;;
  }

#########

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

  dimension: dwelltime {
    description: "Average Dwelltimer"
    type: number
    sql: ${TABLE}.dwelltime ;;

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

#   dimension: startTime_hour {
#     description: "Start time hour"
#     type: date_time_of_day
#     sql: ${TABLE}.startTime ;;
#
#   }

  measure: Sum_TurnOver {
    description: "Turnover sum"
    type: sum
    sql: ${turnOver} ;;

  }

  measure: dwelltime_average {
    description: "Average Dwelltime"
    type: average
    sql: ${dwelltime} ;;

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
