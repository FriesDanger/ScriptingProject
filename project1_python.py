import os
import urllib.request
import json
from datetime import datetime, timedelta

# Finding the current directory where the script's source code is located
dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tracing_info")
print("Current directory where the script's source is", dir)

# Walk through the directory and subdirectories
for dirpath, dirnames, filenames in os.walk(dir):
    print('Current Path:', dirpath)
    print('Directories:', dirnames)
    print('Files:', filenames)
    print()


def get_sun_times(lat, lng, date=None):
    base_url = "https://api.sunrise-sunset.org/json"
    query = f"?lat={lat}&lng={lng}"
    
    if date:
        query += f"&date={date}"
    
    query += "&formatted=1"  # Use AM/PM format

    with urllib.request.urlopen(base_url + query) as response:
        data = json.loads(response.read().decode())

    results = data["results"]

    sunrise_utc = datetime.strptime(results['sunrise'], "%I:%M:%S %p")
    sunset_utc = datetime.strptime(results['sunset'], "%I:%M:%S %p")
    # Convert UTC to local time (UTC-4)
    offset = timedelta(hours=-4)
    sunrise_local = sunrise_utc + offset
    sunset_local = sunset_utc + offset

    # Prepare the output as a string
    output = f"\n📍 Location: ({lat}, {lng}) on {date or 'today'}\n"
    output += f"🌅 Sunrise (Local): {sunrise_local.strftime('%I:%M:%S %p')}\n"
    output += f"🌇 Sunset  (Local): {sunset_local.strftime('%I:%M:%S %p')}\n"
    day_length_str = results['day_length']  # e.g., "13:11:37"
    hours, minutes, seconds = map(int, day_length_str.split(":"))
    output += f"🕒 Day length: {hours}h {minutes}m\n"

    return output


latitude_path = os.path.join(dir, "latitude", "latitude_data.txt")
longitude_path = os.path.join(dir, "longitude", "longitude_data.txt")

with open(latitude_path, 'r') as latitudeFile, open(longitude_path, 'r') as longitudeFile:
    content1 = latitudeFile.read().strip()
    content2 = longitudeFile.read().strip()


# Define the path for the nested directories
nested_directory_path = os.path.join(dir, "sunrise_and_sunset")

# Create the nested directories if necessary
os.makedirs(nested_directory_path, exist_ok=True)

# Define the path for the log file
logfile_path = os.path.join(nested_directory_path, "logfile.txt")

# Open the log file in append mode with UTF-8 encoding
with open(logfile_path, 'a', encoding='utf-8') as file:
    # Call the function and get the output
    output = get_sun_times(content1, content2, date=None)
    # Write the output to the log file
    file.write(output + '\n')

print(f"Output logged to {logfile_path}")
