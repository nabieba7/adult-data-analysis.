# Load data
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
  "capital_loss", "hours_per_week", "native_country",
  "income"
)

# Explore
dim(adult)
head(adult)
str(adult)
summary(adult)
colSums(is.na(adult))
sum(duplicated(adult))

# Clean
adult_clean <- adult

adult_clean$workclass[is.na(adult_clean$workclass)] <- "Unknown"
adult_clean$occupation[is.na(adult_clean$occupation)] <- "Unknown"
adult_clean$native_country[is.na(adult_clean$native_country)] <- "Unknown"

colSums(is.na(adult_clean))
dim(adult_clean)

# Outliers in working hours
boxplot(
  adult_clean$hours_per_week,
  main = "Weekly working hours",
  ylab = "Hours per week",
  col = "lightblue"
)

q1 <- quantile(adult_clean$hours_per_week, 0.25)
q3 <- quantile(adult_clean$hours_per_week, 0.75)
iqr <- q3 - q1

lower_limit <- q1 - 1.5 * iqr
upper_limit <- q3 + 1.5 * iqr

lower_limit
upper_limit

sum(
  adult_clean$hours_per_week < lower_limit |
    adult_clean$hours_per_week > upper_limit
)
# The IQR rule flags 9,008 records with unusual working hours.
# Keep them: unusual values are not necessarily errors.

# Age distribution
hist(
  adult_clean$age,
  main = "Age distribution",
  xlab = "Age",
  col = "lightblue",
  border = "white"
)

mean(adult_clean$age)
median(adult_clean$age)
# Most people are around 20-50 years old. The distribution is right-skewed.

# Working hours by income
boxplot(
  hours_per_week ~ income,
  data = adult_clean,
  main = "Working hours by income",
  xlab = "Income group",
  ylab = "Hours per week",
  col = c("lightblue", "lightgreen")
)

tapply(adult_clean$hours_per_week, adult_clean$income, median)
tapply(
  adult_clean$hours_per_week,
  adult_clean$income,
  quantile,
  probs = c(0.25, 0.75)
)
# Both groups have a median of 40 hours, but the >50K group
# has a higher middle range. This is an association, not causation.

# Age and working hours
plot(
  adult_clean$age,
  adult_clean$hours_per_week,
  main = "Age and working hours",
  xlab = "Age",
  ylab = "Hours per week",
  pch = 16,
  cex = 0.5,
  col = rgb(0, 0, 1, 0.1)
)

cor(adult_clean$age, adult_clean$hours_per_week)
# Correlation is about 0.069: a very weak positive relationship.

# Correlation heatmap
if (!requireNamespace("corrplot", quietly = TRUE)) {
  install.packages("corrplot")
}
library(corrplot)

numeric_data <- adult_clean[, c(
  "age",
  "education_num",
  "capital_gain",
  "capital_loss",
  "hours_per_week"
)]

correlation_matrix <- cor(numeric_data)
round(correlation_matrix, 2)s

corrplot(
  correlation_matrix,
  method = "color",
  type = "upper",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  diag = FALSE
)

