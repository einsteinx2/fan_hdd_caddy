#!/usr/bin/env bash
#
# Export the fan HDD caddy to a timestamped 3MF file for Bambu Studio.
#
# The caddy is one printed part, so each run writes one file per format. Every
# file produced in a single run shares ONE timestamp, so a batch sorts together
# and you can always tell which exports belong to the same run. 3MF (not STL) is
# used because it is Bambu Studio's native format: it carries units, is more
# precise, and packs smaller.
#
# Usage:   ./export.sh [3mf|stl|both]      (default: 3mf)
#   ./export.sh           # 3MF only (best for Bambu Studio)
#   ./export.sh stl       # STL only (for slicers that need it)
#   ./export.sh both      # both formats
# Override the OpenSCAD binary if needed:   OPENSCAD=/path/to/openscad ./export.sh
#
set -euo pipefail

# --- locate the OpenSCAD CLI ----------------------------------------------
# Prefer one on PATH; fall back to the macOS app bundle.
OPENSCAD="${OPENSCAD:-}"
if [[ -z "$OPENSCAD" ]]; then
    if command -v openscad >/dev/null 2>&1; then
        OPENSCAD="$(command -v openscad)"
    elif [[ -x /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD ]]; then
        OPENSCAD="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
    else
        echo "error: OpenSCAD CLI not found. Set OPENSCAD=/path/to/openscad." >&2
        exit 1
    fi
fi

# --- paths (resolved relative to this script, so cwd doesn't matter) -------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCAD="$SCRIPT_DIR/fan_hdd_caddy.scad"
OUT_DIR="$SCRIPT_DIR/exports"

# Output format(s), from the first argument (default: 3mf).
case "${1:-3mf}" in
    3mf)      FORMATS=(3mf) ;;
    stl)      FORMATS=(stl) ;;
    both|all) FORMATS=(3mf stl) ;;
    *) echo "usage: $0 [3mf|stl|both]   (default: 3mf)" >&2; exit 1 ;;
esac

# --- export ----------------------------------------------------------------
mkdir -p "$OUT_DIR"

# One shared timestamp for the whole run, captured in a single `date` call so
# the date and time can't straddle a second boundary. Readable segments keep
# the filename easy to scan: ISO date, then HHhMMmSSs time.
read -r STAMP_DATE STAMP_TIME < <(date +'%Y-%m-%d %Hh%Mm%Ss')

# OpenSCAD version, labelled in each filename (e.g. "OpenSCAD-2026.04.26") so
# it reads as a program version, not another date. Strip spaces for clean names.
VER="$("$OPENSCAD" --version 2>&1 | awk '{print $NF}' | tr -d '[:space:]')"

echo "OpenSCAD:  $OPENSCAD (version $VER)"
echo "Source:    $SCAD"
echo "Date/time: $STAMP_DATE $STAMP_TIME"
echo "Format(s): ${FORMATS[*]}"
echo
count=0
for ext in "${FORMATS[@]}"; do
    out="$OUT_DIR/fan_hdd_caddy_${STAMP_DATE}_${STAMP_TIME}_OpenSCAD-${VER}.${ext}"
    printf '  exporting %-3s -> %s\n' "$ext" "$out"
    "$OPENSCAD" -o "$out" "$SCAD" 2>/dev/null
    count=$((count + 1))
done
echo
echo "Done. $count files written to $OUT_DIR/"
