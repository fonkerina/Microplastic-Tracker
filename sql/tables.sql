/* Note - To activate this script \i + filepath */
/* Plan for PowerBI: avg micro per km2 per site (per year), mciro-macro ratios, seasonal trends, sample counts? */

/* Concatenate all Net Tow/Inland data */
DROP TABLE IF EXISTS all_net_UK CASCADE;
CREATE TABLE all_net_UK AS
    SELECT * 
    FROM uk_net_dat 
    UNION ALL 
    SELECT *
    FROM scots_net_dat 
    WHERE samp_location !~* 'offshore'
;

SELECT samp_location, samp_date, sum_micro_km2 
FROM all_net_uk 
ORDER BY samp_date
LIMIT 20;


/* Sample count per location, per year - ALL*/
SELECT samp_location, 
    count(*) as samp_count_ploc
FROM (
    SELECT samp_location FROM all_net_uk
    UNION ALL
    SELECT samp_location FROM engwales_sed_dat
) AS combined
GROUP BY samp_location
ORDER BY samp_count_ploc DESC
LIMIT 20;

SELECT EXTRACT(YEAR FROM samp_date) AS year, 
    count(*) as samp_count_pyear
FROM (
    SELECT samp_date FROM all_net_uk
    UNION ALL
    SELECT samp_date FROM engwales_sed_dat
) AS combined
GROUP BY year
ORDER BY year DESC
LIMIT 20;


/* INLAND v COASTAL+OFFSHORE */
/* Aggregate relevant stats operations - INLAND */
CREATE OR REPLACE VIEW inner_location_summary AS
SELECT samp_location,
       avg(sum_micro_km2) as mass_avg,
       count(*) as samp_count_ploc
FROM all_net_uk
GROUP BY samp_location;

/* Aggregate relevant stats operations - COASTAL+OFFSHORE */
CREATE OR REPLACE VIEW outer_location_summary AS
SELECT samp_location,
       avg(sum_micro_kg) as sed_mass_avg,
       count(*) as samp_count_ploc
FROM engwales_sed_dat
GROUP BY samp_location;

SELECT * FROM inner_location_summary ORDER BY mass_avg DESC;
SELECT * FROM outer_location_summary ORDER BY sed_mass_avg DESC;
