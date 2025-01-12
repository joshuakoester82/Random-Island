# Procedural World Generator

A GameMaker Studio 2 project that generates procedural 2D worlds using Perlin noise, featuring multiple terrain types and biomes with real-time parameter adjustment.

## Features

- **Multi-pass Terrain Generation**
 - First pass creates base geography (oceans, beaches, plains, hills, mountains)
 - Second pass adds biome variation (lakes, swamps, plains, forests)
 - Smooth transitions between different terrain types

- **Real-time Parameter Adjustment**
 - Interactive sliders for all generation parameters
 - Live preview of parameter changes
 - Click-and-drag or keyboard input for value adjustment
 - Parameter descriptions and recommended ranges
 - Ability to save/copy current parameter values

- **Terrain Parameters**
 - Geographic Features:
   - Base scale (terrain feature size)
   - Octaves (detail levels)
   - Persistence (roughness)
   - Elevation modifiers
   - Radius falloff (land mass shape)
 - Biome Features:
   - Distribution controls
   - Transition thresholds
   - Natural progression from water to land

- **Terrain Types**
 - Water Bodies:
   - Deep Water
   - Shallow Water
   - Lakes
 - Land Features:
   - Beaches
   - Plains
   - Hills
   - Mountains
 - Biomes:
   - Swamps (transitional zones)
   - Forests

## Controls

- **F1**: Generate new world with current parameters
- **Mouse Wheel**: Zoom in/out
- **Arrow Keys**: Pan camera
- **Left Click + Drag**: Adjust parameter values
- **Ctrl + Parameter Adjustment**: Make larger value changes
- **Help Key**: Toggle parameter documentation overlay

## Parameter Guidelines

### Core Parameters
- Lake Modifier (0.3 - 0.7): Controls water feature frequency
- Elevation Modifier (0.3 - 0.7): Affects land-to-water ratio
- Radius Falloff (0.2 - 1.0): Controls continent shape

### Generation Parameters
- Base Scale (4.0 - 16.0): Controls feature size
- Octaves (2 - 5): Affects detail level
- Persistence (0.3 - 0.8): Controls terrain roughness

Full parameter documentation available in-game through the help overlay.

## Technical Details

- Uses Perlin noise for natural-looking terrain generation
- Implements bounded thresholds for consistent terrain transitions
- Features optimized distance calculations for radius falloff
- Supports dynamic camera control and zooming
- Parameter values can be exported for reuse

## Installation

1. Open the project in GameMaker Studio 2
2. All required scripts and objects are included
3. Run the game to start generating worlds

## Usage Notes

- Parameters are designed to work together - extreme values may produce unexpected results
- Each parameter has recommended ranges for best results
- Generate multiple worlds to see the range of possible outcomes
- Use the help overlay to understand parameter effects
- Save parameter values when you find combinations you like

## Performance Considerations

- Higher octave values increase generation time
- Large world sizes may impact performance
- Zoom and pan operations are optimized for smooth camera movement