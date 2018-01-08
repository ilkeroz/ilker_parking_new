view: agg_report_site_level_day_parking {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
        parkingsiteid as siteid
        , parkingsitename as sitename
        , date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
        , occupancy as occupancy
        , minrevenue as minrevenue
        , maxrevenue as maxrevenue
      FROM hive.dwh_sdqa.agg_report_site_level_day
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

  filter: Metrics {
    label: "Metrics"
    suggestions: ["Occupancy","Revenue","Turnover"]
  }

  filter: Statistics {
    label: "Metrics"
    suggestions: ["Min","Max","Avg","Median"]
  }

  measure: Minimum {
    type: number
    description: "Metric"
    sql: CASE WHEN {% condition Metrics %} 'Occupancy' {% endcondition %} THEN ${agg_report_site_level_day_parking.occupancy}
      WHEN {% condition Metrics %} 'Revenue' {% endcondition %} THEN ${agg_report_site_level_day_parking.min_revenue}  END ;;
  }

  measure: Maximum {
    type: number
    description: "Metric"
    sql: CASE WHEN {% condition Metrics %} 'Occupancy' {% endcondition %} THEN ${agg_report_site_level_day_parking.occupancy}
      WHEN {% condition Metrics %} 'Revenue' {% endcondition %} THEN ${agg_report_site_level_day_parking.max_revenue} END ;;
  }


  measure: occupancy {
    description: "Occupancy"
    type: average
    sql: ${TABLE}.occupancy ;;
#     link: {
#       label: "See hourly occupancy %"
#       url: "/dashboards/52?site={{ sitename_hidden._value | url_encode}}&Date={{ starttime_date._value | url_encode }}&Metrics={{Metrics._value | url_encode}"
#     }
  }

  measure: max_revenue {
    description: "Max Revenue"
    type: max
    sql: ${TABLE}.maxrevenue ;;
#     link: {
#       label: "See Hourly Max Revenue"
#       url: "/dashboards/52?site={{ sitename_hidden._value | url_encode}}&Date={{ starttime_date._value | url_encode }}"
#     }
  }
#
  measure: min_revenue {
    description: "Min Revenue"
    type: min
    sql: ${TABLE}.minrevenue ;;
#     link: {
#       label: "See Hourly Min Revenue"
#       url: "/dashboards/52?site={{ sitename_hidden._value | url_encode}}&Date={{ starttime_date._value | url_encode }}"
#     }
  }
}
