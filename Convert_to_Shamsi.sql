CREATE OR REPLACE FUNCTION public.persiandate
(
  IN  dateMiladi  date
)
RETURNS INT AS
$$
DECLARE

    YearDay         INT;
    MiladiYear      INT;
    Sal             INT ;
    Mah             INT ;
    Rooz            INT ;
    TARIKH          VARCHAR(10) ;

BEGIN
    MiladiYear := EXTRACT(YEAR FROM dateMiladi) ;
    YearDay := EXTRACT(DOY FROM dateMiladi);


	
    IF YearDay <= 79 THEN
        BEGIN
		    IF ((MiladiYear - 1) % 4 = 0) THEN
				YearDay := YearDay + 11 ;
			ELSE
				YearDay := YearDay + 10 ;
			END IF;
            IF ((YearDay % 30 ) = 0) THEN
                BEGIN
                    Mah := (YearDay / 30 ) + 9 ;
                    Rooz := 30 ;
                End;
            ELSE
                BEGIN
                    Mah := (YearDay / 30 ) + 10 ;
                    Rooz := (YearDay % 30 ) ;
                End;
            END IF;
            Sal := MiladiYear - 622 ;
        End ;
    ELSE
        BEGIN 
            YearDay := YearDay -79 ;
            IF(YearDay <= 186) THEN
                BEGIN
                    IF((YearDay % 31) = 0) THEN
                        BEGIN
                            Mah := (YearDay / 31);
                            Rooz := 31 ;
                        End;
                    ELSE
                        BEGIN
                            Mah := (YearDay / 31) + 1;
                            Rooz := (YearDay % 31);
                        End;
                    END IF;
                End;
            ELSE
                BEGIN
                    YearDay := YearDay - 186 ;
                    IF ((YearDay % 30) = 0) THEN
                        BEGIN
                            Mah := (YearDay / 30) + 6;
                            Rooz := 30;
                        End;
                    ELSE
                        BEGIN
                            Mah := (YearDay / 30) + 7;
                            Rooz := (YearDay % 30);
                        End;
                    END IF;
                End;
            END IF;
			Sal := MiladiYear - 621 ;
        End;
    END IF;
    
    Tarikh := CONCAT(to_char(Sal,'fm0000'),'/',to_char(Mah,'fm00'),'/',to_char(Rooz,'fm00'))::INT ; 


    RETURN Tarikh;

END
$$
LANGUAGE 'plpgsql';
