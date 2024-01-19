----------------------------------------------------------------
-- DATA CLEANING
----------------------------------------------------------------

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET difficulty = 'novice'
WHERE difficulty = 'novic'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET difficulty = 'intermediate'
WHERE difficulty = 'intermediat'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET difficulty = 'advanced'
WHERE difficulty = 'advance'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET capo = ' 1st fret'
WHERE capo = ' 1st fre'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET capo = ' 2nd fret'
WHERE capo = ' 2nd fre'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET capo = ' 3rd fret'
WHERE capo = ' 3rd fre'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET capo = ' 4th fret'
WHERE capo = ' 4th fre'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET capo = ' 5th fret'
WHERE capo = ' 5th fre'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET capo = ' 6th fret'
WHERE capo = ' 6th fre'

-- fix spelling errors
UPDATE UltimateGuitarHits.dbo.gutiarDB
SET capo = ' 7th fret'
WHERE capo = ' 7th fre'

----------------------------------------------------------------
-- DATA EXPLORATION
----------------------------------------------------------------

-- • Who are the most popular artists?
-- • Who are the highest rated artists?
-- • How does difficulty affect number of hits?
-- • What difficulty has the highest average rating?
-- • How does capo position affect rating?
-- • What capo position has the highest average rating?


SELECT *
FROM UltimateGuitarHits.dbo.gutiarDB


-- artists ranked by number of hits
SELECT Artist, COUNT(Artist) as num_songs
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY Artist
ORDER BY num_songs desc

-- top 5 artists ranked by number of hits
SELECT TOP 5 Artist, COUNT(Artist) as num_songs
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY Artist
ORDER BY num_songs desc

-- top 10 artists ranked by number of hits
SELECT TOP 10 Artist, COUNT(Artist) as num_songs
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY Artist
ORDER BY num_songs desc

-- artists ranked by song_rating/song_hits
SELECT artist, SUM(song_rating) / SUM(song_hits) as prop
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY artist
ORDER BY prop desc

-- difficulties ranked by number of hits
SELECT difficulty, SUM(song_hits) as hits
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY difficulty
ORDER BY hits desc

-- difficulty ranked by song_rating/song_hits
SELECT difficulty, SUM(song_rating) / SUM(song_hits) as prop
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY difficulty
ORDER BY prop desc

-- capo ranked by song_rating/song_hits
SELECT capo, SUM(song_rating) / SUM(song_hits) as prop
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY capo
ORDER BY prop desc

-- page_type by count
SELECT page_type, COUNT(page_type) as cnt
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY page_type
ORDER BY cnt desc

-- song_key capo combo by count
SELECT song_key, capo, COUNT(song_key) as cnt
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY song_key, capo
ORDER BY cnt desc


----------------------------------------------------------------
-- CREATE VIEWS
----------------------------------------------------------------

-- artists ranked by number of hits
CREATE VIEW ArtistsRankedByHits AS
SELECT Artist, COUNT(Artist) as num_songs
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY Artist

-- top 5 artists ranked by number of hits
CREATE VIEW TopFiveArtistsRankedByHits AS
SELECT TOP 5 Artist, COUNT(Artist) as num_songs
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY Artist
ORDER BY num_songs desc

-- top 10 artists ranked by number of hits
CREATE VIEW TopTenArtistsRankedByHits AS
SELECT TOP 10 Artist, COUNT(Artist) as num_songs
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY Artist
ORDER BY num_songs desc

-- artists ranked by song_rating/song_hits
CREATE VIEW ArtistsRankedByRating AS
SELECT artist, SUM(song_rating) / SUM(song_hits) as prop
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY artist

-- difficulties ranked by number of hits
CREATE VIEW DifficultiesRankedByHits AS
SELECT difficulty, SUM(song_hits) as hits
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY difficulty

-- difficulty ranked by song_rating/song_hits
CREATE VIEW DifficultiesRankedByRating AS
SELECT difficulty, SUM(song_rating) / SUM(song_hits) as prop
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY difficulty

-- capo ranked by song_rating/song_hits
CREATE VIEW CaposRankedByRating AS
SELECT capo, SUM(song_rating) / SUM(song_hits) as prop
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY capo

-- page_type by count
CREATE VIEW PageTypeRankedByCount AS
SELECT page_type, COUNT(page_type) as cnt
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY page_type

-- song_key capo combo by count
CREATE VIEW SongKeyCapoRankedByCount AS
SELECT song_key, capo, COUNT(song_key) as cnt
FROM UltimateGuitarHits.dbo.gutiarDB
GROUP BY song_key, capo
