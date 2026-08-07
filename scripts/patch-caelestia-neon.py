#!/usr/bin/env python3
"""Patch scheme.json cua caelestia sang Neon Pink/Purple + nen den tim than.
Chay lai sau moi lan `caelestia scheme set` (lenh do reset file ve mac dinh)."""
import json
import os

PATH = os.path.expanduser("~/.local/state/caelestia/scheme.json")

PATCH = {
    "background": "120019", "surface": "120019", "surfaceDim": "0A0010",
    "surfaceBright": "2A0038", "surfaceContainerLowest": "08000C",
    "surfaceContainerLow": "170022", "surfaceContainer": "1B0027",
    "surfaceContainerHigh": "22002F", "surfaceContainerHighest": "2A0038",

    "onBackground": "FFB3D9", "onSurface": "FFB3D9", "onSurfaceVariant": "C9A0FF",
    "outline": "C9A0FF", "outlineVariant": "8A2BE2",
    "text": "FFB3D9", "subtext1": "E8A8C8", "subtext0": "C9A0FF",
    "overlay2": "A78BC9", "overlay1": "8B6FA8", "overlay0": "6B5285",

    "primary": "FF10F0", "onPrimary": "2A0038", "primaryContainer": "5E00A3",
    "onPrimaryContainer": "FFD6FA", "primaryFixed": "FF6EF9", "primaryFixedDim": "FF10F0",
    "onPrimaryFixed": "2A0038", "onPrimaryFixedVariant": "5E00A3",
    "inversePrimary": "8A2BE2", "surfaceTint": "FF10F0",

    "secondary": "8A2BE2", "onSecondary": "E6D6FF", "secondaryContainer": "4B0082",
    "onSecondaryContainer": "E6D6FF", "secondaryFixed": "A855F7", "secondaryFixedDim": "8A2BE2",
    "onSecondaryFixed": "FFFFFF", "onSecondaryFixedVariant": "4B0082",

    "tertiary": "FFB3D9", "onTertiary": "2A0038", "tertiaryContainer": "C8A2FA",
    "onTertiaryContainer": "2A0038", "tertiaryFixed": "FFB3D9", "tertiaryFixedDim": "C9A0FF",
    "onTertiaryFixed": "2A0038", "onTertiaryFixedVariant": "4B0082",
}

with open(PATH, encoding="utf-8") as f:
    data = json.load(f)

colours = data["colours"]
applied = [k for k in PATCH if k in colours]
skipped = [k for k in PATCH if k not in colours]
colours.update({k: v for k, v in PATCH.items() if k in colours})

with open(PATH, "w", encoding="utf-8") as f:
    json.dump(data, f)

print(f"Da patch {len(applied)} key: {', '.join(applied)}")
if skipped:
    print(f"Bo qua (khong co trong scheme nen): {', '.join(skipped)}")