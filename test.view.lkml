view: test {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: select spot_level.spot_occupancy as Spot_Occupancy,
    spot_level.parkingspotname,
    spot_level.parkinggroupname,
    spot_level.handicapped,
    spot_level.formfactor,
    spot_level.starttime,
    group_level.group_occupancy as Group_Occupancy
    from
    (select occupancy as spot_occupancy, parkingspotname,parkinggroupname,parkinggroupid,handicapped,formfactor,
    date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
    from hive.dwh_qastage2.agg_report_spot_level_day) spot_level

    LEFT OUTER JOIN

    (select avg(occupancy) as group_occupancy,parkinggroupname,parkinggroupid,
    date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime
    from hive.dwh_qastage2.agg_report_spot_level_day
    group by parkinggroupname,parkinggroupid,starttime) group_level

    ON spot_level.parkinggroupid = group_level.parkinggroupid
    and spot_level.starttime = group_level.starttime
    ;;
  }

  dimension: sitename {
    description: "Site Name"
    type: string
    sql: ${TABLE}.sitename ;;
  }

  dimension: parkinggroupname {
    description: "Parking Group Name"
    type: string
    sql: ${TABLE}.parkinggroupname ;;
  }

  dimension: parkingspotname {
    description: "Parking Spot Name"
    type: string
    sql: ${TABLE}.parkingspotname ;;
  }

  dimension_group: starttime {
    description: "End Time"
    type: time
    sql: ${TABLE}.starttime ;;
  }

  dimension:  handicapped{
    description: "Handicapped"
    type: yesno
    sql: ${TABLE}.handicapped;;
  }

  dimension: formfactor {
    description: "Form Factor"
    type: string
    sql: ${TABLE}.formfactor ;;
  }

  dimension: Occupancy {
    type: number
    description: "Occupancy"
    sql: {% if test.handicapped._is_filtered %}
            test.Spot_Occupancy
         {% else %}
            test.Group_Occupancy
         {% endif %} ;;
   }

    dimension: Group_Occupancy {
      description: "Group Occupancy"
      type: number
      sql: ${TABLE}.Group_Occupancy ;;
    }

    dimension: Spot_Occupancy {
      description: "Spot Occupancy"
      type: number
      sql: ${TABLE}.Spot_Occupancy ;;
    }
  }
