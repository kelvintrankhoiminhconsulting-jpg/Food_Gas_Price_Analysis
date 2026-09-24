
--creating an error log
CREATE TABLE dbo.etl_error_log (
    error_id INT IDENTITY(1,1) PRIMARY KEY,
    table_name VARCHAR(100),
    series_id VARCHAR(20),
    observation_date DATE,
    error_type VARCHAR(50),
    error_message VARCHAR(255),
    logged_at DATETIME DEFAULT GETDATE()
);

--load gasoline and load into bls prices table
SELECT TOP 10 *
FROM dbo.raw_gasoline_import2;

SELECT COUNT(*) AS total_rows
FROM dbo.raw_gasoline_import2;

INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU000074714',
    CAST(APU000074714 AS DECIMAL(10,3))
FROM dbo.raw_gasoline_import2;

--verify top 10
SELECT TOP 10 *
FROM dbo.raw_bls_prices
ORDER BY observation_date;
--count total rows
SELECT COUNT(*) AS total_rows
FROM dbo.raw_bls_prices;

--verify egg import
SELECT TOP 10 *
FROM dbo.raw_eggs_import;

--count rows in egg import
SELECT COUNT(*) AS total_rows
FROM dbo.raw_eggs_import;

--move eggs into raw bls prices
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000708111',
    CAST(APU0000708111 AS DECIMAL(10,3))
FROM dbo.raw_eggs_import;

--check to see if has moved 
SELECT
    series_id,
    COUNT(*) AS total_rows
FROM dbo.raw_bls_prices
GROUP BY series_id;

--load milk import and check and count rows
SELECT TOP 10 *
FROM dbo.raw_milk_import;

SELECT COUNT(*) AS total_rows
FROM dbo.raw_milk_import;

--move milk into bls prices table
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000709112',
    CAST(APU0000709112 AS DECIMAL(10,3))
FROM dbo.raw_milk_import;

--verify all three series
SELECT
    series_id,
    COUNT(*) AS total_rows
FROM dbo.raw_bls_prices
GROUP BY series_id
ORDER BY series_id;

--import bread file
SELECT TOP 10 *
FROM dbo.raw_bread_import;

SELECT COUNT(*) AS total_rows
FROM dbo.raw_bread_import;
--add bread to bls price table
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000702111',
    CAST(APU0000702111 AS DECIMAL(10,3))
FROM dbo.raw_bread_import;

--import beef
SELECT TOP 10 *
FROM dbo.raw_ground_beef_import;

SELECT COUNT(*) AS total_rows
FROM dbo.raw_ground_beef_import;

--insert beef to bls price table
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000703112',
    CAST(APU0000703112 AS DECIMAL(10,3))
FROM dbo.raw_ground_beef_import;

--import chicken and row count
SELECT TOP 10 *
FROM dbo.raw_chicken_import;

SELECT COUNT(*) AS total_rows
FROM dbo.raw_chicken_import;

--load into bls price table
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    CAST(column1 AS DATE),
    'APU0000FF1101',
    CAST(column2 AS DECIMAL(10,3))
FROM dbo.raw_chicken_import;

--verify if loaded correctly
SELECT
    series_id,
    COUNT(*) AS total_rows
FROM dbo.raw_bls_prices
GROUP BY series_id
ORDER BY series_id;

--load flour and check
SELECT TOP 10 *
FROM dbo.raw_flour_import;
--load into bls price table
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000701111',
    CAST(APU0000701111 AS DECIMAL(10,3))
FROM dbo.raw_flour_import;

--verify if inserted correctly
SELECT
    series_id,
    COUNT(*) AS total_rows
FROM dbo.raw_bls_prices
GROUP BY series_id
ORDER BY series_id;

--import rice and check top 10
SELECT TOP 5 *
FROM dbo.raw_rice_import;

--insert rice to bls price
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000701312',
    CAST(APU0000701312 AS DECIMAL(10,3))
FROM dbo.raw_rice_import;

--load spaghetti/macaroni and inspect top 10
SELECT TOP 5 *
FROM dbo.raw_spaghetti_import;

--load into bls price
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000701322',
    CAST(APU0000701322 AS DECIMAL(10,3))
FROM dbo.raw_spaghetti_import;

--verify IF IT IS IN BLS PRICE TABLE
SELECT TOP 10 *
FROM dbo.raw_bls_prices
WHERE series_id = 'APU0000701322'
ORDER BY observation_date;

--import coffee and verify top 5
SELECT TOP 5 *
FROM dbo.raw_coffee_import;

--insert coffee to bls price
INSERT INTO dbo.raw_bls_prices
    (observation_date, series_id, price)
SELECT
    observation_date,
    'APU0000717311',
    CAST(APU0000717311 AS DECIMAL(10,3))
FROM dbo.raw_coffee_import;

--verify coffee in bls price table
SELECT TOP 10 *
FROM dbo.raw_bls_prices
WHERE series_id = 'APU0000717311'
ORDER BY observation_date;

--check all 10 series just added
SELECT
    series_id,
    COUNT(*) AS row_count,
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date
FROM dbo.raw_bls_prices
GROUP BY series_id
ORDER BY series_id;

--check total rows
SELECT COUNT(*) AS total_rows
FROM dbo.raw_bls_prices;

--check for null prices
SELECT
    series_id,
    COUNT(*) AS null_price_count
FROM dbo.raw_bls_prices
WHERE price IS NULL
GROUP BY series_id
ORDER BY series_id;

--check total row counts
SELECT
    series_id,
    COUNT(*) AS row_count,
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date
FROM dbo.raw_bls_prices
GROUP BY series_id
ORDER BY series_id;

--check total row counts
SELECT COUNT(*) AS total_rows
FROM dbo.raw_bls_prices;

--check duplicates
SELECT
    series_id,
    observation_date,
    COUNT(*) AS duplicate_count
FROM dbo.raw_bls_prices
GROUP BY
    series_id,
    observation_date
HAVING COUNT(*) > 1
ORDER BY
    series_id,
    observation_date;

--check price is null
SELECT
    COUNT(*) AS null_price_rows
FROM dbo.raw_bls_prices
WHERE price IS NULL;

--create staging table for bls prices
CREATE TABLE dbo.stg_bls_prices (
    observation_date DATE,
    series_id VARCHAR(20),
    price DECIMAL(10,3),
    year INT,
    month INT
);

--load staging table
INSERT INTO dbo.stg_bls_prices
    (observation_date, series_id, price, year, month)
SELECT
    observation_date,
    series_id,
    price,
    YEAR(observation_date),
    MONTH(observation_date)
FROM dbo.raw_bls_prices
WHERE observation_date >= '2022-01-01'
  AND observation_date < '2026-09-01';

--verify staging table
SELECT
    series_id,
    COUNT(*) AS row_count,
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date
FROM dbo.stg_bls_prices
GROUP BY series_id
ORDER BY series_id;

--log the null prices error
INSERT INTO dbo.etl_error_log
    (table_name, series_id, observation_date, error_type, error_message)
SELECT
    'raw_bls_prices',
    series_id,
    observation_date,
    'NULL_PRICE',
    'Price is missing in source data'
FROM dbo.raw_bls_prices
WHERE price IS NULL;

--verify error log
SELECT
    error_type,
    COUNT(*) AS error_count
FROM dbo.etl_error_log
GROUP BY error_type;

--see which items have missing prices
SELECT
    series_id,
    COUNT(*) AS null_price_count,
    MIN(observation_date) AS first_null_date,
    MAX(observation_date) AS last_null_date
FROM dbo.raw_bls_prices
WHERE price IS NULL
GROUP BY series_id
ORDER BY series_id;

--check if stg bls prices table exist check column definitions 
SELECT TOP 5 *
FROM dbo.stg_bls_prices;

SELECT
    COUNT(*) AS row_count,
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date
FROM dbo.stg_bls_prices;

EXEC sp_help 'dbo.stg_bls_prices';

--check stagin row count
SELECT COUNT(*) AS staging_rows
FROM dbo.stg_bls_prices;

--check date range
SELECT
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_prices
FROM dbo.stg_bls_prices;

--check each series
SELECT
    series_id,
    COUNT(*) AS row_count,
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date
FROM dbo.stg_bls_prices
GROUP BY series_id
ORDER BY series_id;

--find the 9 NULL records
SELECT
    series_id,
    observation_date,
    price
FROM dbo.stg_bls_prices
WHERE price IS NULL
ORDER BY series_id, observation_date;

--remove NULL records
DELETE FROM dbo.stg_bls_prices
WHERE price IS NULL;

--then verify
SELECT
    COUNT(*) AS staging_rows,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_prices
FROM dbo.stg_bls_prices;

--check staging quality
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT series_id) AS series_count,
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_prices
FROM dbo.stg_bls_prices;

--checking each series
SELECT
    series_id,
    COUNT(*) AS row_count,
    MIN(observation_date) AS earliest_date,
    MAX(observation_date) AS latest_date
FROM dbo.stg_bls_prices
GROUP BY series_id
ORDER BY series_id;

--create dim_item
CREATE TABLE dbo.dim_item (
    item_key INT PRIMARY KEY,
    series_id VARCHAR(20) NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    unit VARCHAR(30) NOT NULL,
    source VARCHAR(50) NOT NULL
);

--insert 10 items to dim item
INSERT INTO dbo.dim_item
    (item_key, series_id, item_name, category, unit, source)
VALUES
    (1, 'APU000074714',  'Regular gasoline',       'Gas',  'dollars/gallon', 'BLS'),
    (2, 'APU0000708111', 'Eggs, Grade A, Large',   'Food', 'dollars/dozen',  'BLS'),
    (3, 'APU0000709112', 'Whole milk',             'Food', 'dollars/gallon', 'BLS'),
    (4, 'APU0000702111', 'White bread',            'Food', 'dollars/pound',  'BLS'),
    (5, 'APU0000703112', 'Ground beef',            'Food', 'dollars/pound',  'BLS'),
    (6, 'APU0000FF1101', 'Chicken breast',         'Food', 'dollars/pound',  'BLS'),
    (7, 'APU0000701111', 'All-purpose flour',      'Food', 'dollars/pound',  'BLS'),
    (8, 'APU0000701312', 'White rice',             'Food', 'dollars/pound',  'BLS'),
    (9, 'APU0000701322', 'Spaghetti/macaroni',     'Food', 'dollars/pound',  'BLS'),
    (10,'APU0000717311', 'Ground coffee',          'Food', 'dollars/pound',  'BLS');

--verify it
SELECT *
FROM dbo.dim_item
ORDER BY item_key;

--create dim_date
CREATE TABLE dbo.dim_date (
    date_key INT PRIMARY KEY,
    date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    quarter VARCHAR(2) NOT NULL
);

--populate date
WITH DateList AS
(
    SELECT CAST('2022-01-01' AS DATE) AS date_value

    UNION ALL

    SELECT DATEADD(MONTH, 1, date_value)
    FROM DateList
    WHERE date_value < '2026-08-01'
)
INSERT INTO dbo.dim_date
    (date_key, date, year, month, month_name, quarter)
SELECT
    YEAR(date_value) * 10000
        + MONTH(date_value) * 100
        + DAY(date_value) AS date_key,
    date_value,
    YEAR(date_value),
    MONTH(date_value),
    DATENAME(MONTH, date_value),
    'Q' + CAST(DATEPART(QUARTER, date_value) AS VARCHAR(1))
FROM DateList
OPTION (MAXRECURSION 100);

--verify
SELECT *
FROM dbo.dim_date
ORDER BY date;

--build fact_prices
CREATE TABLE dbo.fact_prices (
    price_id INT IDENTITY(1,1) PRIMARY KEY,
    date_key INT NOT NULL,
    item_key INT NOT NULL,
    price DECIMAL(10,3) NOT NULL,

    FOREIGN KEY (date_key)
        REFERENCES dbo.dim_date(date_key),

    FOREIGN KEY (item_key)
        REFERENCES dbo.dim_item(item_key)
);
--load fact table with dim table
INSERT INTO dbo.fact_prices
    (date_key, item_key, price)
SELECT
    d.date_key,
    i.item_key,
    s.price
FROM dbo.stg_bls_prices s
JOIN dbo.dim_date d
    ON s.observation_date = d.date
JOIN dbo.dim_item i
    ON s.series_id = i.series_id;

--verify fact table
SELECT COUNT(*) AS fact_rows
FROM dbo.fact_prices;

--build a star schema
SELECT TOP 20
    f.price_id,
    d.date,
    i.item_name,
    i.category,
    i.unit,
    f.price
FROM dbo.fact_prices f
JOIN dbo.dim_date d
    ON f.date_key = d.date_key
JOIN dbo.dim_item i
    ON f.item_key = i.item_key
ORDER BY d.date, i.item_key;

--what was the avg price of each item by year
SELECT
    d.year,
    i.category,
    i.item_name,
    i.unit,
    AVG(f.price) AS average_price
FROM dbo.fact_prices f
JOIN dbo.dim_date d
    ON f.date_key = d.date_key
JOIN dbo.dim_item i
    ON f.item_key = i.item_key
GROUP BY
    d.year,
    i.category,
    i.item_name,
    i.unit
ORDER BY
    d.year,
    i.category,
    i.item_name;

--how much did each item's price change from 2022 to 2026
WITH AnnualPrices AS
(
    SELECT
        i.item_name,
        i.category,
        i.unit,
        d.year,
        AVG(f.price) AS average_price
    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
    WHERE d.year IN (2022, 2026)
    GROUP BY
        i.item_name,
        i.category,
        i.unit,
        d.year
)
SELECT
    item_name,
    category,
    unit,
    MAX(CASE WHEN year = 2022 THEN average_price END) AS avg_price_2022,
    MAX(CASE WHEN year = 2026 THEN average_price END) AS avg_price_2026,
    MAX(CASE WHEN year = 2026 THEN average_price END)
      - MAX(CASE WHEN year = 2022 THEN average_price END) AS dollar_change,
    (
        MAX(CASE WHEN year = 2026 THEN average_price END)
        - MAX(CASE WHEN year = 2022 THEN average_price END)
    )
    / MAX(CASE WHEN year = 2022 THEN average_price END) * 100 AS percent_change
FROM AnnualPrices
GROUP BY
    item_name,
    category,
    unit
ORDER BY
    percent_change DESC;

--compare only months jan to august 2022 to 2026
WITH PeriodPrices AS
(
    SELECT
        i.item_name,
        i.category,
        i.unit,
        d.year,
        AVG(f.price) AS average_price
    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
    WHERE d.year IN (2022, 2026)
      AND d.month BETWEEN 1 AND 8
    GROUP BY
        i.item_name,
        i.category,
        i.unit,
        d.year
)
SELECT
    item_name,
    category,
    unit,

    MAX(CASE
        WHEN year = 2022
        THEN average_price
    END) AS avg_jan_aug_2022,

    MAX(CASE
        WHEN year = 2026
        THEN average_price
    END) AS avg_jan_aug_2026,

    MAX(CASE
        WHEN year = 2026
        THEN average_price
    END)
    -
    MAX(CASE
        WHEN year = 2022
        THEN average_price
    END) AS dollar_change,

    (
        MAX(CASE
            WHEN year = 2026
            THEN average_price
        END)
        -
        MAX(CASE
            WHEN year = 2022
            THEN average_price
        END)
    )
    /
    MAX(CASE
        WHEN year = 2022
        THEN average_price
    END) * 100 AS percent_change

FROM PeriodPrices
GROUP BY
    item_name,
    category,
    unit
ORDER BY
    percent_change DESC;

--address how did prices move month to month from 2022 to 2026
SELECT
    d.date,
    d.year,
    d.month,
    i.item_name,
    f.price
FROM dbo.fact_prices f
JOIN dbo.dim_date d
    ON f.date_key = d.date_key
JOIN dbo.dim_item i
    ON f.item_key = i.item_key
WHERE i.item_name = 'Ground coffee'
ORDER BY d.date;

--calculate month to month change
WITH MonthlyPrices AS
(
    SELECT
        d.date,
        d.year,
        d.month,
        i.item_name,
        i.category,
        i.unit,
        f.price,

        LAG(f.price) OVER (
            PARTITION BY i.item_key
            ORDER BY d.date
        ) AS previous_month_price

    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
)
SELECT
    date,
    item_name,
    category,
    unit,
    price,
    previous_month_price,

    price - previous_month_price AS dollar_change,

    CAST(
    CASE
        WHEN previous_month_price IS NULL THEN NULL
        ELSE
            (price - previous_month_price)
            / previous_month_price * 100
    END
    AS DECIMAL(10,2)
) AS percent_change

FROM MonthlyPrices
ORDER BY
    item_name,
    date;

--calculate year over year change
WITH MonthlyPrices AS
(
    SELECT
        d.date,
        i.item_key,
        i.item_name,
        i.category,
        i.unit,
        f.price
    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
)

SELECT
    cur.date,
    cur.item_name,
    cur.category,
    cur.unit,
    cur.price,
    prev.price AS price_12_months_ago,

    CAST(
        cur.price - prev.price
        AS DECIMAL(10,3)
    ) AS dollar_change,

    CAST(
        CASE
            WHEN prev.price IS NULL THEN NULL
            ELSE
                (cur.price - prev.price)
                / prev.price * 100
        END
        AS DECIMAL(10,2)
    ) AS percent_change

FROM MonthlyPrices cur

LEFT JOIN MonthlyPrices prev
    ON prev.item_key = cur.item_key
    AND prev.date = DATEADD(MONTH, -12, cur.date)

ORDER BY
    cur.item_name,
    cur.date;

--which food or gas prices fluctuated the most month to month from 2022 to 2026
SELECT
    i.item_name,
    i.category,
    i.unit,

    CAST(
        AVG(f.price)
        AS DECIMAL(10,2)
    ) AS average_price,

    CAST(
        STDEV(f.price)
        AS DECIMAL(10,2)
    ) AS price_volatility

FROM dbo.fact_prices f
JOIN dbo.dim_item i
    ON f.item_key = i.item_key

GROUP BY
    i.item_name,
    i.category,
    i.unit

ORDER BY
    price_volatility DESC;

--calculate the monthly percentage volatility
WITH MonthlyPrices AS
(
    SELECT
        d.date,
        i.item_key,
        i.item_name,
        i.category,
        i.unit,
        f.price,

        LAG(f.price) OVER (
            PARTITION BY i.item_key
            ORDER BY d.date
        ) AS previous_month_price

    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
),

MonthlyChanges AS
(
    SELECT
        item_key,
        item_name,
        category,
        unit,

        CASE
            WHEN previous_month_price IS NULL
                 OR previous_month_price = 0
            THEN NULL
            ELSE
                (price - previous_month_price)
                / previous_month_price * 100
        END AS monthly_percent_change

    FROM MonthlyPrices
)

SELECT
    item_name,
    category,
    unit,

    CAST(
        STDEV(monthly_percent_change)
        AS DECIMAL(10,2)
    ) AS volatility_percent

FROM MonthlyChanges

GROUP BY
    item_name,
    category,
    unit

ORDER BY
    volatility_percent DESC;

--normalize every item to jan 2022 = 100
WITH BasePrices AS
(
    SELECT
        i.item_key,
        i.item_name,
        f.price AS base_price
    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
    WHERE d.date = '2022-01-01'
),

MonthlyPrices AS
(
    SELECT
        d.date,
        d.year,
        d.month,
        i.item_key,
        i.item_name,
        i.category,
        i.unit,
        f.price
    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
)

SELECT
    m.date,
    m.year,
    m.month,
    m.item_name,
    m.category,
    m.unit,
    m.price AS actual_price,
    b.base_price,

    CAST(
        (m.price / b.base_price) * 100
        AS DECIMAL(10,2)
    ) AS price_index

FROM MonthlyPrices m
JOIN BasePrices b
    ON m.item_key = b.item_key

ORDER BY
    m.item_name,
    m.date;

--BUILD A 2022-2026 SUMMARY
WITH PeriodPrices AS
(
    SELECT
        i.item_key,
        i.item_name,
        i.category,
        i.unit,
        d.year,
        AVG(f.price) AS average_price
    FROM dbo.fact_prices f
    JOIN dbo.dim_date d
        ON f.date_key = d.date_key
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
    WHERE d.year IN (2022, 2026)
      AND d.month BETWEEN 1 AND 8
    GROUP BY
        i.item_key,
        i.item_name,
        i.category,
        i.unit,
        d.year
),

OverallStats AS
(
    SELECT
        i.item_key,
        AVG(f.price) AS overall_average,
        STDEV(f.price) AS price_volatility
    FROM dbo.fact_prices f
    JOIN dbo.dim_item i
        ON f.item_key = i.item_key
    GROUP BY
        i.item_key
)

SELECT
    p.item_name,
    p.category,
    p.unit,

    CAST(
        MAX(CASE WHEN p.year = 2022
                 THEN p.average_price END)
        AS DECIMAL(10,3)
    ) AS avg_jan_aug_2022,

    CAST(
        MAX(CASE WHEN p.year = 2026
                 THEN p.average_price END)
        AS DECIMAL(10,3)
    ) AS avg_jan_aug_2026,

    CAST(
        MAX(CASE WHEN p.year = 2026
                 THEN p.average_price END)
        -
        MAX(CASE WHEN p.year = 2022
                 THEN p.average_price END)
        AS DECIMAL(10,3)
    ) AS dollar_change,

    CAST(
        (
            MAX(CASE WHEN p.year = 2026
                     THEN p.average_price END)
            -
            MAX(CASE WHEN p.year = 2022
                     THEN p.average_price END)
        )
        /
        NULLIF(
            MAX(CASE WHEN p.year = 2022
                     THEN p.average_price END),
            0
        ) * 100
        AS DECIMAL(10,2)
    ) AS percent_change,

    CAST(
        s.overall_average
        AS DECIMAL(10,3)
    ) AS overall_average,

    CAST(
        s.price_volatility
        AS DECIMAL(10,3)
    ) AS price_volatility

FROM PeriodPrices p

JOIN OverallStats s
    ON p.item_key = s.item_key

GROUP BY
    p.item_name,
    p.category,
    p.unit,
    s.overall_average,
    s.price_volatility

ORDER BY
    percent_change DESC;

--VALIDATION CHECK, ROW COUNT, 
SELECT COUNT(*) AS fact_row_count
FROM dbo.fact_prices;

--CHECK TO SEE EVERY ITEM IS REPRESENTED
SELECT
    i.item_name,
    COUNT(*) AS row_count
FROM dbo.fact_prices f
JOIN dbo.dim_item i
    ON f.item_key = i.item_key
GROUP BY
    i.item_name
ORDER BY
    i.item_name;

--CHECK FOR MISSING PRICES
SELECT COUNT(*) AS missing_prices
FROM dbo.fact_prices
WHERE price IS NULL;

--CHECK FOR DUPLICATES
SELECT
    item_key,
    date_key,
    COUNT(*) AS row_count
FROM dbo.fact_prices
GROUP BY
    item_key,
    date_key
HAVING COUNT(*) > 1;

--CHECK FOR DATE COVERAGE
SELECT
    MIN(d.date) AS first_date,
    MAX(d.date) AS last_date,
    COUNT(DISTINCT d.date) AS number_of_months
FROM dbo.fact_prices f
JOIN dbo.dim_date d
    ON f.date_key = d.date_key;

--CREATE A CLEAN VIEW TABLE WITH DIM DATE, DIM ITEM AND FACT PRICES
CREATE VIEW dbo.vw_food_gas_prices
AS
SELECT
    f.price_id,
    d.date_key,
    d.date,
    d.year,
    d.month,
    d.month_name,
    d.quarter,

    i.item_key,
    i.series_id,
    i.item_name,
    i.category,
    i.unit,
    i.source,

    f.price

FROM dbo.fact_prices f

JOIN dbo.dim_date d
    ON f.date_key = d.date_key

JOIN dbo.dim_item i
    ON f.item_key = i.item_key;

--TEST TO SEE THE TABLE IS OPERATIONAL
SELECT TOP 20 *
FROM dbo.vw_food_gas_prices
ORDER BY date, item_name;

--END---
