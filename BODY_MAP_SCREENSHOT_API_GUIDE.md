# Body Map Screenshot & API Submission Guide

## Overview
Complete implementation for capturing body map grid screenshots and submitting them to the API along with selected cell data.

## Features Implemented

✅ **Interactive Grid** - 10x5 grid (A-E rows, 1-10 columns) with black borders
✅ **Screenshot Capture** - Automatically captures the grid with selected areas
✅ **Image Upload** - Uploads screenshot as `feedbackImage` to API
✅ **Selected Cells** - Sends list of selected cells (e.g., "A1,B3,C5")
✅ **API Integration** - Posts to `generateDiagnosisPdf.php` endpoint
✅ **Loading States** - Shows progress during capture and upload
✅ **Error Handling** - Proper error messages and retry options

## Files Created

### 1. `body_map_with_screenshot.dart`
Main widget with screenshot capability.

**Key Components:**
- `BodyMapWithScreenshot` - Interactive grid wrapped in `RepaintBoundary`
- `ScreenshotHelper` - Utility class for capturing and submitting

**Methods:**
```dart
// Capture screenshot
static Future<File?> captureWidget(GlobalKey key)

// Submit to API
static Future<bool> submitBodyMapData({
  required String therapistId,
  required String patientId,
  required String day,
  required List<String> selectedCells,
  required File? feedbackImage,
})
```

### 2. `body_map_submission_example.dart`
Complete example screen showing full implementation.

**Features:**
- Instructions card
- Interactive body map
- Selected areas display
- API info display
- Submit button with loading states
- Success/Error dialogs

## API Integration

### Endpoint
```
POST https://jinreflexology.in/api1/new/generateDiagnosisPdf.php
```

### Request Format
```dart
FormData.fromMap({
  'therapistId': '222',
  'patientId': '1059',
  'day': 'first',
  'selectedCells': 'A1,B3,C5,D2', // Comma-separated list
  'feedbackImage': MultipartFile.fromFile(
    imagePath,
    filename: 'body_map_timestamp.png',
  ),
})
```

### Headers
```dart
{
  'Accept': 'application/json',
}
```

### cURL Example
```bash
curl --location 'https://jinreflexology.in/api1/new/generateDiagnosisPdf.php' \
--header 'Accept: application/json' \
--form 'therapistId="222"' \
--form 'patientId="1059"' \
--form 'day="first"' \
--form 'selectedCells="A1,B3,C5,D2"' \
--form 'feedbackImage=@"/path/to/body_map_screenshot.png"'
```

## Usage in Your App

### Basic Integration

```dart
import 'body_map_with_screenshot.dart';

class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final GlobalKey _screenshotKey = GlobalKey();
  List<String> selectedCells = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Body Map
          SizedBox(
            height: 450,
            child: BodyMapWithScreenshot(
              screenshotKey: _screenshotKey,
              initialSelection: selectedCells,
              onSelectionChanged: (selected) {
                setState(() {
                  selectedCells = selected;
                });
              },
            ),
          ),
          
          // Submit Button
          ElevatedButton(
            onPressed: _submitData,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitData() async {
    // Capture screenshot
    final screenshot = await ScreenshotHelper.captureWidget(_screenshotKey);
    
    if (screenshot == null) {
      // Handle error
      return;
    }

    // Submit to API
    final success = await ScreenshotHelper.submitBodyMapData(
      therapistId: '222',
      patientId: '1059',
      day: 'first',
      selectedCells: selectedCells,
      feedbackImage: screenshot,
    );

    if (success) {
      // Show success message
    } else {
      // Show error message
    }
  }
}
```

### Integration with Feedback List

In `freddback_list.dart`:

```dart
import 'body_map_with_screenshot.dart';

class _BodyPartScreenState extends State<BodyPartScreen> {
  final GlobalKey _screenshotKey = GlobalKey();
  List<String> selectedCellIds = [];

  // ... existing code ...

  Future<void> submitData() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Capture screenshot
    final screenshot = await ScreenshotHelper.captureWidget(_screenshotKey);
    
    if (screenshot == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture screenshot')),
      );
      return;
    }

    // Submit to API
    final success = await ScreenshotHelper.submitBodyMapData(
      therapistId: therapistId, // Get from your state/prefs
      patientId: patientId,     // Get from your state/prefs
      day: selectedDay,         // Get from your state/prefs
      selectedCells: selectedCellIds,
      feedbackImage: screenshot,
    );

    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Body Map with Screenshot
            SizedBox(
              height: 450,
              child: BodyMapWithScreenshot(
                screenshotKey: _screenshotKey,
                initialSelection: selectedCellIds,
                onSelectionChanged: (selected) {
                  setState(() {
                    selectedCellIds = selected;
                  });
                },
              ),
            ),
            
            // Rest of your UI...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: submitData,
        label: Text('Submit'),
        icon: Icon(Icons.check_circle_outline),
      ),
    );
  }
}
```

## Screenshot Process

### Step 1: Wrap Widget in RepaintBoundary
```dart
RepaintBoundary(
  key: _screenshotKey,
  child: YourWidget(),
)
```

### Step 2: Capture Screenshot
```dart
final screenshot = await ScreenshotHelper.captureWidget(_screenshotKey);
```

### Step 3: Screenshot is Saved
- Saved to temporary directory
- Format: PNG
- Pixel ratio: 3.0 (high quality)
- Filename: `body_map_timestamp.png`

### Step 4: Upload to API
```dart
final success = await ScreenshotHelper.submitBodyMapData(
  therapistId: '222',
  patientId: '1059',
  day: 'first',
  selectedCells: ['A1', 'B3', 'C5'],
  feedbackImage: screenshot,
);
```

## Data Flow

```
User taps grid cells
    ↓
Cells turn red (selected)
    ↓
User clicks Submit button
    ↓
Show "Capturing screenshot..." dialog
    ↓
Capture grid as PNG image
    ↓
Show "Uploading data..." dialog
    ↓
Create FormData with:
  - therapistId
  - patientId
  - day
  - selectedCells (comma-separated)
  - feedbackImage (PNG file)
    ↓
POST to API endpoint
    ↓
Show success/error message
```

## Error Handling

### Screenshot Capture Failed
```dart
if (screenshotFile == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Failed to capture screenshot'),
      backgroundColor: Colors.red,
    ),
  );
  return;
}
```

### API Submission Failed
```dart
if (!success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Submission failed. Please try again.'),
      backgroundColor: Colors.red,
    ),
  );
}
```

### Network Error
```dart
try {
  final success = await ScreenshotHelper.submitBodyMapData(...);
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: ${e.toString()}'),
      backgroundColor: Colors.red,
    ),
  );
}
```

## Testing

### Test Screenshot Capture
```dart
// Add test button
ElevatedButton(
  onPressed: () async {
    final file = await ScreenshotHelper.captureWidget(_screenshotKey);
    if (file != null) {
      print('Screenshot saved: ${file.path}');
      // Show image in dialog to verify
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Image.file(file),
        ),
      );
    }
  },
  child: Text('Test Screenshot'),
)
```

### Test API Submission
```dart
// Test with dummy data
final success = await ScreenshotHelper.submitBodyMapData(
  therapistId: '222',
  patientId: '1059',
  day: 'first',
  selectedCells: ['A1', 'B2', 'C3'],
  feedbackImage: testImageFile,
);
print('Submission result: $success');
```

## Customization

### Change Screenshot Quality
```dart
// In ScreenshotHelper.captureWidget()
ui.Image image = await boundary.toImage(
  pixelRatio: 5.0, // Increase for higher quality (default: 3.0)
);
```

### Change Image Format
```dart
// In ScreenshotHelper.captureWidget()
ByteData? byteData = await image.toByteData(
  format: ui.ImageByteFormat.rawRgba, // or rawRgba, rawStraightRgba
);
```

### Add Watermark
```dart
// Before capturing, add a watermark widget
Stack(
  children: [
    BodyMapWithScreenshot(...),
    Positioned(
      bottom: 10,
      right: 10,
      child: Text(
        'Jin Reflexology',
        style: TextStyle(color: Colors.grey),
      ),
    ),
  ],
)
```

## Dependencies Required

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.9.0              # For API calls
  path_provider: ^2.1.5    # For file storage
```

## Troubleshooting

### Screenshot is Black/Empty
- Ensure widget is fully rendered before capturing
- Add delay: `await Future.delayed(Duration(milliseconds: 500))`
- Check that `RepaintBoundary` wraps the correct widget

### Image Not Uploading
- Verify file exists: `print(file.path)`
- Check file size: `print(await file.length())`
- Ensure API accepts multipart/form-data

### API Returns Error
- Check API response: `print(response.data)`
- Verify all required fields are sent
- Check API logs on server

### Selected Cells Not Showing
- Verify `selectedCells` list is populated
- Check comma-separated format: "A1,B2,C3"
- Print before sending: `print(selectedCells.join(','))`

## Best Practices

1. **Always show loading indicators** during capture and upload
2. **Handle errors gracefully** with user-friendly messages
3. **Validate data** before submission (check if cells are selected)
4. **Clean up temp files** after successful upload
5. **Test with different network conditions** (slow, offline)
6. **Log API responses** for debugging
7. **Provide retry option** on failure

## Next Steps

- ✅ Screenshot capture implemented
- ✅ API integration complete
- ✅ Error handling added
- 🔲 Add offline support (save locally, sync later)
- 🔲 Add image compression for faster uploads
- 🔲 Implement retry mechanism
- 🔲 Add progress indicator for upload
- 🔲 Cache screenshots for review before submission

## Support

For issues:
1. Check console logs for errors
2. Verify API endpoint is accessible
3. Test screenshot capture separately
4. Review API response format
5. Check file permissions on device
