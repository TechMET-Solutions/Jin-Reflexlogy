import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jin_reflex_new/api_service/location_api_service.dart';

class CountryStateCityWidget extends StatefulWidget {
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;
  final Function(String? country, String? state, String? city) onChanged;
  final bool enabled;

  const CountryStateCityWidget({
    Key? key,
    this.initialCountry,
    this.initialState,
    this.initialCity,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CountryStateCityWidget> createState() =>
      _CountryStateCityWidgetState();
}

class _CountryStateCityWidgetState extends State<CountryStateCityWidget> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<CountryModel> countries = [];
  List<StateModel> states = [];
  List<String> cities = [];

  bool isLoadingCountries = false;
  bool isLoadingStates = false;
  bool isLoadingCities = false;

  @override
  void initState() {
    super.initState();
    selectedCountry = widget.initialCountry;
    selectedState = widget.initialState;
    selectedCity = widget.initialCity;
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    if (!mounted) return;
    setState(() => isLoadingCountries = true);
    
    try {
      final result = await LocationApiService.getCountries();
      
      if (!mounted) return;
      setState(() {
        countries = result;
        isLoadingCountries = false;
      });

      if (selectedCountry != null) {
        await _loadStates(selectedCountry!);
        if (selectedState != null) {
          await _loadCities(selectedCountry!, selectedState!);
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoadingCountries = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading countries: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadStates(String country) async {
    print("🔍 Loading states for: $country");
    
    if (!mounted) return;
    setState(() {
      isLoadingStates = true;
      states = [];
      cities = [];
      selectedState = null;
      selectedCity = null;
    });

    try {
      final result = await LocationApiService.getStates(country);
      print("✅ States loaded: ${result.length} states");
      
      if (!mounted) return;
      setState(() {
        states = result;
        isLoadingStates = false;
      });
      
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No states available for $country"),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      widget.onChanged(selectedCountry, null, null);
    } catch (e) {
      print("❌ Error loading states: $e");
      
      if (!mounted) return;
      setState(() => isLoadingStates = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading states: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadCities(String country, String state) async {
    print("🔍 Loading cities for: $country, $state");
    
    if (!mounted) return;
    setState(() {
      isLoadingCities = true;
      cities = [];
      selectedCity = null;
    });

    try {
      final result = await LocationApiService.getCities(country, state);
      print("✅ Cities loaded: ${result.length} cities");
      
      if (!mounted) return;
      setState(() {
        cities = result;
        isLoadingCities = false;
      });
      
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No cities available for $state, $country"),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      
      widget.onChanged(selectedCountry, selectedState, null);
    } catch (e) {
      print("❌ Error loading cities: $e");
      
      if (!mounted) return;
      setState(() => isLoadingCities = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading cities: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Dropdown
        DropdownSearch<String>(
          items: countries.map((e) => e.name).toList(),
          selectedItem: selectedCountry,
          enabled: widget.enabled && !isLoadingCountries,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search country...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            menuProps:  MenuProps(
              borderRadius: BorderRadius.circular(8),
            ),
            loadingBuilder: (context, searchEntry) =>
                const Center(child: CircularProgressIndicator()),
            emptyBuilder: (context, searchEntry) =>
                const Center(child: Text("No countries found")),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "Country *",
              hintText: "Select country",
              prefixIcon: const Icon(Icons.public),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 19, 4, 66),
                  width: 2,
                ),
              ),
            ),
          ),
          onChanged: (value) async {
            if (value != null && value != selectedCountry) {
              print("🌍 Country selected: $value");
              setState(() => selectedCountry = value);
              await _loadStates(value);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a country";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // State Dropdown
        DropdownSearch<String>(
          items: states.map((e) => e.name).toList(),
          selectedItem: selectedState,
          enabled: widget.enabled && states.isNotEmpty && !isLoadingStates,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search state...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            menuProps:  MenuProps(
              borderRadius: BorderRadius.circular(8),
            ),
            loadingBuilder: (context, searchEntry) =>
                const Center(child: CircularProgressIndicator()),
            emptyBuilder: (context, searchEntry) =>
                const Center(child: Text("No states found")),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "State *",
              hintText: isLoadingStates
                  ? "Loading states..."
                  : states.isEmpty
                      ? "Select country first"
                      : "Select state",
              prefixIcon: const Icon(Icons.location_city),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 19, 4, 66),
                  width: 2,
                ),
              ),
            ),
          ),
          onChanged: (value) async {
            if (value != null && value != selectedState) {
              print("🏙️ State selected: $value");
              setState(() => selectedState = value);
              if (selectedCountry != null) {
                await _loadCities(selectedCountry!, value);
              }
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a state";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // City Dropdown
        DropdownSearch<String>(
          items: cities,
          selectedItem: selectedCity,
          enabled: widget.enabled && cities.isNotEmpty && !isLoadingCities,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search city...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            menuProps:  MenuProps(
              borderRadius: BorderRadius.circular(8),
            ),
            loadingBuilder: (context, searchEntry) =>
                const Center(child: CircularProgressIndicator()),
            emptyBuilder: (context, searchEntry) =>
                const Center(child: Text("No cities found")),
          ),
          dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              labelText: "City *",
              hintText: isLoadingCities
                  ? "Loading cities..."
                  : cities.isEmpty
                      ? "Select state first"
                      : "Select city",
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 19, 4, 66),
                  width: 2,
                ),
              ),
            ),
          ),
          onChanged: (value) {
            print("🏢 City selected: $value");
            setState(() => selectedCity = value);
            widget.onChanged(selectedCountry, selectedState, value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a city";
            }
            return null;
          },
        ),
      ],
    );
  }
}