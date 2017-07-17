view: minutes_parking_aggregates {
  derived_table: {
    sql:
      select siteid ,startday,startdt,enddt,
      date_format(date_parse(startday,'%Y-%m-%d'), '%W') as weekday,
      --date_format(date_parse(startdt, '%Y-%m-%d %H:%i:%s'),'%Y-%m-%d %H:%i:%s') as startdate,
      occpercent , turnovers,parkingspotid,zoneid,groupid
      from dwh_aggregation_parking_spot
      WHERE  startday > date_format(date_add('day',-31,current_date), '%Y-%m-%d')
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



  dimension: startdt {
    type: string
    sql: ${TABLE}.startdt ;;
  }
  dimension: enddt {
    type: string
    sql: ${TABLE}.enddt ;;
  }
  dimension: occpercent {
    type: string
    sql: ${TABLE}.occpercent ;;
  }

  dimension: turnovers {
    type: string
    sql: ${TABLE}.turnovers ;;
  }



  }
