###Building Permits (Python)

###Project Objective

##Conduct Exploratory Data Analysis (EDA) on San Francisco building permit records to evaluate processing timelines and identify operational bottlenecks. 

#Tools & Concepts Used
-•	Libraries: pandas, numpy, matplotlib, seaborn
-•	Concepts: Missing Value Handling (>60% drop threshold), Datetime Parsing, Time-Delta Calculation (Issue_duration_days), Median/Mean Aggregation 

#Key Features & Visual Previews
-•	Data Sanitization: Filtered uninformative high-null columns and imputed missing values across numeric and categorical fields. 
-•	Visual Analysis: Approval duration charts by permit type and weekday application filing volume distributions. 

#Key Business Insights & Recommendations
-•	Insights: New Construction permits face a median lead time of 419.5 days, whereas Over-the-Counter (OTC) alterations process in 0 days. Peak filing occurs mid-week on Tuesday (39,765) and Thursday (37,612). 
-•	Recommendations: Establish dedicated review tracks for heavy structural permits and increase staff intake capacity during mid-week peak days. 

# How to Run / Files
-•	Files: Building_Permits.ipynb, Building_Permits.csv
-•	Execution: Install dependencies (pandas, numpy, matplotlib, seaborn) and execute Building_Permits.ipynb sequentially in Jupyter Notebook. 

