# Registration Troubleshooting - Quick Reference

## 🔍 How to Debug Registration Issues

### Step 1: Check Flutter Console

Look for these debug messages:

```
📤 Sending registration data to: [URL]
📦 Form data: [fields]
📥 Response status: [code]
📥 Response type: [type]
🔍 Parsing response: [data]
✅ Success value: [value]
✅ User ID extracted: [id]
```

### Step 2: Identify Error Type

| Console Message | Problem | Solution |
|----------------|---------|----------|
| `❌ ERROR: Server returned HTML` | Backend PHP error | Check backend logs |
| `❌ DioException: connectionTimeout` | Network too slow | Check internet |
| `❌ DioException: receiveTimeout` | Backend too slow | Optimize backend |
| `❌ DioException: connectionError` | No internet | Check network |
| `❌ Failed to parse string response` | Invalid JSON | Fix backend response |
| `❌ No ID field found in data` | Missing user ID | Fix backend to return ID |
| `❌ 'data' field is null` | Backend error | Check backend logic |

---

## 🚨 Common Errors & Quick Fixes

### Error 1: "String is not subtype of int"

**Symptom:**
```
type 'String' is not a subtype of type 'int' of 'index'
```

**Cause:** Trying to access array with string key or wrong type assumption

**Fix:** ✅ Already fixed with safe type checking in `_parseRegistrationResponse()`

**Verify Fix:**
```dart
// OLD (WRONG)
final id = json["data"]["id"];

// NEW (CORRECT) - Already implemented
final id = data["id"] ?? data["user_id"] ?? data["userId"];
userId = id.toString();
```

---

### Error 2: HTML Response Instead of JSON

**Symptom:**
```
❌ ERROR: Server returned HTML instead of JSON
```

**Cause:** Backend PHP error (syntax error, fatal error, etc.)

**Fix:** ✅ Already detected and handled

**Backend Fix Needed:**
```php
<?php
// Add at top of PHP file
header('Content-Type: application/json');
error_reporting(0);
ini_set('display_errors', 0);

// Use try-catch
try {
    // Your code
    echo json_encode(['success' => 1, 'data' => ['id' => $userId]]);
} catch (Exception $e) {
    echo json_encode(['success' => 0, 'message' => $e->getMessage()]);
}
?>
```

---

### Error 3: "Registration Failed: Unable to create account"

**Symptom:** Generic error message

**Cause:** Multiple possible causes

**Debug Steps:**

1. **Check Console Logs:**
   ```
   Look for ❌ messages in Flutter console
   ```

2. **Check Backend Response:**
   ```dart
   // Already logging:
   debugPrint("📥 Response: ${response.data}");
   ```

3. **Test API Directly:**
   ```bash
   curl -X POST https://jinreflexology.in/api1/new/therapist.php \
     -d "name=Test User" \
     -d "email=test@example.com" \
     -d "m_no=1234567890"
   ```

4. **Check Backend Logs:**
   - PHP error log
   - Apache/Nginx error log
   - Database error log

---

### Error 4: Connection Timeout

**Symptom:**
```
Connection timeout. Please check your internet connection.
```

**Causes:**
- No internet connection
- Firewall blocking
- VPN issues
- Server down

**Fix:**
1. Check internet connection
2. Try different network
3. Check if server is accessible
4. Increase timeout (if needed):
   ```dart
   receiveTimeout: const Duration(seconds: 60), // Increase from 30
   ```

---

### Error 5: Receive Timeout

**Symptom:**
```
Server is taking too long to respond. Please try again.
```

**Causes:**
- Backend processing too slow
- Large file uploads
- Database query slow

**Fix:**
1. Optimize backend code
2. Add database indexes
3. Reduce image sizes before upload
4. Increase timeout if necessary

---

## 🧪 Testing Commands

### Test 1: Check API Endpoint

```bash
curl -I https://jinreflexology.in/api1/new/therapist.php
```

Expected: `HTTP/1.1 200 OK` or `HTTP/1.1 405 Method Not Allowed` (POST required)

### Test 2: Test Registration API

```bash
curl -X POST https://jinreflexology.in/api1/new/therapist.php \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "name=Test User" \
  -d "email=test@example.com" \
  -d "m_no=1234567890" \
  -d "address=Test Address" \
  -d "city=Test City" \
  -d "state=Test State" \
  -d "country=Test Country" \
  -d "pincode=123456" \
  -d "gender=Male" \
  -d "date=01/01/1990" \
  -d "maritalStatus=Single" \
  -d "pid=1"
```

Expected: JSON response with `success` field

### Test 3: Check Response Format

```bash
curl -X POST https://jinreflexology.in/api1/new/therapist.php \
  -d "name=Test" | python -m json.tool
```

Expected: Valid JSON (not HTML)

---

## 📱 User-Facing Error Messages

### What Users See vs What Actually Happened

| User Message | Technical Cause | Action |
|--------------|----------------|--------|
| "Connection timeout. Please check your internet connection." | Network timeout | Check internet |
| "Server is taking too long to respond. Please try again." | Backend slow | Try again later |
| "Server error: 500. Please try again later." | Backend crash | Contact support |
| "No internet connection. Please check your network." | No network | Enable internet |
| "Server error: Received HTML instead of JSON. Please contact support." | PHP error | Contact support |
| "Server response format error. Please contact support." | Type mismatch | Contact support |
| "Invalid response: missing user ID" | Backend didn't return ID | Contact support |
| "Email already exists" | Duplicate email | Use different email |

---

## 🔧 Quick Fixes for Developers

### Fix 1: Enable Detailed Logging

Already enabled! Look for these in console:
- 📤 = Sending request
- 📥 = Received response
- 🔍 = Parsing data
- ✅ = Success
- ❌ = Error

### Fix 2: Test with Mock Data

```dart
// Temporarily replace API call for testing
Future<String?> _callSignUpAPI() async {
  await Future.delayed(Duration(seconds: 2)); // Simulate network
  return "123"; // Mock user ID
}
```

### Fix 3: Add Breakpoints

Add breakpoints at:
1. `_callSignUpAPI()` - Start of API call
2. `_parseRegistrationResponse()` - Response parsing
3. `_registerWithoutPayment()` - Registration flow

### Fix 4: Check Form Data

```dart
// Already logging:
debugPrint("📦 Form data: ${formData.keys.toList()}");

// Add this to see values:
formData.forEach((key, value) {
  debugPrint("  $key: ${value?.toString().substring(0, 50)}...");
});
```

---

## 🎯 Verification Checklist

After implementing fixes, verify:

- [ ] Registration works without courses
- [ ] Registration works with courses
- [ ] Error messages are user-friendly
- [ ] Console shows detailed logs
- [ ] HTML responses are detected
- [ ] Timeouts are handled
- [ ] Network errors show proper messages
- [ ] Payment + registration flow works
- [ ] Dealer ID field is optional
- [ ] All form validations work

---

## 📞 When to Contact Support

Contact backend team if:
1. ❌ HTML responses persist
2. ❌ Missing fields in response
3. ❌ Inconsistent response format
4. ❌ Server errors (500, 502, 503)
5. ❌ Timeout issues persist

Provide:
- Flutter console logs (with 📤 📥 ❌ messages)
- API endpoint URL
- Request data (without sensitive info)
- Response data
- Timestamp of error

---

## 🚀 Performance Tips

### Optimize Image Upload

```dart
// Compress images before base64 encoding
String? _fileToBase64(File? file) {
  if (file == null) return null;
  try {
    // Add image compression here
    final bytes = file.readAsBytesSync();
    return base64Encode(bytes);
  } catch (e) {
    debugPrint("Error converting file: $e");
    return null;
  }
}
```

### Reduce Payload Size

```dart
// Only send images if they exist
final formData = {
  // ... other fields
  if (_fileToBase64(uploadFiles[0]) != null) 
    "image1": _fileToBase64(uploadFiles[0]),
  // ... etc
};
```

---

## 📊 Success Metrics

Monitor these:
- Registration success rate
- Average response time
- Error types frequency
- User drop-off points

---

**Quick Reference Version**: 1.0
**Last Updated**: January 30, 2026
