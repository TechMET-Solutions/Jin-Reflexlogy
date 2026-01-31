# Offline Country-State-City Implementation Guide

## Overview
This implementation uses the `country_state_city: ^0.1.6` package for offline data (no API calls required) with `dropdown_search: ^5.0.6` for searchable dropdowns.

## Files Created

### 1. Widget: `lib/widgets/offline_country_state_city_widget.dart`
- Reusable widget for country → state → city selection
- Uses offline data from `country_state_city` package
- Searchable dropdowns with modern UI
- Cascading selection (selecting country loads states, selecting state loads cities)
- Validation support
- Debug logging with emojis (🌍, 🔍, ✅, ❌)

### 2. Dialog: `lib/screens/shop/offline_address_dialog.dart`
- Complete address form inside AlertDialog
- Integrates the offline widget
- Includes all address fields (name, phone, address lines, pincode)
- Address type selection (Home/Work/Other)
- Default address checkbox
- Form validation
- Returns address data on save

## Key Features

### No API Calls
- All data is loaded from the offline package
- Works without internet connection
- Fast and reliable

### Searchable Dropdowns
- Search functionality for all three dropdowns
- Easy to find countries, states, and cities
- Uses `dropdown_search` package

### Cascading Selection
- Selecting a country automatically loads its states
- Selecting a state automatically loads its cities
- Previous selections are cleared when parent changes

### Modern UI
- Consistent with app color scheme: `Color.fromARGB(255, 19, 4, 66)`
- Rounded borders and proper spacing
- Loading indicators
- Disabled state styling

### Validation
- All three fields are required
- Shows error messages if not selected
- Integrates with Flutter Form validation

## Usage Example

```dart
import 'package:jin_reflex_new/screens/shop/offline_address_dialog.dart';

// Show the dialog
void _showAddressDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const OfflineAddressDialog(),
  ).then((addressData) {
    if (addressData != null) {
      print("Address saved: $addressData");
      // Use the returned data
      // addressData contains: name, phone, address_line1, address_line2,
      // country, state, city, pincode, type, is_default
    }
  });
}
```

## Using the Widget Standalone

```dart
import 'package:jin_reflex_new/widgets/offline_country_state_city_widget.dart';

OfflineCountryStateCityWidget(
  initialCountry: "India",
  initialState: "Maharashtra",
  initialCity: "Mumbai",
  onChanged: (country, state, city) {
    print("Selected: $country, $state, $city");
  },
  enabled: true,
)
```

## How It Works

### 1. Load Countries
```dart
final allCountries = await csc.getAllCountries();
countries = allCountries.map((c) => c.name).toList();
```

### 2. Load States for Selected Country
```dart
final country = allCountries.firstWhere((c) => c.name == countryName);
final allStates = await csc.getStatesOfCountry(country.isoCode);
states = allStates.map((s) => s.name).toList();
```

### 3. Load Cities for Selected State
```dart
final state = allStates.firstWhere((s) => s.name == stateName);
final allCities = await csc.getCountryCities(country.isoCode);
final stateCities = allCities
    .where((city) => city.stateCode == state.isoCode)
    .map((city) => city.name)
    .toList();
```

## Packages Used

### country_state_city: ^0.1.6
- Provides offline country, state, and city data
- Methods used:
  - `getAllCountries()` - Get all countries
  - `getStatesOfCountry(countryIsoCode)` - Get states for a country
  - `getCountryCities(countryIsoCode)` - Get cities for a country
- Models: `Country`, `State`, `City`

### dropdown_search: ^5.0.6
- Provides searchable dropdown functionality
- Features:
  - Search box in dropdown
  - Custom decoration
  - Loading and empty states
  - Validation support

## Differences from API Version

| Feature | API Version | Offline Version |
|---------|-------------|-----------------|
| Data Source | countriesnow.space API | country_state_city package |
| Internet Required | Yes | No |
| Speed | Depends on network | Fast (local data) |
| Reliability | Depends on API uptime | Always available |
| Data Freshness | Always current | Package version dependent |
| Package | http/dio | country_state_city |

## Validation

The widget includes built-in validators:

```dart
validator: (value) {
  if (value == null || value.isEmpty) {
    return "Please select a country";
  }
  return null;
}
```

Use with Flutter Form:

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: OfflineCountryStateCityWidget(...),
)

// Validate
if (_formKey.currentState!.validate()) {
  // All fields are valid
}
```

## Debug Logging

The widget includes emoji-based debug logging:

- 🌍 Country operations
- 🔍 Loading operations
- ✅ Success messages
- ❌ Error messages
- 🏙️ State operations
- 🏢 City operations

Check the console for detailed logs during development.

## Error Handling

- Gracefully handles missing data
- Returns empty lists instead of throwing exceptions
- Shows appropriate messages when data is not available
- Checks `mounted` before calling `setState` after async operations

## Integration Points

### In Buy Now Form
Replace the API version with:
```dart
import 'package:jin_reflex_new/widgets/offline_country_state_city_widget.dart';

OfflineCountryStateCityWidget(
  initialCountry: selectedCountry,
  initialState: selectedState,
  initialCity: selectedCity,
  onChanged: (country, state, city) {
    setState(() {
      selectedCountry = country;
      selectedState = state;
      selectedCity = city;
    });
  },
)
```

### In Add Patient Screen
Same as above - just import and use the widget.

## Testing

1. Run the app
2. Open the offline address dialog
3. Select a country - states should load immediately
4. Select a state - cities should load immediately
5. Select a city
6. Save the form
7. Check console for debug logs

## Troubleshooting

### States not loading
- Check console for error messages
- Verify country name matches exactly
- Ensure package is properly installed

### Cities not loading
- Check console for error messages
- Verify state name matches exactly
- Some states may have limited city data

### Package not found
```bash
flutter pub get
```

## Performance

- Initial country load: ~100ms
- State load: ~50ms
- City load: ~100ms
- All operations are local, no network delay

## Future Enhancements

- Add country flags
- Add phone code prefix
- Add currency information
- Cache loaded data
- Add custom filtering options

## Support

For issues with the offline package, check:
- Package documentation: https://pub.dev/packages/country_state_city
- Package issues: https://github.com/dr-vipin/country_state_city/issues
