view: com_report_occupancy_by_space_monthly {
  derived_table: {
    sql: select
          spot_level.parkingsiteid as siteId,
          spot_level.parkingsitename as siteName,
          spot_level.occupancy as spotAvgOccupancy,
          spot_level.parkinggroupname as parkingGroupName,
          spot_level.parkinggroupid as parkingGroupId,
          spot_level.parkingspotid as parkingSpotId,
          spot_level.parkingspotname as parkingSpotName,
          date_parse(spot_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime

          from hive.dwh_qastage1.agg_report_spot_level_day spot_level
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

  dimension: siteName_hidden {
    description: "Site Name"
    type: string
    hidden: yes
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

  dimension: parkingGroupId {
    description: "Parking Group Id"
    type: string
    sql: ${TABLE}.parkingGroupId ;;
  }

  dimension: parkingGroupId_hidden {
    description: "Parking Group Id"
    type: string
    hidden: yes
    sql: ${TABLE}.parkingGroupName ;;
  }

  dimension: parkingSpotId {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.parkingSpotId ;;
  }

#   dimension: parkingSpotId_hidden {
#     description: "Parking Spot Id"
#     type: string
#     sql: ${TABLE}.parkingSpotId ;;
#   }

  dimension_group: startTime {
    description: "Start Time"
    type: time
    sql: ${TABLE}.startTime ;;
  }

  measure: startTime_measure {
    description: "Start Time"
    type: string
    sql: ${startTime_month} ;;
  }

  dimension: spotAvgOccupancy {
    description: "Spot Avg Occupancy"
    type: number
    sql: ${TABLE}.spotAvgOccupancy ;;
  }

  measure: Occupancy {
    type: average
    description: "Occupancy"
    value_format: "0.00"
    sql: ${spotAvgOccupancy} ;;
#     link: {
#       # spots weekly dashboard
#       label: "See Spots - Occupancy on weekly"
#       url: "/dashboards/134?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Space={{ parkingSpotId._value | url_encode}}&Time={{ startTime_measure._value | url_encode }}"
#     }
  }
}
