# Health Meter Setup Guide

## ✅ What I've Done

1. **Replaced Syncfusion Gauge** with custom image-based health meter (no external packages)
2. **Updated `helth_meeter_screen.dart`** to use `HealthMeterWidget`
3. **Added assets** to `pubspec.yaml`

## 📋 Required Images

You need to add these two images to your `assets/` folder:

### 1. `assets/meter_bg.png` - Meter Background
- Semi-circle gauge with colored zones (Red, Orange, Yellow, Green)
- Labels: POOR, FAIR, GOOD, EXCELLENT
- Percentage markings: 0%, 25%, 50%, 75%, 100%
- Transparent background (PNG)
- Recommended size: 512x512px or 1024x1024px

### 2. `assets/needle.png` - Needle/Pointer
- Long, thin pointer/arrow
- Should point upward in the image
- Transparent background (PNG)
- Recommended size: 512x128px or similar ratio

## 🎨 Image Design Tips

### Meter Background Design:
```
     50%
  25%   75%
FAIR GOOD EXCELLENT
  🔴🟠🟡🟢
0%  POOR    100%
```

The meter should be a semi-circle (180 degrees) with:
- Red zone (0-25%): POOR
- Orange zone (25-50%): FAIR  
- Yellow zone (50-75%): GOOD
- Green zone (75-100%): EXCELLENT

### Needle Design:
- Simple arrow or pointer shape
- Pivot point at the center/base
- Should be long enough to reach the meter edge
- Dark color (black/dark gray) for visibility

## 🚀 Quick Start

### Option 1: Use Your Own Images
1. Create or download meter background and needle images
2. Save them as:
   - `assets/meter_bg.png`
   - `assets/needle.png`
3. Run: `flutter pub get`
4. Hot reload the app

### Option 2: Use Online Resources
You can find free gauge/speedometer images from:
- Flaticon.com (search "speedometer", "gauge", "meter")
- Freepik.com (search "health meter", "gauge")
- Create your own using Canva or Figma

### Option 3: Temporary Placeholder
The widget has built-in error handling. If images are missing:
- Background: Shows gray placeholder
- Needle: Shows black line

## 📱 Testing

After adding images:

1. **Hot Reload**: Press `r` in terminal or hot reload button
2. **Navigate**: Go to Health Meter screen in your app
3. **Test**: Check/uncheck lifestyle items to see the needle animate

## 🎯 Customization

You can customize the meter in `helth_meeter_screen.dart`:

```dart
HealthMeterWidget(
  healthValue: value,
  meterBackgroundImage: 'assets/meter_bg.png',
  needleImage: 'assets/needle.png',
  width: 280,              // Change size
  height: 280,
  animationDuration: const Duration(milliseconds: 1500), // Speed
  animationCurve: Curves.easeInOut, // Animation style
  showValue: true,         // Show percentage
)
```

## 🔧 Troubleshooting

### Images not showing?
1. Check file names match exactly (case-sensitive)
2. Verify images are in `assets/` folder (not `assets/images/`)
3. Run `flutter pub get`
4. Stop and restart the app (not just hot reload)

### Needle not rotating correctly?
- Ensure needle image points upward
- Check that meter is semi-circle (180 degrees)
- Adjust `startAngle` and `endAngle` if needed

### Animation issues?
- Try different `animationCurve` values:
  - `Curves.linear` - Constant speed
  - `Curves.easeInOut` - Smooth start/end
  - `Curves.elasticOut` - Bouncy effect
  - `Curves.bounceOut` - Bounce at end

## 📊 Current Implementation

The health meter now:
- ✅ Uses NO external packages (removed Syncfusion dependency)
- ✅ Animates smoothly when values change
- ✅ Shows health percentage and status
- ✅ Color-coded based on health score
- ✅ Responsive for all screen sizes
- ✅ Calculates score from 27 lifestyle factors

## 🎨 Example Image References

Based on the images you shared, your meter should look like:
- Semi-circular gauge
- Color zones: Red → Orange → Yellow → Green
- Labels at top: POOR, FAIR, GOOD, EXCELLENT
- Percentage markers: 0%, 25%, 50%, 75%, 100%
- Black needle pointing to current health score

## 📝 Next Steps

1. **Add your meter images** to `assets/` folder
2. **Run** `flutter pub get`
3. **Test** the health meter screen
4. **Adjust** sizes/animations as needed

## 💡 Pro Tips

- Use high-resolution images (at least 512x512) for crisp display
- Keep file sizes reasonable (< 100KB each)
- Use PNG format for transparency
- Test on different screen sizes
- The needle rotates from -90° (left) to +90° (right) for 180° range

---

**Need help?** Check `HEALTH_METER_USAGE_GUIDE.md` for detailed documentation.
