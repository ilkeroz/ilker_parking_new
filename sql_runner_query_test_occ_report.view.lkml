view: sql_runner_query_test_occ_report {
  derived_table: {
    sql: SELECT avg(occpercent),date_parse(enddt,'%Y-%m-%d %H:%i:%s') as enddate,siteid,parkingspotid,zoneid
          FROM hive.dwh_netsensenext.dwh_aggregation_parking_spot
          WHERE startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
          GROUP BY enddate
          ORDER BY enddate
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

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: zoneid {
    type: string
    sql: ${TABLE}.zoneid ;;
  }

  set: detail {
    fields: [
      occpercent,

      enddate_time,
      siteid,
      parkingspotid,
      zoneid
    ]
  }
}
