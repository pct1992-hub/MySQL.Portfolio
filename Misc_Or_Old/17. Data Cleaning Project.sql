-- Data Cleaning Project

SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Handle Null Values, or Blank Values
-- 4. Remove Any Unnessecary Columns; Very bad to do to the raw data. Should be done on a new table from the raw table

-- Remove Duplicates

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT *,
ROW_NUMBER() 
	OVER(
		PARTITION BY
		company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() 
	OVER(
		PARTITION BY
		company, 
        location, 
        industry, 
        total_laid_off, 
        percentage_laid_off, 
        `date`, 
        stage, 
        country, 
        funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1
;





CREATE TABLE `layoffs_staging2` (
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

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() 
	OVER(
		PARTITION BY
		company, 
        location, 
        industry, 
        total_laid_off, 
        percentage_laid_off, 
        `date`, 
        stage, 
        country, 
        funds_raised_millions) AS row_num
FROM layoffs_staging
;


SELECT *
FROM layoffs_staging2
WHERE row_num > 1
;

SET SQL_SAFE_UPDATES = 0;

DELETE
FROM layoffs_staging2
WHERE row_num > 1
;

-- Standardizing

SELECT company, TRIM(ccompany)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

# Changing industry types to be the same. e.g. 'Crypto' and 'cryptocurrency' into one single type
SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

# removing the trailing . from country column
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

# change date from a string to a date

SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y') ;

# Never do this to the raw data, only on intermediate table

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Handle NULL/missing values

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = ''
;

SELECT *
FROM layoffs_staging2
WHERE company = 'Airbnb'
;



# We see that Airbnb appears more than once; however, not all have '' in the industry column, so we can use the values from non-blank rows
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '') 
	AND t2.industry IS NOT NULL
;


# set blanks to NULL to make the next part easier
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = ''
;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
	AND t2.industry IS NOT NULL
;

# Cannot replace with non null value, because Bally's only occurs once, so we can't pull the value from a different row
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%'
;

SELECT *
FROM layoffs_staging2
;

# Want to remove rows that cannot be filled in based on any of the info possible. Potentially could get info from web 
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;
 
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

# Dropping the row_num column that is no longer needed

ALTER TABLE layoffs_staging2
DROP COLUMN row_num
;



















