# Health Meter Image Specifications

## Required Images

### 1. Meter Background (`assets/meter_bg.png`)

#### Specifications:
- **Format**: PNG with transparency
- **Size**: 512x512px minimum (1024x1024px recommended)
- **Shape**: Semi-circle (180 degrees)
- **Background**: Transparent

#### Design Elements:

```
                    50%
                  ┌─────┐
              25% │     │ 75%
           ┌──────┴─────┴──────┐
        FAIR│    GOOD    │EXCELLENT
           │             │
      ┌────┴─────────────┴────┐
   0% │  🔴  🟠  🟡  🟢      │ 100%
      └─────────────────────────┘
           POOR
```

#### Color Zones (from left to right):
1. **Red Zone** (0-25%): POOR
   - Color: `#FF0000` or `#E53935`
   - Arc: 0° to 45°

2. **Orange Zone** (25-50%): FAIR
   - Color: `#FF9800` or `#FB8C00`
   - Arc: 45° to 90°

3. **Yellow Zone** (50-75%): GOOD
   - Color: `#FFEB3B` or `#FDD835`
   - Arc: 90° to 135°

4. **Green Zone** (75-100%): EXCELLENT
   - Color: `#4CAF50` or `#43A047`
   - Arc: 135° to 180°

#### Labels:
- **Top Center**: "50%"
- **Top Left**: "25%"
- **Top Right**: "75%"
- **Bottom Left**: "0%"
- **Bottom Right**: "100%"
- **Zone Labels**: POOR, FAIR, GOOD, EXCELLENT

#### Design Tips:
- Use a thick arc/ring (15-20px width)
- Add subtle gradients for depth
- Include tick marks at 0%, 25%, 50%, 75%, 100%
- Use white or light gray for labels
- Add a subtle shadow for 3D effect

---

### 2. Needle (`assets/needle.png`)

#### Specifications:
- **Format**: PNG with transparency
- **Size**: 512x128px (or 4:1 ratio)
- **Shape**: Long, thin pointer/arrow
- **Background**: Transparent
- **Orientation**: Pointing UPWARD (↑)

#### Design Elements:

```
        ↑
        │
        │
        │
        │
        │
        │
        │
        │
        ●
```

#### Needle Design:
- **Length**: 80-90% of meter radius
- **Width**: 2-4px at tip, 6-8px at base
- **Color**: Black (#000000) or dark gray (#424242)
- **Shape Options**:
  1. Simple line with triangle tip
  2. Tapered pointer
  3. Arrow with tail

#### Pivot Point:
- **Location**: Center bottom of image
- **Design**: Small circle (10-15px diameter)
- **Color**: Same as needle or slightly lighter

#### Design Tips:
- Keep it simple and clean
- Ensure good contrast against meter background
- Add subtle shadow for depth
- Make sure it's perfectly vertical (pointing up)
- The pivot circle should be visible but not too large

---

## Quick Design Options

### Option 1: Use Design Tools
**Figma / Canva / Adobe Illustrator**
1. Create 512x512 canvas
2. Draw semi-circle with colored segments
3. Add labels and percentage marks
4. Export as PNG with transparency

### Option 2: Use Online Resources
**Free Resources:**
- Flaticon.com - Search "speedometer", "gauge"
- Freepik.com - Search "health meter", "gauge"
- Vecteezy.com - Search "speedometer vector"

**Modify:**
- Adjust colors to match (Red, Orange, Yellow, Green)
- Add percentage labels
- Crop to semi-circle if needed

### Option 3: Use Code to Generate
You can use online SVG generators or tools like:
- SVG-Edit
- Inkscape (free)
- Method Draw

---

## Example CSS/SVG Code

### Meter Background (SVG):
```svg
<svg width="512" height="256" viewBox="0 0 512 256">
  <!-- Red Zone -->
  <path d="M 50 256 A 206 206 0 0 1 128 50" 
        fill="none" stroke="#E53935" stroke-width="20"/>
  
  <!-- Orange Zone -->
  <path d="M 128 50 A 206 206 0 0 1 256 0" 
        fill="none" stroke="#FB8C00" stroke-width="20"/>
  
  <!-- Yellow Zone -->
  <path d="M 256 0 A 206 206 0 0 1 384 50" 
        fill="none" stroke="#FDD835" stroke-width="20"/>
  
  <!-- Green Zone -->
  <path d="M 384 50 A 206 206 0 0 1 462 256" 
        fill="none" stroke="#43A047" stroke-width="20"/>
  
  <!-- Labels -->
  <text x="50" y="270" fill="#666" font-size="16">0%</text>
  <text x="128" y="60" fill="#666" font-size="16">25%</text>
  <text x="256" y="20" fill="#666" font-size="16">50%</text>
  <text x="384" y="60" fill="#666" font-size="16">75%</text>
  <text x="462" y="270" fill="#666" font-size="16">100%</text>
</svg>
```

### Needle (SVG):
```svg
<svg width="512" height="128" viewBox="0 0 512 128">
  <!-- Needle body -->
  <polygon points="256,10 260,120 252,120" fill="#000"/>
  
  <!-- Needle tip -->
  <polygon points="256,0 262,15 250,15" fill="#000"/>
  
  <!-- Pivot circle -->
  <circle cx="256" cy="120" r="8" fill="#000"/>
</svg>
```

---

## Testing Your Images

### Quick Test:
1. Save images in `assets/` folder
2. Run `flutter pub get`
3. Hot reload app
4. Navigate to Health Meter screen
5. Check if meter displays correctly

### Troubleshooting:
- **Needle not visible**: Check if image is transparent
- **Wrong rotation**: Ensure needle points upward in image
- **Blurry**: Use higher resolution (1024x1024)
- **Colors off**: Adjust image colors to match zones

---

## Alternative: Use Existing Images

If you have the images from your reference (the ones you showed):
1. Extract meter background from first image
2. Extract needle from first image
3. Crop and save as separate PNG files
4. Ensure transparency around edges
5. Save as `meter_bg.png` and `needle.png`

---

## File Checklist

Before testing:
- [ ] `assets/meter_bg.png` exists
- [ ] `assets/needle.png` exists
- [ ] Both are PNG format
- [ ] Both have transparent backgrounds
- [ ] Meter is semi-circle (180°)
- [ ] Needle points upward
- [ ] Files are in `assets/` folder (not `assets/images/`)
- [ ] `pubspec.yaml` includes both assets
- [ ] Ran `flutter pub get`

---

## Final Notes

The widget has built-in error handling:
- If images are missing, it shows placeholders
- Gray box for meter background
- Black line for needle
- App will still work, just won't look as nice

Once you add proper images, the meter will look professional and match your design!
