CREATE OR REPLACE FUNCTION public.persiandate(dateMiladi date)
RETURNS date AS $$
DECLARE
    YearDay         INT;
    MiladiYear      INT;
    Sal             INT;
    Mah             INT;
    Rooz            INT;
    TARIKH          date;
BEGIN
    MiladiYear := EXTRACT(YEAR FROM dateMiladi);
    YearDay := EXTRACT(DOY FROM dateMiladi);
    
    IF YearDay <= 79 THEN
        IF (EXTRACT(YEAR FROM dateMiladi - interval '1 year') % 4 = 0) THEN
            YearDay := YearDay + 11;
        ELSE
            YearDay := YearDay + 10;
        END IF;
        
        IF (YearDay % 30) = 0 THEN
            Mah := (YearDay / 30) + 9;
            Rooz := 30;
        ELSE
            Mah := (YearDay / 30) + 10;
            Rooz := (YearDay % 30);
        END IF;
        
        Sal := MiladiYear - 622;
    ELSE
        YearDay := YearDay - 79;
        
        IF YearDay <= 186 THEN
            IF (YearDay % 31) = 0 THEN
                Mah := (YearDay / 31);
                Rooz := 31;
            ELSE
                Mah := (YearDay / 31) + 1;
                Rooz := (YearDay % 31);
            END IF;
        ELSE
            YearDay := YearDay - 186;
            
            IF (YearDay % 30) = 0 THEN
                Mah := (YearDay / 30) + 6;
                Rooz := 30;
            ELSE
                Mah := (YearDay / 30) + 7;
                Rooz := (YearDay % 30);
            END IF;
        END IF;
        
        Sal := MiladiYear - 621;
    END IF;
    
    TARIKH := CONCAT(to_char(Sal, 'fm0000'), '/', to_char(Mah, 'fm00'), '/', to_char(Rooz, 'fm00'))::date;

    RETURN TARIKH;
END;
$$
LANGUAGE 'plpgsql';
