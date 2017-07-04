--3b
-- Annahme: Kein Land liegt auf mehr als 2 Kontinenten
Create or replace View View2 as (
SELECT v1.*, e.continent 
FROM View1 v1 
JOIN encompasses e 
ON e.country = v1.code 
WHERE e.percentage >= 50);

Select * from View2;

Select * from USER_UPDATABLE_COLUMNS
WHERE Table_Name = 'VIEW2';

update View2
set continent = 'Africa' 
where code = 'R';

Select * from View2 where code = 'R';

