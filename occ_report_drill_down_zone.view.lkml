view: occ_report_drill_down_zone {
  derived_table: {
    sql: SELECT avg(occpercent) as occpercentZone,date_parse(enddt,'%Y-%m-%d %H:%i:%s') as enddate,siteid,zoneid
          FROM dwh_aggregation_parking_spot
          WHERE startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
          GROUP BY enddt,siteid,zoneid
          ORDER BY enddt
       ;;
  }

  suggestions: no

  dimension: occpercent {
    type: number
    value_format: "##\%"
    drill_fields: [zoneid]
    sql: ${TABLE}.occpercent ;;
  }

  dimension_group: enddate {
    type: time
    drill_fields: [zoneid]
    sql: ${TABLE}.enddate ;;
  }

  dimension: siteid {
    type: string
    drill_fields: [zoneid]
    sql: ${TABLE}.siteid ;;
  }

  dimension: zoneid {
    type: string
    primary_key: yes
    sql: ${TABLE}.zoneid ;;
  }

  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  measure: avg_occpercentZone {
    type: average
    value_format: "##\%"
    label: "Average Occupancy Zone"
    drill_fields: [occpercentZoneDetail*]
    sql: ${occpercent} ;;
  }

  set: occpercentZoneDetail {
    fields: [
      occ_report_drill_down_spot.avg_occpercentSpot,
      enddate_time,
      occ_report_drill_down_spot.parkingspotid
    ]
  }

}
