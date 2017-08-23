view: agg_report_site_level_hourly_parking {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: SELECT
        siteid as siteid
        , sitename as sitename
        , date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
        , date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime
        , occupancy as occupancy
      FROM hive.dwh_qastage2.agg_report_site_level_hourly
      ORDER BY starttime
      ;;
  }

  dimension: siteid {
    description: "Site Id"
    type: string
    sql: ${TABLE}.siteid ;;
  }

  dimension: siteid2 {
    description: "Site Name"
    type: string
    hidden: yes
    sql: ${TABLE}.siteid ;;
  }

  dimension: sitename {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: sitename_hidden {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension_group: starttime {
    description: "Start Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension_group: endtime {
    description: "End Time"
    type: time
    sql: ${TABLE}.endtime ;;
  }

  filter: Metrics {
    label: "Metrics"
    suggestions: ["Occupancy","Revenue","Turnover"]
  }

  measure: Minimum {
    type: number
    description: "Metric"
    sql: CASE WHEN {% condition Metrics %} 'Occupancy' {% endcondition %} THEN ${agg_report_site_level_hourly_parking.occupancy}
      WHEN {% condition Metrics %} 'Revenue' {% endcondition %} THEN ${agg_report_site_level_hourly_parking.min_revenue}  END ;;
  }

  measure: Maximum {
    type: number
    description: "Metric"
    sql: CASE WHEN {% condition Metrics %} 'Occupancy' {% endcondition %} THEN ${agg_report_site_level_hourly_parking.occupancy}
      WHEN {% condition Metrics %} 'Revenue' {% endcondition %} THEN ${agg_report_site_level_hourly_parking.max_revenue} END ;;
  }


  measure: occupancy {
    description: "Occupancy"
    type: average
    sql: ${TABLE}.occupancy ;;
#     link: {
#       label: "See occupancy % on 15min interval"
#       url: "/dashboards/56?site={{ sitename_hidden._value | url_encode}}&starttime=after+{{ starttime_time._value | url_encode }}&endtime=before+{{ endtime_time._value | url_encode }}"
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
