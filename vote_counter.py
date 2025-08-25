import pandas as pd

# Load the CSV
df = pd.read_csv("btw25_wbz_ergebnisse.csv", sep=';', encoding='utf-8')

# Identify all Erststimmen columns
vote_columns = [col for col in df.columns if 'Erststimmen' in col]

# Columns to exclude from total
exclude_columns = ["Ungültige - Erststimmen", "Gültige - Erststimmen"]

# Columns to sum for total first votes
party_columns = [col for col in vote_columns if col not in exclude_columns]

# Ensure numeric
df[party_columns] = df[party_columns].apply(pd.to_numeric, errors='coerce')

# Create a new column for super-Gemeinde grouping
def super_gemeinde(name):
    if name.startswith("Berlin, Stadt, Bezirk"):
        return "Berlin"
    elif name.startswith("Hamburg, Freie und Hansestadt, Bezirk"):
        return "Hamburg"
    else:
        return name

df['Super_Gemeindename'] = df['Gemeindename'].apply(super_gemeinde)

# Group by 'Super_Gemeindename' and sum votes
grouped = df.groupby('Super_Gemeindename')[party_columns].sum().reset_index()

# Calculate total first votes per super-Gemeinde (sum of all parties)
grouped['Erststimmen'] = grouped[party_columns].sum(axis=1)

# Calculate AfD percentage
grouped['%AFD'] = 100 * grouped['AfD - Erststimmen'] / grouped['Erststimmen']

# Prepare output
output = grouped[['Super_Gemeindename', 'Erststimmen', 'AfD - Erststimmen', '%AFD']]

# Save to CSV
output.to_csv("afd_share_per_super_gemeinde.csv", sep=';', index=False, encoding='utf-8')
