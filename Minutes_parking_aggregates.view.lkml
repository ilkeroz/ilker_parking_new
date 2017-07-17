view: minutes_parking_aggregates {
  derived_table: {
    sql:
      select siteid ,startday,date_parse(enddt,'%Y-%m-%d %H:%i:%s') as enddate,date_parse(startdt, '%Y-%m-%d %H:%i:%s') as startdate,
      date_format(date_parse(startday,'%Y-%m-%d'), '%W') as weekday,
      --date_format(date_parse(startdt, '%Y-%m-%d %H:%i:%s'),'%Y-%m-%d %H:%i:%s') as startdate,
      occpercent , turnovers,parkingspotid,zoneid,groupid
      from dwh_aggregation_parking_spot
      WHERE  startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
      ORDER BY startdate, enddate ASC
      ;;

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



  dimension: startdate {
    type: date_time_of_day
    sql: ${TABLE}.startdate ;;
  }
  dimension: enddate {
    type: date_time_of_day
    sql: ${TABLE}.enddate ;;
  }
  dimension: occpercent {
    type: string
    sql: ${TABLE}.occpercent ;;
  }

  dimension: turnovers {
    type: string
    sql: ${TABLE}.turnovers ;;
  }
  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }
  dimension: zoneid {
    type: string
    sql: ${TABLE}.zoneid ;;
  }
  dimension: groupid {
    type: string
    sql: ${TABLE}.groupid ;;
  }



  }
