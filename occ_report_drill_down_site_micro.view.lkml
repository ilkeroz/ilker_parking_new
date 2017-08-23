view: occ_report_drill_down_site_micro {

  derived_table: {
    sql: SELECT
        siteid as siteid
        , sitename as sitename
        , date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime
        , occupancy as occupancy
      FROM hive.dwh_qastage2.agg_report_site_level_micro
      ORDER BY endtime
      ;;
  }

  dimension: siteid {
    description: "Site Id"
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: sitename {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
    link: {
      label: "See groups"
      url: "/embed/dashboards/49?site={{value | url_encode}}&time={{_filters['occ_report_drill_down_site_micro.endtime_time'] | url_encode}}"
    }
  }

  dimension_group: endtime {
    description: "End Time"
    type: time
    sql: ${TABLE}.endtime ;;
  }

  measure: occupancy {
    description: "Occupancy"
    type: average
    sql: ${TABLE}.occupancy ;;
  }

}
