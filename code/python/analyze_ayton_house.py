"""Inflation-adjusted descriptive analysis of Ayton House room rents.

The original appendix hard-coded CPIH arrays by room type. This version expects
CPIH to be provided as a year-indexed CSV so observations align explicitly.
"""
from __future__ import annotations

import argparse
from pathlib import Path
import matplotlib.pyplot as plt
import pandas as pd


def main(rents_path: Path, cpih_path: Path, output_path: Path) -> None:
    rents = pd.read_csv(rents_path)
    cpih = pd.read_csv(cpih_path)
    required_rents = {"Date", "Type", "Rent_week"}
    required_cpih = {"year", "CPIH"}
    if missing := required_rents.difference(rents.columns):
        raise ValueError(f"Rent file missing columns: {sorted(missing)}")
    if missing := required_cpih.difference(cpih.columns):
        raise ValueError(f"CPIH file missing columns: {sorted(missing)}")

    rents["Date"] = pd.to_datetime(rents["Date"])
    rents["year"] = rents["Date"].dt.year
    data = rents.merge(cpih, on="year", how="left", validate="many_to_one")
    if data["CPIH"].isna().any():
        missing_years = sorted(data.loc[data["CPIH"].isna(), "year"].unique())
        raise ValueError(f"Missing CPIH values for years: {missing_years}")

    data["real_rent_week"] = data["Rent_week"] / data["CPIH"] * 100
    fig, ax = plt.subplots(figsize=(10, 6))
    for room_type, group in data.groupby("Type"):
        group = group.sort_values("year")
        ax.plot(group["year"], group["real_rent_week"], marker="o", label=room_type)
    ax.set(title="Ayton House Weekly Rent Adjusted by CPIH", xlabel="Year", ylabel="Real weekly rent (£, index base=100)")
    ax.legend(fontsize=7, bbox_to_anchor=(1.02, 1), loc="upper left")
    fig.tight_layout()
    output_path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output_path, dpi=300)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--rents", type=Path, default=Path("data/raw/ayton_house.csv"))
    parser.add_argument("--cpih", type=Path, default=Path("data/raw/cpih_by_year.csv"))
    parser.add_argument("--output", type=Path, default=Path("outputs/figures/ayton_house_real_rents.png"))
    args = parser.parse_args()
    main(args.rents, args.cpih, args.output)
