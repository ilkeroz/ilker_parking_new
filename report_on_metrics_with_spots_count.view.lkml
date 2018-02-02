view: report_on_metrics_with_spots_count {

  derived_table: {
    sql:
        select parking_spot.siteid, parking_spot.parkinggroupid,parking_spot.parkingspotid,lat1,lng1,
        agg_micro.Occupancy as Occupancy,
        agg_micro.Revenue as Revenue,
        agg_micro.Turnover as Turnover,
        agg_micro.Vacancy as Vacancy,
        agg_micro.AvgDwelltime as AvgDwelltime,
        agg_micro.MedianDwelltime as MedianDwelltime,
        agg_micro.MinDwelltime as MinDwelltime,
        agg_micro.MaxDwelltime as MaxDwelltime,
        agg_micro.handicapped as handicapped,
        agg_micro.formfactor as formfactor,
        agg_micro.typeofvehicle as typeofvehicle,
        agg_micro.reservation as reservation,
        agg_micro.businessuse as businessuse,
        agg_micro.howmetered as howmetered,
        agg_micro.areaoftype as areaoftype,
        agg_micro.violationrevenue as violationrevenue,
         agg_micro.violationcount as violationcount,
         agg_micro.violationtype as violationtype
        from hive.dwh_sdqa.dwh_parking_spot parking_spot
        left join
        (select spot_micro.occupancy as Occupancy,
      (case when cardinality(spot_micro.violationlist)>1 then spot_micro.totalrevenue/cast(cardinality(spot_micro.violationlist) as double) else totalrevenue end) as Revenue,
      (case when cardinality(spot_micro.violationlist)>1 then spot_micro.turnover/cast(cardinality(spot_micro.violationlist) as double) else turnover end) as Turnover,
          spot_micro.vacancy as Vacancy,
          coalesce(spot_micro.avgdwelltime,0) as AvgDwelltime,
          coalesce(spot_micro.mediandwelltime,0) as MedianDwelltime,
          coalesce(spot_micro.mindwelltime,0) as MinDwelltime,
          coalesce(spot_micro.maxdwelltime,0) as MaxDwelltime,
          spot_micro.parkingsiteid as siteid,
          spot_micro.parkingsitename as sitename,
          spot_micro.handicap as handicapped,
          spot_micro.formfactor as formfactor,
          array_join(spot_micro.typeovehicle,',','NA') as typeofvehicle,
          spot_micro.reservation as reservation,
          spot_micro.businessuse as businessuse,
          spot_micro.howmetered as howmetered,
          array_join(spot_micro.areaoftype,',','NA') as areaoftype,
          spot_micro.parkinggroupname as groupname,
          spot_micro.parkinggroupid as groupid,
          spot_micro.parkingspotname as spotname,
          spot_micro.parkingspotid as spotid,
          date_parse(spot_micro.starttime,'%Y-%m-%d %H:%i:%s') as startTime,
          date_parse(spot_micro.endtime,'%Y-%m-%d %H:%i:%s') as endTime,
          date_parse(spot_micro.currentbatch,'%Y-%m-%d') as currentbatch,
          "violationrevenue",
          "violationcount",
          "violationtype"
--          ,"lat1",
--          "lng1"
          from
        hive.dwh_sdqa.agg_report_spot_level_micro spot_micro
        left join (
        WITH com_report_violations_revenue_by_space AS (select
          parkingsiteid,
          parkingsitename,
          violationlist,
          space_violation.violationtype as violationtype,
          CAST(space_violation.fine as DOUBLE) as violationrevenue,
          space_violation.violationcount as violationcount,
          parkinggroupid,
          parkinggroupname,
          parkingspotid,
          parkingspotname,
          date_parse(starttime,'%Y-%m-%d %H:%i:%s') as starttime,
          date_parse(endtime,'%Y-%m-%d %H:%i:%s') as endtime,
          date_parse(currentbatch,'%Y-%m-%d') as currentbatch
          from
          hive.dwh_sdqa.agg_report_spot_level_micro
          cross join UNNEST(violationlist) as t (space_violation)
          order by starttime ASC
      )
        SELECT
        DATE_FORMAT((com_report_violations_revenue_by_space.endtime), '%Y-%m-%d %T') AS "endTime",
      com_report_violations_revenue_by_space.parkingsiteid as siteid,
      com_report_violations_revenue_by_space.parkingsitename as sitename,
      com_report_violations_revenue_by_space.parkinggroupid as parkinggroupid,
      com_report_violations_revenue_by_space.parkinggroupname as parkinggroupname,
      com_report_violations_revenue_by_space.parkingspotid as parkingspotid,
      com_report_violations_revenue_by_space.parkingspotname as parkingspotname,
      com_report_violations_revenue_by_space.violationtype as violationtype,
        COALESCE(SUM(com_report_violations_revenue_by_space.violationrevenue), 0) AS "violationrevenue",
        COALESCE(SUM(com_report_violations_revenue_by_space.violationcount), 0) AS "violationcount"
        FROM com_report_violations_revenue_by_space

        GROUP BY 1,2,3,4,5,6,7,8
        ORDER BY 1 DESC

        ) spot_report
        on spot_micro.parkingsiteid = spot_report.siteid
        and spot_micro.parkingsitename = spot_report.sitename
        and spot_micro.parkinggroupid = spot_report.parkinggroupid
        and spot_micro.parkinggroupname = spot_report.parkinggroupname
        and spot_micro.parkingspotid = spot_report.parkingspotid
        and spot_micro.parkingspotname = spot_report.parkingspotname
        and spot_report.endTime = spot_micro.endTime) agg_micro
        on parking_spot.siteid = agg_micro.siteid
        and parking_spot.parkinggroupid = agg_micro.groupid
        and parking_spot.parkingspotid = agg_micro.spotid
      ;;
 }
}
