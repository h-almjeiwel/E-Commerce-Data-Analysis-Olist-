

# Olist E-Commerce Data Pipeline & Analytics
## Overview
This project builds an end-to-end data pipeline on Microsoft Azure using the Olist E-Commerce dataset.
It ingests raw data, cleans it, applies business logic, and creates interactive dashboards to help analyze sales performance.

<img width="2000" height="1414" alt="Bronze Container" src="https://github.com/user-attachments/assets/b85121fb-00c0-47e5-8687-40f1e6e5b465" />

## Technical Approach
### Storage Setup & Container Structure:
The storage account uses a Medallion Architecture with three dedicated containers:
* `bronze`: Stores the raw, unprocessed CSV files directly from the source.
* `silver`: Stores cleaned, filtered, and validated data after initial processing.
* `gold`: Stores final aggregated business data ready for reporting.

Pipeline Automation Container:
* `input`: Stores configuration files like `git.json` to automate Azure Data Factory pipelines.
<img width="2725" height="1497" alt="Screenshot 2026-08-22 195450" src="https://github.com/user-attachments/assets/e7f3422f-9117-4086-abe8-b9dc43ba09c2" />

### 1. Ingestion Phase
Automated pipelines in Azure Data Factory fetch raw dataset files from GitHub and store them directly into the `bronze` container.
<img width="2731" height="1427" alt="DF" src="https://github.com/user-attachments/assets/04ecb77a-5e03-49f0-96e2-633e40b6dd59" />

### 2. Transformation Phase (bronze to silver)
Provisioned a custom Databricks compute cluster and connected to storage using SAS token authentication to read raw files from the `bronze` container,
clean missing values, fix data types, and write structured outputs to the `silver` container.

<img width="2714" height="1571" alt="Screenshot 2026-08-22 194952" src="https://github.com/user-attachments/assets/83760b16-d42e-4f0f-968d-6c6758c6a5db" />
<img width="2725" height="1573" alt="Screenshot 2026-08-22 195114" src="https://github.com/user-attachments/assets/f01bb321-bf68-4e42-9afe-c0a2e2280b5a" />
<img width="2728" height="1575" alt="Screenshot 2026-08-22 195133" src="https://github.com/user-attachments/assets/c77f56be-f403-4ea1-85f0-2a9b137779f4" />
<img width="2729" height="1578" alt="Screenshot 2026-08-22 195148" src="https://github.com/user-attachments/assets/05a0713d-cb8f-44a3-beb1-7bf7b737cb2e" />

### 3. Aggregation Phase (Silver to Gold)
Azure Synapse Analytics queries data from the `silver` container, performs data modeling, and saves the final tables into the `gold` container.

<img width="2721" height="1564" alt="Screenshot 2026-08-22 195301" src="https://github.com/user-attachments/assets/78194da6-824c-42ad-88be-371c910b7e35" />
<img width="2735" height="1570" alt="Screenshot 2026-08-22 195550" src="https://github.com/user-attachments/assets/3bb7bb54-70e0-4149-a2d3-0267e4fd36bc" />

### 4. Data Visualization & Reporting (Power BI)
Connected Power BI directly to Azure Synapse Analytics using the SQL Endpoint and Database authentication. Built interactive dashboards, 
data models, and custom DAX measures to analyze sales and operational logistics.






