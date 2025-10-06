# Snowflake Utilities

This repository contains a collection of SQL procedures, functions, and queries designed to help manage and optimize your Snowflake data warehouse environment. These utilities address several key aspects of Snowflake administration and governance:

## Overview

The utilities in this repository help with:

- **Cost Management**
  - Monitor warehouse usage and costs
  - Identify expensive queries
  - Track storage costs across databases
  - Analyze credit consumption patterns

- **Compliance and Security**
  - Audit user access patterns
  - Track sensitive data access
  - Monitor privilege changes
  - Review security configurations

- **Data Inventory**
  - Sample data across schemas
  - Profile column contents
  - Track table sizes and growth
  - Identify data patterns and anomalies

- **Usage Analytics**
  - Monitor query patterns
  - Track user activity
  - Analyze warehouse performance
  - Review resource utilization

## Available Utilities

### Cost Management
- `GET_WAREHOUSE_CREDIT_COST_SINCE`: Procedure that calculates total credit consumption for each warehouse since a specified timestamp, helping track and analyze warehouse costs.

### Schema Analysis
- `SAMPLE_SCHEMA_COLUMNS`: Procedure that samples data from all columns in a schema, helping understand data patterns and content across tables.

## Usage

Each utility includes detailed documentation in its header comments, explaining:
- Purpose and functionality
- Required parameters
- Return values
- Usage examples
- Important considerations

## Requirements

- Snowflake account with appropriate privileges
- Access to ACCOUNT_USAGE views for some utilities
- Required roles and permissions as documented in each utility

## Contributing

Feel free to submit issues and enhancement requests.