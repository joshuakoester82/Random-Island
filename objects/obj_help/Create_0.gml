offsetmax = 0;
offsetmin =  1440;
offset_speed = 50;
is_help = false;
yoffset = 0;
help_text = @"TERRAIN GENERATION PARAMETERS GUIDE

This world generator uses Perlin noise to create natural-looking terrain. Each parameter affects how the terrain is shaped and distributed.

CORE MODIFIERS
-------------
Lake Modifier (0.3 - 0.7, default: 0.49)
Controls how likely plains are to become lakes and wetlands during biome generation.
- Low values (0.3-0.4): Few water features, mostly dry land
- High values (0.6-0.7): Abundant lakes and swamps, creating wetland-rich terrain

Elevation Modifier (0.3 - 0.7, default: 0.5)
Affects the overall height of terrain. This influences how much of the map becomes ocean vs. land.
- Low values (0.3-0.4): Mostly ocean with island chains
- High values (0.6-0.7): Mostly land with inland seas

Radius Falloff (0.2 - 1.0, default: 0.6)
Controls how quickly terrain height decreases from center to edges.
- Low values (0.2-0.4): Sharp falloff, creating a circular continent
- High values (0.8-1.0): Gentle falloff, allowing land to extend to map edges

GEOGRAPHY GENERATION
-------------------
Base Scale (4.0 - 16.0, default: 10)
Controls the size of major terrain features.
- Low values (4-6): Small, scattered islands
- Medium values (8-12): Natural-looking continents
- High values (14-16): Large, blob-like landmasses

Octaves (2 - 5, default: 4)
Determines how detailed the terrain is.
- 2 octaves: Smooth, simple terrain
- 3-4 octaves: Natural-looking detail
- 5 octaves: Very detailed but more computation
WARNING: Each additional octave doubles generation time!

Persistence (0.3 - 0.8, default: 0.45)
Controls how much each octave affects the final shape.
- Low values (0.3-0.4): Smooth, gentle transitions
- Medium values (0.45-0.55): Natural variation
- High values (0.7-0.8): Rough, dramatic terrain

GEOGRAPHY THRESHOLDS
-------------------
These determine the height ranges for each terrain type. Must maintain order:
Deep Water < Shallow Water < Beach < Plains < Hills

Deep Water (0.1 - 0.3, default: 0.25)
Shallow Water (0.25 - 0.35, default: 0.3)
Beach (0.3 - 0.4, default: 0.32)
Plains (0.4 - 0.6, default: 0.5)
Hills (0.5 - 0.7, default: 0.55)

Adjusting these thresholds changes the proportion of each terrain type:
- Raising a threshold increases everything below it
- Lowering a threshold increases everything above it

BIOME GENERATION
---------------
Creates variation in land areas with a natural progression from wet to dry:

Base Scale (3.0 - 12.0, default: 6)
- Lower than geography for more local variation
- Controls size of biome regions

Octaves (2 - 4, default: 3)
- Affects detail of biome transitions
- Keep lower than geography for performance

Persistence (0.3 - 0.8, default: 0.5)
- Controls how sharply biomes transition
- Higher values create more scattered biomes

BIOME THRESHOLDS
---------------
Must maintain order: Lake < Swamp < Plains < Forest

Lake (0.2 - 0.4, default: 0.35)
Areas of standing water within the terrain.

Swamp (0.35 - 0.5, default: 0.45)
Transitional zones between water and dry land.
- Creates wetlands around lakes
- More realistic transition from water to land

Plains (0.45 - 0.6, default: 0.5)
Open, dry land areas.

Forest (0.5 - 0.7, default: 0.6)
Densely vegetated regions.

This progression creates natural-looking landscapes where swamps form around water bodies before transitioning to drier terrain.

TIPS FOR GOOD GENERATION
-----------------------
1. Start with default values and make small adjustments
2. Keep thresholds properly ordered for natural transitions
3. Don't set values too extreme
4. If terrain looks too noisy, lower persistence
5. If terrain looks too blob-like, lower base scale
6. Adjust lake modifier to control wetland density
7. Generate several maps to see the range of results

Press F1 to generate a new map with current settings.
Hold CTRL while adjusting values for larger changes.
Click and drag on parameter bars to smoothly adjust values.";