view: com_report_violations_count_by_space_yearly {
 derived_table: {
  sql: select objectid,
          siteid,
          sitename,
          violationlist,
          violation,
          parkinggroupid,
          parkingspotid,
          starttimestamp,
          endtimestamp,
          from_unixtime(starttimestamp/1000000) as startTime,
          from_unixtime(endtimestamp/1000000) as endTime
          from hive.dwh_qastage1.dwh_parking_spot_report
          cross join UNNEST(violationlist) as t (group_violation)
          cross join UNNEST(split(group_violation.violationtype,'=')) as v (violation)
          where cardinality(violationlist) != 0
          order by starttime ASC
      ;;
}

dimension: siteid {
  description: "Site ID"
  type: string
  sql: ${TABLE}.siteid ;;
}

dimension: sitename {
  description: "Site Name"
  type: string
  sql: ${TABLE}.sitename ;;
}

dimension: parkinggroupid {
  description: "Parking Group Id"
  type: string
  sql: ${TABLE}.parkinggroupid ;;
}

dimension: parkingspotid {
  description: "Parking Spot Id"
  type: string
  sql: ${TABLE}.parkingspotid ;;
}

dimension: violation {
  description: "Violation"
  type: string
  sql: ${TABLE}.violation ;;
}

  dimension: sitename_hidden {
    type: string
    hidden: yes
    sql: ${TABLE}.sitename ;;
  }

  dimension: violation_hidden {
    description: "Violation"
    type: string
    sql: ${TABLE}.violation ;;
  }

  dimension: parkinggroupid_hidden {
    type: string
    hidden: yes
    sql: ${TABLE}.parkinggroupName ;;
  }

dimension_group: startTime {
  description: "Time"
  type: time
  sql: ${TABLE}.startTime ;;
}

  measure: startTime_measure {
    description: "Start Time"
    type: string
    sql: ${startTime_year} ;;
  }

measure: count {
  type: count
#   sql:${violation};;
  link: {
    # spots monthly dashboard
    label: "See Spots - Violations count on monthly"
    url: "/dashboards/133?Site={{ siteName_hidden._value | url_encode}}&Group={{ parkingGroupId_hidden._value | url_encode}}&Space={{ parkingSpotId._value | url_encode}}&Violation={{violation_hidden._value | url_encode}}&Time={{ startTime_measure._value | url_encode }}"
  }
}
}
