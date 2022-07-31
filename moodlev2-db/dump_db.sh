#!/bin/bash
DB_NAME=$1
DB_USER=postgres

OUTPUT_FILE=full_db.sql

# DUMP Database:
echo "DROP SCHEMA public CASCADE;" > $OUTPUT_FILE
echo "CREATE SCHEMA public;" >> $OUTPUT_FILE
echo "GRANT ALL ON SCHEMA public TO $DB_USER;" >> $OUTPUT_FILE
echo "GRANT ALL ON SCHEMA public TO public;" >> $OUTPUT_FILE

pg_dump --column-inserts -U $DB_USER $DB_NAME >> $OUTPUT_FILE

echo DONE!
