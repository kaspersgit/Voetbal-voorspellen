	CREATE TRIGGER match_hist_update
	AFTER INSERT
	ON '2017'
BEGIN
	INSERT INTO ENG_matches_hist
	(`Div`,
	`Date`,
	`HomeTeam`,
	`AwayTeam`,
	`FTHG`,
	`FTAG`,
	`FTR`,
	`HTHG`,
	`HTAG`,
	`HTR`,
	`Referee`,
	`HS`,
	`AS`,
	`HST`,
	`AST`,
	`HF`,
	`AF`,
	`HC`,
	`AC`,
	`HY`,
	`AY`,
	`HR`,
	`AR`)
	VALUES 
	(NEW.`Div`,
	NEW.`Date`,
	NEW.`HomeTeam`,
	NEW.`AwayTeam`,
	NEW.`FTHG`,
	NEW.`FTAG`,
	NEW.`FTR`,
	NEW.`HTHG`,
	NEW.`HTAG`,
	NEW.`HTR`,
	NEW.`Referee`,
	NEW.`HS`,
	NEW.`AS`,
	NEW.`HST`,
	NEW.`AST`,
	NEW.`HF`,
	NEW.`AF`,
	NEW.`HC`,
	NEW.`AC`,
	NEW.`HY`,
	NEW.`AY`,
	NEW.`HR`,
	NEW.`AR`);
END;