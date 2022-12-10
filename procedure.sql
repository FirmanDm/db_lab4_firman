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