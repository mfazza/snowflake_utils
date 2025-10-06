/*******************************************************************************
* GET_WAREHOUSE_CREDIT_COST_SINCE Procedure
* =====================================
*
* Description:
* ------------
* This procedure calculates the total credit cost for each warehouse since a 
* specified point in time. It helps in monitoring and analyzing warehouse 
* resource consumption and associated costs across your Snowflake account.
*
* Parameters:
* -----------
* SINCE (TIMESTAMP_NTZ) - The starting timestamp from which to calculate
*                         credit consumption. Only warehouse usage after
*                         this timestamp will be included.
*
* Returns:
* --------
* TABLE with columns:
*   - WAREHOUSE_NAME (STRING) - Name of the warehouse
*   - CREDIT_COST   (NUMBER) - Total credits consumed by the warehouse
*
* Usage:
* ------
* CALL GET_WAREHOUSE_CREDIT_COST_SINCE('2025-01-01 00:00:00'::TIMESTAMP_NTZ);
*
* Notes:
* ------
* - Queries the SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY view
* - Results are ordered by credit cost in descending order
* - Includes only cloud services credits usage
* - Executes as caller (inherits caller's privileges)
* - Requires access to account usage data
*
*******************************************************************************/
CREATE OR REPLACE PROCEDURE GET_WAREHOUSE_CREDIT_COST_SINCE(
    SINCE TIMESTAMP_NTZ
)
RETURNS TABLE (
    WAREHOUSE_NAME STRING,
    CREDIT_COST NUMBER
)
LANGUAGE SQL
EXECUTE AS CALLER
AS
BEGIN
    LET results RESULTSET := (
        SELECT
            WAREHOUSE_NAME,
            SUM(CREDITS_USED_CLOUD_SERVICES) AS CREDIT_COST
        FROM SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_METERING_HISTORY
        WHERE START_TIME >= :since
        GROUP BY WAREHOUSE_NAME
        ORDER BY CREDIT_COST DESC
    );
    RETURN TABLE(results);
END;
