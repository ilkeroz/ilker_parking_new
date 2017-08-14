connection: "dwh_netsensenext"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore:  dwh_site {}

explore: daily_parking_aggregates {}

explore: dwh_parking_spot  {}

explore: sql_runner_query_test_occ_report {}

explore: occ_report_parking_zone {}

explore:occ_report_parking_site {}

explore:occ_report_parking {}

explore: occ_report_parking_zone_multiple_spots {}

explore: minutes_parking_aggregates {}

explore: occ_report_site {}

explore: occ_report_zone {}

explore: occ_report_spot {}

explore: occ_report_drill_down_site_micro {}

explore: occ_report_drill_down_group_micro {}

explore: occ_report_drill_down_spot_micro {}

# agg report site/ group/ spot

explore: agg_report_site {}

explore: agg_report_site_day {}

explore: agg_report_site_level_day {}

explore: agg_report_site_level_hourly {}

explore: agg_report_site_level_micro {}

explore: agg_report_group {}

explore: agg_report_group_level_day {}

explore: agg_report_group_level_hourly {}

explore: agg_report_group_level_micro {}

explore: agg_report_spot {}

explore: agg_report_spot_level_day {}

explore: agg_report_spot_level_hourly {}

explore: agg_report_spot_level_micro {}

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

# explore: occ_report_drill_down_site {
#   join: occ_report_drill_down_zone {
#     sql_on: ${occ_report_drill_down_site.siteid}=${occ_report_drill_down_zone.siteid} ;;
#     relationship: one_to_many
#   }
#   join: occ_report_drill_down_spot {
#     sql_on: ${occ_report_drill_down_zone.zoneid}=${occ_report_drill_down_spot.zoneid} ;;
#     relationship: one_to_many
#   }
# }
