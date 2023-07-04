import 'package:contact_application/ui/add_contact/add_contact_screen.dart';
import 'package:contact_application/ui/search/contact_search_screen.dart';
import 'package:contact_application/ui/single_contact/single_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/db/local_database.dart';
import '../../model/contact_model.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<ContactModelSql> contacts = [];

  _updateContacts() async {
    contacts = await LocalDatabase.getAllContacts();
    setState(() {});
  }

  _getContactsByAlp(String order) async {
    contacts = await LocalDatabase.getContactsByAlphabet(order);
    setState(() {});
  }

  @override
  void initState() {
    _updateContacts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.999),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Contacts",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactSearchScreen()));
            },
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          PopupMenuButton(
              color: Colors.grey,
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: PopupMenuButton(
                      child: const Text("Sort by"),
                      itemBuilder: (context) => [
                         PopupMenuItem(
                          onTap: (){
                            setState(() {
                              _getContactsByAlp("ASC");
                            });
                          },
                            child:const Text(
                          "A-Z",
                        )),
                         PopupMenuItem(
                            onTap: (){
                              setState(() {
                                _getContactsByAlp("DESC");
                              });
                            },
                            child:const Text("Z-A")),
                      ],
                    )),
                    PopupMenuItem(
                      child: const Text(
                        "Delete all",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        LocalDatabase.deleteContacts();
                        setState(() {});
                      },
                    )
                  ])
        ],
      ),
      body: contacts.isNotEmpty ?  ListView(
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
                      )));
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
      )
          : Center(child: SvgPicture.asset("assets/svg/box.svg")),
      // body: FutureBuilder<List<ContactModelSql>>(
      //   future: LocalDatabase.getAllContacts(),
      //   builder: (
      //     context,
      //     AsyncSnapshot<List<ContactModelSql>> rowData,
      //   ) {
      //     if (rowData.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else if (rowData.hasData) {
      //       List<ContactModelSql> contacts = rowData.data!;
      //       return contacts.isNotEmpty
      //           ? ListView(
      //               physics: const BouncingScrollPhysics(),
      //               children: List.generate(
      //                 contacts.length,
      //                 (index) => ListTile(
      //                   onTap: () {
      //                     Navigator.pushReplacement(
      //                         context,
      //                         MaterialPageRoute(
      //                             builder: (context) => SingleContactScreen(
      //                                   id: contacts[index].id!,
      //                                 )));
      //                   },
      //                   leading: SvgPicture.asset("assets/svg/account.svg"),
      //                   title: Row(
      //                     children: [
      //                       Text(
      //                         contacts[index].name,
      //                         style: const TextStyle(
      //                             fontSize: 16,
      //                             fontWeight: FontWeight.w500,
      //                             color: Colors.black),
      //                       ),
      //                       const SizedBox(
      //                         width: 5,
      //                       ),
      //                       Text(
      //                         contacts[index].surname,
      //                         style: const TextStyle(
      //                             fontSize: 16,
      //                             fontWeight: FontWeight.w500,
      //                             color: Colors.black),
      //                       ),
      //                     ],
      //                   ),
      //                   subtitle: Text(
      //                     "+998${contacts[index].phone[0]}${contacts[index].phone[1]} ${contacts[index].phone[2]}${contacts[index].phone[3]}${contacts[index].phone[4]} ${contacts[index].phone[5]}${contacts[index].phone[6]} ${contacts[index].phone[7]}${contacts[index].phone[8]}",
      //                     style: const TextStyle(
      //                         fontSize: 14,
      //                         fontWeight: FontWeight.w500,
      //                         color: Color(0xFF8B8B8B)),
      //                   ),
      //                   trailing: SvgPicture.asset("assets/svg/call.svg"),
      //                 ),
      //               ),
      //             )
      //           : Center(child: SvgPicture.asset('assets/svg/box.svg'));
      //     }
      //     return Center(child: Text(rowData.error.toString()));
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddContactScreen()));
        },
      ),
    );
  }
}
