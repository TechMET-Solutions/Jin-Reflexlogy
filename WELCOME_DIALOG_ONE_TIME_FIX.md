# Welcome Dialog - Show Only Once Fix

## Problem
The welcome dialog was showing again after logout, even though it should only appear once when the app is first installed.

## Root Cause
The `clearSharedPreferences()` method in `AppPreference` was clearing ALL data including the welcome dialog flags. It was preserving some flags but **missing the critical `dealer_completed` flag** which determines if the dialog should show.

## Solution Applied

### Fixed `lib/prefs/app_preference.dart`

Added `dealer_completed` flag to the list of preserved data during logout:

```dart
Future<void> clearSharedPreferences() async {
  if (_preferences == null) {
    _preferences = await SharedPreferences.getInstance();
  }
  
  // ✅ Save welcome dialog data before clearing (these persist forever)
  final welcomeName = _preferences!.getString('welcome_name');
  final welcomeMobile = _preferences!.getString('welcome_mobile');
  final welcomeEmail = _preferences!.getString('welcome_email');
  final welcomeDealerId = _preferences!.getString('welcome_dealer_id');
  final dealerCompleted = _preferences!.getBool('dealer_completed'); // ✅ KEY FLAG
  final isFirstTime = _preferences!.getBool('is_first_time_user');
  final welcomeShown = _preferences!.getBool('welcome_dialog_shown');
  
  // Clear all data
  await _preferences!.clear();
  
  // ✅ Restore welcome dialog data
  if (welcomeName != null) {
    await _preferences!.setString('welcome_name', welcomeName);
  }
  if (welcomeMobile != null) {
    await _preferences!.setString('welcome_mobile', welcomeMobile);
  }
  if (welcomeEmail != null) {
    await _preferences!.setString('welcome_email', welcomeEmail);
  }
  if (welcomeDealerId != null) {
    await _preferences!.setString('welcome_dealer_id', welcomeDealerId);
  }
  if (dealerCompleted != null) {
    await _preferences!.setBool('dealer_completed', dealerCompleted);
  }
  if (isFirstTime != null) {
    await _preferences!.setBool('is_first_time_user', isFirstTime);
  }
  if (welcomeShown != null) {
    await _preferences!.setBool('welcome_dialog_shown', welcomeShown);
  }
  
  debugPrint("✅ Logout: Cleared session data but preserved welcome dialog data");
}
```

## How It Works Now

### First Time User Flow:
1. User opens app for the first time
2. `dealer_completed` flag doesn't exist (null/false)
3. Welcome dialog shows
4. User fills form and submits
5. If dealer ID provided → `dealer_completed = true`
6. If dealer ID empty → `dealer_completed = false` (will show again next time)
7. Dialog closes

### After Logout:
1. User logs out
2. `clearSharedPreferences()` is called
3. All login data is cleared (token, userId, type, etc.)
4. Welcome dialog flags are preserved:
   - `welcome_name`
   - `welcome_mobile`
   - `welcome_email`
   - `welcome_dealer_id`
   - `dealer_completed` ✅ (KEY FLAG)
   - `is_first_time_user`
   - `welcome_dialog_shown`
5. User returns to home screen
6. `_checkAndShowWelcomeDialog()` checks `dealer_completed`
7. If `dealer_completed == true` → Dialog does NOT show
8. If `dealer_completed == false` → Dialog shows again (user didn't provide dealer ID)

### Subsequent App Opens:
1. App starts
2. Checks `dealer_completed` flag
3. If true → Never shows dialog again
4. If false → Shows dialog (user needs to complete dealer ID)

## SharedPreferences Keys Used

### Session Data (Cleared on Logout):
- `token` - User authentication token
- `userId` - User ID
- `type` - User type (patient/therapist/prouser)
- `name` - User name
- `email` - User email
- `contactNumber` - User contact

### Persistent Data (Never Cleared):
- `welcome_name` - Name from welcome dialog
- `welcome_mobile` - Mobile from welcome dialog
- `welcome_email` - Email from welcome dialog
- `welcome_dealer_id` - Dealer ID from welcome dialog
- `dealer_completed` - Whether dealer registration is complete
- `is_first_time_user` - First time user flag
- `welcome_dialog_shown` - Whether dialog was shown

## Testing Checklist

- [x] Fresh install → Welcome dialog shows
- [x] Submit with dealer ID → Dialog closes and never shows again
- [x] Submit without dealer ID → Dialog shows again next time
- [x] Logout → Welcome dialog does NOT show
- [x] Reinstall app → Welcome dialog shows (fresh install)
- [x] Close and reopen app → Dialog does not show (if completed)

## Debug Commands

Check welcome dialog status:

```dart
final prefs = await SharedPreferences.getInstance();

debugPrint("===== WELCOME DIALOG STATUS =====");
debugPrint("Name: ${prefs.getString('welcome_name')}");
debugPrint("Mobile: ${prefs.getString('welcome_mobile')}");
debugPrint("Email: ${prefs.getString('welcome_email')}");
debugPrint("Dealer ID: ${prefs.getString('welcome_dealer_id')}");
debugPrint("Dealer Completed: ${prefs.getBool('dealer_completed')}");
debugPrint("Is First Time: ${prefs.getBool('is_first_time_user')}");
debugPrint("Dialog Shown: ${prefs.getBool('welcome_dialog_shown')}");
debugPrint("=================================");
```

## Force Reset Welcome Dialog (For Testing)

If you need to test the welcome dialog again:

```dart
final prefs = await SharedPreferences.getInstance();
await prefs.remove('dealer_completed');
await prefs.remove('welcome_name');
await prefs.remove('welcome_mobile');
await prefs.remove('welcome_email');
await prefs.remove('welcome_dealer_id');
debugPrint("✅ Welcome dialog reset - will show on next app start");
```

## Files Modified

1. `lib/prefs/app_preference.dart` - Added `dealer_completed` and `welcome_name` to preserved flags
2. `lib/services/auth_service.dart` - Updated logout message
3. `WELCOME_DIALOG_ONE_TIME_FIX.md` - Created (this file)

## Logic Flow Diagram

```
App Start
    ↓
Check dealer_completed flag
    ↓
    ├─→ true → Skip dialog, go to home
    │
    └─→ false/null → Show welcome dialog
            ↓
        User fills form
            ↓
        User submits
            ↓
        ├─→ Dealer ID provided → Set dealer_completed = true
        │                         → Never show again
        │
        └─→ Dealer ID empty → Set dealer_completed = false
                              → Show again next time

User Logout
    ↓
Clear session data (token, userId, etc.)
    ↓
Preserve welcome dialog data (dealer_completed, etc.)
    ↓
Return to home
    ↓
Check dealer_completed flag
    ↓
    ├─→ true → Skip dialog
    └─→ false → Show dialog
```

## Important Notes

1. **One-Time Popup**: The dialog shows only once if user provides dealer ID
2. **Persistent Across Logout**: Dialog status persists even after logout
3. **Fresh Install**: Dialog shows on fresh install (no flags exist)
4. **Incomplete Registration**: If user closes dialog without dealer ID, it shows again
5. **Complete Registration**: If user provides dealer ID, dialog never shows again

## Common Issues & Solutions

### Issue: Dialog shows after logout
**Solution:** Check if `dealer_completed` flag is being preserved in `clearSharedPreferences()`

### Issue: Dialog shows every time
**Solution:** Check if `dealer_completed` is being set to `true` after successful submission

### Issue: Dialog never shows
**Solution:** Check if `dealer_completed` flag exists and is set to `true`. Remove it to reset.

### Issue: Need to test dialog again
**Solution:** Use the force reset code above to clear all welcome dialog flags

## Support

If the dialog still shows after logout:
1. Check console logs for "dealer_completed" value
2. Verify `clearSharedPreferences()` is preserving the flag
3. Check if `_handleSubmit()` in welcome_dialog.dart is setting the flag correctly
4. Use debug commands above to inspect current state
