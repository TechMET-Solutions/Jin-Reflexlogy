# Registration Debug Flowchart

## 🔍 Quick Debug Guide - Follow the Emojis!

```
┌─────────────────────────────────────────────────────────────┐
│                    USER CLICKS REGISTER                      │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
         ┌────────────────────────────┐
         │  📤 Sending registration   │
         │     data to: [URL]         │
         └────────────┬───────────────┘
                      │
                      ▼
         ┌────────────────────────────┐
         │   Waiting for response     │
         │      (30 sec timeout)      │
         └────────────┬───────────────┘
                      │
        ┌─────────────┴─────────────┐
        │                           │
        ▼                           ▼
   ⏰ TIMEOUT?                  📥 RESPONSE?
        │                           │
        │                           │
   ┌────┴────┐                 ┌────┴────┐
   │   YES   │                 │   YES   │
   └────┬────┘                 └────┬────┘
        │                           │
        ▼                           ▼
   ❌ Connection              🔍 Check Response Type
      timeout                       │
        │                    ┌──────┴──────┐
        │                    │             │
        │                    ▼             ▼
        │              Is String?     Is Map?
        │                    │             │
        │              ┌─────┴─────┐       │
        │              │           │       │
        │              ▼           ▼       │
        │         Starts with   Parse as   │
        │         <!doctype?    JSON?      │
        │              │           │       │
        │         ┌────┴────┐      │       │
        │         │   YES   │      │       │
        │         └────┬────┘      │       │
        │              │           │       │
        │              ▼           │       │
        │         ❌ HTML          │       │
        │            Error         │       │
        │              │           │       │
        │              │           ▼       │
        │              │      Parse JSON   │
        │              │           │       │
        │              └───────────┴───────┘
        │                          │
        └──────────────────────────┼───────────────┐
                                   │               │
                                   ▼               │
                          ✅ Check "success"       │
                                   │               │
                          ┌────────┴────────┐      │
                          │                 │      │
                          ▼                 ▼      │
                    success == 1?    success == 0? │
                          │                 │      │
                     ┌────┴────┐       ┌────┴────┐ │
                     │   YES   │       │   YES   │ │
                     └────┬────┘       └────┬────┘ │
                          │                 │      │
                          ▼                 ▼      │
                  Extract User ID      Get Error   │
                          │              Message   │
                          │                 │      │
                  ┌───────┴───────┐         │      │
                  │               │         │      │
                  ▼               ▼         │      │
            ID exists?      ID missing?     │      │
                  │               │         │      │
             ┌────┴────┐     ┌────┴────┐   │      │
             │   YES   │     │   YES   │   │      │
             └────┬────┘     └────┬────┘   │      │
                  │               │         │      │
                  ▼               ▼         ▼      ▼
            ✅ SUCCESS      ❌ Missing   ❌ Error  ❌ Network
                  │              ID       Message   Error
                  │               │         │        │
                  └───────────────┴─────────┴────────┘
                                   │
                                   ▼
                          Show Dialog to User
```

---

## 🎯 Console Log Patterns

### ✅ Successful Registration

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [name, email, gender, date, address, city, state, country, pincode, maritalStatus, m_no, dealer_id, pid, education, image1, image2, image3, image4, courseId]
📥 Response status: 200
📥 Response type: _Map<String, dynamic>
🔍 Parsing response: {success: 1, message: Registration successful, data: {id: 123, name: John Doe, email: john@example.com}}
✅ Success value: 1 (type: int)
✅ User ID extracted: 123
🚀 Starting registration without payment...
✅ Registration successful! User ID: 123
```

**Action:** ✅ Show success dialog

---

### ❌ HTML Response Error

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
📥 Response status: 200
📥 Response type: String
❌ ERROR: Server returned HTML instead of JSON
HTML Response: <!DOCTYPE html><html><head><title>PHP Error</title></head><body><h1>Fatal error</h1><p>Uncaught exception...
❌ Failed to parse HTML response as JSON: FormatException: Unexpected character
❌ Registration error: Exception: Server error: Received HTML instead of JSON. Please contact support.
```

**Action:** ❌ Show error dialog: "Server error: Received HTML instead of JSON. Please contact support."

**Fix:** Check backend PHP error logs

---

### ❌ Type Mismatch Error (FIXED)

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
📥 Response status: 200
📥 Response type: _Map<String, dynamic>
🔍 Parsing response: {success: 1, data: 123}
✅ Success value: 1 (type: int)
✅ User ID (direct): 123
✅ Registration successful! User ID: 123
```

**Action:** ✅ Show success dialog

**Note:** Now handles when `data` is directly the ID (not a map)

---

### ❌ Connection Timeout

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
❌ DioException: connectionTimeout
❌ Error message: Connecting timeout[30000ms]
❌ Response: null
❌ Registration error: Exception: Connection timeout. Please check your internet connection.
```

**Action:** ❌ Show error dialog: "Connection timeout. Please check your internet connection."

**Fix:** Check internet connection

---

### ❌ Receive Timeout

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
❌ DioException: receiveTimeout
❌ Error message: Receiving data timeout[30000ms]
❌ Response: null
❌ Registration error: Exception: Server is taking too long to respond. Please try again.
```

**Action:** ❌ Show error dialog: "Server is taking too long to respond. Please try again."

**Fix:** Optimize backend or increase timeout

---

### ❌ No Internet Connection

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
❌ DioException: connectionError
❌ Error message: SocketException: Failed host lookup
❌ Response: null
❌ Registration error: Exception: No internet connection. Please check your network.
```

**Action:** ❌ Show error dialog: "No internet connection. Please check your network."

**Fix:** Enable internet connection

---

### ❌ Backend Error (500)

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
📥 Response status: 500
❌ DioException: badResponse
❌ Error message: Http status error [500]
❌ Response: Internal Server Error
❌ Registration error: Exception: Server error: 500. Please try again later.
```

**Action:** ❌ Show error dialog: "Server error: 500. Please try again later."

**Fix:** Check backend server logs

---

### ❌ Missing User ID

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
📥 Response status: 200
📥 Response type: _Map<String, dynamic>
🔍 Parsing response: {success: 1, message: Registration successful, data: {name: John Doe, email: john@example.com}}
✅ Success value: 1 (type: int)
❌ No ID field found in data: [name, email]
❌ Error parsing response: Exception: Invalid response: missing user ID
❌ Registration error: Exception: Invalid response: missing user ID
```

**Action:** ❌ Show error dialog: "Invalid response: missing user ID"

**Fix:** Backend must return user ID in response

---

### ❌ Backend Error Message

```
📤 Sending registration data to: https://jinreflexology.in/api1/new/therapist.php
📦 Form data: [...]
📥 Response status: 200
📥 Response type: _Map<String, dynamic>
🔍 Parsing response: {success: 0, message: Email already exists}
✅ Success value: 0 (type: int)
❌ Registration failed: Email already exists
❌ Registration error: Exception: Email already exists
```

**Action:** ❌ Show error dialog: "Email already exists"

**Fix:** User should use different email

---

## 🔧 Debug Commands

### 1. Check if API is accessible

```bash
curl -I https://jinreflexology.in/api1/new/therapist.php
```

Expected: `HTTP/1.1 200 OK` or `HTTP/1.1 405 Method Not Allowed`

---

### 2. Test registration API

```bash
curl -X POST https://jinreflexology.in/api1/new/therapist.php \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "name=Test User" \
  -d "email=test@example.com" \
  -d "m_no=1234567890" \
  -d "address=Test" \
  -d "city=Test" \
  -d "state=Test" \
  -d "country=Test" \
  -d "pincode=123456" \
  -d "gender=Male" \
  -d "date=01/01/1990" \
  -d "maritalStatus=Single" \
  -d "pid=1"
```

Expected: JSON response with `success` field

---

### 3. Check response format

```bash
curl -X POST https://jinreflexology.in/api1/new/therapist.php \
  -d "name=Test" | python -m json.tool
```

Expected: Valid JSON (not HTML)

---

### 4. Check response time

```bash
time curl -X POST https://jinreflexology.in/api1/new/therapist.php \
  -d "name=Test" -d "email=test@example.com"
```

Expected: < 5 seconds

---

## 📱 User Experience Flow

```
User Fills Form
      │
      ▼
User Clicks "REGISTER" or "PAY & REGISTER"
      │
      ▼
Loading Indicator Shows
      │
      ▼
API Call Made (30 sec timeout)
      │
      ├─────────────────────────────────┐
      │                                 │
      ▼                                 ▼
  ✅ SUCCESS                        ❌ ERROR
      │                                 │
      ▼                                 ▼
Success Dialog                    Error Dialog
      │                                 │
      ├─ "Registration Successful"      ├─ "Connection timeout..."
      ├─ "Your account has been..."     ├─ "Server error..."
      │                                 ├─ "No internet..."
      ▼                                 ├─ "Email already exists"
Navigate to Home                        │
                                        ▼
                                  User Can Retry
```

---

## 🎯 Quick Decision Tree

```
Registration Failed?
│
├─ Check Console Logs
│  │
│  ├─ See 📤 but no 📥?
│  │  └─ Network issue (timeout/no internet)
│  │
│  ├─ See ❌ HTML Error?
│  │  └─ Backend PHP error
│  │
│  ├─ See ❌ Type error?
│  │  └─ Response format issue (should be fixed)
│  │
│  └─ See ❌ Missing ID?
│     └─ Backend not returning user ID
│
├─ Test API with curl
│  │
│  ├─ Returns HTML?
│  │  └─ Fix backend PHP errors
│  │
│  ├─ Returns JSON with success: 0?
│  │  └─ Check error message
│  │
│  └─ Timeout?
│     └─ Optimize backend
│
└─ Check Backend Logs
   │
   ├─ PHP errors?
   │  └─ Fix PHP code
   │
   ├─ Database errors?
   │  └─ Fix database queries
   │
   └─ No errors but wrong response?
      └─ Fix response format
```

---

## 📊 Error Frequency Monitoring

Track these metrics:

| Error Type | Count | % | Action |
|------------|-------|---|--------|
| Connection Timeout | 5 | 10% | Check network |
| HTML Response | 15 | 30% | Fix backend |
| Missing ID | 2 | 4% | Fix backend |
| Email Exists | 20 | 40% | Normal |
| Other | 8 | 16% | Investigate |

---

## ✅ Verification Steps

1. **Check Console**
   - Look for 📤 (request sent)
   - Look for 📥 (response received)
   - Look for ✅ (success) or ❌ (error)

2. **Identify Error Type**
   - Connection timeout?
   - HTML response?
   - Type mismatch?
   - Missing fields?

3. **Take Action**
   - Network issue → Check internet
   - Backend error → Check logs
   - Format issue → Contact backend team

4. **Verify Fix**
   - Test registration again
   - Check console logs
   - Verify success dialog

---

**Quick Reference Version**: 1.0
**Last Updated**: January 30, 2026
