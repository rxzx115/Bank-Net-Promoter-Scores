# Bank-Net-Promoter-Scores

Objective: To understand the bank net promoter scores (NPS) to enhance customer loyalty and forecast business growth


Guiding questions:
    - What is the overall average NPS in the 2021 year and across each market? 
    - What is the overall average NPS monthly? What is the average NPS across each market on a monthly level?
    - What are the differences in the distribution of rating types (e.g., promoters, passives, detractors) across different market segments?


Data collection: To retrieve data from Kaggle


Data cleaning:
    - Investigated different date data formats for data quality
    - Transformed the survey ratings to rating type for further analysis
    - Reviewed duplicates in the customer name for data integrity


Data exploration:
    - Exploratory data analysis was performed in SQL to answer the guiding questions
    - Refer to the separate .sql file for further details


Data visualization
    - Data visualization was performed in Tableau
    - Refer to the separate Tableau data visualization on Tableau Public for further details


Insights and recommendations: 
    1) A significant portion of customers are detractors, outnumbering passives. 
        - Implement targeted surveys or interviews with detractors to identify their pain points (e.g., specific service issues, product features, fees). Address these issues directly to reduce the number of detractors and potentially convert them into passives or promoters.
    2) The monthly NPS shows fluctuations throughout the year, with a peak in April and a dip in June. 
        - Investigate the factors contributing to the NPS peaks and troughs each month. Analyze marketing campaigns, product launches, seasonal service changes, or external events that might correlate with these shifts. 
    3) The distribution of ratings reveals a high frequency of both top scores and very low scores. 
        - Implement targeted strategies for customers under passive scores. Implement a loyalty programs to further strengthen their relationship. Loyalty programs could include enhanced tier rewards (e.g., CDs, savings accounts, financial planning consultations), referral bonus programs (e.g., cash bonuses, reward point awards, reduction in credit card annual fees), and exclusive offers (e.g., new credit cards, insurance services, etc.).
