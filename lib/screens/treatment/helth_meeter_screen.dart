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
  bool breakfast = false;
  bool lunch = false;
  bool afternoon = false;
  bool dinner = false;
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

  double get score {
    double s = 0;
    if (wakeUp) s += 4.0;
    if (meditation) s += 4.0;
    if (yoga) s += 4.0;
    if (exercise) s += 3.0;
    if (stretching) s += 1.0;
    if (barefootWalking) s += 1.0;
    if (sunBath) s += 2.0;
    if (breakfast) s += 2.0;
    if (lunch) s += 4.0;
    if (afternoon) s += 2.0;
    if (dinner) s += 4.0;
    if (avoidWaterWithMeal) s += 1.0;
    if (drinkWater) s += 2.0;
    if (avoidScreenWhileEating) s += 1.0;
    if (chewFood) s += 2.0;
    if (avoidTeaCoffee) s += 4.0;
    if (avoidAlcohol) s += 8.0;
    if (avoidNonVeg) s += 4.0;
    if (dinnerSleepGap) s += 4.0;
    if (sleepTiming) s += 2.0;
    if (avoidDaySleep) s += 4.0;
    if (followCelibacy) {
      int userAge = age;
      if (userAge >= 1 && userAge <= 21) {
        s += 10.0;
      } else if (userAge > 21 && userAge <= 30) {
        s += 10.0;
      } else if (userAge > 30 && userAge <= 50) {
        s += 10.0;
      } else if (userAge > 50 && userAge <= 70) {
        s += 10.0;
      } else if (userAge > 70) {
        s += 10.0;
      }
    }
    if (avoidMobilePosture) s += 4.0;
    if (avoidLongPosture) s += 2.0;
    if (avoidPainkillers) s += 5.0;
    if (avoidLustContent) s += 2.0;
    if (familyTime) s += 6.0;
    if (workWithPatience) s += 4.0;
    if (liveStressFree) s += 4.0;

    return double.parse(s.toStringAsFixed(1));
  }

  // Health Meter Widget - Fixed at top
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
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Health Meter with Images
          Center(
            child: HealthMeterWidget(
              healthValue: value,
              meterBackgroundImage: 'assets/images/meter_bg.png',
              needleImage: 'assets/images/needle.png',
              width: 250,
              height: 250,
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
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
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
      body: Column(
        children: [
          // Fixed Health Meter Section (Non-scrollable)
          Expanded(flex: 0, child: healthMeter(score)),

          // Scrollable Content Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Life Style Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 20),

                        // Gender Section - Bullet points प्रमाणे
                        const Text(
                          "Gender",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            // Male bullet with circle
                            _buildGenderOption('Male'),
                            const SizedBox(width: 20),
                            // Female bullet with circle
                            _buildGenderOption('Female'),
                            SizedBox(width: 40),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                width: 30,
                                child: TextField(
                                  controller: ageController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Enter age",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Daily Lifestyle Checkboxes (1-18)
                  _buildHealthItem(
                    "1. Early Wake Up (Between 4 to 6 am)",
                    wakeUp,
                    (v) {
                      setState(() => wakeUp = v!);
                    },
                  ),

                  _buildHealthItem("2. 15 Minutes Meditation", meditation, (v) {
                    setState(() => meditation = v!);
                  }),

                  _buildHealthItem("3. 15 Minutes Yoga and Pranayama", yoga, (
                    v,
                  ) {
                    setState(() => yoga = v!);
                  }),

                  _buildHealthItem(
                    "4. 30 Minutes Physical Exercise",
                    exercise,
                    (v) {
                      setState(() => exercise = v!);
                    },
                  ),

                  _buildHealthItem(
                    "5. 3 Minutes Normal Stretching (Only for sitting work)",
                    stretching,
                    (v) {
                      setState(() => stretching = v!);
                    },
                  ),

                  _buildHealthItem(
                    "6. 5 Minutes Barefoot Walking",
                    barefootWalking,
                    (v) {
                      setState(() => barefootWalking = v!);
                    },
                  ),

                  _buildHealthItem("7. 15 Minutes Sun Bath", sunBath, (v) {
                    setState(() => sunBath = v!);
                  }),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[100]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Follow Proper Food Timing",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   celibacyGuideline,
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: Colors.green[800],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildHealthItem(
                    "8 Breakfast - Between 7 to 9 am",
                    breakfast,
                    (v) {
                      setState(() => breakfast = v!);
                    },
                  ),

                  _buildHealthItem("9 Lunch - Between 11 to 1 pm", lunch, (v) {
                    setState(() => lunch = v!);
                  }),

                  _buildHealthItem(
                    "10 Afternoon - Between 2 to 4 pm",
                    afternoon,
                    (v) {
                      setState(() => afternoon = v!);
                    },
                  ),

                  _buildHealthItem("11 Dinner - Between 5 to 8 pm", dinner, (
                    v,
                  ) {
                    setState(() => dinner = v!);
                  }),

                  _buildHealthItem(
                    "12. Avoid Drinking Water While Eating",
                    avoidWaterWithMeal,
                    (v) {
                      setState(() => avoidWaterWithMeal = v!);
                    },
                  ),

                  _buildHealthItem("13. Drink 2 to 3 Liter Water", drinkWater, (
                    v,
                  ) {
                    setState(() => drinkWater = v!);
                  }),

                  _buildHealthItem(
                    "14. Avoid TV and Mobile While Eating",
                    avoidScreenWhileEating,
                    (v) {
                      setState(() => avoidScreenWhileEating = v!);
                    },
                  ),

                  _buildHealthItem("15. Chew Your Food Thoroughly", chewFood, (
                    v,
                  ) {
                    setState(() => chewFood = v!);
                  }),

                  _buildHealthItem(
                    "16. Avoid Tea, Coffee, Vegetable Soup, and Juice",
                    avoidTeaCoffee,
                    (v) {
                      setState(() => avoidTeaCoffee = v!);
                    },
                  ),

                  _buildHealthItem(
                    "17. Avoid Alcoholic Drinks and Any Type of Drugs",
                    avoidAlcohol,
                    (v) {
                      setState(() => avoidAlcohol = v!);
                    },
                  ),

                  _buildHealthItem(
                    "18. Avoid Non-Vegetarian Food",
                    avoidNonVeg,
                    (v) {
                      setState(() => avoidNonVeg = v!);
                    },
                  ),

                  _buildHealthItem(
                    "19. Maintain Gap Between Dinner and Sleep",
                    dinnerSleepGap,
                    (v) {
                      setState(() => dinnerSleepGap = v!);
                    },
                  ),

                  _buildHealthItem(
                    "20. Go to Bed Between 9 to 11 pm",
                    sleepTiming,
                    (v) {
                      setState(() => sleepTiming = v!);
                    },
                  ),

                  _buildHealthItem(
                    "21. Avoid Sleep in Day and Late Night Waking",
                    avoidDaySleep,
                    (v) {
                      setState(() => avoidDaySleep = v!);
                    },
                  ),

                  _buildHealthItem(
                    "22. Follow Celibacy/Avoid Intercourse",
                    followCelibacy,
                    (v) {
                      setState(() => followCelibacy = v!);
                    },
                  ),

                  // Age-wise Celibacy Guideline
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
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
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildHealthItem(
                    "23. Avoid use of mobile more than 15 min in a single posture",
                    avoidMobilePosture,
                    (v) {
                      setState(() => avoidMobilePosture = v!);
                    },
                  ),

                  _buildHealthItem(
                    "24. Avoid continued work more than 60 min in a single posture",
                    avoidLongPosture,
                    (v) {
                      setState(() => avoidLongPosture = v!);
                    },
                  ),

                  _buildHealthItem(
                    "25. Avoid Pain killers and excess use of supplements",
                    avoidPainkillers,
                    (v) {
                      setState(() => avoidPainkillers = v!);
                    },
                  ),

                  _buildHealthItem(
                    "26. Avoid watching Lust pictures/shows/games",
                    avoidLustContent,
                    (v) {
                      setState(() => avoidLustContent = v!);
                    },
                  ),

                  _buildHealthItem(
                    "27. Daily 30 minute all family member meet",
                    familyTime,
                    (v) {
                      setState(() => familyTime = v!);
                    },
                  ),

                  _buildHealthItem("28. Work with Patience", workWithPatience, (
                    v,
                  ) {
                    setState(() => workWithPatience = v!);
                  }),

                  _buildHealthItem("29. Live Stress Free", liveStressFree, (v) {
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
                            color: _getHealthStatusColor(
                              score,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getHealthStatusColor(score),
                            ),
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
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Check Score Button
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(celibacyGuideline),
                                      const SizedBox(height: 10),
                                      const Divider(),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Health Tips:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
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
