view: occ_report_zone {
  derived_table: {
    sql: SELECT avg(occpercent) as occpercent,date_parse(enddt,'%Y-%m-%d %H:%i:%s') as enddate,siteid,zoneid
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
    sql: ${TABLE}.occpercent ;;
  }

  measure: avg_occpercent {
    type: average
    value_format: "##\%"
    label: "Average Occupancy"
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

  dimension: zoneid {
    type: string
    sql: ${TABLE}.zoneid ;;
    link: {
      label: "See spots"
      url: "/dashboards/44?site={{value | uri_encode}}"
    }
  }

}
