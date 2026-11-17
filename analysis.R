# Load the Adult dataset
adult <- read.csv(
  "data/adult.data",
  header = FALSE,
  strip.white = TRUE,
  na.strings = "?"
)
# Check rows and columns
dim(adult)
# Add column names
names(adult) <- c(
  "age", "workclass", "fnlwgt", "education",
  "education_num", "marital_status", "occupation",
  "relationship", "race", "sex", "capital_gain",
  "capital_loss", "hours_per_week", "native_country",
  "income"
)
# View the first six rows
head(adult)
str(adult)
# Count missing values in each column
colSums(is.na(adult))

# Count repeated rows
sum(duplicated(adult))
summary(adult)

# Make a copy for cleaning
adult_clean <- adult

# Replace missing categories with "Unknown"
adult_clean$workclass[is.na(adult_clean$workclass)] <- "Unknown"

adult_clean$occupation[is.na(adult_clean$occupation)] <- "Unknown"

adult_clean$native_country[is.na(adult_clean$native_country)] <- "Unknown"

# Check the result
colSums(is.na(adult_clean))
dim(adult_clean)


