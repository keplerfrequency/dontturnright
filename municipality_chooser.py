import csv
import math

# Input CSV file
input_csv = "germany_municipalities_jun_2025.csv"

# Output TXT file
output_txt = "cities_output.txt"

# List to hold formatted rows (pop, formatted_string)
rows = []

with open(input_csv, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    for row in reader:
        pop = int(row["population_total"])
        if pop > 2500:  # Only include municipalities with population > 1000
            name = row["municipality_name_(gemeindename)"].replace('"', '\\"')
            
            # Convert to float and round to 3 decimals
            lon = float(row["longitude"].replace(",", "."))
            lat = float(row["latitude"].replace(",", "."))
            
            # Round population up to nearest 1000 and divide by 1000
            pop_thousands = math.ceil(pop / 1000)
            
            # Store population for sorting and the formatted string
            formatted = f'    ["{name}", {lon:.3f}, {lat:.3f}, {pop_thousands}],'
            rows.append((pop, formatted))

# Sort rows by population descending
rows.sort(key=lambda x: x[0], reverse=True)

# Write to output file
with open(output_txt, "w", encoding="utf-8") as f:
    f.write("// [municipality_name_(gemeindename), longitude, latitude, population_total]\n")
    f.write("[\n")
    for i, (_, line) in enumerate(rows):
        # avoid trailing comma on last element
        if i == len(rows) - 1:
            f.write(line.rstrip(',') + "\n")
        else:
            f.write(line + "\n")
    f.write("]\n")

print(f"Output written to {output_txt}")
