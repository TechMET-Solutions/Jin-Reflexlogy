import 'package:flutter/material.dart';
import 'shop_screen.dart';

void showDeliveryPopup(BuildContext context) {
  String selectedOption = "india";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔶 Top Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        37,
                        41,
                        170,
                      ).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_shipping,
                      color: Color.fromARGB(255, 50, 42, 164),
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔶 Title
                  const Text(
                    "Select Delivery Location",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Please choose where the product should be delivered",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                  const SizedBox(height: 16),

                  // 🔶 Options
                  _deliveryTile(
                    title: "Delivery within India",
                    icon: Icons.flag,
                    value: "india",
                    groupValue: selectedOption,
                    onChanged: (val) {
                      setState(() => selectedOption = val);
                    },
                  ),

                  const SizedBox(height: 10),

                  _deliveryTile(
                    title: "Delivery outside India",
                    icon: Icons.public,
                    value: "outside",
                    groupValue: selectedOption,
                    onChanged: (val) {
                      setState(() => selectedOption = val);
                    },
                  ),

                  const SizedBox(height: 20),

                  // 🔶 Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              59,
                              47,
                              146,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ShopScreen(
                                      deliveryType: selectedOption,
                                    ),
                              ),
                            );
                          },
                          child: const Text(
                            "Continue",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

/// 🔹 Custom Radio Tile
Widget _deliveryTile({
  required String title,
  required IconData icon,
  required String value,
  required String groupValue,
  required Function(String) onChanged,
}) {
  final bool isSelected = value == groupValue;

  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () => onChanged(value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? const Color.fromARGB(255, 42, 39, 121)
                  : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        color:
            isSelected
                ? const Color.fromARGB(255, 29, 43, 106).withOpacity(0.08)
                : Colors.white,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
                isSelected
                    ? const Color.fromARGB(255, 40, 56, 126)
                    : Colors.grey,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Radio<String>(
            value: value,
            groupValue: groupValue,
            activeColor: const Color.fromARGB(255, 49, 48, 144),
            onChanged: (val) {
              if (val != null) onChanged(val);
            },
          ),
        ],
      ),
    ),
  );
}
