GRANT CREATE APPLICATION PACKAGE ON ACCOUNT TO ROLE accountadmin;
CREATE APPLICATION PACKAGE hello_snowflake_package;
SHOW APPLICATION PACKAGES;
USE APPLICATION PACKAGE hello_snowflake_package;
CREATE SCHEMA stage_content;
CREATE OR REPLACE STAGE hello_snowflake_package.stage_content.hello_snowflake_stage
  FILE_FORMAT = (TYPE = 'csv' FIELD_DELIMITER = '|' SKIP_HEADER = 1);
LIST @hello_snowflake_package.stage_content.hello_snowflake_stage;  
CREATE APPLICATION HELLO_SNOWFLAKE_APP
  FROM APPLICATION PACKAGE HELLO_SNOWFLAKE_PACKAGE
  USING '@hello_snowflake_package.stage_content.hello_snowflake_stage';
SHOW APPLICATIONS;

CALL core.hello();
USE APPLICATION PACKAGE hello_snowflake_package;
CREATE SCHEMA IF NOT EXISTS shared_data;
CREATE TABLE IF NOT EXISTS accounts (ID INT, NAME VARCHAR, VALUE VARCHAR);
INSERT INTO accounts VALUES
  (1, 'Nihar', 'Snowflake'),
  (2, 'Frank', 'Snowflake'),
  (3, 'Benoit', 'Snowflake'),
  (4, 'Steven', 'Acme');
SELECT * FROM accounts;
GRANT USAGE ON SCHEMA shared_data TO SHARE IN APPLICATION PACKAGE hello_snowflake_package;
GRANT SELECT ON TABLE accounts TO SHARE IN APPLICATION PACKAGE hello_snowflake_package;

DROP APPLICATION hello_snowflake_app;
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING '@hello_snowflake_package.stage_content.hello_snowflake_stage';

SELECT * FROM code_schema.accounts_view;

SELECT code_schema.addone(3);
SELECT code_schema.multiply(1,2);

ALTER APPLICATION PACKAGE hello_snowflake_package
  ADD VERSION v1_0 USING '@hello_snowflake_package.stage_content.hello_snowflake_stage';
SHOW VERSIONS IN APPLICATION PACKAGE hello_snowflake_package;

DROP APPLICATION hello_snowflake_app;
CREATE APPLICATION hello_snowflake_app
  FROM APPLICATION PACKAGE hello_snowflake_package
  USING VERSION V1_0;

