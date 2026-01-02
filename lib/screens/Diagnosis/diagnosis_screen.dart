import 'package:flutter/material.dart';
import 'package:jin_reflex_new/main.dart';
import 'package:jin_reflex_new/screens/Diagnosis/add_diagnosis_screen.dart';
import 'package:jin_reflex_new/screens/Diagnosis/register_screen.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';

class SimpleContactListScreen extends StatefulWidget {
  const SimpleContactListScreen({Key? key}) : super(key: key);

  @override
  State<SimpleContactListScreen> createState() =>
      _SimpleContactListScreenState();
}

class _SimpleContactListScreenState extends State<SimpleContactListScreen>
    with RouteAware {
  List<Map<String, String>> allContacts = [];
  List<Map<String, String>> filteredContacts = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    // Simulate API call
    setState(() {
      allContacts = [
        {'id': '1012', 'name': 'Sapna Kalpesh Gandhi', 'phone': '8857837417'},
        {'id': '1013', 'name': 'Raman Ji Jain', 'phone': '917898299332'},
        {
          'id': '1043',
          'name': 'Kamladevi Mangilal Jain',
          'phone': '917517424248',
        },
        {
          'id': '1045',
          'name': 'Sushila Shubhkarn Jain',
          'phone': '917517424248',
        },
        {
          'id': '1046',
          'name': 'Prachi Prashant Deulgaonkar',
          'phone': '840798043',
        },
        {
          'id': '1047',
          'name': 'Vimlesh Rasiklal Gandhi',
          'phone': '917020684557',
        },
        {'id': '1059', 'name': 'Mansingh Ji Pawar', 'phone': '919623270000'},
        {'id': '1063', 'name': 'Supriya Ji Bohra', 'phone': '919422214717'},
        {
          'id': '1064',
          'name': 'Sunaiyana Pratik Kankaria',
          'phone': '918554922211',
        },
        {'id': '1065', 'name': 'Sachin S. Niwane', 'phone': '7588652165'},
        {
          'id': '1070',
          'name': 'Divya Jitendra Vaidya',
          'phone': '918319219643',
        },
        {
          'id': '1076',
          'name': 'Krishna Jain Dhariwal',
          'phone': '919620547674',
        },
        {'id': '1077', 'name': 'Ranju Jain Kothari', 'phone': '919003224528'},
        {'id': '1083', 'name': 'Sapna Samir Bhagwat', 'phone': '919823101137'},
        {
          'id': '1089',
          'name': 'Mitesh Bhupendra Doshi',
          'phone': '16475706286',
        },
        {
          'id': '1090',
          'name': 'Pushpa Navinchandra Solanki',
          'phone': '919822666643',
        },
        {
          'id': '1092',
          'name': 'Nehali Shardchandra Diwan',
          'phone': '9881511711',
        },
        {'id': '1095', 'name': 'Mrs Ramesh Kankaria', 'phone': '918237777727'},
        {'id': '1096', 'name': 'Jyoti Kankaria', 'phone': '919420813327'},
        {'id': '1098', 'name': 'Rajeev Ji Agrawal', 'phone': '919850803500'},
        {
          'id': '1102',
          'name': 'Manish Parasmalji Aanchaliya',
          'phone': '9579977777',
        },
      ];
      filteredContacts = List.from(allContacts);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    fetchPatients();
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts =
          allContacts
              .where(
                (contact) =>
                    contact['name']!.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    contact['phone']!.contains(query),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CommonAppBar(title: "title"),
      body: Column(
        children: [
          // 🔍 Search bar + Register button row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: _filterContacts,
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPatientForm(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredContacts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PatientDiagnosisScreen(),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 1,
                    shadowColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            contact['id']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              contact['name']!,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            contact['phone']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
