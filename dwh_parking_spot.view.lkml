view: dwh_parking_spot {
  sql_table_name: hive.{{ _user_attributes['platform'] }}.dwh_parking_spot ;;
  suggestions: yes

  dimension: active {
    type: yesno
    sql: ${TABLE}.active ;;
  }

  dimension: activesince {
    type: number
    sql: ${TABLE}.activesince ;;
  }

  dimension: address {
    type: string
    sql: ${TABLE}.address ;;
  }

  dimension: altitude {
    type: number
    sql: ${TABLE}.altitude ;;
  }


  dimension: channel {
    type: number
    sql: ${TABLE}.channel ;;
  }

  dimension: demarcated {
    type: yesno
    sql: ${TABLE}.demarcated ;;
  }

  dimension: description {
    type: string
    label: "Spot Desc"
    sql: ${TABLE}.description ;;
  }

  dimension: lat1 {
    type: number
    sql: ${TABLE}.lat1 ;;
  }

  dimension: lat2 {
    type: number
    sql: ${TABLE}.lat2 ;;
  }

  dimension: lat3 {
    type: number
    sql: ${TABLE}.lat3 ;;
  }

  dimension: lat4 {
    type: number
    sql: ${TABLE}.lat4 ;;
  }

  dimension: lng1 {
    type: number
    sql: ${TABLE}.lng1 ;;
  }

  dimension: lng2 {
    type: number
    sql: ${TABLE}.lng2 ;;
  }

  dimension: lng3 {
    type: number
    sql: ${TABLE}.lng3 ;;
  }

  dimension: lng4 {
    type: number
    sql: ${TABLE}.lng4 ;;
  }

  dimension: nodeid {
    type: string
    sql: ${TABLE}.nodeid ;;
  }

  dimension: objectid {
    type: string
    sql: ${TABLE}.objectid ;;
  }

  dimension: occupancy {
    type: yesno
    sql: ${TABLE}.occupancy ;;
  }

  dimension: orgid {
    type: string
    sql: ${TABLE}.orgid ;;
  }

  dimension: parkinggroupid {
    type: string
    sql: ${TABLE}.parkinggroupid ;;
  }

  dimension: parkingspotid {
    type: string
    sql: ${TABLE}.parkingspotid ;;
  }

  dimension: parkingzoneid {
    type: string
    sql: ${TABLE}.parkingzoneid ;;
  }

  dimension: since {
    type: number
    sql: ${TABLE}.since ;;
  }

  dimension: siteid {
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: tags {
    type: string
    sql: ${TABLE}.tags ;;
  }

  dimension: ts {
    type: number
    sql: ${TABLE}.ts ;;
  }

  dimension: x1 {
    type: number
    sql: ${TABLE}.x1 ;;
  }

  dimension: x2 {
    type: number
    sql: ${TABLE}.x2 ;;
  }

  dimension: x3 {
    type: number
    sql: ${TABLE}.x3 ;;
  }

  dimension: x4 {
    type: number
    sql: ${TABLE}.x4 ;;
  }

  dimension: y1 {
    type: number
    sql: ${TABLE}.y1 ;;
  }

  dimension: y2 {
    type: number
    sql: ${TABLE}.y2 ;;
  }

  dimension: y3 {
    type: number
    sql: ${TABLE}.y3 ;;
  }

  dimension: y4 {
    type: number
    sql: ${TABLE}.y4 ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
