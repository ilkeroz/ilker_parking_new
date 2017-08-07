view: hourly_parking_aggregates {

  derived_table: {
    sql:
      select hist.siteid as siteid,
             hist.startday as startday,
             hist.weekday as weekday,
             hist.hour as hour,
             hist.hourly_occupancy_percent as hourly_occupancy_percent,
             hist.hourly_parked_vehicles as hourly_parked_vehicles,
             week.hourly_occupancy_percent as week_hourly_occupancy_percent
      from
      (
      SELECT siteid, startday,
             date_format(date_parse(startday,'%Y-%m-%d'), '%W') as weekday,
             substr(starthr, 12, 2) as hour,
             avg(case occpercent when 200 then 100 else occpercent end) as hourly_occupancy_percent,
             sum(turnovers) as hourly_parked_vehicles
      FROM   hive.{{ _user_attributes['platform'] }}.dwh_aggregation_parking_spot
      WHERE  startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
    and parkingspotid != 'F95AA0C3-D486-4982-BFF9-DEFADAD1FEA0'
      GROUP BY siteid, startday, starthr
      ) hist
      LEFT OUTER JOIN
      (
      SELECT siteid, startday,
             date_format(date_parse(startday,'%Y-%m-%d'), '%W') as weekday,
             substr(starthr, 12, 2) as hour,
             avg(case occpercent when 200 then 100 else occpercent end) as hourly_occupancy_percent
      FROM   hive.{{ _user_attributes['platform'] }}.dwh_aggregation_parking_spot
      WHERE  startday > date_format(date_add('day',-8,current_date), '%Y-%m-%d')
    and parkingspotid != 'F95AA0C3-D486-4982-BFF9-DEFADAD1FEA0'
      and    case date_format(date_parse(startday,'%Y-%m-%d'),'%W')
             when 'Monday' then 1
             when 'Tuesday' then 2
             when 'Wednesday' then 3
             when 'Thursday' then 4
             when 'Friday' then 5
             when 'Saturday' then 6
             when 'Sunday' then 7
             end
             <=
             case date_format(current_date,'%W')
             when 'Monday' then 1
             when 'Tuesday' then 2
             when 'Wednesday' then 3
             when 'Thursday' then 4
             when 'Friday' then 5
             when 'Saturday' then 6
             when 'Sunday' then 7
             end
      GROUP BY siteid, startday, starthr
      ) week
      ON     hist.siteid = week.siteid
      AND    hist.weekday = week.weekday
      AND    hist.hour = week.hour
      ORDER  By hist.siteid, hist.startday, hist.hour
      ;;
      sql_trigger_value: select date_format(current_timestamp,'%H') ;;
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

  dimension: weekday {
    type: string
    sql: ${TABLE}.weekday ;;
  }

  dimension: hour {
    type: string
    sql: ${TABLE}.hour ;;
  }

  dimension: hourly_occupancy_percent {
    type: number
    value_format: "##\%"
    sql: ${TABLE}.hourly_occupancy_percent ;;
  }

  dimension: hourly_parked_vehicles {
    type: number
    value_format: "###"
    sql: ${TABLE}.hourly_parked_vehicles ;;
  }

  dimension: week_hourly_occupancy_percent {
    type: number
    value_format: "##\%"
    sql: ${TABLE}.week_hourly_occupancy_percent ;;
  }

  dimension_group: day_details {
    type: time
    timeframes: []
    sql: date_parse(${TABLE}.startday,'%Y-%m-%d') ;;
  }

  measure: avg_occupancy {
    type: average
    value_format: "##\%"
    label: "Average Occupancy"
    sql: ${hourly_occupancy_percent} ;;
  }

  measure: avg_occupancy_past_week {
    type: average
    value_format: "##\%"
    label: "Average Occupancy - This Week"
    sql: ${week_hourly_occupancy_percent} ;;
  }

  measure: avg_turnovers {
    type: average
    value_format: "###"
    label: "Average Parked Vehicles by Arrival Hour"
    sql: ${hourly_parked_vehicles} ;;
  }
}
