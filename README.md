# E-commerce Cart Abandonment Analysis

## **Project Overview**
Cart abandonment is one of the most important challenges in e-commerce, directly impacting revenue and customer conversion. Every abandoned shopping cart represents potential sales that were not completed.

This project analyzes customer behavior throughout the shopping cart journey to understand where users drop off, identify patterns behind cart abandonment, and estimate the potential business impact.

Using SQL, the project explores user activity, cart behavior, checkout attempts, orders, and cart events to measure abandonment, discover behavioral trends, and provide actionable business recommendations for improving conversion rates.

## **Business Problem**
An e-commerce company has noticed that a considerable number of customers add products to their shopping carts but leave the website before completing their purchases.

This behavior results in lost sales opportunities, lower conversion rates, and reduced return on marketing investments. While customers successfully reach the shopping cart stage, the company lacks clear visibility into why many purchase journeys end before checkout completion.

To improve conversion performance, the business needs to understand customer behavior during the shopping journey, identify abandonment patterns, and uncover opportunities to recover lost revenue.

## **Project Goal**
The goal of this project is to measure cart abandonment performance, identify the key drivers behind customer drop-off, quantify the business impact, and provide data-driven recommendations that help increase completed purchases and recover lost revenue.

## **Executive Summary**
**NO SUMMARY YET**

## **Dataset Description**
| Table       | Description                             |
| ----------- | --------------------------------------- |
| Users       | Contains customer profile information, including demographics, acquisition channels, device preferences, and membership status. This table represents the customer dimension used throughout the analysis.                                                 |
| Products    | Stores product information such as category, brand, pricing, cost, inventory status, and customer ratings. It provides the product context for items added to shopping carts.                                            |
| Carts      | Represents shopping carts created by customers. Each cart belongs to a single user and records when the cart was created, serving as the central entity for abandonment analysis.                                              |
| Cart Items    | Contains the individual products added to each shopping cart, including quantities and item prices. This table links carts with products and enables product-level abandonment analysis.                                   |
| Checkout Attempts    | Records customers who initiated the checkout process, including payment method, shipping cost, and whether the checkout was successfully completed.                                   |
| Orders    | Contains completed purchases generated from successful checkout attempts. This table represents converted shopping carts and is used to distinguish completed purchases from abandoned carts.                                  |
| Cart Events    | Stores user interactions related to shopping cart activities, such as cart creation, item additions or removals, checkout initiation, payment failures, purchase completion, and cart abandonment. These events help analyze customer behavior throughout the purchase journey.                                   |
| Abandonment Reasons    | Contains the simulated reason associated with each abandoned cart, along with a confidence score indicating the likelihood of that reason. This table supports root cause analysis of cart abandonment.                                  |

## **Schema Design**
![erd](./schema/erd.png)

## **Data Preparation**
### **Data Quality Assessment**
A comprehensive data quality assessment was performed before moving data from the **raw_data** layer to the **analytics_data** layer. The objective was to evaluate data quality, validate table relationships, and identify any potential issues that could impact downstream analysis.

The assessment focused on ensuring the dataset was complete, consistent, and reliable for cart abandonment analysis.

The following checks were performed:
- Checked for exact duplicate records across all tables.
- Validated primary key uniqueness.
- Assessed missing values and data completeness.
- Identified orphan records.
- Validated categorical values against their expected domains.
- Verified numeric value ranges and business rule consistency.

### **Issues Found**
| Check          | Result                                    |
| -------------- | ----------------------------------------- |
| Missing Values | **city** column: 5,125 records (5.12%)    |
| Business Rule | **11 active products** have zero stock (`stock = 0` while `is_active = TRUE`). |

### **Data Cleaning Process**
Following the data quality assessment, only minimal cleaning was required before loading the data into the analytical layer.

The following transformations were applied:
- Replaced missing values in the `city` column with **'Unknown'** using `COALESCE()` to preserve records while avoiding bias toward any existing city.
- Retained the **11 active products with zero stock** without modification. Due to their low frequency relative to the dataset size, they were treated as valid business anomalies rather than data errors and were preserved for analysis.

No duplicate records, orphan records, or primary key violations were found. Therefore, no additional cleaning or record removal was required.

## **Exploratory Data Analysis (EDA)**
- The **users** table contains **100,000** users, the **products** table contains **5,000** products, the **orders** table contains **64,857** orders, the **checkout_attempts** table conatins **216,796** attempts, the **carts** table conatins **361,028** carts, the **cart_items** table contains **1,083,844** cart items, the **cart_events** table conatins **3,251,588** events, the **abandonment_reasons** table conatins **144,232** records.

### **Users Volume by Country**
![users_volume_by_country](./charts/1.users_volume_by_country.png)
#### **Key Findings**
- The user base is distributed almost evenly across the **five** countries, with each market contributing approximately **20%** of the total users.
- The **UAE** has the largest user base, representing **20.18%** of all registered users.
- **Saudi Arabia** has the smallest user base, accounting for **19.81%** of total users.
- The difference between the largest and smallest country segments is minimal, indicating a well-balanced geographic distribution.
#### **Business Interpretation**
The dataset represents a balanced customer distribution across the five target markets, with no single country dominating the user base. This balanced distribution helps reduce geographic bias in subsequent analyses, making cross-country comparisons more reliable. Any significant differences observed later in cart abandonment behavior or conversion performance are therefore less likely to be driven solely by differences in user population size.
### **Users Volume by City**
![users_volume_by_city](./charts/2.users_volume_by_city.png)
#### **Key Findings**
- User distribution across cities is balanced within each country, with no single city overwhelmingly dominating its local user base.
- **Amman** and **Kuwait City** have the largest individual city populations, representing **19.09%** and **18.99%** of the total user base, respectively. This is expected since each is the only represented city for its country.
- In **Egypt**, users are distributed almost evenly across **Alexandria (6.33%)**, **Giza (6.29%)**, and **Cairo (6.26%)**.
- In **Saudi Arabia**, the user base is nearly equally divided between **Jeddah (9.39%)** and **Riyadh (9.37%)**.
- In the **UAE**, **Dubai (9.58%)** and **Abu Dhabi (9.57%)** show an almost identical user distribution.
- The **Unknown** city category accounts for approximately **1%** of users in every country, reflecting a consistent pattern of missing city values across the dataset.
#### **Business Interpretation**
The city distribution indicates that the dataset was generated with a balanced geographic representation within each country. No individual city disproportionately dominates its country's customer base, reducing the likelihood of geographic concentration bias during subsequent analyses.

Additionally, the **Unknown** city values are consistently distributed across all countries rather than concentrated in a specific market. This suggests that the missing city information is a general data quality issue rather than a country-specific problem, making it less likely to distort geographic comparisons in later analyses.
### **Users Volume by Device**
![users_volume_by_device](./charts/3.users_volume_by_device.png)
#### **Key Findings**
- **Mobile** is the most commonly used device, accounting for **65.03%** of the total user base.
- **Desktop** is the second most popular platform, representing **29.99%** of users.
- **Tablet** usage is relatively limited, contributing only **4.98%** of the total users.
- The device distribution is clearly **skewed** toward **mobile**, with nearly **two-thirds** of users accessing the platform through mobile devices.
#### **Business Interpretation**
The dataset indicates a strong preference for **mobile** devices, with mobile users representing the majority of the customer base. This distribution reflects a **mobile-first** usage pattern that is commonly observed in modern e-commerce platforms.

Given the significant share of mobile users, subsequent analyses should compare cart abandonment and conversion performance across device types to determine whether user behavior differs between mobile, desktop, and tablet users.
### **Users Volume by Acquisition Channel**
![users_volume_by_acquisition_channel](./charts/4.users_volume_by_acquisition_channel.png)
#### **Key Findings**
- **Organic Search** is the largest acquisition channel, accounting for **24.33%** of all users.
- **Direct (19.47%)** and **Social Media (19.46%)** contribute nearly identical shares, making them the second-largest sources of user acquisition.
- **Paid Search** represents **14.38%** of the user base.
- **Referral (9.79%)** and **Email (9.70%)** contribute similar proportions and represent smaller acquisition channels.
- **Unknown** accounts for **2.86%** of users, indicating a relatively small proportion of records with unavailable acquisition source information.
#### **Business Interpretation**
The user base is acquired through a diverse mix of marketing channels, with **Organic Search** representing the largest source of new users. No single acquisition channel dominates the dataset, suggesting that customer acquisition is distributed across multiple channels rather than relying on a single source.

The similar user shares of **Direct** and **Social Media** indicate that both channels contribute comparable acquisition volumes, while **Paid Search**, **Referral**, and **Email** provide additional traffic at lower volumes.

These results provide a solid baseline for the subsequent analysis, where acquisition channels can be evaluated not only by user volume but also by business outcomes such as cart abandonment, conversion rates, and completed purchases.

























