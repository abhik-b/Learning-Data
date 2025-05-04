use `world_layoffs`;

SELECT * 
FROM layoffs;

-- Staging 
CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Display the Table
SELECT *
FROM layoffs;

-- 1. Remove Duplicates

-- First we check that by partitioning using the following columns can we get distinct rows 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`) as row_num
FROM layoffs;


-- Then we use that as a cte to select only the rows whose row number is one 
-- (who is present only once in this entire table)
WITH numbered_rows AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) as row_num
FROM layoffs
)
SELECT * 
FROM numbered_rows
WHERE row_num>1;


-- Now we will do create a new table layout staging 2
-- and within the table we will insert all the values along with row_num
CREATE TABLE `layoffs_staging_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_staging_2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY 
company,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) 
AS row_num
FROM layoffs;

-- And then delete duplicates based on the column row_num
SELECT *
FROM layoffs_staging_2
WHERE row_num > 1;

DELETE
FROM layoffs_staging_2
WHERE row_num > 1;


-- 2. Standardize data (maintain consistency)
SELECT DISTINCT TRIM(company)
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET company=TRIM(company);

SELECT *
FROM layoffs_staging_2
WHERE industry LIKE 'Crypto%';


SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET industry='Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET country=TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET `date`=STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT *
FROM layoffs_staging_2;

ALTER TABLE layoffs_staging_2
MODIFY COLUMN `date` DATE;

-- 3. Populate Null values (if necessary)


SELECT  t1.company,t1.industry, t2.industry
FROM layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = "")
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = "")
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging_2
SET industry = NULL 
WHERE industry = '';

UPDATE layoffs_staging_2 t1
JOIN layoffs_staging_2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;


DELETE 
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4. Remove any irrelevant columns 

ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;
