"""Collect archived Zoopla listing-page observations from the Wayback Machine.

Reconstructed from Appendix 5. Website structures and archive behavior may have
changed since the original project, so selectors should be treated as historical.
Respect the Internet Archive's terms and use a conservative request delay.
"""
from __future__ import annotations

import argparse
import logging
import re
import time
from pathlib import Path

import pandas as pd
import requests
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options

LOGGER = logging.getLogger(__name__)
YEARS = range(2012, 2021)
ARCHIVE_ROOT = "https://web.archive.org"
TARGET_URL = "https://www.zoopla.co.uk/to-rent/property/fife/st-andrews/"
USER_AGENT = "Mozilla/5.0 (compatible; academic-research-portfolio/1.0)"


def make_driver(headless: bool = True) -> webdriver.Chrome:
    options = Options()
    if headless:
        options.add_argument("--headless=new")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    return webdriver.Chrome(options=options)


def collect_snapshot_links(driver: webdriver.Chrome, years=YEARS) -> list[str]:
    links: list[str] = []
    for year in years:
        calendar_url = f"{ARCHIVE_ROOT}/web/{year}1201000000*/{TARGET_URL}"
        LOGGER.info("Opening %s", calendar_url)
        driver.get(calendar_url)
        time.sleep(3)
        soup = BeautifulSoup(driver.page_source, "lxml")
        grid = soup.find("div", class_="calendar-grid")
        if grid is None:
            LOGGER.warning("No calendar grid found for %s", year)
            continue
        for anchor in grid.find_all("a", href=True):
            href = anchor["href"]
            links.append(href if href.startswith("http") else ARCHIVE_ROOT + href)
    return sorted(set(links))


def parse_snapshot(session: requests.Session, url: str) -> list[dict]:
    response = session.get(url, timeout=30)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, "html.parser")
    results = soup.find_all("li", class_="clearfix")
    match = re.search(r"/web/(\d{8})", url)
    snapshot_date = match.group(1) if match else None
    rows: list[dict] = []

    for result in results:
        rent_node = result.find("a", class_="listing-results-price")
        address_node = result.find("a", class_="listing-results-address")
        type_node = result.find("h2", class_="listing-results-attr")
        if not all((rent_node, address_node, type_node)):
            continue

        rent_values = [int(x) for x in re.findall(r"\b\d+\b", rent_node.get_text().replace(",", ""))]
        bedroom_digits = re.findall(r"\d+", type_node.get_text())
        if not rent_values or not bedroom_digits:
            continue

        # The original code used the second numeric token for one specific snapshot.
        rent_index = 1 if snapshot_date == "20120109" and len(rent_values) > 1 else 0
        rows.append({
            "date": snapshot_date,
            "rent": rent_values[rent_index],
            "bedrooms": int(bedroom_digits[0]),
            "address": address_node.get_text(" ", strip=True),
            "archive_url": url,
        })
    return rows


def main(output: Path, delay: float) -> None:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(message)s")
    driver = make_driver()
    try:
        links = collect_snapshot_links(driver)
    finally:
        driver.quit()

    session = requests.Session()
    session.headers.update({"User-Agent": USER_AGENT})
    housing: list[dict] = []
    for link in links:
        try:
            housing.extend(parse_snapshot(session, link))
        except requests.RequestException as exc:
            LOGGER.warning("Skipping %s: %s", link, exc)
        time.sleep(delay)

    frame = pd.DataFrame(housing)
    if not frame.empty:
        frame["date"] = pd.to_datetime(frame["date"], format="%Y%m%d", errors="coerce")
        frame = frame.drop_duplicates()
    output.parent.mkdir(parents=True, exist_ok=True)
    frame.to_csv(output, index=False)
    LOGGER.info("Wrote %s rows to %s", len(frame), output)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, default=Path("data/interim/zoopla_wayback_raw.csv"))
    parser.add_argument("--delay", type=float, default=2.0)
    args = parser.parse_args()
    main(args.output, args.delay)
