import 'package:flutter/material.dart';
import '../../widgets/health_meter_widget.dart';

class HealthFormScreen extends StatefulWidget {
  const HealthFormScreen({super.key});

  @override
  State<HealthFormScreen> createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen> {
  // Gender
  String? gender = 'Male';

  // Age
  TextEditingController ageController = TextEditingController();

  // Working position checkboxes
  bool sitPosition = false;
  bool standingPosition = false;
  bool fieldWorkPosition = false;

  // Checkboxes for daily lifestyle
  bool wakeUp = false;
  bool meditation = false;
  bool yoga = false;
  bool exercise = false;
  bool stretching = false;
  bool barefootWalking = false;
  bool sunBath = false;
  bool foodTiming = false;
  bool avoidWaterWithMeal = false;
  bool drinkWater = false;
  bool avoidScreenWhileEating = false;
  bool chewFood = false;
  bool avoidTeaCoffee = false;
  bool avoidAlcohol = false;
  bool avoidNonVeg = false;
  bool dinnerSleepGap = false;
  bool sleepTiming = false;
  bool avoidDaySleep = false;

  // Celibacy/Avoid Intercourse
  bool followCelibacy = false;

  // Other lifestyle factors
  bool avoidMobilePosture = false;
  bool avoidLongPosture = false;
  bool avoidPainkillers = false;
  bool avoidLustContent = false;
  bool familyTime = false;
  bool workWithPatience = false;
  bool liveStressFree = false;

  // Get Age from controller
  int get age {
    if (ageController.text.isEmpty) return 25;
    return int.tryParse(ageController.text) ?? 25;
  }

  // Get Celibacy Guideline based on Age
  String get celibacyGuideline {
    int userAge = age;
    if (userAge >= 1 && userAge <= 21) {
      return "Fully follow Celibacy";
    } else if (userAge > 21 && userAge <= 30) {
      return "Do not engage sexual activity more than 8 times a Month";
    } else if (userAge > 30 && userAge <= 50) {
      return "Do not engage sexual activity more than 4 times a Month";
    } else if (userAge > 50 && userAge <= 70) {
      return "Do not engage sexual activity more than 1 time a Month";
    } else if (userAge > 70) {
      return "Fully follow Celibacy";
    }
    return "Not specified";
  }

  // Calculate Score
  double get score {
    double s = 0;
    double totalPoints = 27; // Total number of health factors

    // Lifestyle factors (1-18)
    if (wakeUp) s += (100 / totalPoints);
    if (meditation) s += (100 / totalPoints);
    if (yoga) s += (100 / totalPoints);
    if (exercise) s += (100 / totalPoints);
    if (stretching) s += (100 / totalPoints);
    if (barefootWalking) s += (100 / totalPoints);
    if (sunBath) s += (100 / totalPoints);
    if (foodTiming) s += (100 / totalPoints);
    if (avoidWaterWithMeal) s += (100 / totalPoints);
    if (drinkWater) s += (100 / totalPoints);
    if (avoidScreenWhileEating) s += (100 / totalPoints);
    if (chewFood) s += (100 / totalPoints);
    if (avoidTeaCoffee) s += (100 / totalPoints);
    if (avoidAlcohol) s += (100 / totalPoints);
    if (avoidNonVeg) s += (100 / totalPoints);
    if (dinnerSleepGap) s += (100 / totalPoints);
    if (sleepTiming) s += (100 / totalPoints);
    if (avoidDaySleep) s += (100 / totalPoints);

    // Celibacy (19-20)
    if (followCelibacy) s += (100 / totalPoints);

    // Other factors (21-27)
    if (avoidMobilePosture) s += (100 / totalPoints);
    if (avoidLongPosture) s += (100 / totalPoints);
    if (avoidPainkillers) s += (100 / totalPoints);
    if (avoidLustContent) s += (100 / totalPoints);
    if (familyTime) s += (100 / totalPoints);
    if (workWithPatience) s += (100 / totalPoints);
    if (liveStressFree) s += (100 / totalPoints);

    return double.parse(s.toStringAsFixed(1)); // Max = 100
  }

  // Health Meter Widget - Custom Image-based design (No external packages)
  Widget healthMeter(double value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Health Meter with Images
          Center(
            child: HealthMeterWidget(
              healthValue: value,
              meterBackgroundImage: 'assets/images/meter_bg.png',
              needleImage: 'assets/images/needle.png',
              width: 500,
              height: 500,
              animationDuration: const Duration(milliseconds: 1500),
              animationCurve: Curves.easeInOut,
              showValue: true,
              valueTextStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _getHealthStatusColor(value),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Title
          const Center(
            child: Text(
              "Health Meter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Gender Section - Bullet points प्रमाणे
          const Text(
            "Gender",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Male bullet with circle
              _buildGenderOption('Male'),
              const SizedBox(width: 20),
              // Female bullet with circle
              _buildGenderOption('Female'),
            ],
          ),

          const SizedBox(height: 16),

          // Age Section
          const Text(
            "Age -",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter age",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            //textAlign: TextAlign.center,
            onChanged: (value) {
              setState(() {});
            },
          ),

          const SizedBox(height: 16),

          // Working position - Checkboxes प्रमाणे
          const Text(
            "Working position -",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildWorkPositionCheckbox('Sit', sitPosition, (v) {
                setState(() => sitPosition = v!);
              }),
              const SizedBox(width: 15),
              _buildWorkPositionCheckbox('standing', standingPosition, (v) {
                setState(() => standingPosition = v!);
              }),
              const SizedBox(width: 15),
              _buildWorkPositionCheckbox('field work', fieldWorkPosition, (v) {
                setState(() => fieldWorkPosition = v!);
              }),
            ],
          ),

          const SizedBox(height: 20),

          // Health Meter Gauge
        ],
      ),
    );
  }

  Widget _buildGenderOption(String genderText) {
    bool isSelected = gender == genderText;
    return GestureDetector(
      onTap: () {
        setState(() {
          gender = genderText;
        });
      },
      child: Row(
        children: [
          // Bullet point
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.green : Colors.grey,
                width: 2,
              ),
              color: isSelected ? Colors.green : Colors.transparent,
            ),
            child:
                isSelected
                    ? const Center(
                      child: Icon(Icons.check, size: 12, color: Colors.white),
                    )
                    : null,
          ),
          const SizedBox(width: 8),
          Text(
            genderText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkPositionCheckbox(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(
              color: value ? Colors.green : Colors.grey,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
            color: value ? Colors.green : Colors.transparent,
          ),
          child:
              value
                  ? const Center(
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  )
                  : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: value ? FontWeight.bold : FontWeight.normal,
            color: value ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildHealthItem(String title, bool value, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Checkbox with custom design
          Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () {
                onChanged(!value);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: value ? Colors.green : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: value ? Colors.green : Colors.transparent,
                ),
                child:
                    value
                        ? const Center(
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        )
                        : null,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: value ? Colors.green[800] : Colors.black,
                  fontWeight: value ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Health Meter",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Health Meter Gauge Section
            healthMeter(score),

            // Daily Life Style Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "Your Daily Life Style",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Daily Lifestyle Checkboxes (1-18)
            _buildHealthItem("1. Early Wake Up (Between 4 to 6 am)", wakeUp, (
              v,
            ) {
              setState(() => wakeUp = v!);
            }),

            _buildHealthItem("2. 15 Minutes Meditation", meditation, (v) {
              setState(() => meditation = v!);
            }),

            _buildHealthItem("3. 15 Minutes Yoga and Pranayama", yoga, (v) {
              setState(() => yoga = v!);
            }),

            _buildHealthItem("4. 30 Minutes Physical Exercise", exercise, (v) {
              setState(() => exercise = v!);
            }),

            _buildHealthItem(
              "5. 3 Minutes Normal Stretching (Only for sitting work)",
              stretching,
              (v) {
                setState(() => stretching = v!);
              },
            ),

            _buildHealthItem("6. 5 Minutes Barefoot Walking", barefootWalking, (
              v,
            ) {
              setState(() => barefootWalking = v!);
            }),

            _buildHealthItem("7. 15 Minutes Sun Bath", sunBath, (v) {
              setState(() => sunBath = v!);
            }),

            _buildHealthItem("8. Follow Proper Food Timing", foodTiming, (v) {
              setState(() => foodTiming = v!);
            }),

            _buildHealthItem(
              "9. Avoid Drinking Water While Eating",
              avoidWaterWithMeal,
              (v) {
                setState(() => avoidWaterWithMeal = v!);
              },
            ),

            _buildHealthItem("10. Drink 2 to 3 Liter Water", drinkWater, (v) {
              setState(() => drinkWater = v!);
            }),

            _buildHealthItem(
              "11. Avoid TV and Mobile While Eating",
              avoidScreenWhileEating,
              (v) {
                setState(() => avoidScreenWhileEating = v!);
              },
            ),

            _buildHealthItem("12. Chew Your Food Thoroughly", chewFood, (v) {
              setState(() => chewFood = v!);
            }),

            _buildHealthItem(
              "13. Avoid Tea, Coffee, Vegetable Soup, and Juice",
              avoidTeaCoffee,
              (v) {
                setState(() => avoidTeaCoffee = v!);
              },
            ),

            _buildHealthItem(
              "14. Avoid Alcoholic Drinks and Any Type of Drugs",
              avoidAlcohol,
              (v) {
                setState(() => avoidAlcohol = v!);
              },
            ),

            _buildHealthItem("15. Avoid Non-Vegetarian Food", avoidNonVeg, (v) {
              setState(() => avoidNonVeg = v!);
            }),

            _buildHealthItem(
              "16. Maintain Gap Between Dinner and Sleep",
              dinnerSleepGap,
              (v) {
                setState(() => dinnerSleepGap = v!);
              },
            ),

            _buildHealthItem("17. Go to Bed Between 9 to 11 pm", sleepTiming, (
              v,
            ) {
              setState(() => sleepTiming = v!);
            }),

            _buildHealthItem(
              "18. Avoid Sleep in Day and Late Night Waking",
              avoidDaySleep,
              (v) {
                setState(() => avoidDaySleep = v!);
              },
            ),

            // Celibacy Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                "Follow Celibacy / Avoid Intercourse",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Age-wise Celibacy Guideline
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For Age $age:",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    celibacyGuideline,
                    style: TextStyle(fontSize: 14, color: Colors.green[800]),
                  ),
                ],
              ),
            ),

            _buildHealthItem("19. Follow Celibacy", followCelibacy, (v) {
              setState(() => followCelibacy = v!);
            }),

            // Other Lifestyle Factors (21-27)
            _buildHealthItem(
              "21. Avoid use of mobile more than 15 min in a single posture",
              avoidMobilePosture,
              (v) {
                setState(() => avoidMobilePosture = v!);
              },
            ),

            _buildHealthItem(
              "22. Avoid continued work more than 60 min in a single posture",
              avoidLongPosture,
              (v) {
                setState(() => avoidLongPosture = v!);
              },
            ),

            _buildHealthItem(
              "23. Avoid Pain killers and excess use of supplements",
              avoidPainkillers,
              (v) {
                setState(() => avoidPainkillers = v!);
              },
            ),

            _buildHealthItem(
              "24. Avoid watching Lust pictures/shows/games",
              avoidLustContent,
              (v) {
                setState(() => avoidLustContent = v!);
              },
            ),

            _buildHealthItem(
              "25. Daily 30 minute all family member meet",
              familyTime,
              (v) {
                setState(() => familyTime = v!);
              },
            ),

            _buildHealthItem("26. Work with Patience", workWithPatience, (v) {
              setState(() => workWithPatience = v!);
            }),

            _buildHealthItem("27. Live Stress Free", liveStressFree, (v) {
              setState(() => liveStressFree = v!);
            }),

            const SizedBox(height: 20),

            // Score Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[100]!),
              ),
              child: Column(
                children: [
                  Text(
                    "Health Score: ${score.toInt()}%",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _getHealthStatusColor(score).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getHealthStatusColor(score)),
                    ),
                    child: Text(
                      _getHealthStatus(score),
                      style: TextStyle(
                        fontSize: 16,
                        color: _getHealthStatusColor(score),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Gender: $gender  |  Age: ${ageController.text.isEmpty ? "Not set" : age}  |  Working: ${sitPosition ? "Sit" : ""}${standingPosition ? "Standing" : ""}${fieldWorkPosition ? "Field work" : ""}",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Check Score Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text(
                            "Health Assessment",
                            style: TextStyle(color: Colors.green),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Health Score: ${score.toInt()}%",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Status: ${_getHealthStatus(score)}",
                                  style: TextStyle(
                                    color: _getHealthStatusColor(score),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Divider(),
                                const SizedBox(height: 10),
                                const Text(
                                  "Personal Details:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Gender: $gender"),
                                Text(
                                  "Age: ${ageController.text.isEmpty ? "Not specified" : age}",
                                ),
                                Text(
                                  "Working Position: ${sitPosition ? "Sit" : ""}${standingPosition ? ", Standing" : ""}${fieldWorkPosition ? ", Field work" : ""}",
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                const SizedBox(height: 10),
                                const Text(
                                  "Celibacy Guideline:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(celibacyGuideline),
                                const SizedBox(height: 10),
                                const Divider(),
                                const SizedBox(height: 10),
                                const Text(
                                  "Health Tips:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(_getHealthTips(score)),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                  );
                },
                child: const Text(
                  "View Detailed Health Report",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String _getHealthStatus(double score) {
    if (score >= 75) return "Excellent Health!";
    if (score >= 50) return "Good Health";
    if (score >= 25) return "Needs Improvement";
    return "Poor Health - Needs Attention";
  }

  String _getHealthTips(double score) {
    if (score >= 75)
      return "You're doing great! Maintain your healthy lifestyle.";
    if (score >= 50) return "Good progress! Try to add more healthy habits.";
    if (score >= 25)
      return "Focus on adding more healthy habits to your routine.";
    return "Consider making significant lifestyle changes for better health.";
  }

  Color _getHealthStatusColor(double score) {
    if (score >= 75) return Colors.green;
    if (score >= 50) return Colors.orange;
    if (score >= 25) return Colors.yellow[800]!;
    return Colors.red;
  }
}
