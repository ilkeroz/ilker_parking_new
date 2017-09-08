view: report_violations_by_group {
  derived_table: {
    sql: select
          group_level.parkingsiteid as siteId,
          group_level.parkingsitename as siteName,
         CAST(group_fine as DOUBLE) as group_violationFees,
          group_violation as groupViolation,
          CAST(space_fine as DOUBLE) as space_violationFees,
          space_violation as spaceViolation,
          spot_level.parkinggroupname as parkingGroupName,
          spot_level.parkinggroupid as parkingGroupId,
          spot_level.parkingspotname as parkingSpotName,
          spot_level.parkingspotid as parkingSpotId,
          date_parse(group_level.starttime,'%Y-%m-%d %H:%i:%s') as startTime

          from hive.dwh_qastage2.agg_report_group_level_micro_demo group_level
          cross join UNNEST(violationlist) as t (group_violationfine)
          cross join UNNEST(split(group_violationfine.violationtype,'='),split(CAST(group_violationfine.fine as VARCHAR),'=')) as v (group_violation,group_fine)
          inner join hive.dwh_qastage2.agg_report_spot_level_micro_demo spot_level
          cross join UNNEST(violationlist) as t (space_violationfine)
          cross join UNNEST(split(space_violationfine.violationtype,'='),split(CAST(space_violationfine.fine as VARCHAR),'=')) as v (space_violation,space_fine)
          on group_level.parkingsiteid = spot_level.parkingsiteid
          and group_level.parkinggroupid = spot_level.parkinggroupid
          and group_level.starttime = spot_level.starttime
          order by starttime ASC
      ;;
  }

  dimension: siteId {
    description: "Site ID"
    type: string
    sql: ${TABLE}.siteId ;;
  }

  dimension: siteName {
    description: "Site Name"
    type: string
    sql: ${TABLE}.siteName ;;
  }

  dimension: parkingGroupId {
    description: "Parking Group Id"
    type: string
    sql: ${TABLE}.parkingGroupId ;;
  }

  dimension: parkingGroupName {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.parkingGroupName ;;
  }

  dimension: parkingSpotName {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.parkingSpotName ;;
  }

  dimension: parkingSpotId {
    description: "Parking Spot Id"
    type: string
    sql: ${TABLE}.parkingSpotId ;;
  }

  dimension: violation {
    description: "Violation"
    type: string
    sql: ${TABLE}.violation ;;
  }

  dimension_group: starttime {
    description: "Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  measure: ViolationFees{
    type: number
    description: "Violation Fees"
    sql: {% if report_violations_by_group.parkingSpotName._is_filtered %}
            ${Sum_Space_Violationfees}
         {% else %}
            ${Sum_Group_Violationfees}
         {% endif %} ;;
  }

  dimension: group_violationFees {
    description: "Group Violation Fees"
    type: number
    sql: ${TABLE}.group_violationFees ;;
  }

  measure: Sum_Group_Violationfees {
    description: "Group Violation Fees"
    type: sum
    sql: ${group_violationFees} ;;
  }

  dimension: space_violationFees {
    description: "Space Violation Fees"
    type: number
    sql: ${TABLE}.space_violationFees ;;
  }

  measure: Sum_Space_Violationfees {
    description: "Space Violation Fees"
    type: sum
    sql: ${space_violationFees} ;;
  }

  dimension: groupViolation {
    description: "Group Violation count"
    type: string
    sql: ${TABLE}.groupViolation ;;
  }

  measure: Number_Group_Violations {
    description: "Group Violations count"
    type: count_distinct
    sql: ${groupViolation} ;;
  }

  dimension: spaceViolation {
    description: "Space Violation count"
    type: string
    sql: ${TABLE}.spaceViolation ;;
  }

  measure: Number_Space_Violations {
    description: "Space Violations count"
    type: count_distinct
    sql: ${spaceViolation} ;;
  }

}
