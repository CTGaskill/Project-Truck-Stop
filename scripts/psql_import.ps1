psql -h localhost -d superset -U superset_admin -c "DROP TABLE IF EXISTS project_truck_stop.masturbation_data CASCADE"
psql -h localhost -d superset -U superset_admin -c "CREATE TABLE project_truck_stop.masturbation_data (Datetime VARCHAR(255),Subreddit VARCHAR(255),Comment VARCHAR,Is_NSFW_subreddit bool,CommentID VARCHAR(255));"
psql -h localhost -d superset -U superset_admin -c "\copy project_truck_stop.masturbation_data FROM '.\data.csv' DELIMITER ',' CSV HEADER;"
