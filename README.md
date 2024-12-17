<img src="https://assets.website-files.com/61a888508b7cccb7485cdac2/61b31d9009792071f950394b_logo_dscovr.svg">

# Data Engineer: DuckDB & DBT - Dynamic Data Modeling Challenge (Solved)

## Overview

This project uses **dbt** and **DuckDB** to transform raw data of the New York City Taxi Trips Dataset into four Data Marts models in order to solve the [challenge](https://github.com/dscovr/duckdb-dbt-challenge/tree/main). The pipeline is structured into three phases: raw, staging, marts. Next, there are two additional bonus sections: implementing tests and displaying the results in table format.

---

## How to run the project

### Prerequisites

Ensure the following tools are installed and configured:
- **Python >= 3.10**
- **git**
- **uv**
- **wget**

### Follow the steps below

1. **Clone the repository**:
   ```bash
   $ git clone https://github.com/TeccoFabio/duckdb-dbt-challenge.git && cd duckdb-dbt-challenge/
   ```

2. **Create and activate a virtual environment**:
   ```bash
   $ uv venv && source .venv/bin/activate
   ```

3. **Install all packages needed**
   ```bash
   $ uv sync
   ```

4. **Install duckdb_cli for Linux**
   ```bash
   $ wget https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip && unzip duckdb_cli-linux-amd64.zip && mv duckdb .venv/bin/
   ```

5. **Download all the dependencies**
   ```bash
   $ uv run dbt deps 
   ```

6. **Download the New York City Taxi Trips Dataset**
   ```bash
   $ wget https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet -P data/raw
   ```

7. **Usage**
   - To execute all models:
      ```bash
      $ uv run dbt run
      ```
   - To execute a specific model:
     ```bash
     $ uv run dbt run --select model_name
     ```
   

---

## Models

### **Raw Model**

**raw_yellow_tripdata__trips** is exclusively responsible for loading the data useful for the project from the Parquet file to a materialized table in DuckDB, ensuring traceability and enabling debugging.

### **Staging Model**

In the staging model, data from the raw model (defined as a source in **_yellow_tripdata__trips.yml**) is transformed (as a materialized view) to make it more useful and consistent for further analysis.

Specifically, the **stg_yellow_tripdata__trips** model:  
- renames fields to provide clearer names;  
- standardizes dates to the `TIMESTAMP` type;  
- converts some fields saved in overly large data types to optimize storage;  
- classifies distances into three **trip_segment** categories;  
- divides the day into four **time_slot** categories;  
- calculates trip duration in minutes using the `FLOAT` type to retain precision;  
- creates a boolean flag **is_prepaid** to identify pre-paid trips.  

In the `WHERE` clause, rows with inconsistent data are filtered out, such as:  
- passenger counts not between 1 and 4, as New York City taxis can carry a maximum of 4 passengers;  
- other fields with negative values.

### **Marts Models**

Mart models are designed to support key KPIs and final reporting of the results, so they are materialized as tables.

All four models have in the `FROM` clause the reference to the staging model, using the Jinja function **{{ref}}**.

Since it was repeated in two data marts, a macro was created to simultaneously perform the `ROUND` and `SUM` of a field placed under `GROUP BY`.

---

## How to run tests

They are in models/schema.yml.

### Types of tests included:
1. **Not null tests**:
   Validates that critical fields are not null. Example:
   ```yml
   - name: vendor_id
        data_tests:
          - not_null
   ```
2. **Accepted values tests**
   Validates that all of the values in a column are present in a supplied list of values. Example:
   ```yml
   - name: time_slot
        data_tests:
          - accepted_values:
              values: ['Morning', 'Afternoon', 'Evening', 'Night']
   ```

### Run all tests
Use the following command to run all tests:
```bash
$ uv run dbt test
```

---

## Displaying results

Use the following commands to view the final results:

1. **Trips by Time of Day**
   ```bash
   $ uv run duckdb data/db/yellow_tripdata.duckdb "SELECT time_slot AS 'Time Slot', printf('%,d', total_trip) AS 'Total Trip', printf('$%,.2f', total_revenue) AS 'Total Revenue' FROM Trips_by_Time_of_Day ORDER BY CASE time_slot WHEN 'Morning' THEN 1 WHEN 'Afternoon' THEN 2 WHEN 'Evening' THEN 3 WHEN 'Night' THEN 4 END;" --box
   ```

2. **Top 5 Pickup Zones**
   ```bash
   $ uv run duckdb data/db/yellow_tripdata.duckdb "SELECT pu_location_id AS 'Top 5 Pickup Zone', printf('%,d', total_trips) AS 'Total Trip', printf('$%,.2f', total_revenue) AS 'Total Revenue' FROM Top_5_Pickup_Zones" --box
   ```

3. **Driver/Rate Performance**
   ```bash
   $ uv run duckdb data/db/yellow_tripdata.duckdb "SELECT vendor_id AS 'Provider', CONCAT(average_tip_percentage, '%') AS 'Average Tip Percentage' FROM Provider_Performance" --box
   ```

4. **Distance Analysis**
   ```bash
   $ uv run duckdb data/db/yellow_tripdata.duckdb "SELECT trip_segment AS 'Trip Segment', CONCAT(average_trip_duration, ' minutes') AS 'Average Trip Duration', printf('$%,.2f', total_revenue) AS 'Total Revenue' FROM Distance_Analysis" --box
   ```

## Contact

For questions, you can reach me at:
- **Email**: fabio.tecco@tim.it
- **GitHub**: [TeccoFabio](https://github.com/TeccoFabio)

---