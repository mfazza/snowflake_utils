/*******************************************************************************
* SAMPLE_SCHEMA_COLUMNS Procedure
* ============================
*
* Description:
* ------------
* This procedure analyzes all tables within a specified schema and
* collects sample values for each column. It helps in understanding data
* patterns and content across an entire schema without needing to query
* each table individually.
*
* Parameters:
* -----------
* DATABASE_NAME (VARCHAR) - The name of the database containing
*                          the schema to analyze
* SCHEMA_NAME (VARCHAR)   - The name of the schema to analyze
*
* Returns:
* --------
* TABLE with columns:
*   - TABLE_NAME   (STRING) - Name of the table
*   - COLUMN_NAME  (STRING) - Name of the column
*   - DATA_TYPE    (STRING) - Data type of the column
*   - SAMPLE_VALUE (STRING) - A non-null sample value from the column
*
* Usage:
* ------
* CALL SAMPLE_SCHEMA_COLUMNS('YOUR_DATABASE', 'YOUR_SCHEMA');
*
* Notes:
* ------
* - Creates a temporary table 'SAMPLE_RESULTS' during execution
* - Only collects non-null values as samples
* - Executes as caller (inherits caller's privileges)
* - All sample values are cast to STRING for consistent output
* - Still needs error handling for edge cases (e.g., no tables, no columns)
*
*******************************************************************************/
CREATE OR REPLACE PROCEDURE SAMPLE_SCHEMA_COLUMNS(DATABASE_NAME VARCHAR, SCHEMA_NAME VARCHAR) -- noqa: 
RETURNS TABLE(
    TABLE_NAME STRING,
    COLUMN_NAME STRING,
    DATA_TYPE STRING,
    SAMPLE_VALUE STRING
)
LANGUAGE SQL
EXECUTE AS CALLER
AS
$$
DECLARE
    v_table STRING;
    v_column STRING;
    v_sql STRING;
    v_result VARIANT;
    v_data_type STRING;
    result RESULTSET;
    c_statement RESULTSET DEFAULT (SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = :SCHEMA_NAME);
    c1 CURSOR FOR c_statement;

BEGIN
    USE DATABASE IDENTIFIER(:DATABASE_NAME);
    USE SCHEMA IDENTIFIER(:SCHEMA_NAME);
    EXECUTE IMMEDIATE '
        CREATE OR REPLACE TEMPORARY TABLE SAMPLE_RESULTS(
            TABLE_NAME STRING,
            COLUMN_NAME STRING,
            DATA_TYPE STRING,
            SAMPLE_VALUE STRING
        )';

    FOR rec IN c1 DO
        v_table := rec.TABLE_NAME;
        v_column := rec.COLUMN_NAME;
        v_data_type := rec.DATA_TYPE;

        v_sql := 'INSERT INTO SAMPLE_RESULTS(TABLE_NAME, COLUMN_NAME, DATA_TYPE, SAMPLE_VALUE) ' ||
                 'SELECT ''' || v_table || ''', ''' || v_column || ''',  ''' || v_data_type || ''', CAST(MAX("' || v_column || '") AS STRING) ' ||
                 'FROM "' || DATABASE_NAME || '"."' || SCHEMA_NAME || '"."' || v_table || '" ' ||
                 'WHERE "' || v_column || '" IS NOT NULL';
        EXECUTE IMMEDIATE v_sql;
    END FOR;
    
    result := (EXECUTE IMMEDIATE 'SELECT * FROM SAMPLE_RESULTS');
    SELECT 'Sample collection complete. This returns a table you can store elsewhere. Alternatively, you can query thge temp table SAMPLE_RESULTS for the output.';
    RETURN TABLE(result);
END;
$$;
