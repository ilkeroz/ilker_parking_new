view: agg_report_site {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT DISTINCT(siteid)
    , sitename as sitename
      FROM hive.dwh_qastage2.agg_report_site_level_day
      ORDER BY siteid
      ;;
  }

  dimension: siteid {
    description: "Site Id"
    type: string
    sql: ${TABLE}.siteid;;
  }

  dimension: sitename {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
    link: {
      label: "See daily occupancy %"
      url: "/dashboards/51?site={{ sitename._value | url_encode}}"
    }
  }
}
