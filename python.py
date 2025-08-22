import pandas as pd

# Read the CSV file
df = pd.read_csv('btw25_wbz_ergebnisse.csv', sep=";")

# Count unique entries in a specific column
unique_count = df['Gemeindename'].nunique()
print(f"Number of unique entries: {unique_count}")

# Or to see the actual unique values
unique_values = df['Gemeindename'].unique()
print(f"Unique values: {unique_values}")

# Or get counts of each unique value
value_counts = df['Gemeindename'].value_counts()
print(value_counts)