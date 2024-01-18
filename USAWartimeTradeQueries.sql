SELECT *
FROM USAWartimeTrade.dbo.Disputes

SELECT *
FROM USAWartimeTrade.dbo.Participants_Per_Dispute

SELECT *
FROM USAWartimeTrade.dbo.National_Trade

SELECT *
FROM USAWartimeTrade.dbo.Dyadic_Trade


-------------------------------------------------------------------
-- Disputes for Analysis
-------------------------------------------------------------------

-- WW1
SELECT *
FROM USAWartimeTrade.dbo.Participants_Per_Dispute
WHERE dispnum = 257

-- WW2
SELECT *
FROM USAWartimeTrade.dbo.Participants_Per_Dispute
WHERE dispnum = 258

-- Vietnam War
SELECT *
FROM USAWartimeTrade.dbo.Participants_Per_Dispute
WHERE dispnum = 611

-- Korean War
SELECT *
FROM USAWartimeTrade.dbo.Participants_Per_Dispute
WHERE dispnum = 51

-- Iran-Iraq War
SELECT *
FROM USAWartimeTrade.dbo.Participants_Per_Dispute
WHERE dispnum = 2115

-- Gulf War
SELECT *
FROM USAWartimeTrade.dbo.Participants_Per_Dispute
WHERE dispnum = 3957

-------------------------------------------------------------------

-- assign titles to disputes
ALTER TABLE USAWartimeTrade.dbo.Disputes
ADD warname varchar(50)

UPDATE USAWartimeTrade.dbo.Disputes
SET warname = 'World War I'
WHERE dispnum = '257'

UPDATE USAWartimeTrade.dbo.Disputes
SET warname = 'World War II'
WHERE dispnum = '258'

UPDATE USAWartimeTrade.dbo.Disputes
SET warname = 'Vietnam War'
WHERE dispnum = '611'

UPDATE USAWartimeTrade.dbo.Disputes
SET warname = 'Korean War'
WHERE dispnum = '51'

UPDATE USAWartimeTrade.dbo.Disputes
SET warname = 'Iran-Iraq War'
WHERE dispnum = '2115'

UPDATE USAWartimeTrade.dbo.Disputes
SET warname = 'Gulf War'
WHERE dispnum = '3957'

-- remove dispute records that are not related to analysis
DELETE
FROM USAWartimeTrade.dbo.Disputes
Where dispnum != 257 AND
	dispnum != 258 AND
	dispnum != 611 AND
	dispnum != 51 AND
	dispnum != 2115 AND
	dispnum != 3957

-- remove participant dispute records that are not related to analysis
DELETE
FROM USAWartimeTrade.dbo.Participants_Per_Dispute
Where dispnum != 257 AND
	dispnum != 258 AND
	dispnum != 611 AND
	dispnum != 51 AND
	dispnum != 2115 AND
	dispnum != 3957

-- remove columns from dispute records that are not related to analysis
ALTER TABLE USAWartimeTrade.dbo.Disputes
DROP COLUMN stday, stmon, endday, endmon, outcome, settle, fatality, fatalpre, maxdur, mindur, hiact, hostlev, recip, ongo2014, version

-- remove columns from participant dispute records that are not related to analysis
ALTER TABLE USAWartimeTrade.dbo.Participants_Per_Dispute
DROP COLUMN stday, stmon, endday, endmon, revstate, revtype1, revtype2, fatality, fatalpre, hiact, hostlev, orig, version

-- remove national trade records that are not related to analysis
DELETE
FROM USAWartimeTrade.dbo.National_Trade
WHERE ccode != 2 -- USA

-- remove dyadic trade records that are not related to analysis
DELETE
FROM USAWartimeTrade.dbo.Dyadic_Trade
WHERE ccode1 != 2 -- USA

-- remove columns from dyadic trade records that are not related to analysis
ALTER TABLE USAWartimeTrade.dbo.Dyadic_Trade
DROP COLUMN smoothflow1, smoothflow2, smoothtotrade,
	spike1, spike2, dip1, dip2, trdspike, tradedip,
	bel_lux_alt_flow1, bel_lux_alt_flow2, china_alt_flow1,
	china_alt_flow2, source1, source2, version

-- remove columns from national trade records that are not related to analysis
ALTER TABLE USAWartimeTrade.dbo.National_Trade
DROP COLUMN alt_imports, alt_exports, source1, source2, version


-- add top five USA trading partners to list
ALTER TABLE USAWartimeTrade.dbo.National_Trade
ADD first_trading_partner varchar(50),
	second_trading_partner varchar(50),
	third_trading_partner varchar(50),
	fourth_trading_partner varchar(50),
	fifth_trading_partner varchar(50)


-- change -9 (unknown) values to 0
UPDATE USAWartimeTrade.dbo.Dyadic_Trade
SET flow1 = '0'
WHERE flow1 = '-9'

UPDATE USAWartimeTrade.dbo.Dyadic_Trade
SET flow2 = '0'
WHERE flow2 = '-9'


-- delete unused countries from dyadic trade
DELETE
FROM USAWartimeTrade.dbo.Dyadic_Trade
WHERE (
	importer2 <> 'Italy' AND
	importer2 <> 'Japan' AND
	importer2 <> 'France' AND
	importer2 <> 'United Kingdom' AND
	importer2 <> 'Russia' AND
	importer2 <> 'Belgium' AND
	importer2 <> 'Canada' AND
	importer2 <>'Denmark' AND
	importer2 <> 'Greece' AND
	importer2 <> 'Iceland' AND
	importer2 <> 'Luxembourg' AND
	importer2 <> 'Netherlands' AND
	importer2 <> 'Norway' AND
	importer2 <> 'Portugal' AND
	importer2 <> 'Spain' AND
	importer2 <> 'Turkey' AND
	importer2 <> 'Australia' AND
	importer2 <> 'Luxembourg' AND
	importer2 <> 'Czechoslovakia' AND
	importer2 <> 'Hungary' AND
	importer2 <> 'Poland' AND
	importer2 <> 'Romania' AND
	importer2 <> 'Syria' AND
	importer2 <> 'Yugoslavia'
	)
	OR (year < 1947 OR year > 1991)

-- percent of US trade for first five years of Cold War
WITH PercentOfUSTrade (importer2, year, per) AS
(
	SELECT dya.importer2, dya.year, (CONVERT(float, flow2)) / (CONVERT(float, nat.imports) + CONVERT(float, nat.exports)) AS per
	FROM USAWartimeTrade.dbo.Dyadic_Trade dya
	JOIN USAWartimeTrade.dbo.National_Trade nat
	ON dya.year = nat.year
)
SELECT importer2, AVG(per) AS percent_of_US_trade_first_five_years
FROM PercentOfUSTrade
WHERE year <= 1951
GROUP BY importer2

-- percent of US trade for last five years of Cold War
WITH PercentOfUSTrade (importer2, year, per) AS
(
	SELECT dya.importer2, dya.year, (CONVERT(float, flow2)) / (CONVERT(float, nat.imports) + CONVERT(float, nat.exports)) AS per
	FROM USAWartimeTrade.dbo.Dyadic_Trade dya
	JOIN USAWartimeTrade.dbo.National_Trade nat
	ON dya.year = nat.year
)
SELECT importer2, AVG(per) AS percent_of_US_trade_last_five_years
FROM PercentOfUSTrade
WHERE year >= 1987
GROUP BY importer2