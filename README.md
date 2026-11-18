# Adult Census Data Analysis

This project explores the Adult dataset using R.

## Research question

How do education and working hours relate to income
in the Adult sample?

## Dataset

I used adult.data, which contains 32,561 rows and 15 columns.
The records were extracted from the 1994 US Census database.

Source: https://archive.ics.uci.edu/dataset/2/adult

## What I did

- Checked data types, missing values and repeated rows.
- Replaced missing categories with "Unknown".
- Retained repeated rows because there is no person ID.
- Checked unusual working hours using the IQR rule.
- Created a histogram, boxplot, scatter plot, correlation
  heatmap and education-income bar chart.
- One-hot encoded workclass, transformed capital values,
  scaled the features and ran PCA.

## Main findings

- Age and working hours had a weak correlation of about 0.069.
- Both income groups had median working hours of 40,
  but their distributions differed.
- 41.48% of bachelor's graduates earned above $50K,
  compared with 15.95% of high-school graduates.
- Ten principal components explained 82.87% of the variance.

## Limitations

The data is historical and the analysis is unweighted.
The findings describe associations, not causes.
Scaling encoded categories can give rare categories more influence.

## How to run

1. Download the dataset from the source above.
2. Put adult.data inside a folder called data.
3. Install corrplot using install.packages("corrplot").
4. Open analysis.R in RStudio and run it from the top.

## Reference

Becker, B. and Kohavi, R. (1996) Adult [Dataset].
UCI Machine Learning Repository.
Available at: https://doi.org/10.24432/C5XW20
(Accessed: 16 November 2026).
