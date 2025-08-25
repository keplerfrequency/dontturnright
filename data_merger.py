import pandas as pd
import ast

# Load the AfD CSV
afd_df = pd.read_csv("afd_share_per_super_gemeinde.csv", sep=';', encoding='utf-8')

# Create a clean column for matching: take everything before the first comma, lowercase
afd_df['Gemeindename_clean'] = afd_df['Super_Gemeindename'].str.split(pat=',', n=1).str[0].str.strip().str.lower()

# Read your municipality list from the file, skipping comment lines
with open("cities_output.txt", "r", encoding="utf-8") as f:
    lines = f.readlines()
    content = "".join(line for line in lines if not line.strip().startswith("//"))
    municipalities = ast.literal_eval(content)  # safely parse the list

# Prepare new list and counters
new_municipalities = []
matches_list = []
matches = 0
missed = 0

for entry in municipalities:
    city_name = entry[0].strip()           # original name from cities_output.txt
    name_clean = city_name.lower()         # lowercase for matching
    match = afd_df[afd_df['Gemeindename_clean'] == name_clean]
    if not match.empty:
        # Convert to plain Python float and round to 1 decimal
        afd_percentage = round(float(match['%AFD'].values[0]))
        new_municipalities.append(entry + [afd_percentage])
        # Add both names to matches list
        afd_name = match['Super_Gemeindename'].values[0]
        matches_list.append(f"{afd_name} <-> {city_name}")
        matches += 1
    else:
        new_municipalities.append(entry + [None])
        missed += 1

# Save matches to a file with both names
with open("matches.txt", "w", encoding="utf-8") as f:
    for m in matches_list:
        f.write(m + "\n")

# Print summary
print(f"Matches found: {matches}")
print(f"Gemeinde not found: {missed}")

# Save the final list in Python list format
with open("cities_with_afd.txt", "w", encoding="utf-8") as f:
    f.write("[\n")
    for i, entry in enumerate(new_municipalities):
        line = f"    {entry}"
        if i < len(new_municipalities) - 1:
            line += ","
        line += "\n"
        f.write(line)
    f.write("]")
