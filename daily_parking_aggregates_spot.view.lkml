view: daily_parking_aggregates_spot {

  derived_table: {
    sql:
      SELECT spot.siteid as siteid, spot.parkingspotid as spotid, spot.startday as startday,
             sum(spot.turnovers) as daily_turnovers,
             sum(spot.occduration/(1000000*60)) / case when sum(spot.turnovers)=0 then 1 else sum(spot.turnovers) end as daily_parking_minutes
      FROM   hive.{{ _user_attributes['platform'] }}.dwh_aggregation_parking_spot spot
      WHERE  spot.startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
    and spot.parkingspotid != 'F95AA0C3-D486-4982-BFF9-DEFADAD1FEA0'
      GROUP BY spot.siteid, spot.parkingspotid, spot.startday
      ;;
      sql_trigger_value: select date_format(current_timestamp,'%d') ;;
  }

  suggestions: yes

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: spotid {
    type: string
    label: "Spot Id"
    sql: ${TABLE}.spotid ;;
  }

  dimension: startday {
    type: string
    sql: ${TABLE}.startday ;;
  }

  dimension: daily_turnovers {
    type: number
    sql: ${TABLE}.daily_turnovers ;;
  }

  dimension: daily_parking_minutes {
    type: number
    sql: ${TABLE}.daily_parking_minutes ;;
  }

  dimension_group: time_details {
    type: time
    timeframes: []
    sql: date_parse(${TABLE}.startday,'%Y-%m-%d') ;;
  }

  measure: avg_turnovers {
    type: average
    label: "Avg Parked Vehicles per Day"
    value_format: "###"
    sql: ${daily_turnovers} ;;
  }

  measure: avg_parking_minutes {
    type: average
    label: "Avg Parking Duration Minutes"
    value_format: "###"
    sql: ${daily_parking_minutes} ;;
  }

  measure: sum_turnovers {
    type: sum
    label: "Total Parked Vehicles"
    value_format: "#####"
    sql: ${daily_turnovers} ;;
  }
}
