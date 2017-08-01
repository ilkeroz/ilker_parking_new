view: occ_report_drill_down_site {
  derived_table: {
    sql: SELECT avg(occpercent) as occpercent,date_parse(enddt,'%Y-%m-%d %H:%i:%s') as enddate,siteid
          FROM dwh_aggregation_parking_spot
          WHERE startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
          GROUP BY enddt,siteid
          ORDER BY enddt
       ;;
  }

  suggestions: no

  dimension: occpercent {
    type: number
    value_format: "##\%"
   # drill_fields: [zoneid]
    sql: ${TABLE}.occpercent ;;
  }

  dimension_group: enddate {
    type: time
  #  drill_fields: [zoneid]
    sql: ${TABLE}.enddate ;;
  }

  dimension: siteid {
    type: string
    primary_key: yes
  #  drill_fields: [zoneid]
    sql: ${TABLE}.siteid ;;
  }

  measure: avg_occpercentZone {
    type: average
    value_format: "##\%"
    label: "Average Occupancy Zone"
    drill_fields: [occpercentSiteDetail*]
    sql: ${occpercent} ;;
  }

  set: occpercentSiteDetail {
    fields: [
      avg_occpercentZone,
      enddate_time,
      occ_report_drill_down_zone.zoneid
    ]
  }

}
