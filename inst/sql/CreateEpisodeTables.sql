/* Create empty Episode Table */
IF OBJECT_ID('@oncology_database_schema.@episode_table', 'U') IS NOT NULL
	DROP TABLE @oncology_database_schema.@episode_table;

CREATE TABLE @oncology_database_schema.@episode_table (
	episode_id BIGINT,
	person_id BIGINT,
	episode_concept_id INT,
	episode_start_datetime DATE,
	episode_end_datetime DATE,
	episode_parent_id BIGINT,
	episode_number BIGINT,
	episode_object_concept_id INT,
	episode_type_concept_id INT,
	episode_source_value VARCHAR (50),
	episode_source_concept_id INT);


/* Create empty Episode Event Table */
IF OBJECT_ID('@oncology_database_schema.@episode_event_table', 'U') IS NOT NULL
	DROP TABLE @oncology_database_schema.@episode_event_table;

CREATE TABLE @oncology_database_schema.@episode_event_table (
	episode_id BIGINT,
	visit_occurrence_id BIGINT,
	condition_occurrence_id BIGINT,
	procedure_occurrence_id BIGINT,
	drug_exposure_id BIGINT,
	device_exposure_id BIGINT,
	measurement_id BIGINT,
	specimen_id BIGINT,
	observation_id BIGINT,
	note_id BIGINT,
	cost_id BIGINT);
