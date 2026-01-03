import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/api_service.dart';
import 'package:jin_reflex_new/api_service/api_state.dart' hide ApiService;
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/login_screen.dart';
import 'package:jin_reflex_new/main.dart';
import 'package:jin_reflex_new/model/dignosis_list_model.dart';
import 'package:jin_reflex_new/screens/Diagnosis/add_patient_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/diagnosis_record_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/tritment_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class MemberListScreen extends StatefulWidget {
  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> with RouteAware {
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

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    fetchPatients(isInitial: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isFetchingMore &&
          hasMore &&
          _currentSearchText.isEmpty) {
        fetchPatients();
      }
    });

    // Add listener for search field
    searchController.addListener(() {
      _onSearchChanged();
    });
  }

  // ---------------- ROUTE OBSERVER ----------------
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
    scrollController.dispose();
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ---------------- SEARCH HANDLER ----------------
  void _onSearchChanged() {
    final newText = searchController.text;

    // Debounce to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && newText == searchController.text) {
        _currentSearchText = newText;
        fetchPatients(isInitial: true, search: newText);
      }
    });
  }

  Future<void> fetchPatients({
  bool isInitial = false,
  String search = '',
}) async {
  if (isFetchingMore) return;

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
 
    
    var url = Uri.parse('https://jinreflexology.in/api1/new/list_patients.php');
    
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    
    Map<String, String> body = {
      'pd': AppPreference().getString(PreferencesKey.userId),
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (search.isNotEmpty) {
      body['search'] = search;
    }
    
    print("🔍 Making POST request to: $url");
    print("Body: $body");
    
    var response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    
    if (response.statusCode == 200) {
      var jsonBody = jsonDecode(response.body);
      
      if (jsonBody['success'] == 1) {
        final List raw = jsonBody["data"] ?? [];
        final newList = raw.map((e) => PatientData.fromJson(e)).toList();

        setState(() {
          if (isInitial) {
            patients = newList;
          } else {
            patients.addAll(newList);
          }

          isLoading = false;
          isFetchingMore = false;
          hasMore = newList.length == limit;
          page++;
        });
      } else {
        print("❌ API returned success: 0");
        setState(() {
          isLoading = false;
          isFetchingMore = false;
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
    print("Stack trace: $stackTrace");
    setState(() {
      isLoading = false;
      isFetchingMore = false;
    });
  }
}

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final token = AppPreference().getString(PreferencesKey.userId);
    final type = AppPreference().getString(PreferencesKey.type);

    return Scaffold(
      appBar: CommonAppBar(title: "Patient List"),
      backgroundColor: Color(0xFFFDF3DD),
      body:
          type == "patient" || token.isEmpty
              ? JinLoginScreen(
                text: "MemberListScreen",
                type: "therapist",
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
                    SizedBox(height: 10),

                    // SEARCH + ADD
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
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
                                  SizedBox(width: 12),
                                  Icon(Icons.search, color: Colors.orange),
                                  SizedBox(width: 8),
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
                          SizedBox(width: 10),
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
                              height: 48,
                              width: 48,
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

                    SizedBox(height: 16),

                    // LIST HEADER
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                        ],
                      ),
                    ),

                    SizedBox(height: 10),

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
                                      size: 64,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      _currentSearchText.isEmpty
                                          ? "No Patients Found"
                                          : "No patients match '$_currentSearchText'",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 8),
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
                              : RefreshIndicator(
                                color: Colors.orange,
                                onRefresh: () async {
                                  await fetchPatients(isInitial: true);
                                },
                                child: ListView.builder(
                                  controller: scrollController,
                                  padding: EdgeInsets.only(
                                    left: 14,
                                    right: 14,
                                    bottom: 20,
                                  ),
                                  itemCount:
                                      patients.length +
                                      (hasMore && _currentSearchText.isEmpty
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    if (index == patients.length) {
                                      return Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.orange,
                                          ),
                                        ),
                                      );
                                    }

                                    final patient = patients[index];

                                    return Card(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 0,
                                      ),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
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
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.orange
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      patient.name,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black87,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(height: 4),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.phone,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 14,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          patient.mobile,
                                                          style: TextStyle(
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        SizedBox(width: 12),
                                                        Icon(
                                                          Icons.person,
                                                          color:
                                                              Colors.grey[600],
                                                          size: 14,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          patient.id,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.orange,
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w500,
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
                  ],
                ),
              ),
    );
  }
}
