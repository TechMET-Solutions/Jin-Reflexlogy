# Country/State/City Instant Refresh Fix Guide

## Problem
When users change the delivery type (India/International) in the app, the country/state/city data and course prices don't refresh instantly. The app requires a restart to see the updated data.

## Root Cause
The `isIndianUser()` function reads from SharedPreferences, but the UI components don't listen for changes to this preference. They only fetch data once during `initState()`.

## Solution Applied

### 1. Sign Up Screen - Course Selection (✅ FIXED)
**File**: `lib/auth/sign_up_screen.dart`

**Changes Made**:
- Added a country selector dropdown in the CourseSelectionScreen
- Added `setCountryCode()` method to update SharedPreferences and refresh courses
- Moved `countryCode` to class level for proper state management
- Country selector allows instant switching between India (🇮🇳) and International (🌍)

**How it works**:
```dart
// User selects country from dropdown
onChanged: (value) async {
  if (value != null && value != countryCode) {
    await setCountryCode(value); // Updates prefs + refreshes courses
  }
}
```

### 2. Other Files Using isIndianUser()

#### Files that need similar fixes:
1. **lib/screens/shop/buy_now_form.dart**
   - Uses `isIndianUser()` for payment gateway selection
   - Should add country selector or listen to delivery_type changes

2. **lib/screens/Diagnosis/add_patient_screen.dart**
   - Uses `isIndianUser()` in payment popup
   - Already uses FutureBuilder which is good

3. **lib/e-book_login.dart**
   - Uses `_isIndianUser()` for pricing display
   - Has `_loadCountry()` method but doesn't refresh on change

## Implementation Pattern

### Pattern 1: Add Country Selector (Recommended for forms)
```dart
DropdownButton<String>(
  value: countryCode,
  items: const [
    DropdownMenuItem(value: "in", child: Text("🇮🇳 India")),
    DropdownMenuItem(value: "us", child: Text("🌍 International")),
  ],
  onChanged: (value) async {
    if (value != null) {
      await setCountryCode(value);
    }
  },
)

Future<void> setCountryCode(String newCountryCode) async {
  final prefs = await SharedPreferences.getInstance();
  final deliveryType = newCountryCode == "in" ? "india" : "outside";
  await prefs.setString("delivery_type", deliveryType);
  
  setState(() {
    countryCode = newCountryCode;
    isLoading = true;
  });
  
  await fetchData(); // Refresh your data
}
```

### Pattern 2: Use StreamController (For global state)
```dart
// Create a global stream for delivery type changes
class DeliveryTypeNotifier {
  static final _controller = StreamController<String>.broadcast();
  
  static Stream<String> get stream => _controller.stream;
  
  static void notify(String deliveryType) {
    _controller.add(deliveryType);
  }
}

// In your widget
StreamBuilder<String>(
  stream: DeliveryTypeNotifier.stream,
  builder: (context, snapshot) {
    // Rebuild when delivery type changes
  },
)
```

### Pattern 3: Use Riverpod Provider (Best for state management)
```dart
final deliveryTypeProvider = StateNotifierProvider<DeliveryTypeNotifier, String>((ref) {
  return DeliveryTypeNotifier();
});

class DeliveryTypeNotifier extends StateNotifier<String> {
  DeliveryTypeNotifier() : super("india");
  
  Future<void> setDeliveryType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("delivery_type", type);
    state = type;
  }
}

// In your widget
final deliveryType = ref.watch(deliveryTypeProvider);
```

## Testing Checklist

- [x] Sign up screen course selection refreshes instantly
- [ ] Buy now form updates payment gateway based on country
- [ ] Add patient screen shows correct currency
- [ ] E-book screen shows correct pricing
- [ ] All screens persist the selected country across app restarts

## Files Modified
1. ✅ `lib/auth/sign_up_screen.dart` - Added country selector and instant refresh

## Files That Need Updates
1. ⏳ `lib/screens/shop/buy_now_form.dart`
2. ⏳ `lib/screens/Diagnosis/add_patient_screen.dart`
3. ⏳ `lib/e-book_login.dart`

## Next Steps
1. Test the sign up screen country selector
2. Apply similar pattern to other screens
3. Consider implementing a global state management solution (Riverpod provider)
4. Add visual feedback when country changes (loading indicator, snackbar)

## Benefits
- ✅ Instant data refresh without app restart
- ✅ Better user experience
- ✅ Consistent country selection across the app
- ✅ Proper state management
- ✅ No more confusion about which country is selected
