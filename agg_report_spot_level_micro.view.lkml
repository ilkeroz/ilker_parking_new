view: agg_report_spot_level_micro {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
        siteid as siteid
        , sitename as sitename
        , parkinggroupid as parkinggroupid
        , parkinggroupname as parkinggroupname
        , parkingspotid as parkingspotid
        , parkingspotname as parkingspotname
        , formfactor as formfactor
        , handicapped as handicapped
        , vehicleType as typeofvehicle
        , date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
        , date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime
        , occupancy as occupancy
      FROM hive.dwh_qastage2.agg_report_spot_level_micro
      cross join UNNEST(typeovehicle) as t (vehicleType)
      ORDER BY starttime
      ;;
  }

  dimension: siteid {
    description: "Site Id"
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: sitename {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: parkinggroupid {
    description: "Parking Group Id"
    type: string
    sql: ${TABLE}.parkinggroupid ;;
  }

  dimension: parkinggroupname {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.parkinggroupname ;;
  }

  dimension: parkingspotid {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: parkingspotname {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.parkingspotname ;;
  }

  dimension: formfactor {
    description: "Form Factor"
    type: string
    sql: ${TABLE}.formfactor ;;
  }

  dimension: handicapped {
    description: "Handicapped"
    type: yesno
    sql: ${TABLE}.handicapped ;;
  }

  dimension: typeofvehicle {
    description: "Type of vehicle"
    type: string
    sql: ${TABLE}.typeofvehicle ;;
  }

  dimension_group: starttime {
    description: "Start Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension_group: endtime {
    description: "End Time"
    type: time
    sql: ${TABLE}.endtime ;;
  }

  measure: occupancy {
    description: "Occupancy"
    type: average
    sql: ${TABLE}.occupancy ;;
  }
}
