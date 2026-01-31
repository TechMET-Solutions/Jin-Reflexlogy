import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:http/http.dart' as http;
import 'package:jin_reflex_new/api_service/payment_getway_keys.dart';
import 'package:jin_reflex_new/api_service/prefs/PreferencesKey.dart';
import 'package:jin_reflex_new/api_service/prefs/app_preference.dart';
import 'package:jin_reflex_new/screens/shop/cart_items_model.dart';
import 'package:jin_reflex_new/api_service/location_api_service.dart';
import 'package:jin_reflex_new/widgets/offline_country_state_city_widget.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ===============================================================
/// ADDRESS MODEL
/// ===============================================================
class Address {
  final String id;
  final String userId;
  final String userType;
  final String name;
  final String phone;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String country;
  final String type;
  bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.userId,
    required this.userType,
    required this.name,
    required this.phone,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    required this.country,
    required this.type,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      userType: json['userType'] ?? 'patient',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      addressLine1: json['address_line1'] ?? '',
      addressLine2: json['address_line2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      country: json['country'] ?? '',
      type: json['type'] ?? 'home',
      isDefault: json['is_default'] == true || json['is_default'] == 1,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'userType': userType,
      'name': name,
      'phone': phone,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'country': country,
      'type': type,
      'is_default': isDefault ? 1 : 0,
    };
  }

  String get fullAddress {
    final parts = [addressLine1];
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      parts.add(addressLine2!);
    }
    parts.add('$city, $state, $pincode');
    parts.add(country);
    return parts.join(', ');
  }

  // Display type with capital first letter
  String get displayType {
    if (type.isEmpty) return 'Home';
    return '${type[0].toUpperCase()}${type.substring(1)}';
  }
}

/// ===============================================================
/// ADDRESS API SERVICE
/// ===============================================================
class AddressApiService {
  static const String baseUrl = "https://admin.jinreflexology.in/api";

  // Get all addresses for user
  static Future<List<Address>> getUserAddresses() async {
    final userId = AppPreference().getString(PreferencesKey.userId);
    final userType = AppPreference().getString(PreferencesKey.type);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/userAddress"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": userId, "userType": userType}),
      );

      print("🔍 Get Addresses Response Status: ${response.statusCode}");
      print("🔍 Get Addresses Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true) {
          final List data = decoded["data"] ?? [];
          return data.map((e) => Address.fromJson(e)).toList();
        } else {
          throw Exception("API Error: ${decoded["message"]}");
        }
      } else {
        throw Exception("Failed to load addresses: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error in getUserAddresses: $e");
      rethrow;
    }
  }

  // Create new address
  static Future<Address> createAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/userAddress/store"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(addressData),
      );

      print("🔍 Create Address Response Status: ${response.statusCode}");
      print("🔍 Create Address Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true) {
          return Address.fromJson(decoded["data"] ?? addressData);
        } else {
          throw Exception("API Error: ${decoded["message"]}");
        }
      } else {
        throw Exception("Failed to create address: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error in createAddress: $e");
      rethrow;
    }
  }

  // Update address
  static Future<Address> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/userAddress/$addressId"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(addressData),
      );

      print("🔍 Update Address Response Status: ${response.statusCode}");
      print("🔍 Update Address Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true) {
          return Address.fromJson(decoded["data"] ?? addressData);
        } else {
          throw Exception("API Error: ${decoded["message"]}");
        }
      } else {
        throw Exception("Failed to update address: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error in updateAddress: $e");
      rethrow;
    }
  }

  // Delete address
  static Future<bool> deleteAddress(String addressId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/userAddress/$addressId"),
        headers: {"Accept": "application/json"},
      );

      print("🔍 Delete Address Response Status: ${response.statusCode}");
      print("🔍 Delete Address Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded["success"] == true;
      } else {
        throw Exception("Failed to delete address: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error in deleteAddress: $e");
      rethrow;
    }
  }

  // Set default address
  static Future<bool> setDefaultAddress(String addressId) async {
    try {
      // First get all addresses
      final addresses = await getUserAddresses();

      // Update all addresses - set the selected one as default, others as not default
      for (var address in addresses) {
        await updateAddress(address.id, {
          ...address.toJson(),
          'is_default': address.id == addressId ? 1 : 0,
        });
      }

      return true;
    } catch (e) {
      print("❌ Error in setDefaultAddress: $e");
      return false;
    }
  }
}

/// ===============================================================
/// ADDRESS MANAGEMENT SCREEN
/// ===============================================================
class AddressManagementScreen extends StatefulWidget {
  final Function(Address address) onAddressSelected;

  const AddressManagementScreen({Key? key, required this.onAddressSelected})
    : super(key: key);

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  List<Address> savedAddresses = [];
  bool isLoading = true;
  String? selectedAddressId;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    try {
      setState(() => isLoading = true);

      final addresses = await AddressApiService.getUserAddresses();

      setState(() {
        savedAddresses = addresses;
        if (addresses.isNotEmpty) {
          // Find default address or select first one
          final defaultAddress = addresses.firstWhere(
            (addr) => addr.isDefault,
            orElse: () => addresses.first,
          );
          selectedAddressId = defaultAddress.id;
        }
      });
    } catch (e) {
      print("❌ Error loading addresses: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load addresses: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _deleteAddress(String addressId) async {
    try {
      final userId = AppPreference().getString(PreferencesKey.userId);
      final userType = AppPreference().getString(PreferencesKey.type);

      final response = await http.delete(
        Uri.parse("https://admin.jinreflexology.in/api/userAddress/delete"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "userType": userType,
          "address_id": addressId,
        }),
      );

      print("🔍 Delete Address Response Status: ${response.statusCode}");
      print("🔍 Delete Address Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true) {
          setState(() {
            savedAddresses.removeWhere((address) => address.id == addressId);
            if (selectedAddressId == addressId && savedAddresses.isNotEmpty) {
              selectedAddressId = savedAddresses.first.id;
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Address deleted successfully"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          throw Exception("API Error: ${decoded["message"]}");
        }
      } else {
        throw Exception("Failed to delete address: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error deleting address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete address: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _setDefaultAddress(String addressId) async {
    try {
      final success = await AddressApiService.setDefaultAddress(addressId);

      if (success) {
        // Update local list
        setState(() {
          for (var address in savedAddresses) {
            address.isDefault = address.id == addressId;
          }
          selectedAddressId = addressId;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Default address updated"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("❌ Error setting default address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to set default address"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Delivery Address"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Add New Address Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddAddressDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.add_location_alt),
                      label: const Text(
                        "Add New Address",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Saved Addresses List
                  Expanded(
                    child:
                        savedAddresses.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: savedAddresses.length,
                              itemBuilder: (context, index) {
                                final address = savedAddresses[index];
                                return _addressCard(address);
                              },
                            ),
                  ),

                  // Deliver Here Button
                  if (selectedAddressId != null)
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          final selectedAddress = savedAddresses.firstWhere(
                            (addr) => addr.id == selectedAddressId,
                          );
                          widget.onAddressSelected(selectedAddress);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            247,
                            200,
                            90,
                          ),
                          foregroundColor: const Color.fromARGB(255, 19, 4, 66),
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "DELIVER TO THIS ADDRESS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No saved addresses found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Text(
            "Add your first address to continue",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddAddressDialog,
            icon: const Icon(Icons.add_location),
            label: const Text("Add Address"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 19, 4, 66),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(Address address) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color:
              selectedAddressId == address.id
                  ? const Color.fromARGB(255, 19, 4, 66)
                  : Colors.grey.shade300,
          width: selectedAddressId == address.id ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() => selectedAddressId = address.id);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Default Badge
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 19, 4, 66),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "DEFAULT",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (address.isDefault) const SizedBox(height: 8),

              // Address Type
              Row(
                children: [
                  Icon(
                    address.type == "home"
                        ? Icons.home
                        : address.type == "work"
                        ? Icons.work
                        : Icons.location_on,
                    color: const Color.fromARGB(255, 19, 4, 66),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    address.displayType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Address Details
              Text(
                address.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(address.addressLine1),
              if (address.addressLine2 != null &&
                  address.addressLine2!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(address.addressLine2!),
              ],
              const SizedBox(height: 4),
              Text("${address.city}, ${address.state}, ${address.pincode}"),
              const SizedBox(height: 4),
              Text(address.country),
              const SizedBox(height: 8),
              Text(
                "Phone: ${address.phone}",
                style: const TextStyle(color: Colors.grey),
              ),

              // Action Buttons
              const SizedBox(height: 12),
              Row(
                children: [
                  // Set as Default Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _setDefaultAddress(address.id),
                      style: OutlinedButton.styleFrom(
                        foregroundColor:
                            address.isDefault
                                ? Colors.grey
                                : const Color.fromARGB(255, 19, 4, 66),
                        side: BorderSide(
                          color:
                              address.isDefault
                                  ? Colors.grey
                                  : const Color.fromARGB(255, 19, 4, 66),
                        ),
                      ),
                      icon: const Icon(Icons.star_border, size: 16),
                      label: Text(
                        address.isDefault ? "Default" : "Set as Default",
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Edit Button
                  IconButton(
                    onPressed: () => _showEditAddressDialog(address),
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: "Edit",
                  ),

                  // Delete Button
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Delete Address"),
                              content: const Text(
                                "Are you sure you want to delete this address?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteAddress(address.id);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: "Delete",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAddressDialog({Address? address}) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController(
      text: address?.name ?? "",
    );
    final TextEditingController phoneController = TextEditingController(
      text: address?.phone ?? "",
    );
    final TextEditingController address1Controller = TextEditingController(
      text: address?.addressLine1 ?? "",
    );
    final TextEditingController address2Controller = TextEditingController(
      text: address?.addressLine2 ?? "",
    );
    final TextEditingController pincodeController = TextEditingController(
      text: address?.pincode ?? "",
    );

    // Country, State, City variables
    String? selectedCountry = address?.country;
    String? selectedState = address?.state;
    String? selectedCity = address?.city;

    String selectedType = address?.type ?? "home";
    bool isDefault = address?.isDefault ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                address == null ? "Add New Address" : "Edit Address",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 19, 4, 66),
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address Type Selection
                      Text(
                        "Address Type",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Home"),
                              selected: selectedType == "home",
                              onSelected: (selected) {
                                setState(() {
                                  selectedType = "home";
                                });
                              },
                              selectedColor: const Color.fromARGB(
                                255,
                                19,
                                4,
                                66,
                              ),
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    selectedType == "home"
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Work"),
                              selected: selectedType == "work",
                              onSelected: (selected) {
                                setState(() {
                                  selectedType = "work";
                                });
                              },
                              selectedColor: const Color.fromARGB(
                                255,
                                19,
                                4,
                                66,
                              ),
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    selectedType == "work"
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Other"),
                              selected: selectedType == "other",
                              onSelected: (selected) {
                                setState(() {
                                  selectedType = "other";
                                });
                              },
                              selectedColor: const Color.fromARGB(
                                255,
                                19,
                                4,
                                66,
                              ),
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color:
                                    selectedType == "other"
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Set as Default Checkbox
                      if (address == null || !address.isDefault)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          child: CheckboxListTile(
                            title: const Text(
                              "Set as default address",
                              style: TextStyle(fontSize: 14),
                            ),
                            value: isDefault,
                            onChanged: (value) {
                              setState(() {
                                isDefault = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      if (address == null || !address.isDefault)
                        const SizedBox(height: 20),

                      // Full Name
                      Text(
                        "Full Name *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter your full name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 19, 4, 66),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      Text(
                        "Phone Number *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: "Enter 10-digit mobile number",
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 19, 4, 66),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          prefix: const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Text("+91 "),
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          if (v.length != 10) return "10 digits required";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address Line 1
                      Text(
                        "Address Line 1 *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: address1Controller,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "House no, Building, Street",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 19, 4, 66),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                      const SizedBox(height: 16),

                      // Address Line 2 (Optional)
                      Text(
                        "Address Line 2 (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: address2Controller,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "Apartment, Floor, Landmark",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Country State City Widget (Offline)
                      OfflineCountryStateCityWidget(
                        initialCountry: selectedCountry,
                        initialState: selectedState,
                        initialCity: selectedCity,
                        onChanged: (country, state, city) {
                          setState(() {
                            selectedCountry = country;
                            selectedState = state;
                            selectedCity = city;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Pincode
                      Text(
                        "Pincode *",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: pincodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          hintText: "Enter 6-digit pincode",
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 19, 4, 66),
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return "Required";
                          if (v.length != 6) return "6 digits required";
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),

                      // Required Fields Note
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          "* Required fields",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Validation for dropdowns
                      if (selectedCountry == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select country"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (selectedState == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              selectedCountry == "India"
                                  ? "Please select state"
                                  : "Please select region/province",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (selectedCity == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              selectedCountry == "India"
                                  ? "Please select city"
                                  : "Please select city/town",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      await _saveAddress(
                        name: nameController.text,
                        phone: phoneController.text,
                        addressLine1: address1Controller.text,
                        addressLine2:
                            address2Controller.text.isNotEmpty
                                ? address2Controller.text
                                : null,
                        city: selectedCity!,
                        state: selectedState!,
                        pincode: pincodeController.text,
                        country: selectedCountry!,
                        type: selectedType,
                        isDefault: isDefault,
                        addressId: address?.id,
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    address == null ? "Save Address" : "Update Address",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditAddressDialog(Address address) {
    _showAddAddressDialog(address: address);
  }

  Future<void> _saveAddress({
    required String name,
    required String phone,
    required String addressLine1,
    required String? addressLine2,
    required String city,
    required String state,
    required String pincode,
    required String country,
    required String type,
    required bool isDefault,
    String? addressId,
  }) async {
    try {
      final userId = AppPreference().getString(PreferencesKey.userId);
      final userType = AppPreference().getString(PreferencesKey.type);

      final Map<String, dynamic> body = {
        "user_id": userId,
        "userType": userType,
        "name": name,
        "phone": phone,
        "address_line1": addressLine1,
        "address_line2": addressLine2,
        "city": city,
        "state": state,
        "pincode": pincode,
        "country": country,
        "type": type,
        "is_default": isDefault ? 1 : 0,
      };

      if (addressId == null) {
        // Create new address
        await AddressApiService.createAddress(body);
      } else {
        // Update existing address
        await AddressApiService.updateAddress(addressId, body);
      }

      // Reload addresses
      await _loadSavedAddresses();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            addressId == null
                ? "Address saved successfully"
                : "Address updated successfully",
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("❌ Error saving address: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to save address: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        validator: validator,
      ),
    );
  }
}

/// ===============================================================
/// BUY NOW FORM SCREEN
/// ===============================================================
class BuyNowFormScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double subtotal;
  final double discount;
  final double total;
  final String deliveryType; // 'india' or 'outside'

  const BuyNowFormScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.deliveryType,
  });

  @override
  State<BuyNowFormScreen> createState() => _BuyNowFormScreenState();
}

class _BuyNowFormScreenState extends State<BuyNowFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController couponController = TextEditingController();

  bool isLoading = false;
  bool isApplyingCoupon = false;
  Map<int, int>? productIdMap;
  Address? selectedAddress;
  String? appliedCouponCode;
  double currentSubtotal = 0;
  double currentDiscount = 0;
  double currentTotal = 0;
  late Razorpay _razorpay;
  bool _canGoBack = true;

  @override
  void initState() {
    super.initState();
    currentSubtotal = widget.subtotal;
    currentDiscount = widget.discount;
    currentTotal = widget.total;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _fetchProductIdMapping();
    _loadDefaultAddress();
    _fillUserInfo();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _fillUserInfo() {
    final name = AppPreference().getString(PreferencesKey.name);
    final email = AppPreference().getString(PreferencesKey.email);
    final phone = AppPreference().getString(PreferencesKey.contactNumber);

    if (name.isNotEmpty) nameController.text = name;
    if (email.isNotEmpty) emailController.text = email;
    if (phone.isNotEmpty) phoneController.text = phone;
  }

  Future<void> _loadDefaultAddress() async {
    try {
      final addresses = await AddressApiService.getUserAddresses();
      if (addresses.isNotEmpty) {
        final defaultAddress = addresses.firstWhere(
          (addr) => addr.isDefault,
          orElse: () => addresses.first,
        );
        setState(() {
          selectedAddress = defaultAddress;
          _fillFormWithAddress(defaultAddress);
        });
      }
    } catch (e) {
      print("❌ Error loading default address: $e");
    }
  }

  void _fillFormWithAddress(Address address) {
    nameController.text = address.name;
    phoneController.text = address.phone;
  }

  void _openAddressManagement() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddressManagementScreen(
              onAddressSelected: (address) {
                setState(() {
                  selectedAddress = address;
                  _fillFormWithAddress(address);
                });
              },
            ),
      ),
    );
  }

  /// ================= PAYMENT HANDLERS =================
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
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
      amount: currentTotal.toInt(),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Failed\n${response.message}"),
        backgroundColor: Colors.red,
      ),
    );

    await sendPaymentToBackend(
      status: "failed",
      reason: response.message,
      amount: currentTotal.toInt(),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wallet Used: ${response.walletName}")),
    );
  }

  Future<bool> isIndianUser() async {
    final prefs = await SharedPreferences.getInstance();
    final deliveryType = prefs.getString("delivery_type");
    return deliveryType == "india";
  }

  /// ===============================================================
  /// Fetch product ID mapping from cart API
  /// ===============================================================
  Future<void> _fetchProductIdMapping() async {
    try {
      final userId = AppPreference().getString(PreferencesKey.userId);
      final type = AppPreference().getString(PreferencesKey.type);
      final country = widget.deliveryType == "india" ? "in" : "us";

      final response = await http.get(
        Uri.parse(
          "https://admin.jinreflexology.in/api/cart?user_id=$userId&country=$country&type=$type",
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["success"] == true) {
          final cartData = decoded["data"] as List;
          final mapping = <int, int>{};

          for (var item in cartData) {
            final cartItemId = item["id"] as int;
            final productId = item["product_id"] as int;
            mapping[cartItemId] = productId;
          }

          setState(() {
            productIdMap = mapping;
          });
        }
      }
    } catch (e) {
      print("❌ Error fetching product mapping: $e");
    }
  }

  Future<void> startPayment(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate address
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a delivery address"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final isIndia = await isIndianUser();

    if (isIndia) {
      var options = {
        'key': razorpayKey,
        'amount': (currentTotal * 100).toInt(),
        'name': AppPreference().getString(PreferencesKey.name),
        'description': 'Order Payment',
        'prefill': {
          'contact': AppPreference().getString(PreferencesKey.contactNumber),
          'email': AppPreference().getString(PreferencesKey.email),
        },
      };

      _razorpay.open(options);
    } else {
      _startPayPalPayment(context);
    }
  }

  void _startPayPalPayment(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: isSandboxMode,
              clientId: paypalClientId,
              secretKey: paypalSecret,
              transactions: [
                {
                  "amount": {
                    "total": currentTotal.toStringAsFixed(2),
                    "currency": "USD",
                  },
                  "description": "Order Payment",
                },
              ],
              note: "Order Payment",
              onSuccess: (Map params) async {
                final paypalPaymentId = params["data"]?["id"];

                debugPrint("PayPal Payment ID: $paypalPaymentId");

                if (paypalPaymentId == null) {
                  debugPrint("❌ PayPal paymentId null");
                  return;
                }

                await sendPaymentToBackend(
                  status: "success",
                  paymentId: paypalPaymentId,
                  orderId: null,
                  amount: currentTotal.toInt(),
                );
                placeOrder();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("PayPal Payment Successful"),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              },
              onError: (error) async {
                // await sendPaymentToBackend(
                //   status: "failed",
                //   reason: error.toString(),
                //   amount: currentTotal.toInt(),
                // );
                // debugPrint("❌ PayPal Error: $error");
              },
              onCancel: () async {
                debugPrint("⚠️ PayPal Cancelled");
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
      var postData = {
        "user_id": AppPreference().getString(PreferencesKey.userId),
        "payment_id": paymentId,
        "orderid": orderId,
        "amount": currentTotal,
        "status": status,
        "email": AppPreference().getString(PreferencesKey.email),
        "name": AppPreference().getString(PreferencesKey.name),
        "contact": AppPreference().getString(PreferencesKey.contactNumber),
      };
      log("${postData}");
      final response = await dio.post(
        "https://admin.jinreflexology.in/api/payment_callback",
        data: {
          "user_id": AppPreference().getString(PreferencesKey.userId),
          "payment_id": paymentId,
          "orderid": orderId,
          "amount": currentSubtotal,
          "status": status,
          "email": AppPreference().getString(PreferencesKey.email),
          "name": AppPreference().getString(PreferencesKey.name),
          "contact": AppPreference().getString(PreferencesKey.contactNumber),
          "country": widget.deliveryType == "india" ? "in" : "us",
          "userType":AppPreference().getString(PreferencesKey.type)
        },
      );

      debugPrint("✅ Payment sent to backend: ${response.data}");
      if (response.data["success"] == true) {
        log("Payment Success");
        await placeOrder();
        Navigator.pop(context);
      } else {}
    } catch (e) {
      debugPrint("❌ Backend API error: $e");
    }
  }

  /// ===============================================================
  /// APPLY COUPON API
  /// ===============================================================
  Future<void> applyCoupon() async {
    if (couponController.text.trim().isEmpty) {
      _showError("Please enter coupon code");
      return;
    }

    if (appliedCouponCode != null) {
      _showError("A coupon is already applied. Remove it first.");
      return;
    }

    setState(() => isApplyingCoupon = true);

    const String url = "https://admin.jinreflexology.in/api/cart/apply-coupon";
    final country = widget.deliveryType == "india" ? "in" : "us";
    final type = AppPreference().getString(PreferencesKey.type);

    final Map<String, dynamic> body = {
      "user_id": AppPreference().getString(PreferencesKey.userId),
      "country": country,
      "coupon_code": couponController.text.trim(),
      "type": type,
    };

    print("=== APPLY COUPON REQUEST ===");
    print("URL: $url");
    print("Body: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          await _fetchProductIdMapping();
          final totals = decoded["totals"] ?? {};

          setState(() {
            appliedCouponCode = couponController.text.trim();
            currentSubtotal = double.tryParse(totals["subtotal"] ?? "0") ?? 0;
            currentDiscount = double.tryParse(totals["discount"] ?? "0") ?? 0;
            currentTotal = double.tryParse(totals["total"] ?? "0") ?? 0;
          });

          _showSuccess("Coupon applied successfully!");
        } else {
          _showError(decoded["message"] ?? "Failed to apply coupon");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error: $e");
      _showError("Network error: Please check your internet connection");
    } finally {
      setState(() => isApplyingCoupon = false);
    }
  }

  /// ===============================================================
  /// REMOVE COUPON API
  /// ===============================================================
  Future<void> removeCoupon() async {
    await _fetchProductIdMapping();
    final type = AppPreference().getString(PreferencesKey.type);
    final userId = AppPreference().getString(PreferencesKey.userId);

    setState(() => isApplyingCoupon = true);

    const String url = "https://admin.jinreflexology.in/api/cart/remove-coupon";

    final country = widget.deliveryType == "india" ? "in" : "us";
    setState(() {
      _canGoBack = false;
    });

    final Map<String, dynamic> body = {
      "user_id": int.parse(userId),
      "country": country,
      "type": type,
    };

    print("=== REMOVE COUPON REQUEST ===");
    print("URL: $url");
    print("Body: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        await _fetchProductIdMapping();
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          final totals = decoded["totals"] ?? {};
          await _fetchProductIdMapping();
          setState(() {
            appliedCouponCode = null;
            couponController.clear();
            currentSubtotal = double.tryParse(totals["subtotal"] ?? "0") ?? 0;
            currentDiscount = double.tryParse(totals["discount"] ?? "0") ?? 0;
            currentTotal = double.tryParse(totals["total"] ?? "0") ?? 0;
          });
          setState(() {
            _canGoBack = true;
          });
        } else {
          _canGoBack = true;
          _showError(decoded["message"] ?? "Failed to remove coupon");
        }
      } else {
        _canGoBack = true;
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Network error: $e");
      _showError("Network error: Please check your internet connection");
      _canGoBack = true;
    } finally {
      setState(() => isApplyingCoupon = false);
    }
  }

  /// ===============================================================
  /// PLACE ORDER API
  /// ===============================================================
  Future<void> placeOrder() async {
    if (productIdMap == null) {
      _showError("Loading product information. Please try again.");
      return;
    }

    if (selectedAddress == null) {
      _showError("Please select a delivery address");
      return;
    }

    setState(() => isLoading = true);

    const String url = "http://admin.jinreflexology.in/api/place-order";

    List<Map<String, dynamic>> items = [];
    for (var cartItem in widget.cartItems) {
      final actualProductId = productIdMap![cartItem.id];
      if (actualProductId != null) {
        items.add({
          "product_id": actualProductId,
          "quantity": cartItem.quantity,
        });
      }
    }

    if (items.isEmpty) {
      _showError("No valid items in cart. Please refresh cart.");
      setState(() => isLoading = false);
      return;
    }

    final Map<String, dynamic> body = {
      "user_id": AppPreference().getString(PreferencesKey.userId),
      "address": selectedAddress!.fullAddress,
      "city": selectedAddress!.city,
      "state": selectedAddress!.state,
      "country": selectedAddress!.country,
      "pincode": selectedAddress!.pincode,
      "customer_name": nameController.text.trim(),
      "customer_email": emailController.text.trim(),
      "customer_phone": phoneController.text.trim(),
      "items": items,
      "subtotal": currentSubtotal,
      "discount": currentDiscount,
      "total": currentTotal,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);

          if (decoded["success"] == true) {
            _showSuccessPopup(decoded);
          } else {
            _showError(decoded["message"] ?? "Something went wrong");
          }
        } catch (e) {
          _showError("Invalid response from server");
        }
      } else {
        _showError("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("Network error: Please check your internet connection");
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// ===============================================================
  /// UI
  /// ===============================================================

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isApplyingCoupon) {
          await removeCoupon();
        }

        if (!_canGoBack) {
          _showError("Please wait, placing your order...");
          return false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        appBar: AppBar(
          leading: InkWell(
            onTap: () async {
              if (isApplyingCoupon) await removeCoupon();
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          title: Text(
            widget.deliveryType == "india"
                ? "Buy Now - India Delivery"
                : "Buy Now - International Delivery",
          ),
          backgroundColor: const Color.fromARGB(255, 19, 4, 66),
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _cartItemsSection(),
                const SizedBox(height: 16),
                _priceSummarySection(),
                const SizedBox(height: 20),
                _addressSelectionSection(),
                const SizedBox(height: 20),
                //  _customerDetailsSection(),
                const SizedBox(height: 20),
                _couponSection(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _bottomBar(),
      ),
    );
  }

  /// ===============================================================
  /// CART ITEMS LIST
  /// ===============================================================
  Widget _cartItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Items",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...widget.cartItems.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color.fromARGB(255, 19, 4, 66)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.network(
                    item.image,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => const Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.deliveryType == "india" ? "₹" : "\$"} ${item.price} × ${item.quantity} = ${widget.deliveryType == "india" ? "₹" : "\$"} ${item.price * item.quantity}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  /// ===============================================================
  /// PRICE SUMMARY
  /// ===============================================================
  Widget _priceSummarySection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _priceRow(
            "Subtotal",
            "${widget.deliveryType == "india" ? "₹" : "\$"} ${currentSubtotal.toStringAsFixed(2)}",
          ),
          _priceRow(
            "Discount",
            "- ${widget.deliveryType == "india" ? "₹" : "\$"} ${currentDiscount.toStringAsFixed(2)}",
          ),
          const Divider(),
          _priceRow(
            "Total Amount",
            "${widget.deliveryType == "india" ? "₹" : "\$"} ${currentTotal.toStringAsFixed(2)}",
            bold: true,
            color: const Color.fromARGB(255, 19, 4, 66),
          ),
        ],
      ),
    );
  }

  /// ===============================================================
  /// ADDRESS SELECTION SECTION
  /// ===============================================================
  Widget _addressSelectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Delivery Address",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (selectedAddress != null)
          Card(
            elevation: 3,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedAddress!.displayType,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color.fromARGB(255, 19, 4, 66),
                        ),
                      ),
                      if (selectedAddress!.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "DEFAULT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedAddress!.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(selectedAddress!.addressLine1),
                  if (selectedAddress!.addressLine2 != null &&
                      selectedAddress!.addressLine2!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(selectedAddress!.addressLine2!),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    "${selectedAddress!.city}, ${selectedAddress!.state}, ${selectedAddress!.pincode}",
                  ),
                  const SizedBox(height: 4),
                  Text(selectedAddress!.country),
                  const SizedBox(height: 8),
                  Text(
                    "Phone: ${selectedAddress!.phone}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _openAddressManagement,
                      icon: const Icon(Icons.location_on),
                      label: const Text("Change Address"),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Icon(Icons.location_off, size: 40, color: Colors.grey),
                const SizedBox(height: 10),
                const Text(
                  "No address selected",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _openAddressManagement,
                  icon: const Icon(Icons.add_location),
                  label: const Text("Select Address"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// ===============================================================
  /// CUSTOMER DETAILS FORM
  /// ===============================================================
  Widget _customerDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Customer Details",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  /// ===============================================================
  /// COUPON SECTION
  /// ===============================================================
  Widget _couponSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Apply Coupon",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        if (appliedCouponCode != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.discount, color: Colors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Coupon Applied: $appliedCouponCode",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "You saved ${widget.deliveryType == "india" ? "₹" : "\$"}${currentDiscount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: isApplyingCoupon ? null : removeCoupon,
                  icon: const Icon(Icons.close, color: Colors.red),
                  tooltip: "Remove coupon",
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: couponController,
                decoration: InputDecoration(
                  hintText: "Enter coupon code",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 19, 4, 66),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                enabled: appliedCouponCode == null && !isApplyingCoupon,
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      appliedCouponCode == null
                          ? const Color.fromARGB(255, 19, 4, 66)
                          : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed:
                    (appliedCouponCode == null && !isApplyingCoupon)
                        ? applyCoupon
                        : null,
                child:
                    isApplyingCoupon
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : Text(
                          appliedCouponCode == null ? "Apply" : "Applied",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ===============================================================
  /// BOTTOM BAR
  /// ===============================================================
  Widget _bottomBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                productIdMap != null
                    ? const Color.fromARGB(255, 19, 4, 66)
                    : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed:
              (productIdMap != null && !isLoading)
                  ? () {
                    startPayment(context);
                  }
                  : null,
          child:
              isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                  : productIdMap != null
                  ? const Text(
                    "Place Order & Pay",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                  : const Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }

  /// ===============================================================
  /// HELPERS
  /// ===============================================================
  Widget _priceRow(
    String title,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : null,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : null,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          validator:
              validator ??
              (v) => v == null || v.trim().isEmpty ? "Required" : null,
          decoration: _border(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  InputDecoration _border() {
    return InputDecoration(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 19, 4, 66),
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  void _showSuccessPopup(Map<String, dynamic> response) {
    final orderId = response["data"]["order_id"] ?? "N/A";
    final orderNumber =
        response["data"]["order_details"]["order_number"] ?? "N/A";
    final totalAmount = response["data"]["order_details"]["total_amount"] ?? 0;
    final status = response["data"]["order_details"]["status"] ?? "N/A";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (_) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Order Placed Successfully!"),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Your order has been placed successfully."),
                  const SizedBox(height: 16),
                  const Text(
                    "Order Summary:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _orderDetailRow("Order ID:", orderId),
                  _orderDetailRow("Order Number:", orderNumber),
                  _orderDetailRow(
                    "Total Amount:",
                    "${widget.deliveryType == "india" ? "₹" : "\$"} ${totalAmount.toStringAsFixed(2)}",
                  ),
                  _orderDetailRow("Status:", _capitalize(status)),
                  if (appliedCouponCode != null) ...[
                    const SizedBox(height: 8),
                    _orderDetailRow("Coupon Applied:", appliedCouponCode!),
                    _orderDetailRow(
                      "Discount:",
                      "${widget.deliveryType == "india" ? "₹" : "\$"} ${currentDiscount.toStringAsFixed(2)}",
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Thank you for shopping with us!",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  removeCoupon();
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 19, 4, 66),
                ),
                child: const Text(
                  "Continue Shopping",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _orderDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
