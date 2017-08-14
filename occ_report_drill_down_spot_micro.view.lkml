view: occ_report_drill_down_spot_micro {
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
        , date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime
        , occupancy as occupancy
      FROM hive.dwh_qastage2.agg_report_spot_level_micro
      ORDER BY endtime
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
  type: string
  sql: ${TABLE}.handicapped ;;
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
