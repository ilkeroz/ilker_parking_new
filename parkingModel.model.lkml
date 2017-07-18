connection: "dwh_netsensenext"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore:  dwh_site {}

explore: daily_parking_aggregates {}

explore: dwh_parking_spot  {}

explore: sql_runner_query_test_occ_report {}

explore: realtime_parking {
#   sql_always_where: lat1 != 0 ;;
join: dwh_site {
  sql_on: ${realtime_parking.siteid}=${dwh_site.siteid} ;;
  relationship: many_to_one
}
join: dwh_customer {
  sql_on: ${dwh_site.orgid}=${dwh_customer.orgid} ;;
  relationship: many_to_one
}
}

explore: hourly_parking_aggregates {
  join: dwh_site {
    sql_on: ${hourly_parking_aggregates.siteid}=${dwh_site.siteid} ;;
    relationship: many_to_one
  }
  join: dwh_customer {
    sql_on: ${dwh_site.orgid}=${dwh_customer.orgid} ;;
    relationship: many_to_one
  }
}
explore: minutes_parking_aggregates {
  join: dwh_site {
    sql_on: ${minutes_parking_aggregates.siteid}=${dwh_site.siteid} ;;
    relationship: many_to_one
  }
  join: dwh_customer {
    sql_on: ${dwh_site.orgid}=${dwh_customer.orgid} ;;
    relationship: many_to_one
  }
}





explore: daily_parking_aggregates_spot {
  join: dwh_site {
    sql_on: ${daily_parking_aggregates_spot.siteid}=${dwh_site.siteid} ;;
    relationship: many_to_one
  }
  join: dwh_customer {
    sql_on: ${dwh_site.orgid}=${dwh_customer.orgid} ;;
    relationship: many_to_one
  }
  join: dwh_parking_spot {
    sql_on: ${daily_parking_aggregates_spot.spotid}=${dwh_parking_spot.parkingspotid} ;;
    relationship: many_to_one
  }
  join: realtime_parking {
    sql_on: ${daily_parking_aggregates_spot.spotid}=${realtime_parking.parkingspotid} ;;
    relationship: many_to_one
  }
}
