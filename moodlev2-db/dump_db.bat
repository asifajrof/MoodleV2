@echo off

SET DB_NAME=%1
SET DB_USER=postgres
SET OUTPUT_FILE=full_db.sql

echo DROP SCHEMA public CASCADE; > %OUTPUT_FILE%
echo CREATE SCHEMA public; >> %OUTPUT_FILE%
echo GRANT ALL ON SCHEMA public TO %DB_USER%; >> %OUTPUT_FILE%
echo GRANT ALL ON SCHEMA public TO public; >> %OUTPUT_FILE%

pg_dump --column-inserts -U %DB_USER% %DB_NAME% >> %OUTPUT_FILE%

echo DONE!
