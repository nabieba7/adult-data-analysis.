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

# Check the data types
str(adult)