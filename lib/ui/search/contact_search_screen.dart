import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/db/local_database.dart';
import '../../model/contact_model.dart';
import '../contact_screen/contact_screen.dart';
import '../single_contact/single_contact_screen.dart';

class ContactSearchScreen extends StatefulWidget {
  const ContactSearchScreen({Key? key}) : super(key: key);

  @override
  State<ContactSearchScreen> createState() => _ContactSearchScreenState();
}

class _ContactSearchScreenState extends State<ContactSearchScreen> {
  List<ContactModelSql> contacts = [];
  String query = '';

  _updateContacts() async {
    contacts = await LocalDatabase.getAllContacts();
    setState(() {});
  }

  @override
  void initState() {
    _updateContacts();
    LocalDatabase.getSearch(query).then((value) {
      setState(() {
        contacts.clear();
        contacts.addAll(value);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.999),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: TextField(
                  onChanged: (newText) {
                    setState(() {});
                    onTextChanged(newText);
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Search...",
                  ),
                ),
              ),
              SizedBox(
                height: 740,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    contacts.length,
                    (index) => ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleContactScreen(
                              id: contacts[index].id!,
                            ),
                          ),
                        );
                      },
                      leading: SvgPicture.asset("assets/svg/account.svg"),
                      title: Row(
                        children: [
                          Text(
                            contacts[index].name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            contacts[index].surname,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "+998${contacts[index].phone[0]}${contacts[index].phone[1]} ${contacts[index].phone[2]}${contacts[index].phone[3]}${contacts[index].phone[4]} ${contacts[index].phone[5]}${contacts[index].phone[6]} ${contacts[index].phone[7]}${contacts[index].phone[8]}",
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8B8B8B)),
                      ),
                      trailing: SvgPicture.asset("assets/svg/call.svg"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onTextChanged(String newText) {
    query = newText;
    LocalDatabase.getSearch(query).then((value) {
      setState(() {
        contacts.clear();
        contacts.addAll(value);
      });
    });
  }
}
