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