# Summary
Post-merge independent code review fixes for P1 critical bugs and P2 enhancements.

# Changes
The changes made in this PR are:
1. P1: read_fit_track timestamp conversion handles numeric or POSIXct inputs
2. P1: analyse_track uses NA_character_ for geo fallback and cleans up temp downloads
3. P2: analyse_track and analyse_gpx roxygen titles added
4. P2: plot_route leaflet popup null-guard for missing elevation data
5. P2: calculate_elevation_stats guards 0-row input

# Checks
- [x] All R CMD checks pass (local verification)
- [x] `roxygen2::roxygenise()` has been run prior to merging to ensure that `.Rd` and `NAMESPACE` files are up to date.
- [ ] `NEWS.md` has been updated.
- [ ] If a new version is required, create a new version with `usethis::use_version()`.
- [x] When adding a new function, run `devtools::load_all()` and test new functions, especially on visualisations that are not covered by tests.

# Notes
This fixes bugs identified during post-merge independent review. No specific issue number assigned.

*Independent review required before merge per PR template.*
