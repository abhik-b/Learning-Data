use `world_layoffs`;

SELECT *
FROM layoffs_staging_2;


-- See the max laid off in 1 go
SELECT MAX(total_laid_off)
FROM layoffs_staging_2;

-- See the company who had the max laid off in 1 go
SELECT company, total_laid_off, `date`
FROM layoffs_staging_2
WHERE total_laid_off = (
    SELECT MAX(total_laid_off)
    FROM layoffs_staging_2
);
-- Google laid off 12000+ people in one go

-- Companies whose max percentage laid off is 1
SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- these are mostly startups it looks like who all went out of business during this time


-- Companies, Industries & their total layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;
-- Amazon, Google, Meta are also leaders in laying off

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;
-- Consumer industry lays off 45000+ 

SELECT country, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY country
ORDER BY 2 DESC;
-- India Ranks 2nd in laying off, USA being the 1st with 250000+ layoffs

SELECT stage, COUNT(*) AS num_layoffs, SUM(total_laid_off) AS total_laid_off
FROM layoffs_staging_2
GROUP BY stage
ORDER BY 3 DESC LIMIT 5;
-- Post-IPO companies accounted for the highest number of layoffs across all funding stages,
-- followed by companies with unknown funding, those that were acquired, 
-- and those in Series C and D stages.


SELECT stage, industry, SUM(total_laid_off) AS total
FROM layoffs
WHERE stage IN ('Post-IPO', 'Acquired', 'Series C', 'Series D')
GROUP BY stage, industry
ORDER BY stage, total DESC;




SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
) 
SELECT `MONTH`, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs_staging_2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 5
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Most affected industry each year:
WITH yearly_industry AS (
  SELECT YEAR(`date`) AS `year`, industry, SUM(total_laid_off) AS layoffs,
         RANK() OVER (PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC) AS `rank`
  FROM layoffs_staging_2
  GROUP BY `year`, industry
)
SELECT *
FROM yearly_industry
WHERE `rank` = 1;

