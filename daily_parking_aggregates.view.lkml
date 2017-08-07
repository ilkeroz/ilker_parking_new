view: daily_parking_aggregates {

  derived_table: {
    sql:
      SELECT spot.siteid as siteid, spot.startday as startday, cust.name as customer_name, site.name as site_name,
             sum(spot.turnovers) as daily_turnovers,
             sum(spot.occduration/(1000000*60)) / case when sum(spot.turnovers)=0 then 1 else sum(spot.turnovers) end as daily_parking_minutes
      FROM   hive.{{ _user_attributes['platform'] }}.dwh_aggregation_parking_spot spot
      JOIN   hive.{{ _user_attributes['platform'] }}.dwh_site site ON site.siteid = spot.siteid
      JOIN   hive.{{ _user_attributes['platform'] }}.dwh_customer cust ON cust.orgid = site.orgid
      WHERE  spot.startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
    and spot.parkingspotid != 'F95AA0C3-D486-4982-BFF9-DEFADAD1FEA0'
      GROUP BY spot.siteid, spot.startday, cust.name, site.name
      ;;
      sql_trigger_value: select date_format(current_timestamp,'%d') ;;
  }

  suggestions: yes

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: startday {
    type: string
    sql: ${TABLE}.startday ;;
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}.customer_name ;;
  }

  dimension: site_name {
    type: string
    sql: ${TABLE}.site_name ;;
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
    sql: ${daily_turnovers} ;;
  }

  measure: avg_parking_minutes {
    type: average
    sql: ${daily_parking_minutes} ;;
  }

}
