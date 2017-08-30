view: report_group_level_day_parking {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select group_level.occupancy as Group_Occupancy,
    group_level.siteid as siteid,
    group_level.sitename as sitename,
    spot_level.occupancy as Spot_Occupancy,
    spot_level.handicapped as handicapped,
    spot_level.formfactor as formfactor,
    vehicleType as typeofvehicle,
    spot_level.parkinggroupname as parkinggroupname,
    spot_level.parkinggroupid as parkinggroupid,
    spot_level.parkingspotname as parkingspotname,
    date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as starttime

    from hive.dwh_qastage2.agg_report_group_level_day group_level
    inner join hive.dwh_qastage2.agg_report_spot_level_day spot_level
    cross join UNNEST(typeovehicle) as t (vehicleType)
    on group_level.siteid = spot_level.siteid
    and group_level.parkinggroupid = spot_level.parkinggroupid
    and group_level.starttime = spot_level.starttime
      ;;
  }

  dimension: siteid {
    description: "Site ID"
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: sitename {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: parkinggroupname {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.parkinggroupname ;;
  }

  dimension: parkingspotname {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.parkingspotname ;;
  }

  dimension_group: starttime {
    description: "End Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension:  handicapped{
    description: "Handicapped"
    type: yesno
    sql: ${TABLE}.handicapped;;
  }

  dimension: formfactor {
    description: "Form Factor"
    type: string
    sql: ${TABLE}.formfactor ;;
  }

  dimension: typeofvehicle {
    description: "Vehicle Type"
    type: string
    sql: ${TABLE}.typeofvehicle ;;
  }

  measure: Occupancy {
    type: number
    description: "Occupancy"
    sql: {% if report_group_level_day_parking.handicapped._is_filtered or report_group_level_day_parking.formfactor._is_filtered %}
            ${Avg_Spot_Occupancy}
         {% else %}
            ${Avg_Group_Occupancy}
         {% endif %} ;;
}

  dimension: Group_Occupancy {
    description: "Group Occupancy"
    type: number
    sql: ${TABLE}.Group_Occupancy ;;
  }

  dimension: Spot_Occupancy {
    description: "Spot Occupancy"
    type: number
    sql: ${TABLE}.Spot_Occupancy ;;
  }

  measure: Avg_Group_Occupancy {
    description: "Group Occupancy"
    type: average
    sql: ${Group_Occupancy} ;;
  }

  measure: Avg_Spot_Occupancy {
    description: "Spot Occupancy"
    type: average
    sql: ${Spot_Occupancy} ;;
  }
}
