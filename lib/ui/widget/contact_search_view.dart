import 'package:contact_application/model/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../single_contact/single_contact_screen.dart';

class ContactSearchView extends SearchDelegate {
  ContactSearchView(this.contacts, {required this.suggestionList});

  final List<String> suggestionList;
  final List<ContactModelSql> contacts;

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      onPressed: () {
        query = '';
      },
      icon: const Icon(Icons.close),
    ),
    Row(children: [
      Icon(Icons.more_vert,color: Colors.black,),
      SizedBox(width: 24,)
    ],)
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () {
      close(context, query);
    },
  );

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(
          fontSize: 64,
        ),
      ),
    );
  }



  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = suggestionList.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
      //["Olmazor","Samarqand","Moscow"]
    }).toList();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(
          suggestions.length,
              (index) => GestureDetector(
            child: ListTile(
              title: Text(suggestions[index]),
            onTap: () {
              query = suggestions[index];
              Navigator.push(context, CupertinoPageRoute(builder: (context)=>SingleContactScreen(id: contacts[index].id!, listening: (){})));
            },
            )
              // close(context, query);
          ),
        ),
      ),
    );
  }
}