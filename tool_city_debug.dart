import 'package:country_state_city/country_state_city.dart' as csc;

Future<void> main() async {
  final countries = await csc.getAllCountries();
  final india = countries.firstWhere((c) => c.isoCode == 'IN', orElse: () => countries.first);
  print('country=${india.name} iso=${india.isoCode}');

  final states = await csc.getStatesOfCountry(india.isoCode);
  print('states=${states.length}');
  if (states.isNotEmpty) {
    final st = states.first;
    print('first_state name=${st.name} iso=${st.isoCode} countryCode=${st.countryCode}');
    final stateCities = await csc.getStateCities(india.isoCode, st.isoCode);
    print('stateCities=${stateCities.length}');

    final allCities = await csc.getCountryCities(india.isoCode);
    print('allCities=${allCities.length}');
    final matched = allCities.where((c) => c.stateCode == st.isoCode).toList();
    print('matchedByStateCode=${matched.length}');
    if (allCities.isNotEmpty) {
      final c = allCities.first;
      print('sample city=${c.name} stateCode=${c.stateCode} countryCode=${c.countryCode}');
    }
  }
}
