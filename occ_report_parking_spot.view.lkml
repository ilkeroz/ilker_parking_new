view: occ_report_parking_spot {
  derived_table: {
    sql: SELECT avg(occpercent) as occpercent,date_parse(enddt,'%Y-%m-%d %H:%i:%s') as enddate,parkingspotid
          FROM hive.dwh_netsensenext.dwh_aggregation_parking_spot
          WHERE startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
          GROUP BY enddt,parkingspotid
          ORDER BY enddt
       ;;
  }

  suggestions: no

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: occpercent {
    type: number
    value_format: "##\%"
    sql: ${TABLE}.occpercent ;;
  }



  dimension_group: enddate {
    type: time
    sql: ${TABLE}.enddate ;;
  }

  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  set: detail {
    fields: [
      occpercent,
      parkingspotid,
      enddate_time

    ]
  }
}
