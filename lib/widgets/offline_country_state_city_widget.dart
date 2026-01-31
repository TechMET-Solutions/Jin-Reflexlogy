import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

class OfflineCountryStateCityWidget extends StatefulWidget {
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;
  final Function(String? country, String? state, String? city) onChanged;
  final bool enabled;

  const OfflineCountryStateCityWidget({
    Key? key,
    this.initialCountry,
    this.initialState,
    this.initialCity,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<OfflineCountryStateCityWidget> createState() =>
      _OfflineCountryStateCityWidgetState();
}

class _OfflineCountryStateCityWidgetState
    extends State<OfflineCountryStateCityWidget> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  List<String> countries = [];
  List<String> states = [];
  List<String> cities = [];

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
    try {
      print("🌍 Loading countries from offline data...");
      final allCountries = await csc.getAllCountries();
      
      if (!mounted) return;
      setState(() {
        countries = allCountries.map((c) => c.name).toList();
      });
      
      print("✅ Loaded ${countries.length} countries");

      if (selectedCountry != null) {
        await _loadStates(selectedCountry!);
        if (selectedState != null) {
          await _loadCities(selectedCountry!, selectedState!);
        }
      }
    } catch (e) {
      print("❌ Error loading countries: $e");
      if (!mounted) return;
      setState(() => countries = []);
    }
  }

  Future<void> _loadStates(String countryName) async {
    print("🔍 Loading states for: $countryName");
    
    try {
      final allCountries = await csc.getAllCountries();
      final country = allCountries.firstWhere(
        (c) => c.name == countryName,
        orElse: () => csc.Country(
          name: '',
          isoCode: '',
          phoneCode: '',
          flag: '',
          currency: '',
          latitude: '',
          longitude: '',
        ),
      );

      if (country.name.isEmpty) {
        print("❌ Country not found: $countryName");
        if (!mounted) return;
        setState(() {
          isLoadingStates = false;
          states = [];
        });
        return;
      }

      final allStates = await csc.getStatesOfCountry(country.isoCode);
      
      if (!mounted) return;
      setState(() {
        states = allStates.map((s) => s.name).toList();
        isLoadingStates = false;
      });
      
      print("✅ Loaded ${states.length} states for $countryName");
      
      widget.onChanged(selectedCountry, null, null);
    } catch (e) {
      print("❌ Error loading states: $e");
      
      if (!mounted) return;
      setState(() {
        states = [];
        isLoadingStates = false;
      });
    }
  }

  Future<void> _loadCities(String countryName, String stateName) async {
    print("🔍 Loading cities for: $countryName, $stateName");
    
    try {
      final allCountries = await csc.getAllCountries();
      final country = allCountries.firstWhere(
        (c) => c.name == countryName,
        orElse: () => csc.Country(
          name: '',
          isoCode: '',
          phoneCode: '',
          flag: '',
          currency: '',
          latitude: '',
          longitude: '',
        ),
      );

      if (country.name.isEmpty) {
        print("❌ Country not found: $countryName");
        if (!mounted) return;
        setState(() {
          isLoadingCities = false;
          cities = [];
        });
        return;
      }

      final allStates = await csc.getStatesOfCountry(country.isoCode);
      final state = allStates.firstWhere(
        (s) => s.name == stateName,
        orElse: () => csc.State(
          name: '',
          isoCode: '',
          countryCode: '',
        ),
      );

      if (state.name.isEmpty) {
        print("❌ State not found: $stateName");
        if (!mounted) return;
        setState(() {
          isLoadingCities = false;
          cities = [];
        });
        return;
      }

      final allCities = await csc.getCountryCities(country.isoCode);
      final stateCities = allCities
          .where((city) => city.stateCode == state.isoCode)
          .map((city) => city.name)
          .toList();
      
      if (!mounted) return;
      setState(() {
        cities = stateCities;
        isLoadingCities = false;
      });
      
      print("✅ Loaded ${cities.length} cities for $stateName, $countryName");
      
      widget.onChanged(selectedCountry, selectedState, null);
    } catch (e) {
      print("❌ Error loading cities: $e");
      
      if (!mounted) return;
      setState(() {
        cities = [];
        isLoadingCities = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Dropdown
        DropdownSearch<String>(
          items: countries,
          selectedItem: selectedCountry,
          enabled: widget.enabled && countries.isNotEmpty,
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
            menuProps: MenuProps(
              borderRadius: BorderRadius.circular(8),
            ),
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
              setState(() {
                selectedCountry = value;
                selectedState = null;
                selectedCity = null;
                states = [];
                cities = [];
                isLoadingStates = true;
              });
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
          items: states,
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
            menuProps: MenuProps(
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
              setState(() {
                selectedState = value;
                selectedCity = null;
                cities = [];
                isLoadingCities = true;
              });
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
            menuProps: MenuProps(
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
