import 'package:contact_application/ui/add_contact/add_contact_screen.dart';
import 'package:contact_application/ui/single_contact/single_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/db/local_database.dart';
import '../../model/contact_model.dart';
import '../widget/contact_search_view.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<ContactModelSql> contacts = [];


  String searchText = "";

  int selectedMenu = 1;
  List<ContactModelSql> allContacts = [];


  _updateContacts() async {
    contacts = await LocalDatabase.getAllContacts();
    allContacts = await LocalDatabase.getAllContacts();
    setState(() {});
  }

  _getContactsByAlp(String order) async {
    contacts = await LocalDatabase.getContactsByAlphabet(order);
    setState(() {});
  }
  _getContactsByQuery(String query) async {
    contacts = await LocalDatabase.getContactsByQuery(query);
    setState(() {});
  }

  myFunc(){
    print("Yangulandi");
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          "Contacts",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                searchText = await showSearch(
                  context: context,
                  delegate: ContactSearchView(
                    contacts,
                    suggestionList: allContacts.map((e) => e.name).toList(),
                  ),
                );
                if (searchText.isNotEmpty) _getContactsByQuery(searchText);
                print("RESULT:$searchText");
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              )),
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (int item) {
              setState(() {
                selectedMenu = item;
              });
              if (selectedMenu == 1) {
              } else {
                _getContactsByAlp(selectedMenu == 2 ? "ASC" : "DESC");
              }
            },
// offset: Offset(-50, 0),
            position: PopupMenuPosition.values.last,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 1,
                child: ZoomTapAnimation(child: Text('Delete all'),onTap: (){showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete everything?'),
                      content: const Text(
                          'Are you sure you want to remove everything'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No')),
                        TextButton(
                            onPressed: () {
                              LocalDatabase.deleteContacts();
                              setState(() {});
                              _updateContacts();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.red),
                            )),
                      ],
                    ));},),

              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Sort by A-Z'),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: Text('Sort by Z-A'),
              ),
            ],
          ),
        ],
      ),
      body: contacts.isNotEmpty
          ? ListView(
        physics: const BouncingScrollPhysics(),
        children: List.generate(
          contacts.length,
              (index) => ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleContactScreen(
                        listening: (){
                          setState(() {

                          });
                          _updateContacts();
                        },
                        id: contacts[index].id!,
                      )));
            },
            leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.withOpacity(0.2),
                ),
                child: Image.asset(contacts[index].photo,width: 50,height: 50,)),
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
              "+998 ${contacts[index].phone[0]}${contacts[index].phone[1]} ${contacts[index].phone[2]}${contacts[index].phone[3]}${contacts[index].phone[4]} ${contacts[index].phone[5]}${contacts[index].phone[6]} ${contacts[index].phone[7]}${contacts[index].phone[8]}",
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF8B8B8B)),
            ),
            trailing: ZoomTapAnimation(
                onTap: ()async{
                  await launchUrl(Uri.parse("tel:+998${contacts[index].phone}"));
                },
                child: SvgPicture.asset("assets/svg/call.svg")),
          ),
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: SvgPicture.asset("assets/svg/box.svg")),
              Text('You have no contacts yet',style: TextStyle(fontSize: 16,color: Colors.black.withOpacity(0.4),fontWeight: FontWeight.w500),)
            ],
          ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  AddContactScreen(listening: (){
                    setState(() {

                    });
                    myFunc();
                    _updateContacts();},)));
        },
      ),
    );
  }
}




