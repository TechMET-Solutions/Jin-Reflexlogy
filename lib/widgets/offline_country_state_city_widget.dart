import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:flutter/material.dart';

class OfflineCountryStateCityWidget extends StatefulWidget {
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;
  final Function(String? country, String? state, String? city) onChanged;
  final bool enabled;

  const OfflineCountryStateCityWidget({
    super.key,
    this.initialCountry,
    this.initialState,
    this.initialCity,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  State<OfflineCountryStateCityWidget> createState() =>
      _OfflineCountryStateCityWidgetState();
}

class _OfflineCountryStateCityWidgetState
    extends State<OfflineCountryStateCityWidget> {
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

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
    _countryController.text = selectedCountry ?? '';
    _stateController.text = selectedState ?? '';
    _cityController.text = selectedCity ?? '';
    _loadCountries();
  }

  @override
  void dispose() {
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadCountries() async {
    final allCountries = await csc.getAllCountries();
    if (!mounted) return;

    setState(() {
      countries = allCountries.map((c) => c.name).toList();
    });

    if (selectedCountry != null) {
      await _loadStates(selectedCountry!, preserveSelection: true);
      if (selectedState != null) {
        await _loadCities(
          selectedCountry!,
          selectedState!,
          preserveSelection: true,
        );
      }
    }
  }

  Future<void> _loadStates(
    String countryName, {
    bool preserveSelection = false,
  }) async {
    if (!mounted) return;
    setState(() {
      isLoadingStates = true;
      states = [];
      cities = [];
      if (!preserveSelection) {
        selectedState = null;
        selectedCity = null;
        _stateController.clear();
        _cityController.clear();
      }
    });

    final allCountries = await csc.getAllCountries();
    final country = allCountries.where((c) => c.name == countryName).firstOrNull;

    if (country == null) {
      if (!mounted) return;
      setState(() => isLoadingStates = false);
      return;
    }

    final allStates = await csc.getStatesOfCountry(country.isoCode);
    if (!mounted) return;

    setState(() {
      states = allStates.map((s) => s.name).toList();
      isLoadingStates = false;
      if (preserveSelection && !states.contains(selectedState)) {
        selectedState = null;
        selectedCity = null;
        _stateController.clear();
        _cityController.clear();
      }
    });
  }

  Future<void> _loadCities(
    String countryName,
    String stateName, {
    bool preserveSelection = false,
  }) async {
    if (!mounted) return;
    setState(() {
      isLoadingCities = true;
      cities = [];
      if (!preserveSelection) {
        selectedCity = null;
        _cityController.clear();
      }
    });

    final allCountries = await csc.getAllCountries();
    final country = allCountries.where((c) => c.name == countryName).firstOrNull;
    if (country == null) {
      if (!mounted) return;
      setState(() => isLoadingCities = false);
      return;
    }

    final allStates = await csc.getStatesOfCountry(country.isoCode);
    final state = allStates.where((s) => s.name == stateName).firstOrNull;
    if (state == null) {
      if (!mounted) return;
      setState(() => isLoadingCities = false);
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
      if (preserveSelection && !cities.contains(selectedCity)) {
        selectedCity = null;
        _cityController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAutocompleteField(
          label: 'Country *',
          hint: 'Type country name',
          icon: Icons.public,
          controller: _countryController,
          enabled: widget.enabled,
          options: countries,
          onSelected: (value) async {
            selectedCountry = value;
            _countryController.text = value;
            selectedState = null;
            selectedCity = null;
            _stateController.clear();
            _cityController.clear();
            widget.onChanged(selectedCountry, null, null);
            await _loadStates(value);
          },
        ),
        const SizedBox(height: 16),
        _buildAutocompleteField(
          label: 'State *',
          hint:
              isLoadingStates
                  ? 'Loading states...'
                  : 'Type state name',
          icon: Icons.location_city,
          controller: _stateController,
          enabled: widget.enabled && selectedCountry != null && !isLoadingStates,
          options: states,
          onSelected: (value) async {
            selectedState = value;
            _stateController.text = value;
            selectedCity = null;
            _cityController.clear();
            widget.onChanged(selectedCountry, selectedState, null);
            if (selectedCountry != null) {
              await _loadCities(selectedCountry!, value);
            }
          },
        ),
        const SizedBox(height: 16),
        _buildAutocompleteField(
          label: 'City *',
          hint:
              isLoadingCities
                  ? 'Loading cities...'
                  : 'Type city name',
          icon: Icons.location_on,
          controller: _cityController,
          enabled: widget.enabled && selectedState != null && !isLoadingCities,
          options: cities,
          onSelected: (value) {
            selectedCity = value;
            _cityController.text = value;
            widget.onChanged(selectedCountry, selectedState, selectedCity);
          },
        ),
      ],
    );
  }

  Widget _buildAutocompleteField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required bool enabled,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: controller.text),
      optionsBuilder: (textEditingValue) {
        if (!enabled) return const Iterable<String>.empty();
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) return options.take(20);
        return options.where((item) => item.toLowerCase().contains(query));
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
        textController.value = controller.value;
        textController.addListener(() {
          controller.value = textController.value;
        });

        return TextFormField(
          controller: textController,
          focusNode: focusNode,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon),
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
          onChanged: (value) {
            controller.text = value;
            if (value.isEmpty) {
              if (label.startsWith('Country')) {
                selectedCountry = null;
                selectedState = null;
                selectedCity = null;
                _stateController.clear();
                _cityController.clear();
                states = [];
                cities = [];
              } else if (label.startsWith('State')) {
                selectedState = null;
                selectedCity = null;
                _cityController.clear();
                cities = [];
              } else {
                selectedCity = null;
              }
              widget.onChanged(selectedCountry, selectedState, selectedCity);
              setState(() {});
            }
          },
        );
      },
      optionsViewBuilder: (context, onSelectedOption, filteredOptions) {
        final items = filteredOptions.toList();
        if (items.isEmpty) return const SizedBox.shrink();

        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, minWidth: 280),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    dense: true,
                    title: Text(item),
                    onTap: () => onSelectedOption(item),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
