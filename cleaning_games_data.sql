SELECT * 
FROM dbo.games_data

SELECT COUNT(DISTINCT id), COUNT(*) 
FROM dbo.games_data

-- standardized release_date: remove timestamp

SELECT release_date, CONVERT(DATE, release_date) 
FROM dbo.games_data

ALTER TABLE dbo.games_data
ADD release_date_standard date

UPDATE dbo.games_data
SET release_date_standard = CONVERT(DATE, release_date)

SELECT release_date, release_date_standard
FROM dbo.games_data

-- price to numeric

SELECT price, COUNT(price)
FROM dbo.games_data
GROUP BY price
ORDER BY price

UPDATE dbo.games_data
SET price = REPLACE(price, 'Free to play', 0)

SELECT price
FROM dbo.games_data
WHERE price LIKE('% %')

UPDATE dbo.games_data
SET price = NULL
WHERE price LIKE('% %')

SELECT price
FROM dbo.games_data
WHERE price = ' '

UPDATE dbo.games_data
SET price = NULL
WHERE price = ' '

SELECT price
FROM dbo.games_data
WHERE price LIKE('%?%')

UPDATE dbo.games_data
SET price = NULL
WHERE price LIKE('%?%')

SELECT price
FROM dbo.games_data
WHERE price LIKE('%,%')

UPDATE dbo.games_data
SET price = REPLACE(price,',','')

SELECT price, CONVERT(NUMERIC, price)
FROM dbo.games_data

ALTER TABLE dbo.games_data
ADD price_standard numeric

UPDATE dbo.games_data
SET price_standard = CONVERT(numeric, price)

SELECT price_standard
FROM dbo.games_data
GROUP BY price_standard
ORDER BY price_standard

-- clean dc_price and convert to numeric

SELECT dc_price, COUNT(dc_price)
FROM dbo.games_data
GROUP BY dc_price
ORDER BY dc_price

UPDATE dbo.games_data
SET dc_price = REPLACE(dc_price, 'Free to play', 0)

SELECT dc_price
FROM dbo.games_data
WHERE dc_price = ' '

UPDATE dbo.games_data
SET dc_price = NULL
WHERE dc_price = ' '

SELECT dc_price
FROM dbo.games_data
WHERE dc_price LIKE('%,%')

UPDATE dbo.games_data
SET dc_price = REPLACE(dc_price,',','')

ALTER TABLE dbo.games_data
ADD dc_price_standard numeric

UPDATE dbo.games_data
SET dc_price_standard = CONVERT(numeric, dc_price)

SELECT dc_price_standard
FROM dbo.games_data
GROUP BY dc_price_standard
ORDER BY dc_price_standard

-- developer standardized in new table

SELECT developer, COUNT(developer)
FROM dbo.games_data
GROUP BY developer
ORDER BY developer

SELECT s.title, s.id, s.developer, v.value
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.developer, ';') as v
WHERE s.developer LIKE('%;%')

SELECT s.id as game_id, s.title, v.value AS developer
INTO games_developer
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.developer, ';') as v

SELECT *
FROM dbo.games_developer

-- publisher standardized in new table

SELECT publisher, COUNT(publisher)
FROM dbo.games_data
GROUP BY publisher
ORDER BY publisher

SELECT s.title, s.id, s.publisher, v.value
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.publisher, ';') as v
WHERE s.publisher LIKE('%;%')

SELECT s.id as game_id, s.title, v.value AS publisher
INTO games_publisher
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.publisher, ';') as v

SELECT *
FROM dbo.games_publisher

-- genres standardized in new table

SELECT genres, COUNT(genres)
FROM dbo.games_data
GROUP BY genres
ORDER BY genres

SELECT s.title, s.id, s.genres, v.value
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.genres, ';') as v
WHERE s.genres LIKE('%;%')

SELECT s.id as game_id, s.title, v.value AS genres
INTO games_genres
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.genres, ';') as v
WHERE s.genres is not null

SELECT *
FROM dbo.games_genres

-- multiplayer_or_singleplayer standardized in new table

SELECT multiplayer_or_singleplayer, COUNT(multiplayer_or_singleplayer)
FROM dbo.games_data
GROUP BY multiplayer_or_singleplayer
ORDER BY multiplayer_or_singleplayer

SELECT s.title, s.id, s.multiplayer_or_singleplayer, v.value
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.multiplayer_or_singleplayer, ';') as v
WHERE s.multiplayer_or_singleplayer LIKE('%;%')

SELECT s.id as game_id, s.title, v.value AS player_type
INTO games_playertype
  FROM dbo.games_data AS s
  CROSS APPLY STRING_SPLIT(s.multiplayer_or_singleplayer, ';') as v

SELECT *
FROM dbo.games_playertype