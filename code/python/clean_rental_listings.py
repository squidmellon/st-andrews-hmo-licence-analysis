"""Clean historical rental listings collected from archived webpages."""
from __future__ import annotations

import argparse
from pathlib import Path
import pandas as pd

NON_ST_ANDREWS_TERMS = ("dundee", "kirkcaldy", "cupar", "boarhills", "boarhill")
ST_ANDREWS_TERMS = ("st andrews", "st. andrews", "st-andrews", "saint andrews")


def clean_listings(frame: pd.DataFrame) -> pd.DataFrame:
    required = {"date", "rent", "bedrooms", "address"}
    missing = required.difference(frame.columns)
    if missing:
        raise ValueError(f"Missing columns: {sorted(missing)}")

    data = frame.copy()
    data["date"] = pd.to_datetime(data["date"], errors="coerce")
    data["listing_year"] = data["date"].dt.year
    data["address_clean"] = data["address"].astype(str).str.replace(r"\s+", " ", regex=True).str.strip()
    lower = data["address_clean"].str.lower()
    data["explicit_non_st_andrews"] = lower.apply(lambda x: any(term in x for term in NON_ST_ANDREWS_TERMS))
    data["explicit_st_andrews"] = lower.apply(lambda x: any(term in x for term in ST_ANDREWS_TERMS))
    data = data.loc[~data["explicit_non_st_andrews"]].copy()

    # Original workflow treated repeated address-rent-property-type records
    # within a year as suspected duplicates.
    data = data.drop_duplicates(subset=["listing_year", "rent", "bedrooms", "address_clean"])
    data["rent_per_room"] = data["rent"] / data["bedrooms"].replace(0, pd.NA)
    return data.sort_values(["listing_year", "address_clean"])


def main(input_path: Path, output_path: Path) -> None:
    frame = pd.read_csv(input_path)
    cleaned = clean_listings(frame)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    cleaned.to_csv(output_path, index=False)
    print(f"Wrote {len(cleaned)} rows to {output_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, default=Path("data/interim/zoopla_wayback_raw.csv"))
    parser.add_argument("--output", type=Path, default=Path("data/processed/rental_listings_clean.csv"))
    args = parser.parse_args()
    main(args.input, args.output)
