# 1. LOAD AND CHECK DATA
# Source: https://archive.ics.uci.edu/dataset/2/adult
# Question: How do education and working hours relate to income?

adult <- read.csv(
  "data/adult.data",
  header = FALSE,
  strip.white = TRUE,
  na.strings = "?"
)

names(adult) <- c(
  "age", "workclass", "fnlwgt", "education",
  "education_num", "marital_status", "occupation",
  "relationship", "race", "sex", "capital_gain",
  "capital_loss", "hours_per_week", "native_country", "income"
)

dim(adult)
str(adult)
summary(adult)
colSums(is.na(adult))
sum(duplicated(adult))


# 2. CLEAN DATA

# Retain repeated rows: no person ID confirms they are duplicates.
# Unknown labels preserve records without guessing missing information.
# 1. Initialize dataset and check dimensions / missing values
adult_clean <- adult
dim(adult_clean)
colSums(is.na(adult_clean))

# 2. Impute missing categorical values with "Unknown"
adult_clean$workclass[is.na(adult_clean$workclass)] <- "Unknown"
adult_clean$occupation[is.na(adult_clean$occupation)] <- "Unknown"
adult_clean$native_country[is.na(adult_clean$native_country)] <- "Unknown"

# 3. Check working-hour outliers using the IQR rule
q1 <- quantile(adult_clean$hours_per_week, 0.25)
q3 <- quantile(adult_clean$hours_per_week, 0.75)
iqr_val <- q3 - q1

lower <- q1 - 1.5 * iqr_val
upper <- q3 + 1.5 * iqr_val

# 4. Count the number of outliers
sum(adult_clean$hours_per_week < lower | adult_clean$hours_per_week > upper)

# Keep the 9,008 flagged records: short and long weeks can be valid.


# 3. EXPLORE THE DATA

# How is age distributed?
hist(
  adult_clean$age,
  main = "Age distribution",
  xlab = "Age", col = "lightblue", border = "white"
)
# Ages concentrate around 20–50, with a tail towards older ages.

# Do working hours differ between income groups?
boxplot(
  hours_per_week ~ income, data = adult_clean,
  main = "Working hours by income",
  xlab = "Income group", ylab = "Hours per week",
  col = c("lightblue", "lightgreen")
)

tapply(adult_clean$hours_per_week, adult_clean$income, median)
# Both medians are 40, but the >50K group's box extends to higher hours.

# Is age related to working hours?
plot(
  adult_clean$age, adult_clean$hours_per_week,
  main = "Age and working hours",
  xlab = "Age", ylab = "Hours per week",
  pch = 16, cex = 0.5, col = rgb(0, 0, 1, 0.1)
)

cor(adult_clean$age, adult_clean$hours_per_week)
# About 0.069: a very weak positive linear relationship.

# Which numerical features are related?
# Install corrplot once in the Console: install.packages("corrplot")
library(corrplot)

numeric_data <- adult_clean[, c(
  "age", "education_num", "capital_gain",
  "capital_loss", "hours_per_week"
)]

correlation_matrix <- cor(numeric_data)
round(correlation_matrix, 2)

corrplot(
  correlation_matrix,
  method = "color", type = "upper",
  addCoef.col = "black", tl.col = "black",
  tl.srt = 45, diag = FALSE
)
# All pairwise linear correlations are weak.

# Does income differ across education levels?
education_income <- tapply(
  adult_clean$income == ">50K",
  adult_clean$education,
  mean
) * 100

round(education_income, 2)

par(mar = c(5, 9, 4, 2))
barplot(
  sort(education_income),
  horiz = TRUE, las = 1, col = "lightblue",
  main = "Income above $50K by education",
  xlab = "Percentage within each group", xlim = c(0, 100)
)
par(mar = c(5, 4, 4, 2) + 0.1)

# Bachelors: 41.48%; HS-grad: 15.95%.
# This is association, not proof that education causes higher income.
# 4. ENCODE, TRANSFORM AND RUN PCA

# One-hot encode employment type: each category becomes a 0/1 column.
adult_clean$workclass <- as.factor(adult_clean$workclass)
workclass_encoded <- model.matrix(
  ~ workclass - 1, data = adult_clean
)

pca_data <- cbind(numeric_data, workclass_encoded)

# Compress large capital values while keeping zeros.
pca_data$capital_gain <- log1p(pca_data$capital_gain)
pca_data$capital_loss <- log1p(pca_data$capital_loss)

# Centre and scale each feature as part of PCA.
pca_result <- prcomp(pca_data, center = TRUE, scale. = TRUE)

summary(pca_result)

# Percentage of variance explained
variance_percent <- 100 * pca_result$sdev^2 /
  sum(pca_result$sdev^2)

round(variance_percent, 2)
round(cumsum(variance_percent), 2)

plot(
  variance_percent, type = "b", pch = 16,
  main = "PCA scree plot",
  xlab = "Principal component",
  ylab = "Explained variance (%)", col = "blue"
)

# Loadings show which features contribute to PC1 and PC2.
round(pca_result$rotation[, 1:2], 2)
summary(pca_result)
round(pca_result$rotation[, 1:2], 2)
# PCA findings:
# PC1 explains 13.49% and PC2 explains 9.97% of the variance.
# Together they explain 23.46%, so two components are not enough.
# Ten components explain 82.87%, showing limited compression.
# PC1 mainly contrasts private employment with other characteristics.
# PC2 contrasts longer hours and higher education with unknown workclass.
# The final near-zero component comes from one-hot encoding redundancy.