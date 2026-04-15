import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/api_state.dart' hide ApiService;
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/main.dart';
import 'package:jin_reflex_new/model/dignosis_list_model.dart';
import 'package:jin_reflex_new/screens/Diagnosis/add_patient_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/tritment_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberListScreen extends StatefulWidget {
  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> with RouteAware {
  String getLimitedName({required String text, required double screenWidth}) {
    // 1️⃣ numbers remove
    final withoutNumbers = text.replaceAll(RegExp(r'\d'), '');

    // 2️⃣ clean extra spaces
    final cleanText = withoutNumbers.trim().replaceAll(RegExp(r'\s+'), ' ');

    // 3️⃣ decide character limit
    final int charLimit = screenWidth < 600 ? 22 : 32;

    // 4️⃣ apply limit
    if (cleanText.length <= charLimit) {
      return cleanText;
    }
    return cleanText.substring(0, charLimit);
  }

  List<PatientData> patients = [];
  bool isLoading = true;
  bool isFetchingMore = false;
  bool hasMore = true;
  int page = 1;
  final int limit = 30;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _currentSearchText = '';
  Timer? _searchDebounceTimer;
  late Razorpay _razorpay;
  final TextEditingController amountController = TextEditingController();
  bool showValidation = false;
  int _balanceRefreshTrigger = 0;
  @override
  void initState() {
    super.initState();
    print("🎯 initState called");
    fetchPatients(isInitial: true);
    scrollController.addListener(_scrollListener);
    searchController.addListener(_onSearchChanged);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _scrollListener() {
    if (!scrollController.hasClients) return;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;
    if (currentScroll >= maxScroll - 100 &&
        !isFetchingMore &&
        hasMore &&
        _currentSearchText.isEmpty) {
      print("🎯 Scroll reached bottom, fetching more...");
      print("📊 Current scroll: $currentScroll, Max: $maxScroll");
      print("📊 Page: $page, HasMore: $hasMore");
      fetchPatients();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    // 🔥 screen visible again → fresh load
    fetchPatients(isInitial: true);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchController.dispose();
    amountController.dispose();
    _searchFocusNode.dispose();
    _searchDebounceTimer?.cancel();
    _razorpay.clear();
    super.dispose();
  }

  // ---------------- SEARCH HANDLER ----------------
  void _onSearchChanged() {
    // Cancel previous timer
    _searchDebounceTimer?.cancel();

    // Set new timer for debounce
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final newText = searchController.text.trim();

      // Only search if text changed
      if (newText != _currentSearchText) {
        _currentSearchText = newText;
        print("🔍 Searching for: '$newText'");
        fetchPatients(isInitial: true, search: newText);
      }
    });
  }

  // FIXED: fetchPatients function
  Future<void> fetchPatients({
    bool isInitial = false,
    String search = '',
  }) async {
    print("\n" + "=" * 60);
    print("🚀 FETCHING PATIENTS");
    print("📌 isInitial: $isInitial");
    print("📌 Current Page: $page");
    print("📌 Search Text: '$search'");
    print("📌 isFetchingMore: $isFetchingMore");
    print("📌 hasMore: $hasMore");
    print("📌 Current Patients: ${patients.length}");
    print("=" * 60);

    // If already fetching, return
    if (isFetchingMore) {
      print("⏸️ Already fetching, skipping...");
      return;
    }

    // If searching, stop pagination
    if (search.isNotEmpty && !isInitial) {
      print("⚠️ Search active, pagination stopped");
      return;
    }

    // Calculate which page to fetch
    int fetchPage = isInitial ? 1 : page;

    setState(() {
      if (isInitial) {
        page = 1;
        hasMore = true;
        patients.clear();
        isLoading = true;
      }
      isFetchingMore = true;
    });

    try {
      var url = Uri.parse(
        'https://jinreflexology.in/api1/new/list_patients.php',
      );

      Map<String, String> body = {
        'pid': AppPreference().getString(PreferencesKey.userId),
        'page': fetchPage.toString(),
        'limit': limit.toString(),
      };

      if (search.isNotEmpty) {
        body['search'] = search;
      }
      print("🌐 API Request Details:");
      print("   URL: $url");
      print("   Body: $body");
      print("   Fetching Page: $fetchPage");

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print("📥 API Response:");
      print("   Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        var jsonBody = jsonDecode(response.body);
        print("   Success: ${jsonBody['success']}");

        final List raw = jsonBody["data"] ?? [];
        print("   Data Items Received: ${raw.length}");

        if (jsonBody['success'] == 1) {
          final newList = raw.map((e) => PatientData.fromJson(e)).toList();

          print("✅ Patients Loaded: ${newList.length}");
          print("📊 Limit: $limit");
          print("📊 HasMore Check: ${newList.length == limit}");

          setState(() {
            if (isInitial) {
              patients = newList;
            } else {
              patients.addAll(newList);
            }

            isLoading = false;
            isFetchingMore = false;

            // Update hasMore based on response length
            hasMore = newList.length == limit;

            // Increment page only if we got full page
            if (hasMore && !isInitial) {
              page++;
              print("📈 Page incremented to: $page");
            }

            print("📊 Total Patients Now: ${patients.length}");
            print("📊 HasMore Flag: $hasMore");
          });
        } else {
          print("❌ API Error: ${jsonBody['message']}");
          setState(() {
            isLoading = false;
            isFetchingMore = false;
            hasMore = false;
          });
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
        setState(() {
          isLoading = false;
          isFetchingMore = false;
        });
      }
    } catch (e, stackTrace) {
      print("❌ Exception: $e");
      print("❌ StackTrace: $stackTrace");
      setState(() {
        isLoading = false;
        isFetchingMore = false;
      });
    }
    print("=" * 60 + "\n");
  }

  Future<bool> isIndianUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("delivery_type") == "india";
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Success\nPayment ID: ${response.paymentId}"),
        backgroundColor: Colors.green,
      ),
    );

    await sendPaymentToBackend(
      status: "success",
      paymentId: response.paymentId,
      orderId: response.orderId,
      amount: int.tryParse(amountController.text) ?? 0,
    );

    if (!mounted) return;
    setState(() {
      _balanceRefreshTrigger++;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed\n${response.message}"),
        backgroundColor: Colors.red,
      ),
    );

    await sendPaymentToBackend(
      status: "failed",
      reason: response.message,
      amount: int.tryParse(amountController.text) ?? 0,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Used: ${response.walletName}")),
    );
  }

  void _showPaymentPopup() {
    amountController.clear();
    showValidation = false;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return FutureBuilder<bool>(
          future: isIndianUser(),
          builder: (context, snapshot) {
            final bool isIndia = snapshot.data ?? true;

            return StatefulBuilder(
              builder: (context, setPopupState) {
                return AlertDialog(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Add Payment',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Enter amount to add balance',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              'Enter Amount ${isIndia ? "(Rs)" : "(\$)"}',
                          border: const OutlineInputBorder(),
                          errorText:
                              showValidation ? 'Minimum 50 required' : null,
                        ),
                        onChanged: (_) {
                          if (showValidation) {
                            setPopupState(() => showValidation = false);
                          }
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final amountText = amountController.text.trim();

                        if (amountText.isEmpty ||
                            int.tryParse(amountText) == null ||
                            int.parse(amountText) < 50) {
                          setPopupState(() => showValidation = true);
                          return;
                        }

                        final enteredAmount = int.parse(amountText);
                        Navigator.pop(dialogContext);

                        if (isIndia) {
                          _razorpay.open({
                            'key': razorpayKey,
                            'amount': enteredAmount * 100,
                            'name': AppPreference().getString(
                              PreferencesKey.name,
                            ),
                            'description': 'Wallet Payment',
                            'prefill': {
                              'contact': AppPreference().getString(
                                PreferencesKey.contactNumber,
                              ),
                              'email': AppPreference().getString(
                                PreferencesKey.email,
                              ),
                            },
                          });
                        } else {
                          _startPayPalPayment();
                        }
                      },
                      child: const Text('Pay'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _startPayPalPayment() {
    final String amount = amountController.text.trim();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: isSandboxMode,
              clientId: paypalClientId,
              secretKey: paypalSecret,
              transactions: [
                {
                  "amount": {"total": amount, "currency": "USD"},
                  "description": "Wallet / Service Payment",
                },
              ],
              note: "Demo PayPal payment",
              onSuccess: (Map params) async {
                final paypalPaymentId = params["data"]?["id"];
                if (paypalPaymentId == null) {
                  debugPrint("PayPal paymentId null");
                  return;
                }

                await sendPaymentToBackend(
                  status: "success",
                  paymentId: paypalPaymentId,
                  orderId: null,
                  amount: int.tryParse(amountController.text) ?? 0,
                );

                if (!mounted) return;
                setState(() {
                  _balanceRefreshTrigger++;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PayPal Payment Successful"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              onError: (error) async {
                await sendPaymentToBackend(
                  status: "failed",
                  reason: error.toString(),
                  amount: int.tryParse(amountController.text) ?? 0,
                );

                if (!mounted) return;
                Navigator.pop(context);
              },
              onCancel: () async {
                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
      ),
    );
  }

  Future<void> sendPaymentToBackend({
    required String status,
    String? paymentId,
    String? orderId,
    String? reason,
    required int amount,
  }) async {
    try {
      final dio = Dio();
      await dio.post(
        "https://admin.jinreflexology.in/api/payment_callback",
        data: {
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "payment_id": paymentId,
          "orderid": orderId,
          "amount": amount.toString(),
          "status": status,
          "reason": reason,
          "email": AppPreference().getString(PreferencesKey.email),
          "name": AppPreference().getString(PreferencesKey.name),
          "contact": AppPreference().getString(PreferencesKey.contactNumber),
        },
      );
    } catch (e) {
      debugPrint("Backend API error: $e");
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final token = AppPreference().getString(PreferencesKey.userId);
    final type = AppPreference().getString(PreferencesKey.type);
    print(token);
    return Scaffold(
      appBar: CommonAppBar(
        title: "Patient List",
        showBalance: true,
        userId: token,
        balanceRefreshTrigger: _balanceRefreshTrigger,
        actions: [
          InkWell(
            onTap: () {
              _showPaymentPopup();
            },
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.green,
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  "Add Amount",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 5),
          // IconButton(
          //   tooltip: "Add Payment",
          //   onPressed: _showPaymentPopup,
          //   icon: const Icon(Icons.account_balance_wallet, color: Colors.white),
          // ),
        ],
      ),
      backgroundColor: Color(0xFFFDF3DD),
      body:
          type == "patient" ||
                  type == "user" ||
                  type == "prouser" ||
                  token.isEmpty
              ? JinLoginScreen(
                text: "MemberListScreen",
                type: "therapist",
                registershow: true,
                onTab: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MemberListScreen()),
                  );
                },
              )
              : SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.0125),

                    // SEARCH + ADD BUTTON
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.035,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: screenSize.height * 0.06,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: screenSize.width * 0.03),
                                  Icon(Icons.search, color: Colors.orange),
                                  SizedBox(width: screenSize.width * 0.02),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      focusNode: _searchFocusNode,
                                      decoration: InputDecoration(
                                        hintText:
                                            "Search patient by name, mobile or ID",
                                        hintStyle: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  if (searchController.text.isNotEmpty)
                                    IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        searchController.clear();
                                        _currentSearchText = '';
                                        fetchPatients(isInitial: true);
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.025),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AddPatientScreen(
                                        patientName: '',
                                        patientId: '',
                                        pid: AppPreference().getString(
                                          PreferencesKey.userId,
                                        ),
                                        diagnosisId: '',
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              height: screenSize.height * 0.06,
                              width: screenSize.width * 0.12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.orange,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenSize.height * 0.02),

                    // LIST HEADER WITH DEBUG INFO
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Patients: ${patients.length}",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (_currentSearchText.isNotEmpty)
                            Text(
                              "Search: '$_currentSearchText'",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          // DEBUG INFO
                          Row(
                            children: [
                              Text(
                                "Page: $page",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.02),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.015,
                                  vertical: screenSize.height * 0.0025,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      hasMore
                                          ? Colors.green[100]
                                          : Colors.red[100],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  hasMore ? "Has More" : "No More",
                                  style: TextStyle(
                                    color: hasMore ? Colors.green : Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenSize.height * 0.0125),

                    // PATIENT LIST
                    Expanded(
                      child:
                          isLoading
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                              )
                              : patients.isEmpty
                              ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      color: Colors.grey[400],
                                      size: screenSize.width * 0.16,
                                    ),
                                    SizedBox(height: screenSize.height * 0.02),
                                    Text(
                                      _currentSearchText.isEmpty
                                          ? "No Patients Found"
                                          : "No patients match '$_currentSearchText'",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: screenSize.height * 0.01),
                                    if (_currentSearchText.isNotEmpty)
                                      TextButton(
                                        onPressed: () {
                                          searchController.clear();
                                          fetchPatients(isInitial: true);
                                        },
                                        child: Text(
                                          "Clear Search",
                                          style: TextStyle(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                              : NotificationListener<ScrollNotification>(
                                onNotification: (
                                  ScrollNotification scrollInfo,
                                ) {
                                  // Additional scroll debug
                                  if (scrollInfo is ScrollEndNotification) {
                                    print("📜 Scroll ended");
                                    print(
                                      "   Position: ${scrollController.position.pixels}",
                                    );
                                    print(
                                      "   Max: ${scrollController.position.maxScrollExtent}",
                                    );
                                  }
                                  return false;
                                },
                                child: RefreshIndicator(
                                  color: Colors.orange,
                                  onRefresh: () async {
                                    print("🔃 Pull to refresh triggered");
                                    await fetchPatients(isInitial: true);
                                  },
                                  child: ListView.builder(
                                    controller: scrollController,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      left: screenSize.width * 0.035,
                                      right: screenSize.width * 0.035,
                                      bottom: screenSize.height * 0.025,
                                    ),
                                    itemCount:
                                        patients.length +
                                        (hasMore &&
                                                !isFetchingMore &&
                                                _currentSearchText.isEmpty
                                            ? 1
                                            : 0),
                                    itemBuilder: (context, index) {
                                      // Loading indicator for pagination
                                      if (index >= patients.length) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: screenSize.height * 0.025,
                                          ),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                CircularProgressIndicator(
                                                  color: Colors.orange,
                                                ),
                                                SizedBox(
                                                  height:
                                                      screenSize.height * 0.01,
                                                ),
                                                Text(
                                                  "Loading more patients...",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }

                                      final patient = patients[index];

                                      return Card(
                                        margin: EdgeInsets.symmetric(
                                          vertical: screenSize.height * 0.0075,
                                          horizontal: 0,
                                        ),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => DiagnosisListScreen(
                                                      patientName: patient.name,
                                                      pid:
                                                          AppPreference()
                                                              .getString(
                                                                PreferencesKey
                                                                    .userId,
                                                              )
                                                              .toString(),
                                                      diagnosisId: patient.id,
                                                      patientId: patient.id,
                                                      gender: patient.gender,
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                              screenSize.width * 0.04,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: screenSize.width * 0.1,
                                                  height:
                                                      screenSize.width * 0.1,
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      patient.name.isNotEmpty
                                                          ? patient.name[0]
                                                              .toUpperCase()
                                                          : '?',
                                                      style: TextStyle(
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      screenSize.width * 0.04,
                                                ), 
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              patient.name,
                                                              style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),

                                                          const SizedBox(
                                                            width: 8,
                                                          ),

                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              patient
                                                                  .registerationDate,
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              style: const TextStyle(
                                                                fontSize: 15,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                              ),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            screenSize.height *
                                                            0.005,
                                                      ),

                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.phone,
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                            size: 14,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                screenSize
                                                                    .width *
                                                                0.01,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              patient.mobile,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .grey[600],
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                screenSize
                                                                    .width *
                                                                0.03,
                                                          ),
                                                          Icon(
                                                            Icons.person,
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                            size: 14,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                screenSize
                                                                    .width *
                                                                0.01,
                                                          ),
                                                          Flexible(
                                                            child: Text(
                                                              patient.id,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .orange,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.grey[400],
                                                  size: 16,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}
