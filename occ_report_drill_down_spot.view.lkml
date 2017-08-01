view: occ_report_drill_down_spot {
  derived_table: {
    sql: SELECT avg(occpercent) as occpercent,date_parse(enddt,'%Y-%m-%d %H:%i:%s') as enddate,siteid,zoneid,parkingspotid
          FROM dwh_aggregation_parking_spot
          WHERE startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
          GROUP BY enddt,siteid,zoneid,parkingspotid
          ORDER BY enddt
       ;;
  }

  suggestions: no

  dimension: occpercent {
    type: number
    value_format: "##\%"
    sql: ${TABLE}.occpercent ;;
  }

  dimension_group: enddate {
    type: time
    drill_fields: [parkingspotid]
    sql: ${TABLE}.enddate ;;
  }

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: zoneid {
    type: string
    drill_fields: [parkingspotid]
    sql: ${TABLE}.zoneid ;;
  }

  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  measure: avg_occpercentSpot {
    type: average
    value_format: "##\%"
    label: "Average Occupancy Spot"
    drill_fields: [occpercentSpotDetail*]
    sql: ${occpercent} ;;
  }

  set: occpercentSpotDetail {
    fields: [
      avg_occpercentSpot,
      enddate_time,
      parkingspotid
    ]
  }
}
