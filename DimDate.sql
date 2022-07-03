
DROP TABLE if exists dimdate;

CREATE TABLE dimdate
(
  jalalidate			   VARCHAR(10) NOT NULL,
  iddatedim                INT NOT NULL,
  RoozShamsi			   INT NOT NULL,
  datemiladi               DATE NOT NULL,
  epoch                    BIGINT NOT NULL,
  day_suffix               VARCHAR(4) NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  week_of_year_iso         CHAR(10) NOT NULL,
  month_actual             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL
);

ALTER TABLE public.dimdate ADD CONSTRAINT dimdate_jalalidate_pk PRIMARY KEY (jalalidate);

CREATE INDEX dimdate_datemiladi_idx
  ON dimdate(datemiladi);

COMMIT;

INSERT INTO dimdate
SELECT PersianDate(TarikhMiladi) As jalalidate,
       CASE
           WHEN EXTRACT(ISODOW FROM TarikhMiladi) = 6 THEN 0  --'شنبه'
           WHEN EXTRACT(ISODOW FROM TarikhMiladi) = 7 THEN 1  --'یکشنبه'
           WHEN EXTRACT(ISODOW FROM TarikhMiladi) = 1 THEN 2  --'دوشنبه'
           WHEN EXTRACT(ISODOW FROM TarikhMiladi) = 2 THEN 3  --'سه شنبه'
           WHEN EXTRACT(ISODOW FROM TarikhMiladi) = 3 THEN 4  --'چهار شنبه'
           WHEN EXTRACT(ISODOW FROM TarikhMiladi) = 4 THEN 5  --'پنج شنبه'
           WHEN EXTRACT(ISODOW FROM TarikhMiladi) = 5 THEN 6  --'جمعه'
           END AS RoozShamsi,
	   TO_CHAR(TarikhMiladi, 'yyyymmdd')::INT AS iddatedim,
       TarikhMiladi AS datemiladi,
       EXTRACT(EPOCH FROM TarikhMiladi) AS epoch,  -- 1970/01/01    ثانیه از این تاریخ
       TO_CHAR(TarikhMiladi, 'fmDDth') AS daysuffix,
       TO_CHAR(TarikhMiladi, 'TMDay') AS dayname,
       EXTRACT(ISODOW FROM TarikhMiladi) AS day_week,
       EXTRACT(DAY FROM TarikhMiladi) AS day_month,
       TarikhMiladi - DATE_TRUNC('quarter', TarikhMiladi)::DATE + 1 AS day_quarter,
       EXTRACT(DOY FROM TarikhMiladi) AS day_year,
       TO_CHAR(TarikhMiladi, 'W')::INT AS week_month,
       EXTRACT(WEEK FROM TarikhMiladi) AS week_year,
       EXTRACT(ISOYEAR FROM TarikhMiladi) || TO_CHAR(TarikhMiladi, '"-W"IW-') || EXTRACT(ISODOW FROM TarikhMiladi) AS week_year_iso,
       EXTRACT(MONTH FROM TarikhMiladi) AS month_actual,
       TO_CHAR(TarikhMiladi, 'TMMonth') AS month_name     -- 1348/10/11
FROM (SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS TarikhMiladi
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) IR
ORDER BY 1;

COMMIT;
