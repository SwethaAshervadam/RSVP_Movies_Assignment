USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:


-- Selecting the table name and number of rows from the INFORMATION_SCHEMA.TABLES view
SELECT 
    table_name,       
    table_rows        
FROM 
    INFORMATION_SCHEMA.TABLES  
WHERE 
    TABLE_SCHEMA = 'imdb';  -- Filtering by the schema named 'imdb'



-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Counting the number of NULL values in specific columns of the 'movie' table
SELECT
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS null_id,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS null_title,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS null_year,
    COUNT(CASE WHEN date_published IS NULL THEN 1 END) AS null_date_published,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS null_duration,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS null_country,
    COUNT(CASE WHEN worlwide_gross_income IS NULL THEN 1 END) AS null_worlwide_gross_income,
    COUNT(CASE WHEN languages IS NULL THEN 1 END) AS null_languages,
    COUNT(CASE WHEN production_company IS NULL THEN 1 END) AS null_production_company
FROM
    movie;

/*Result:
		Country, World wise gross income, languages and production company columns have null columns respectively.
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Total number of movies released each year
SELECT
    year,
    COUNT(*) AS number_of_movies
FROM
    movie
GROUP BY
    year
ORDER BY
    year;



/*Result:

The result is a table showing the total number of movies released each year.
Each row represents a unique year, and the corresponding 'number_of_movies' column indicates the count of movies released in that year.
 The highest number of movies is produced were in the year 2017 with 3052 movies followed by 2018 and 2019 with 2944 and 2001 movies respectively.
*/


-- Trend look month wise -- 

-- Common Table Expression (CTE) to extract the month and id from the 'date_published' column
WITH Months AS (
    SELECT
        MONTH(date_published) AS Month_num,
        id
    FROM
        movie
)
-- Main query to count the number of movies released each month
SELECT
    Month_num,
    COUNT(id) AS number_of_movies
FROM
    Months
GROUP BY
    Month_num
ORDER BY
    Month_num;



/* Result:
		The result is a table showing the trend of the number of movies released each month.
		Each row represents a unique month, and the corresponding 'number_of_movies' column indicates the count of movies released in that month.
        The highest number of movies is produced in the month of March with 824 movies followed by September and January.
*/








/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:


 -- Selecting the count of distinct movie IDs and the year from the movie table
SELECT
    Count(DISTINCT id) AS number_of_movies,  
    year                                     
FROM
    movie                                   
WHERE
    (country LIKE '%INDIA%' OR country LIKE '%USA%')  -- Filtering movies with country containing 'INDIA' or 'USA'
    AND year = 2019;                        		  -- Further filtering movies for the year 2019



/*Result:
		The result shows the count of distinct movies and the year, meeting the specified criteria.
			-- 1059 movies were produced in the USA or India in the year 2019
*/





/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


-- Selecting distinct genres from the 'genre' table
SELECT DISTINCT
    genre AS Genre
FROM
    genre;


/* Result:
		The result is a list of distinct genres available in the 'genre' table.
		Each row represents a unique genre, and the result set contains only one column named 'Genre' to show the distinct genres.
			-- Movies belong to 13 genres in the dataset.
*/







/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Selecting the genre and the count of movies for each genre, ordering by count in descending order and limiting to 1 result
SELECT
    genre,                               
    Count(id) AS number_of_movies			
FROM
    movie AS m                            	
    INNER JOIN genre AS g                 	
    ON g.movie_id = m.id                  	
GROUP BY
    genre                                	
ORDER BY
    number_of_movies DESC                 	-- Ordering the result by 'number_of_movies' in descending order
LIMIT 1;                                	-- Limiting the result to the first row (highest count)


/*Result:
		The result consists of the highest number of movies produced overall.
			-- 4285 Drama movies were produced in total and are the highest among all genres. 

*/



-- Selecting 'genre', 'year', and the maximum number of movies produced in a given genre in the last year - 2019
SELECT 
	genre, 
    year,
	max(num_of_movies) AS Max_num_of_movies
FROM 
(
/* Subquery ('tbl') that joins the 'movie' and 'genre' tables based on 'id' and 'movie_id'*/
SELECT 
	year, 
	genre, 
	count(id) AS num_of_movies
FROM movie
INNER JOIN  genre
ON movie.id=genre.movie_id
WHERE year = 2019	-- Filtering rows where the 'year' is 2019
GROUP BY genre	-- Grouping the result by 'genre' to count the number of movies in each genre
) tbl
	GROUP BY genre
	ORDER BY num_of_movies DESC
	LIMIT 1;		-- Limiting the result to only one row (the top row) to find the highest number





/*Result:
In the year 2019, the number of movies produced were 1078 from the Drama genre and are the highest among all genres. 
*/


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Creating a Common Table Expression (CTE) named GenreCounts for counting the number of genres each movie belongs to
WITH GenreCounts AS
(
SELECT
        movie_id,
        COUNT(genre) AS num_genres
    FROM
        genre
    GROUP BY
        movie_id
)
/*Counting the number of movies that belong to only one genre*/
SELECT
    COUNT(*) AS count_movies_single_genre
FROM
    GenreCounts
WHERE
    num_genres = 1;


/*Result:
		The result of this query will give you the count of movies that belong to only one genre.
			-- 3289 movies belong to only one genre.
*/





/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Creating a Common Table Expression (CTE) named MovieGenreDurations 
WITH MovieGenreDurations AS
(
    SELECT 
        genre,
        duration
    FROM movie m
    INNER JOIN genre g
    ON m.id = g.movie_id
)
-- Calculating the average duration for each genre using the CTE 
SELECT 
    genre,
    ROUND(AVG(duration), 2) AS avg_duration
FROM MovieGenreDurations
-- Grouping the results by genre 
GROUP BY genre
ORDER BY avg_duration DESC;


/*Result:
		The result shows the average duration for each genre based on the movies' durations in the movie and genre tables.
				-- Action genre has the highest duration of 112.88 minutes followed by Romance and Crime genres.
                -- The Drama genre has the average duration of 107.66 minutes.
*/







/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


-- Creating a Common Table Expression (CTE) named Genre_count
WITH Genre_count AS (
    SELECT 
        genre, 
        COUNT(id) AS movie_count
    FROM 
        movie m
        INNER JOIN genre g ON m.id = g.movie_id
    --  Grouping the results by genre
    GROUP BY genre
)
--  Ranking genres based on the number of movies produced
SELECT 
    *,
    RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
FROM Genre_count;





/*Result:
		The 'thriller' genre holds the third position among all genres in terms of the number of produced movies, with a count of 1484 movies. */



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:



-- Selecting minimum and maximum values for various rating-related metrics from the 'ratings' table
select 
    min(avg_rating) as min_avg_rating,
    max(avg_rating) as max_avg_rating,
    min(total_votes) AS min_total_votes,
    max(total_votes) AS max_total_votes,
    min(median_rating) AS min_median_rating,
    max(median_rating) AS max_median_rating
from ratings;



/*Result:
		-- Average ratings range from 1.0 to 10.0.
		-- Total votes for entries range from 100 to 725,138.
		-- Median ratings range from 1 to 10.
*/


   

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Creating a Common Table Expression (CTE) named Top10Movies
-- This CTE selects the title, average rating, and assigns a dense rank based on average rating in descending order
WITH Top10Movies AS (
    SELECT
        title,
        avg_rating,
        DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS avg_rank
    FROM
        movie m
        INNER JOIN ratings r ON m.id = r.movie_id
    LIMIT 10 		
)
-- Selecting columns from the Top10Movies CTE 
SELECT
    title,
    avg_rating,
    ROW_NUMBER() OVER () AS movie_rank			
FROM
    Top10Movies;



/*Result: 
			Top 3 movies have average rating >= 9.8
*/





/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have


-- Selecting median rating and counting the number of movies for each median rating in ascending order
SELECT 
    median_rating, 
	count(movie_id) AS movie_count		 
FROM ratings		
GROUP BY median_rating			
ORDER BY median_rating;			


/*Result:
		A list of median ratings along with the count of movies for each unique median rating, ordered by median rating in ascending order.
        Movies with a median rating of 7 is highest in number with movie count of 2257.
*/



/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


-- Selecting production company, counting the number of movies, and calculating the dense rank
SELECT 
    production_company, 
    count(id) AS movie_count,
    DENSE_RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie m
INNER JOIN ratings r 
ON m.id = r.movie_id
-- Filtering the results based on average rating, production company, and excluding null production companies
WHERE avg_rating > 8 AND production_company IS NOT NULL
GROUP BY production_company 
ORDER BY movie_count DESC;



/*Result:
		A list of production companies along with the count of movies for each unique production company, 
		and a dense rank based on the count of movies in descending order. The results are ordered by the movie count in descending order.
			-- Dream Warrior Pictures and National Theatre Live production houses have produced the most number of hit movies (average rating > 8)
			-- They have rank=1 and movie count =3 
*/


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Selecting genre and the count of movies in each genre
SELECT 
    genre, 
    COUNT(id) AS movie_count
FROM 
    movie m
INNER JOIN 
    genre g ON m.id = g.movie_id
INNER JOIN 
    ratings r ON m.id = r.movie_id
-- Filtering the results based on certain conditions
WHERE 
    year = '2017' 
    AND MONTH(date_published) = 3
    AND total_votes > 1000 
    AND country LIKE '%USA%'
GROUP BY 
    genre
ORDER BY 
    movie_count DESC;



/*Result:
		The resulting table displays the number of movies within each genre that were released in March 2017, received over 1000 total votes, and originated from the United States.
			-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
			-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes
*/





-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Selecting movie title, average rating, and genre
SELECT 
    title,
    avg_rating,
    genre
FROM 
    movie m
INNER JOIN 
    genre g ON m.id = g.movie_id
INNER JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    title LIKE 'the%' 		-- Movies with titles starting with 'the'
    AND avg_rating > 8 		-- Movies with an average rating greater than 8
ORDER BY
	avg_rating DESC;



/*Result:
		The result table includes movies with titles starting with "The" and having an average rating greater than 8. 
        The columns show the movie title, average rating, and genre.
			-- There are 8 movies which begin with "The" in their title.
			-- The Brighton Miracle has highest average rating of 9.5.
			-- All the movies belong to the top 3 genres.

*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


-- Selecting the median rating and the count of movies for significant insights
SELECT 
	median_rating,
	count(*) AS movies_count
FROM 
	movie m
INNER JOIN 
	ratings r ON m.id = r.movie_id
WHERE 
	date_published BETWEEN '2018-04-01' AND '2019-04-01' 	-- Movies released between April 1, 2018, and April 1, 2019
	AND median_rating = 8 									-- Movies with a median rating of 8
GROUP BY 
	median_rating;



/*Result:
		The result of this query includes the median ratings and the count of movies for each median rating group where the movies meet the specified conditions.
        -- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8
*/



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:


-- Selecting the country and the sum of total votes for movies to find the total number of votes
SELECT
    country,
    SUM(total_votes) AS total_votes
FROM
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
WHERE
    country IN ('Germany', 'Italy') 			-- Selecting movies from Germany and Italy
GROUP BY
    country;


/*Result:
		It includes the country and the total sum of votes for movies from Germany and Italy, with each row representing a different country.
        -- By observation, German movies received the highest number of votes when queried against language and country columns.
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Counting the number of NULL values in different columns of the 'names' table
SELECT
    COUNT(CASE WHEN name IS NULL THEN 1 END) AS name_nulls,
    COUNT(CASE WHEN height IS NULL THEN 1 END) AS height_nulls,
    COUNT(CASE WHEN date_of_birth IS NULL THEN 1 END) AS date_of_birth_nulls,
    COUNT(CASE WHEN known_for_movies IS NULL THEN 1 END) AS known_for_movies_nulls
    FROM
    names;


/*Result:
	The result of this query would be a single row with columns indicating the count of NULL values for each respective column in the 'names' table.
		-- Height, date_of_birth, known_for_movies columns contain NULLS

*/




/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Common Table Expression (CTE) to find the top 3 genres based on the number of movies produced in each genre
WITH top_3_genres AS 
(
    SELECT
        *,
        RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
    FROM 
    (
        -- Subquery to calculate the count of movies for each genre
        SELECT
            genre,
            COUNT(id) AS movie_count
        FROM
            movie m
            INNER JOIN genre g ON m.id = g.movie_id
            INNER JOIN ratings USING (movie_id)
		WHERE 
			avg_rating > 8
        GROUP BY
            genre
    ) tbl
    LIMIT 3				-- Limiting the result to the top 3 genres
)
-- Main query to find the top 3 directors based on the count of movies with an average rating greater than 8
SELECT
    NAME AS director_name,
    COUNT(movie_id) AS movie_count
FROM
    director_mapping dm
    INNER JOIN genre USING (movie_id)
    INNER JOIN names n ON dm.name_id = n.id
    INNER JOIN top_3_genres USING (genre)
    INNER JOIN ratings USING (movie_id)
WHERE
    avg_rating > 8				-- Filtering movies with an average rating greater than 8
GROUP BY
    director_name
ORDER BY
    movie_count DESC
LIMIT 3;					-- Limiting the result to the top 3 directors

 

/*Result:
		-- James Mangold , Anthony Russo and Soubin Shahir are top three directors in the top three genres whose movies have an average rating > 8

*/


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


/* Selecting the actor name and the count of movies they have been a part of, 
  where the median rating of the movies is greater than or equal to 8 */
SELECT 
    n.name AS actor_name,
    COUNT(m.id) AS movie_count
FROM 
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN role_mapping rol USING (movie_id)
    INNER JOIN names n ON rol.name_id = n.id
WHERE 
    median_rating >= 8				-- Filtering movies with a median rating greater than or equal to 8
GROUP BY 
    actor_name
ORDER BY 
    movie_count DESC
LIMIT 2;			-- Limiting the result to the top 2 actors




/*Result:
		The first two actors with the highest movie counts, where the median rating of the associated movies is greater than or equal to 8, are displayed. 
			-- Top two actors are Mammootty and Mohanlal.
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


/* Selecting the production company, the sum of total votes for their movies, 
   and the rank of the production company based on the total votes in descending order */
SELECT 
    production_company,
    SUM(total_votes) AS vote_count,
    RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
    movie m
    INNER JOIN ratings r ON m.id = r.movie_id
WHERE 
    production_company IS NOT NULL
GROUP BY 
    production_company
ORDER BY 
    vote_count DESC
LIMIT 3;			-- Limiting the result to the top 3 production companies



/* Result:
		The top 3 production companies are displayed, showing their names, the sum of total votes for their movies, and their rank based on total votes. 
        -- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.

*/




/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- Common Table Expression (CTE) to calculate aggregated data for actors in India
WITH actor_stats AS (
    -- Selecting actor-related statistics for the CTE
    SELECT
        n.name AS actor_name,                   
        SUM(total_votes) AS total_votes,        
        COUNT(m.id) AS movie_count,             
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating  		-- Calculating the weighted average rating per actor
    FROM
        movie m
        INNER JOIN ratings r ON m.id = r.movie_id
        INNER JOIN role_mapping rol USING (movie_id)
        INNER JOIN names n ON rol.name_id = n.id
    WHERE
        country = 'India' AND rol.category = 'Actor'  			-- Filtering for actors in India
    GROUP BY
        actor_name  
	HAVING
		movie_count=5 			-- The actor having acted in five Indian movies. 
)
-- Main query to select data from the CTE and add ranking based on actor_avg_rating
SELECT
    *,
    RANK() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank  
FROM
    actor_stats
ORDER BY
    actor_avg_rating DESC;  
    

/*Result:
		The columns include the actor's name, total votes, movie count, actor's average rating, and the actor's rank based on average rating. 
        -- Top actor is Vijay Sethupathi followed by Fahadh Faasil and Joju George.
*/


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- Common Table Expression (CTE) to calculate aggregated data for actresses in India
WITH actress_stats AS (
    -- Selecting actress-related statistics for the CTE
    SELECT
        n.name AS actress_name,                 
        SUM(total_votes) AS total_votes,        
        COUNT(m.id) AS movie_count,             
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating  	-- Calculating the weighted average rating per actress
    FROM
        movie m
        INNER JOIN ratings r ON m.id = r.movie_id
        INNER JOIN role_mapping rol USING (movie_id)
        INNER JOIN names n ON rol.name_id = n.id
    WHERE
        country = 'India' AND rol.category = 'Actress' AND m.languages like '%Hindi%'  		-- Filtering for actresses in India who acted in Hindi movies
    GROUP BY
        actress_name
    HAVING
        movie_count >= 3  		
    ORDER BY
        movie_count DESC  
)
-- Main query to select data from the CTE and add ranking based on actress_avg_rating
SELECT
    *,
    RANK() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank  
FROM
    actress_stats
LIMIT 5;  			-- Limiting the final result to the top 5 actresses




/*Result:
		 The columns include the actress's name, total votes, movie count, actress's average rating, and the actress's rank based on average rating. 
         -- Top five actresses in Hindi movies released in India based on their average ratings are Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda
		 -- Taapsee Pannu tops with average rating 7.74. 
*/



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


-- Selecting the title, average rating, and categorizing movies based on their average rating for the 'Thriller' genre
SELECT 
    title,
    avg_rating,
    CASE 
        -- The CASE statement categorizes movies into different categories (Superhit, Hit, One-time-watch, or Flop) based on their average rating.
        WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
        ELSE 'Flop movies'
    END AS avg_rating_thriller_category
FROM 
    movie m										
    INNER JOIN ratings r ON m.id = r.movie_id	
    INNER JOIN genre USING (movie_id)			
WHERE 
    genre = 'Thriller';  		-- Filtering movies with the 'Thriller' genre


/*Result:
		'Thriller' genre movies are categorized according to CASE statement.
*/



/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


-- Selecting genre, average duration, running total duration, and moving average duration for each genre
SELECT 
    genre,
    ROUND(AVG(duration)) AS avg_duration,
    SUM(ROUND(AVG(duration), 1)) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(ROUND(AVG(duration), 2)) OVER (ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM 
    movie AS m 
    INNER JOIN genre AS g ON m.id = g.movie_id
GROUP BY 
    genre
ORDER BY 
    genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Common Table Expression (CTE) to find the top 3 genres based on the number of movies produced in each genre
WITH top_3_genres AS 
(
    SELECT
        *,
        RANK() OVER (ORDER BY movie_count DESC) AS genre_rank
    FROM 
    (
        -- Subquery to calculate the count of movies for each genre
        SELECT
            genre,
			COUNT(id) AS movie_count
        FROM
            movie m
            INNER JOIN genre g ON m.id = g.movie_id
        GROUP BY
            genre
    ) tbl
    LIMIT 3			-- Limiting the result to the top 3 genres
)
-- Selecting genre, year, title, worldwide gross income, and movie rank for the top 5 movies in each genre
SELECT 
    genre,
    year,
    title AS movie_name,
    worlwide_gross_income,
    DENSE_RANK() OVER (ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM 
    movie m
    INNER JOIN genre g ON m.id = g.movie_id
WHERE 
    genre IN (SELECT genre FROM top_3_genres)  		-- Filtering movies only for genres in the top 3 genres
LIMIT 5;  	-- Limiting the result to the top 5 movies



/*Result:
The top 5 movies from the top three genres are 'Shatamanam Bhavati', 'Winner', 'The Villain', 'Thank You for Your Service' and 'Antony & Cleopatra'.
*/



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


-- Selecting production companies and their respective movie counts, calculating a dense rank based on movie count
SELECT
    *,
    DENSE_RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
FROM
    (
        -- Subquery to calculate movie counts for each production company
        SELECT
            production_company,
            COUNT(id) AS movie_count
        FROM
            movie m
            INNER JOIN ratings r ON m.id = r.movie_id
        WHERE
            median_rating >= 8
            AND production_company IS NOT NULL
            AND POSITION(',' IN languages) > 0
        GROUP BY
            production_company
    ) tbl
LIMIT 2; 			-- Limiting the result to the top 2 production companies based on movie count



/*Result:
		The top two production companies based on the highest number of hits among multilingual movies are Star Cinema and Twentieth Century Fox.
*/




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- Common Table Expression (CTE) to calculate aggregated data for actresses in Drama genre
WITH ActressStats AS (
    SELECT
        name AS actress_name,
        SUM(total_votes) AS total_votes,
        COUNT(m.id) AS movie_count,
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating
    FROM
        movie m
        INNER JOIN ratings r ON m.id = r.movie_id
        INNER JOIN genre USING (movie_id)
        INNER JOIN role_mapping rol USING (movie_id)
        INNER JOIN names n ON rol.name_id = n.id
    WHERE
        category = 'actress'	
        AND genre = 'Drama'		
        AND avg_rating > 8		
    GROUP BY
        actress_name
)
-- Main query to select information about the top 3 actresses from the CTE
SELECT
    *,
    RANK() OVER (ORDER BY movie_count DESC) AS actress_rank
FROM
    ActressStats
LIMIT 3; 			-- Limiting the result to the top 3 actresses based on movie count



/*Result: 
		The top 3 actresses  based on number of Super Hit movies in drama genre are Parvathy Thiruvothu , Susan Brown and Amanda Lawrence */


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:



-- Common Table Expression (CTE) to calculate details for directors
WITH directors_details AS 
(
    SELECT
        *,
        DATEDIFF(next_date_published, date_published) AS date_difference
    FROM
        (
            -- Subquery to gather information about directors and their movies
            SELECT
                dir.name_id,
                n.name AS director_name,
                dir.movie_id,
                duration,
                avg_rating,
                total_votes,
                m.date_published,
                LEAD(date_published, 1) OVER (PARTITION BY dir.name_id ORDER BY date_published, movie_id) AS next_date_published
            FROM
                movie m
                INNER JOIN ratings r ON m.id = r.movie_id
                INNER JOIN director_mapping dir USING (movie_id)
                INNER JOIN names n ON dir.name_id = n.id
        ) tbl
)
-- Main query to select aggregated information about directors
SELECT
    name_id AS director_id,
    director_name AS director_name,
    COUNT(movie_id) AS number_of_movies,
    ROUND(AVG(date_difference)) AS avg_inter_movie_days,
    ROUND(AVG(avg_rating), 2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM
    directors_details
GROUP BY
    director_id
ORDER BY
    COUNT(movie_id) DESC
LIMIT 9;			-- The result set is limited to the top 9 directors based on the count of movies.


/*Result:
		The top director based on the count of movies is Andrew Jones with the Average inter movie duration in 191 days.
*/

-- Average inter movie duration in days
