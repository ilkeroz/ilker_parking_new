view: occ_report_parking_site {
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
    sql: ${TABLE}.occpercent ;;
  }

  measure: avg_occpercent {
    type: average
    value_format: "##\%"
    label: "Average Occupancy"
    drill_fields: [siteid]
    sql: ${occpercent} ;;
  }

  dimension_group: enddate {
    type: time
    sql: ${TABLE}.enddate ;;
  }

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  set: detail {
    fields: [
      occpercent,
      siteid,
      enddate_time

    ]
  }
}
