-- Quiz Funnel: Step 1

-- [SLIDE 4] 

-- What columns does the table have?

SELECT *
FROM survey
LIMIT 10;

-- Quiz Funnel: Step 2

-- [SLIDE 4] 

-- What is the number of responses for each question?

-- The number of responses for each question is 500, 475, 380, 361, 270.

SELECT question, 
  COUNT(DISTINCT user_id)
FROM survey
GROUP BY 1;


-- Quiz Funnel: Step 3

-- Which question(s) of the quiz have a lower completion rate?

-- [SLIDES 5-6] Used spreadsheet to calculate completion rates 

-- [SLIDE 5] Analyzed customers' preference for the various shapes with this query: 

SELECT question, 
   response, 
   COUNT(response) AS 'num_responses'
FROM survey
WHERE question LIKE '3%'
GROUP BY response
ORDER BY 3 DESC;

-- The above query shows each rectangular and square together make up 68% of selections.

-- [SLIDE 6]

/* [SLIDE 6] uses the same query that produced the funnel [SLIDES 3-4] and the same spreadsheet calculations to arrive at 20% drop from question 4 to 5. My reasoning follows from an analysis of typical funnel behavior
and general thought about the question. */


-- Home Try-On Funnel: Step 4

-- [SLIDE 8]

-- Examine the first five rows of each table. What are the column names?

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;

/* Let's find out whether or not users who get more pairs to try on at home will be more likely to make a purchase (i.e. 3 pairs in the home try-on set or 5 pairs in the home try-on set).

This statement requests the same info as listed in step 6. I deal with this later in [SLIDE 11]. */



-- Home Try-On Funnel: Step 5

/* Use a LEFT JOIN to combine the quiz, home_try_on, and purchase tables together, 
starting with the top of the funnel (quiz) and ending with the bottom of the funnel (purchase)
Select only the first 10 rows from this table. */

SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;



-- Home Try-On Funnel: Step 6

-- [SLIDES 7-8]

/* I'm figuring out the amount of people who went through each stage of the conversion funnel, and I'm calculating the overall conversion rate (as decimal and I convert to percentage for the slides). */

WITH conversion_funnel AS (SELECT DISTINCT q.user_id AS 'quiz_takers',
   h.user_id IS NOT NULL AS 'is_home_try_on',
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)
SELECT COUNT(quiz_takers) AS 'num_quiz', 
   SUM(is_home_try_on) AS 'num_try_on', 
   SUM(is_purchase) AS 'num_purchase',
(1.0 * SUM(is_purchase) / COUNT(quiz_takers)) AS 'overall_conversion_rate'
FROM conversion_funnel;



-- [SLIDE 9]

/* Seeing if style choices played a role in why 250 people chose to not proceed with stage 2 of the conversion funnel: Home Try-On. The following query gives me the style breakdown for those 250 people. */

SELECT style, 
   COUNT(*) AS 'style_count'
FROM quiz q
LEFT JOIN home_try_on h
	ON q.user_id = h.user_id
WHERE h.user_id IS NULL
GROUP BY 1
ORDER BY 2 DESC;



-- [SLIDE 10]

/* I'm trying to figure out why 255 people did not proceed with a purchase after home try-on.
These queries show the breakdown of their quiz choices. */

-- Style choices of the 255 people who did not move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NULL)
SELECT style, 
   count(*) AS 'num_style'
FROM why_no_conversion
GROUP BY 1;

-- Fit choices of the 255 people who did not move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NULL)
SELECT fit, 
   count(*) AS 'num_fit'
FROM why_no_conversion
GROUP BY 1;

-- Shape choices of the 255 people who did not move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NULL)
SELECT shape, 
   count(*) AS 'num_shape'
FROM why_no_conversion
GROUP BY 1;

-- Color choices of the 255 people who did not move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NULL)
SELECT color, 
   count(*) AS 'num_color'
FROM why_no_conversion
GROUP BY 1;

-- Now looking at purchasers

-- Style choices of the 495 people who did move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NOT NULL)
SELECT style, 
   count(*) AS 'num_style'
FROM why_no_conversion
GROUP BY 1;

-- Fit choices of the 495 people who did move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NOT NULL)
SELECT fit, 
   count(*) AS 'num_fit'
FROM why_no_conversion
GROUP BY 1;

-- Shape choices of the 495 people who did move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NOT NULL)
SELECT shape, 
   count(*) AS 'num_shape'
FROM why_no_conversion
GROUP BY 1;

-- Color choices of the 495 people who did move from home_try_on to purchase

WITH why_no_conversion AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON h.user_id = q.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE h.user_id IS NOT NULL AND
p.user_id IS NOT NULL)
SELECT color, 
   count(*) AS 'num_color'
FROM why_no_conversion
GROUP BY 1;

/* Double checking to see if any of the people who listed "I'm not sure. Let's skip it." for their style choice on the quiz ever made it to a purchase. */

-- 99 selected "I'm not sure. Let's skip it."

SELECT style, 
   COUNT(*)
FROM quiz
WHERE style LIKE 'I%';

-- 99 NULL in purchase table with style choice containing "I'm not sure. Let's skip it".

WITH doubters_purchasing AS (SELECT *
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
WHERE q.style LIKE 'I%')
SELECT COUNT(user_id IS NULL)
FROM doubters_purchasing;

-- Visual confirmation of table results also possible without even using SELECT COUNT in the last query.



-- [SLIDE 11]

/* We can calculate the difference in purchase rates between customers who had 3 number_of_pairs with ones who had 5. */

-- First let's find out how many people tried on 3 pairs of glasses vs 5 pairs of glasses

SELECT number_of_pairs, 
   COUNT(DISTINCT h.user_id) AS 'num_home_try_on'
FROM home_try_on h
GROUP BY number_of_pairs;

-- Next let's figure out how many people purchased when they received 3 pairs of glasses vs 5 pairs of glasses

SELECT number_of_pairs, 
   COUNT(DISTINCT p.user_id) AS 'num_purchase'
FROM home_try_on h
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE p.user_id IS NOT NULL
GROUP BY number_of_pairs;



-- [SLIDE 12] 

-- Comparing color from the people who took the quiz and color from the purchasers.

SELECT color, 
  COUNT(*) AS 'count'
FROM quiz
GROUP BY 1
ORDER BY 2 DESC;

SELECT color, 
  COUNT(*) AS 'count'
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;


-- [SLIDE 13]

/* Next, I wanted to confirm as best as possible using the filters on warbyparker.com which generic color "Driftwood Fade" and "Sea Glass Gray" belonged to. All the other colors like "Jet Black" or "Rosewood Tortoise" contained the name of their generic color but these ones didn't. With these results, I could complete the newly aligned quiz/purchase color comparison */

SELECT color, 
  model_name
FROM purchase
WHERE color LIKE '%sea%'
    OR color LIKE '%drift%'
GROUP BY 1;


-- [SLIDE 14] is an intro slide to [SLIDES 15-19].

-- [SLIDE 15]

-- Looking at style selections from the quiz

SELECT style, 
  COUNT(style)
FROM quiz
GROUP BY 1;

-- Looking at fit selections from the quiz

SELECT fit, 
  COUNT(fit)
FROM quiz
GROUP BY 1;

-- Looking at shape selections from the quiz

SELECT shape, 
  COUNT(shape)
FROM quiz
GROUP BY 1;


-- [SLIDE 16]


/* Joining quiz, home try-on, and purchase together 
so that I can trace the most popular "style" choices among customers who purchased. */

SELECT q.style, 
   COUNT(q.style) AS 'num_style'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE p.user_id IS NOT NULL
GROUP BY q.style;


/* Joining quiz, home try-on, and purchase together 
so that I can trace the most popular "fit" choices among customers who purchased. */

SELECT q.fit, 
   COUNT(q.fit) AS 'num_fit'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE p.user_id IS NOT NULL
GROUP BY fit;


/* Joining quiz, home try-on, and purchase together 
so that I can trace the most popular "shape" choices among customers who purchased. */


SELECT q.shape, 
   COUNT(q.shape) AS 'num_shape'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON h.user_id = p.user_id
WHERE p.user_id IS NOT NULL
GROUP BY q.shape;


-- [SLIDES 17-19] analyze the results of the above queries located on [SLIDES 15-16].


-- [SLIDES 20-21]

-- I use the following query and transfer the results to a spreadsheet to perform calculations

SELECT model_name, 
   COUNT(model_name) AS 'num_models_purchased',
   price
FROM purchase
GROUP BY 1
ORDER BY 2 DESC;

/* I used this query and research on the Warby Parker website to confirm which colors mapped to which models.
Combining my analysis from the color analysis on [SLIDES 12-13], I'm able to arrive at my recommendations. */

SELECT model_name, color
FROM purchase
GROUP BY 2
ORDER BY 1 ASC;


-- [SLIDES 22-24]

-- This query shows me all the men's glasses ranked by gross sales.

SELECT style, 
   model_name, 
   COUNT(model_name) AS 'total volume',
   SUM(price) AS 'total gross sales'
FROM purchase
WHERE style LIKE 'M%'
GROUP BY 2
ORDER BY 4 DESC;

-- This query shows me all the men's glasses ranked by total volume.

SELECT style, 
   model_name, 
   COUNT(model_name) AS 'total volume',
   SUM(price) AS 'total gross sales'
FROM purchase
WHERE style LIKE 'M%'
GROUP BY 2
ORDER BY 3 DESC;


-- [SLIDES 25-27]

-- This query shows me all the women's glasses ranked by total volume.

SELECT style, 
   model_name, 
   COUNT(model_name) AS 'total volume',
   SUM(price) AS 'total gross sales'
FROM purchase
WHERE style LIKE 'W%'
GROUP BY 2
ORDER BY 3 DESC;


-- This query shows me all the women's glasses ranked by gross sales.

SELECT style, 
   model_name, 
   COUNT(model_name) AS 'total volume',
   SUM(price) AS 'total gross sales'
FROM purchase
WHERE style LIKE 'W%'
GROUP BY 2
ORDER BY 4 DESC;


-- [SLIDES 28-29]

-- This query shows me all glasses ranked by total volume.

SELECT style, 
   model_name, 
   COUNT(model_name) AS 'total volume',
   SUM(price) AS 'total gross sales'
FROM purchase
GROUP BY 2
ORDER BY 3 DESC;


-- This query shows me all glasses ranked by gross sales.

SELECT style, 
   model_name, 
   COUNT(model_name) AS 'total volume',
   SUM(price) AS 'total gross sales'
FROM purchase
GROUP BY 2
ORDER BY 4 DESC;

-- [SLIDE 30]

-- This is a summary slide of all actionable insights. Please refer to above queries.




