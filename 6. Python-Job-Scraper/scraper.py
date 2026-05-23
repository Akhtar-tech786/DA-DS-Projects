import requests
from bs4 import BeautifulSoup
import csv

# Website URL
url = "https://realpython.github.io/fake-jobs/"
base_url = "https://realpython.github.io"

# Send HTTP request
response = requests.get(url)

# Check if request succeeded
if response.status_code == 200:

    # Parse HTML
    soup = BeautifulSoup(response.text, "html.parser")

    # Find all job cards
    job_cards = soup.find_all("div", class_="card-content")

    # Open CSV file
    with open("jobs.csv", mode="w", newline="", encoding="utf-8") as file:

        writer = csv.writer(file)

        # Write header
        writer.writerow(["Job Title", "Company", "Location", "URL"])

        # Loop through jobs
        for job in job_cards:

            # Extract fields safely
            title_tag = job.find("h2", class_="title")
            company_tag = job.find("h3", class_="company")
            location_tag = job.find("p", class_="location")
            link_tags = job.find_all("a")

            # Handle missing fields
            title = title_tag.text.strip() if title_tag else "N/A"

            company = company_tag.text.strip() if company_tag else "N/A"

            location = location_tag.text.strip() if location_tag else "N/A"

            if len(link_tags) > 1:
                full_link = link_tags[1]["href"]
            else:
                full_link = "N/A"

            # Write row to CSV
            writer.writerow([title, company, location, full_link])

    print("Jobs successfully saved to jobs.csv")

else:
    print("Failed to fetch webpage")