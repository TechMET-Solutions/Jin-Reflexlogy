import 'dart:convert';
import 'package:flutter/material.dart';
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

class MemberListScreen extends StatefulWidget {
  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> with RouteAware {
  List<PatientData> patients = [];
  List<PatientData> filteredPatients = [];

  bool isLoading = true;
  bool isFetchingMore = false;
  bool hasMore = true;

  int page = 1;
  final int limit = 30;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    fetchPatients(isInitial: true);

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isFetchingMore &&
          hasMore) {
        fetchPatients();
      }
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
    super.dispose();
  }

  // ---------------- SEARCH ----------------
  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() => filteredPatients = patients);
      return;
    }

    final q = query.toLowerCase();

    setState(() {
      filteredPatients =
          patients.where((p) {
            return p.name.toLowerCase().contains(q) || p.mobile.contains(query);
          }).toList();
    });
  }

  // ---------------- API WITH PAGINATION ----------------
  Future<void> fetchPatients({bool isInitial = false}) async {
    if (isFetchingMore) return;

    setState(() {
      if (isInitial) {
        page = 1;
        hasMore = true;
        patients.clear();
        filteredPatients.clear();
        isLoading = true;
      }
      isFetchingMore = true;
    });

    try {
      final response = await ApiService().postRequest(
        "https://jinreflexology.in/api1/new/list_patients.php"
        "?pid=${AppPreference().getString(PreferencesKey.userId).toString()}&page=$page&limit=$limit",
        {},
      );

      if (response?.statusCode == 200) {
        dynamic jsonBody =
            response?.data is String
                ? jsonDecode(response!.data)
                : response?.data;

        final List raw = jsonBody["data"] ?? [];

        final List<PatientData> newList =
            raw.map((e) => PatientData.fromJson(e)).toList();

        setState(() {
          patients.addAll(newList);
          filteredPatients = patients;
          isLoading = false;
          isFetchingMore = false;
          hasMore = newList.length == limit;
          page++;
        });
      } else {
        setState(() {
          isLoading = false;
          isFetchingMore = false;
        });
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
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
    print("DEBUG TYPE => '$type'");
    print("DEBUG TOKEN => '$token'");
    print("DEBUG isEmpty => ${token.isEmpty}");
    return Scaffold(
      backgroundColor: const Color(0xFFFDF3DD),
      body:
          type == "prouser" || token.isEmpty
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
                    const SizedBox(height: 10),

                    // SEARCH + ADD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 12),
                                  const Icon(
                                    Icons.search,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      onChanged: filterSearch,
                                      decoration: const InputDecoration(
                                        hintText: "Search name or mobile...",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AddPatientScreen(
                                        patientName: '',
                                        patientId: '',
                                        pid: '22',
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
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // LIST
                    Expanded(
                      child:
                          isLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange,
                                ),
                              )
                              : filteredPatients.isEmpty
                              ? const Center(child: Text("No Patients Found"))
                              : ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                itemCount:
                                    filteredPatients.length + (hasMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == filteredPatients.length) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }

                                  final patient = filteredPatients[index];

                                  return InkWell(
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
                                                          PreferencesKey.userId,
                                                        )
                                                        .toString(),
                                                diagnosisId: patient.id,
                                                patientId: patient.id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  patient.id,
                                                  style: const TextStyle(
                                                    color: Colors.orange,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    patient.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(patient.mobile),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}
