WITH t1 AS (SELECT osm_id, ST_Centroid(geom) AS geom FROM nodes wl WHERE country <@ Array[0]),
t2 AS (SELECT t1.osm_id, CASE WHEN COUNT(cg.cid) = 0 THEN ARRAY[1000]::INTEGER[] ELSE ARRAY_AGG(COALESCE(cg.cid, 1000)) END AS aa_fids FROM t1 LEFT JOIN countries cg ON ST_Intersects(t1.geom, cg.geometry) GROUP BY t1.osm_id)
UPDATE nodes uw SET country = t2.aa_fids FROM t2 WHERE t2.osm_id = uw.osm_id;