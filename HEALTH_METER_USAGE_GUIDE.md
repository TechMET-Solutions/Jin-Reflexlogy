# Health Meter Widget - Usage Guide

## Overview
A custom Flutter widget that creates an animated health meter (speedometer/gauge) without any external packages. Uses only `Image.asset`, `Transform.rotate`, and built-in Flutter animations.

## Features
✅ No external packages required
✅ Smooth animations with customizable duration and curves
✅ Responsive design for all screen sizes
✅ Health value range: 0-100
✅ Automatic color coding (Poor/Fair/Good/Excellent)
✅ Customizable appearance
✅ Multiple meter support

## Files Created

### 1. `lib/widgets/health_meter_widget.dart`
Basic health meter widget with essential features.

### 2. `lib/widgets/advanced_health_meter_widget.dart`
Advanced version with full customization options.

### 3. `lib/screens/treatment/health_meter_example_screen.dart`
Simple example with slider control.

### 4. `lib/screens/treatment/health_meter_demo_screen.dart`
Comprehensive demo with multiple meters.

## Quick Start

### Step 1: Add Images to Assets

Add your meter images to `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/meter_bg.png
    - assets/needle.png
```

### Step 2: Basic Usage

```dart
import 'package:jin_reflex_new/widgets/health_meter_widget.dart';

HealthMeterWidget(
  healthValue: 75.0,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
  width: 300,
  height: 300,
)
```

### Step 3: With Animation Control

```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  double _healthValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HealthMeterWidget(
          healthValue: _healthValue,
          meterBackgroundImage: 'assets/meter_bg.png',
          needleImage: 'assets/needle.png',
        ),
        Slider(
          value: _healthValue,
          min: 0,
          max: 100,
          onChanged: (value) {
            setState(() => _healthValue = value);
          },
        ),
      ],
    );
  }
}
```

## Customization Options

### Basic Widget Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `healthValue` | `double` | Required | Health value (0-100) |
| `meterBackgroundImage` | `String` | Required | Path to background image |
| `needleImage` | `String` | Required | Path to needle image |
| `width` | `double` | 300 | Widget width |
| `height` | `double` | 300 | Widget height |
| `animationDuration` | `Duration` | 1500ms | Animation duration |
| `animationCurve` | `Curve` | easeInOut | Animation curve |
| `showValue` | `bool` | true | Show percentage value |
| `valueTextStyle` | `TextStyle?` | null | Custom text style |

### Advanced Widget Additional Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `startAngle` | `double` | -90 | Start angle in degrees |
| `endAngle` | `double` | 90 | End angle in degrees |
| `needleWidth` | `double` | 1.0 | Needle width ratio |
| `needleHeight` | `double` | 1.0 | Needle height ratio |
| `needlePivot` | `Alignment` | center | Needle rotation pivot |
| `centerWidget` | `Widget?` | null | Custom center widget |
| `onValueChanged` | `ValueChanged?` | null | Value change callback |

## Examples

### Example 1: Simple Meter
```dart
HealthMeterWidget(
  healthValue: 85.0,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
)
```

### Example 2: Custom Animation
```dart
HealthMeterWidget(
  healthValue: 60.0,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
  animationDuration: Duration(milliseconds: 2000),
  animationCurve: Curves.elasticOut,
)
```

### Example 3: Full Circle Meter
```dart
AdvancedHealthMeterWidget(
  healthValue: 75.0,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
  startAngle: -135,  // Start from bottom-left
  endAngle: 135,     // End at bottom-right
)
```

### Example 4: Custom Display
```dart
AdvancedHealthMeterWidget(
  healthValue: 90.0,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
  showValue: false,
  centerWidget: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.favorite, color: Colors.red, size: 40),
      Text('Healthy', style: TextStyle(fontSize: 20)),
    ],
  ),
)
```

## Image Requirements

### Meter Background Image
- Should be a semi-circle or full circle gauge
- Transparent background (PNG recommended)
- Include scale markings and labels
- Recommended size: 512x512 or 1024x1024

### Needle Image
- Should be a long, thin pointer
- Transparent background (PNG)
- Pivot point should be at the center or base
- Recommended size: 512x128 or similar ratio

## Angle Configuration

The meter uses radians for rotation:
- **Half Circle (180°)**: `startAngle: -90`, `endAngle: 90`
- **Three-Quarter Circle (270°)**: `startAngle: -135`, `endAngle: 135`
- **Full Circle (360°)**: `startAngle: 0`, `endAngle: 360`

## Health Status Ranges

| Status | Range | Color |
|--------|-------|-------|
| EXCELLENT | 75-100% | Green |
| GOOD | 50-74% | Light Green |
| FAIR | 25-49% | Yellow/Orange |
| POOR | 0-24% | Red |

## Integration with Existing Code

To use in your existing `helth_meeter_screen.dart`:

```dart
import 'package:jin_reflex_new/widgets/health_meter_widget.dart';

// In your build method:
HealthMeterWidget(
  healthValue: calculatedHealthValue,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
  width: MediaQuery.of(context).size.width * 0.8,
  height: MediaQuery.of(context).size.width * 0.8,
)
```

## Responsive Design

The widget automatically adapts to screen size:

```dart
// Will scale down on smaller screens
HealthMeterWidget(
  healthValue: 70.0,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
  width: MediaQuery.of(context).size.width * 0.9,
  height: MediaQuery.of(context).size.width * 0.9,
)
```

## Performance Tips

1. **Use cached images**: Images are automatically cached by Flutter
2. **Optimize image size**: Use appropriate resolution (512x512 is usually enough)
3. **Limit simultaneous animations**: Avoid animating too many meters at once
4. **Use const constructors**: When values don't change

## Troubleshooting

### Needle not rotating correctly
- Check that `startAngle` and `endAngle` match your meter design
- Verify needle image pivot point is correct
- Ensure health value is between 0-100

### Images not showing
- Verify image paths in `pubspec.yaml`
- Run `flutter pub get` after adding assets
- Check image file names match exactly (case-sensitive)

### Animation too fast/slow
- Adjust `animationDuration` parameter
- Try different `animationCurve` values (Curves.linear, Curves.easeIn, etc.)

## Next Steps

1. Add your meter background and needle images to `assets/` folder
2. Update `pubspec.yaml` with image paths
3. Import the widget in your screen
4. Customize parameters to match your design
5. Test with different health values

## Support

For issues or questions, refer to:
- Flutter documentation: https://flutter.dev/docs
- Transform.rotate: https://api.flutter.dev/flutter/widgets/Transform/Transform.rotate.html
- Animation: https://flutter.dev/docs/development/ui/animations
