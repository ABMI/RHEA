IF OBJECT_ID('@target_database_schema.@target_cohort_table', 'U') IS NOT NULL
	DROP TABLE @target_database_schema.@target_cohort_table;

SELECT [COHORT_DEFINITION_ID]
	   ,[SUBJECT_ID]
	   ,[cohort_start_date]
	   ,[cohort_end_date]
INTO @target_database_schema.@target_cohort_table
FROM [CDMPv533_ABMI].[results_v280].[cohort]
WHERE COHORT_DEFINITION_ID = @target_cohort_id
