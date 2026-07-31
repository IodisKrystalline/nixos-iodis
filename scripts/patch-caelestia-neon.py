#!/usr/bin/env python3
"""
Patch mau Neon Pink/Purple/Lavender + nen den tim than vao scheme.json
cua caelestia. Chi dong vao nhom primary/secondary/tertiary (Main/Sub/Text)
va nhom background/surface* (nen dashboard/widget), giu nguyen cac key
con lai (outline, term*, ...) tu scheme nen (catppuccin/mocha).

Chay lai script nay MOI LAN sau khi ban dung `caelestia scheme set`,
vi lenh do se ghi de scheme.json ve nguyen ban goc.
"""
import json
import os

PATH = os.path.expanduser("~/.local/state/caelestia/scheme.json")

PATCH = {
    # Nen: Den tim than (eggplant/purple-black)
    "background":              "120019",
    "surface":                 "120019",
    "surfaceDim":              "0A0010",
    "surfaceBright":           "2A0038",
    "surfaceContainerLowest":  "08000C",
    "surfaceContainerLow":     "170022",
    "surfaceContainer":        "1B0027",
    "surfaceContainerHigh":    "22002F",
    "surfaceContainerHighest": "2A0038",

    # Main: Neon Pink
    "primary":               "FF10F0",
    "onPrimary":              "2A0038",
    "primaryContainer":       "5E00A3",
    "onPrimaryContainer":     "FFD6FA",
    "primaryFixed":           "FF6EF9",
    "primaryFixedDim":        "FF10F0",
    "onPrimaryFixed":         "2A0038",
    "onPrimaryFixedVariant":  "5E00A3",
    "inversePrimary":         "8A2BE2",
    "surfaceTint":            "FF10F0",

    # Sub: Neon Purple
    "secondary":              "8A2BE2",
    "onSecondary":            "E6D6FF",
    "secondaryContainer":     "4B0082",
    "onSecondaryContainer":   "E6D6FF",
    "secondaryFixed":         "A855F7",
    "secondaryFixedDim":      "8A2BE2",
    "onSecondaryFixed":       "FFFFFF",
    "onSecondaryFixedVariant":"4B0082",

    # Text khac: Lavender
    "tertiary":               "FFB3D9",
    "onTertiary":              "2A0038",
    "tertiaryContainer":       "C8A2FA",
    "onTertiaryContainer":     "2A0038",
    "tertiaryFixed":           "FFB3D9",
    "tertiaryFixedDim":        "C9A0FF",
    "onTertiaryFixed":         "2A0038",
    "onTertiaryFixedVariant":  "4B0082",
}

with open(PATH, encoding="utf-8") as f:
    data = json.load(f)

colours = data["colours"]
applied, skipped = [], []
for key, hexval in PATCH.items():
    if key in colours:
        colours[key] = hexval
        applied.append(key)
    else:
        skipped.append(key)

with open(PATH, "w", encoding="utf-8") as f:
    json.dump(data, f)

print(f"Da patch {len(applied)} key: {', '.join(applied)}")
if skipped:
    print(f"Bo qua (khong ton tai trong scheme nen): {', '.join(skipped)}")