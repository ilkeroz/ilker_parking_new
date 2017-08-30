# view: report_violations {
# derived_table: {
#   sql: SELECT
#           parkinggroupid as parkinggroupid
#         , parkinggroupname as parkinggroupname
#         , date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
#         , violation as violation
#         , count() as violationscount
#         , sum(CAST(fine as DOUBLE)) as violationfees
#       FROM hive.dwh_qastage2.agg_report_group_level_micro
#       cross join UNNEST(violationfinelist) as t (violationfine)
#       cross join UNNEST(split(violationfine.violationtype,'='),split(CAST(violationfine.fine as VARCHAR),'=')) as v (violation,fine)
#       group by parkinggroupid,parkinggroupname,starttime,violation
#       ORDER BY starttime
#       ;;
# }
#
# dimension: parkinggroupid {
#   description: "Parking Group Id"
#   type: string
#   sql: ${TABLE}.parkinggroupid ;;
# }
#
# dimension: parkinggroupname {
#   description: "Parking Group Name"
#   type: string
#   sql: ${TABLE}.parkinggroupname ;;
# }
#
#   dimension: violation {
#     description: "Violation"
#     type: string
#     sql: ${TABLE}.violation ;;
#   }
#
# dimension_group: starttime {
#   description: "Time"
#   type: time
#   sql: ${TABLE}.starttime ;;
# }
#
# dimension: violationscount {
#   description: "Number of Violations"
#   type: number
#   sql: ${TABLE}.violationscount ;;
# }
#
#   dimension: violationfees {
#     description: "Violation Fees"
#     type: number
#     sql: ${TABLE}.violationfees ;;
#   }
#
# measure: Violations_Count {
#   label: "Number of Violations"
#   description: "Number of Violations"
#   type: count
#   sql: ${violationscount} ;;
# }
#
#   measure: Violation_Fees {
#     label: "Violation Fees"
#     description: "Violation Fees"
#     type: sum
#     value_format: "0.00"
#     sql: ${violationfees} ;;
#   }
# }
