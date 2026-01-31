# Country-State-City Dropdown Troubleshooting Guide

## Problem: States/Cities Not Loading in UI

### Root Cause Analysis

The issue occurs when:
1. ✅ API calls work (verified in Postman)
2. ✅ `onChanged` is triggered
3. ✅ Data is fetched successfully
4. ❌ But UI doesn't update

### Why This Happens

**Problem:** `setState()` timing and async operations

When you call an async function without `await` in `onChanged`:
```dart
onChanged: (value) {
  setState(() => selectedCountry = value);
  _loadStates(value);  // ❌ Not awaited - setState happens before data loads
}
```

The setState completes BEFORE the API call finishes, so the UI rebuilds with empty lists.

### The Fix

**Solution:** Use `async/await` properly

```dart
onChanged: (value) async {  // ✅ Make callback async
  if (value != null && value != selectedCountry) {
    setState(() => selectedCountry = value);
    await _loadStates(value);  // ✅ Wait for data to load
  }
}
```

## Key Changes Made

### 1. Proper Async Handling
```dart
// BEFORE (Wrong)
onChanged: (value) {
  setState(() => selectedCountry = value);
  _loadStates(value);  // Fires and forgets
}

// AFTER (Correct)
onChanged: (value) async {
  setState(() => selectedCountry = value);
  await _loadStates(value);  // Waits for completion
}
```

### 2. Mounted Check
```dart
Future<void> _loadStates(String country) async {
  if (!mounted) return;  // ✅ Prevent setState on disposed widget
  
  setState(() {
    isLoadingStates = true;
    states = [];
  });

  try {
    final result = await LocationApiService.getStates(country);
    
    if (!mounted) return;  // ✅ Check again after async operation
    setState(() {
      states = result;
      isLoadingStates = false;
    });
  } catch (e) {
    if (!mounted) return;  // ✅ Check before showing snackbar
    setState(() => isLoadingStates = false);
  }
}
```

### 3. Debug Logging
```dart
Future<void> _loadStates(String country) async {
  print("🔍 Loading states for: $country");
  
  try {
    final result = await LocationApiService.getStates(country);
    print("✅ States loaded: ${result.length} states");
    
    setState(() {
      states = result;
      isLoadingStates = false;
    });
  } catch (e) {
    print("❌ Error loading states: $e");
  }
}
```

## Common Issues & Solutions

### Issue 1: Dropdown Shows "No items found"
**Cause:** API returns data but in wrong format
**Solution:** Check API response structure
```dart
// API returns: {"error": false, "data": {"states": [...]}}
// Your code expects: {"error": false, "data": [...]}

// Fix in location_api_service.dart:
final data = decoded['data'];
final List states = data['states'] ?? [];  // ✅ Access nested 'states'
```

### Issue 2: Loading Indicator Stuck
**Cause:** `isLoadingStates` not reset on error
**Solution:** Always reset in finally or catch block
```dart
try {
  // API call
} catch (e) {
  setState(() => isLoadingStates = false);  // ✅ Reset on error
}
```

### Issue 3: Previous Selection Not Cleared
**Cause:** Not resetting dependent dropdowns
**Solution:** Clear child selections when parent changes
```dart
Future<void> _loadStates(String country) async {
  setState(() {
    isLoadingStates = true;
    states = [];
    cities = [];           // ✅ Clear cities
    selectedState = null;  // ✅ Clear state selection
    selectedCity = null;   // ✅ Clear city selection
  });
}
```

### Issue 4: Dropdown Disabled After Selection
**Cause:** Wrong enabled condition
**Solution:** Check loading state and data availability
```dart
// WRONG
enabled: states.isNotEmpty

// CORRECT
enabled: widget.enabled && states.isNotEmpty && !isLoadingStates
```

## Testing Checklist

Use this to verify your implementation:

- [ ] Countries load on init
- [ ] Selecting country shows loading indicator
- [ ] States populate after country selection
- [ ] State dropdown becomes enabled
- [ ] Selecting state shows loading indicator
- [ ] Cities populate after state selection
- [ ] City dropdown becomes enabled
- [ ] Changing country clears state and city
- [ ] Changing state clears city
- [ ] Search works in all dropdowns
- [ ] Error messages show on API failure
- [ ] No errors in console
- [ ] Debug logs show correct flow

## Debug Logs to Watch For

When working correctly, you should see:
```
🌍 Country selected: India
🔍 Loading states for: India
✅ States loaded: 36 states
🏙️ State selected: Maharashtra
🔍 Loading cities for: India, Maharashtra
✅ Cities loaded: 50 cities
🏢 City selected: Mumbai
```

## API Response Validation

### Expected Response Format

**Countries:**
```json
{
  "error": false,
  "data": [
    {
      "name": "India",
      "iso2": "IN",
      "iso3": "IND"
    }
  ]
}
```

**States:**
```json
{
  "error": false,
  "data": {
    "states": [
      {
        "name": "Maharashtra",
        "state_code": "MH"
      }
    ]
  }
}
```

**Cities:**
```json
{
  "error": false,
  "data": [
    "Mumbai",
    "Pune",
    "Nagpur"
  ]
}
```

## Performance Tips

1. **Debounce API calls** if user changes selection rapidly
2. **Cache results** to avoid repeated API calls
3. **Use FutureBuilder** for cleaner async handling (optional)
4. **Limit dropdown items** if list is very large (>1000 items)

## Still Not Working?

Check these:

1. **API Service:** Verify `LocationApiService` methods return correct data
2. **Network:** Check internet connection and API availability
3. **CORS:** If using web, ensure API allows cross-origin requests
4. **State Management:** Ensure widget is properly mounted
5. **Console Logs:** Look for error messages or exceptions

## Working Example

See `lib/screens/shop/address_dialog_example.dart` for a complete working implementation.

## Need Help?

1. Check console logs for error messages
2. Verify API responses in Postman
3. Add debug prints in `_loadStates` and `_loadCities`
4. Ensure `setState()` is being called
5. Check if widget is still mounted when setState is called
