#!/bin/bash

# Fetch the API data and save it to a variable
API_URL="https://speed.cloudflare.com/meta"
response=$(curl -s "$API_URL")

# Print the raw response to verify structure
echo "Raw API response:"
echo "$response"

# Function to extract JSON fields safely
extract_field() {
  echo "$response" | grep -oP "\"$1\":\s*\"[^\"]+\"" | sed "s/\"$1\":\s*\"//g" | sed 's/"//g'
}

# Extract required fields
hostname=$(extract_field "hostname")
clientIp=$(extract_field "clientIp")
httpProtocol=$(extract_field "httpProtocol")
asn=$(extract_field "asn")
asOrganization=$(extract_field "asOrganization")
colo=$(extract_field "colo")
country=$(extract_field "country")
city=$(extract_field "city")
region=$(extract_field "region")
postalCode=$(extract_field "postalCode")
latitude=$(extract_field "latitude")
longitude=$(extract_field "longitude")

# Check if hostname exists (main identifier)
if [ -z "$hostname" ]; then
  echo "Hostname not found in response. Exiting."
  exit 1
fi

# Function to sanitize folder names (replace non-alphanumeric characters with underscores)
sanitize() {
  echo "$1" | sed 's/[^a-zA-Z0-9]/_/g'
}

# Sanitize all extracted values
sanitized_hostname=$(sanitize "$hostname")
sanitized_clientIp=$(sanitize "$clientIp")
sanitized_httpProtocol=$(sanitize "$httpProtocol")
sanitized_asn=$(sanitize "$asn")
sanitized_asOrganization=$(sanitize "$asOrganization")
sanitized_colo=$(sanitize "$colo")
sanitized_country=$(sanitize "$country")
sanitized_city=$(sanitize "$city")
sanitized_region=$(sanitize "$region")
sanitized_postalCode=$(sanitize "$postalCode")
sanitized_latitude=$(sanitize "$latitude")
sanitized_longitude=$(sanitize "$longitude")

# Create the main "tracing_info" folder
main_folder="tracing_info"
mkdir -p "$main_folder"

# Create individual folders and text files inside "tracing_info"
declare -A fields=(
  ["hostname"]="$hostname"
  ["clientIp"]="$clientIp"
  ["httpProtocol"]="$httpProtocol"
  ["asn"]="$asn"
  ["asOrganization"]="$asOrganization"
  ["colo"]="$colo"
  ["country"]="$country"
  ["state"]="$region"
  ["city"]="$city"
  ["postalCode"]="$postalCode"
  ["latitude"]="$latitude"
  ["longitude"]="$longitude"
)

for key in "${!fields[@]}"; do
  folder_name="$main_folder/${key}"
  mkdir -p "$folder_name" # Create folder if not exists
  
  # Save the actual value into a hidden text file inside the folder
  echo "${fields[$key]}" > "$folder_name/${key}_data.txt"
  
  echo "Created folder: $folder_name with hidden data file"
done

cmd.exe /c project1_batch.bat
