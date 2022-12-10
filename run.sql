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
$$;

SELECT * from movies_from_dist('Walt Disney');

-- Procedure to show how much money per day movie gave to it`s produsers

DROP PROCEDURE IF EXISTS movie_daily_revenue(varchar);
CREATE OR REPLACE PROCEDURE movie_daily_revenue(check_movie varchar)
LANGUAGE plpgsql
AS $$
DECLARE mov_name movie.movie_name%TYPE;
DECLARE mov_year movie.movie_year%TYPE;
DECLARE mov_reve movie.movie_revenue%TYPE;
DECLARE daily INT;

BEGIN
    SELECT
		movie_name, 
		movie_year, 
		movie_revenue,
		case
			when mod(movie_year, 4) = 0 then round(movie_revenue/366)
			else round(movie_revenue/365)
		end revenue_daily
		into mov_name, mov_year, mov_reve, daily
	FROM movie WHERE movie_name = check_movie;
	RAISE INFO 'Name: %,  Year: %, Revenue: %, Daily: %', Trim(mov_name), mov_year, mov_reve, daily;
END;
$$;

call movie_daily_revenue('Titanic');


-- Create function for triger
CREATE OR REPLACE FUNCTION no_market_share() RETURNS trigger 
LANGUAGE 'plpgsql'
AS
$$
     BEGIN
          UPDATE genre 
          SET genre_market_share = 0 WHERE genre.genre_id = NEW.genre_id; 
		  RETURN NULL; -- result is ignored since this is an AFTER trigger
     END;
$$;

-- Creating triger, which will reduce market share of new genres to 0
CREATE TRIGGER genre_insert 
AFTER INSERT ON genre
FOR EACH ROW EXECUTE FUNCTION no_market_share();

INSERT INTO genre (genre_id, genre_name, genre_movies_number, genre_market_share) VALUES (11, 'SQL tutorial', 420, 100);
SELECT * from genre