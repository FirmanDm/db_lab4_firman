--Function to return movies from chosen distributor 


DROP FUNCTION IF EXISTS movies_from_dist(varchar);
CREATE OR REPLACE FUNCTION movies_from_dist(asked_name varchar) 
    RETURNS TABLE (dist_own_name varchar, dist_movie_name varchar, dist_movie_year int)
    LANGUAGE 'plpgsql'
AS $$
BEGIN
    RETURN QUERY
        SELECT dist_name::varchar, movie_name::varchar, movie_year::int
		FROM distributor
		LEFT JOIN movie USING (dist_id) 
		WHERE dist_name = asked_name;
END;
$$