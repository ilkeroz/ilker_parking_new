view: agg_report_site_level_day {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
        siteid as siteid
        , sitename as sitename
        , date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
        , occupancy as occupancy
      FROM hive.dwh_qastage2.agg_report_site_level_day
      ORDER BY starttime
      ;;
  }

  dimension: siteid {
    description: "Site Id"
    type: string
    sql: ${TABLE}.siteid
    ;;
  }

  dimension: sitename {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: siteid2 {
    description: "Site Name"
    type: string
    hidden: yes
    sql: ${TABLE}.siteid ;;
  }

  dimension: sitename_hidden {
    description: "Site Name"
    type: string
    hidden: yes
    sql: ${TABLE}.sitename ;;
  }

  dimension_group: starttime {
    description: "Start Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  measure: occupancy {
    description: "Occupancy"
    type: average
    sql: ${TABLE}.occupancy ;;
    link: {
      label: "See hourly occupancy %"
      url: "/dashboards/52?site={{ sitename_hidden._value | url_encode}}&Date={{ starttime_date._value | url_encode }}"
    }
  }
}
