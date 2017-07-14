view: minutes_parking_aggregates {
  derived_table: {
    sql:
      select siteid ,startday,weekday,occduration/(100000*60) as minute,
             occpercent , turnovers
      from dwh_aggregation_parking_spot
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

  dimension: occduration {
    type: number
    sql: ${TABLE}.occduration ;;
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

