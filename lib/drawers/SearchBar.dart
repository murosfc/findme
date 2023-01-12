import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SearchBar extends SearchDelegate {
  List<String> searchResults = [
    'Rafael',
    'Felipe',
    'Nathalia'
  ]; //Esta lista deve ser preenchida com os amigos adicionados pelo usuário

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          onPressed: () {
            query.isEmpty ? close(context, null) : query = '';
          },
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => Container(
        color: Color(0xFF121212),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => close(context, null),
        ),
      );

  @override
  Widget buildResults(BuildContext context) => Center(child: Text(query));

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();

    suggestions.sort();

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
              title: Text(suggestion, style: TextStyle(color: Colors.white)),
              onTap: () {
                query = suggestion;
                showResults(context);
              });
        });
  }

  @override
  String get searchFieldLabel => 'search-hint'.i18n();

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: searchFieldDecorationTheme,
      hintColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Color(0xFF121212),
      ),
      textTheme: Theme.of(context)
          .textTheme
          .copyWith(headline6: TextStyle(color: Colors.white)),
    );
  }
}
