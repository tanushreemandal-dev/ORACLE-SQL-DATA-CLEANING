select * 
from LAYOFFS;

select count(*)
from layoffs;

-- to see the column names,their respective data types and data length of layoffs table
SELECT column_name, data_type, data_length
FROM user_tab_columns
WHERE table_name = 'LAYOFFS';

-- creatig a copy of layoffs table and data
create table layoffs_copy as
select *
from layoffs;

select * 
from LAYOFFS_COPY;

-- filtering duplicates
with filter_duplicates as(
   select lc.*,row_number()over(partition by company,location,total_laid_off,"date",PERCENTAGE_LAID_OFF,industry,stage,
   funds_raised_millions,country order by company) row_num 
   from layoffs_copy lc
)
select *
from filter_duplicates
where row_num>1;

select *
from LAYOFFS_COPY
where company='Casper'

-- deleting duplicate rows by creating another table
create table layoffs_copy1 as 
select lc.*,
row_number()over(partition by company,location,total_laid_off,"date",PERCENTAGE_LAID_OFF,industry,stage,
   funds_raised_millions,country order by company) row_num 
   from layoffs_copy lc;

select *
from LAYOFFS_COPY1
where row_num>1;

delete 
from LAYOFFS_COPY1
where row_num>1;

--standardising data
select company
from layoffs_copy1;

update layoffs_copy1
set company=trim(company);

-- displayed all distinct industry names
select distinct industry
from layoffs_copy1
order by 1;

--display everything where industry name contains crypo in it
select *
from layoffs_copy1
where industry like 'Crypto%';

-- changed the industry name from cryptocurrency to crypto wheerever present
update layoffs_copy1
set industry ='Crypto'
where industry like 'Crypto%';

select distinct location 
from layoffs_copy1
order by 1;

select distinct country
from layoffs_copy1
order by 1;

update layoffs_copy1
set country='United States'
where country like 'United States%';

select "date"
from layoffs_copy1;

-- changing data type of date column from timestamp to date
-- 1)adding a new temporary DATE column
alter table layoffs_copy1 
add new_date date;

-- 2)converting and filling the date values(extracting YYYY-MM-DD)
UPDATE layoffs_copy1 
SET new_date = TO_DATE(SUBSTR("date",1,10),'YYYY-MM-DD');

-- 3)drop the original column
alter table layoffs_copy1
drop column "date";

-- 4)rename the new column to "date"
ALTER TABLE layoffs_copy1 
RENAME COLUMN new_date TO "date";

SELECT column_name, data_type, data_length
FROM user_tab_columns
WHERE upper(table_name)='LAYOFFS_COPY1';

-- NULL VALUES
select *
from layoffs_copy1
where total_laid_off='NULL' -- here NULL is stored as text that's why we have to mention 'NULL'
and PERCENTAGE_LAID_OFF='NULL';

select *
from layoffs_copy1
where industry='NULL'
or industry is null;

select *
from layoffs_copy1
where company='Airbnb';

select *
from layoffs_copy1
where company like 'Bally%' ;

-- populating null value
update layoffs_copy1
set industry='Travel'
where company='Airbnb' and industry is null;

-- finding the industries of respective companies which have null values in industry
select *
from LAYOFFS_COPY1 l1
join layoffs_copy1 l2
on l1.company=l2.company
where (l1.industry is null or l1.industry='NULL')
and (l2.industry is not null and l2.industry<>'NULL');

select distinct company,industry
from layoffs_copy1
order by company;

-- populating null values
MERGE INTO layoffs_copy1 target
USING (
    SELECT company, MIN(industry) AS industry
    FROM layoffs_copy1
    WHERE industry IS NOT NULL 
      AND TRIM(industry) <> 'NULL'
    GROUP BY company
) source
ON (target.company = source.company)
WHEN MATCHED THEN
UPDATE SET target.industry = source.industry
WHERE target.industry IS NULL 
   OR TRIM(target.industry) = 'NULL';

-- displaying the rows having null values in both total_laid_off and percentage_laid_off
select *
from layoffs_copy1
where (total_laid_off is null or total_laid_off='NULL')
and (PERCENTAGE_LAID_OFF is null or PERCENTAGE_LAID_OFF='NULL');

-- deleteing the rows having null values in both total_laid_off and percentage_laid_off
delete from layoffs_copy1
where (total_laid_off is null or total_laid_off='NULL')
and (PERCENTAGE_LAID_OFF is null or PERCENTAGE_LAID_OFF='NULL');

--dropping row_num column
alter table layoffs_copy1
drop column row_num;

select *
from layoffs_copy1;