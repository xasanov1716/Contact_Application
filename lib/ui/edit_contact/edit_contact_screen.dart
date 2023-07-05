import 'package:contact_application/data/db/local_database.dart';
import 'package:contact_application/ui/contact_screen/contact_screen.dart';
import 'package:contact_application/ui/single_contact/single_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../model/contact_model.dart';

class EditContactScreen extends StatefulWidget {
  const EditContactScreen({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<EditContactScreen> createState() => _EditContactScreen();
}

class _EditContactScreen extends State<EditContactScreen> {
  List<ContactModelSql> contacts = [];
  String name = "";
  String surname = "";
  String phone = "";
  late ContactModelSql contactModelSql;

  _updateContacts() async {
    contacts = await LocalDatabase.getAllContacts();
    contactModelSql = (await LocalDatabase.getSingleContact(widget.id))!;
    name = contactModelSql.name;
    surname = contactModelSql.surname;
    phone = contactModelSql.phone;
    setState(() {});
  }

  @override
  void initState() {
    _updateContacts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '(##) ### - ## - ##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

    final TextEditingController nameController =
        TextEditingController(text: name);
    final TextEditingController surnameController =
        TextEditingController(text: surname);
    final TextEditingController phoneController = TextEditingController(
        text:
            "(${phone[0]}${phone[1]}) ${phone[2]}${phone[3]}${phone[4]} - ${phone[5]}${phone[6]} - ${phone[7]}${phone[8]}");
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.999),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SingleContactScreen(id: widget.id,listening: (){_updateContacts();},)));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          "Edit",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () async {
               if(phoneController.text.length==18){
                 String name =
                     "${phoneController.text[1]}${phoneController.text[2]}${phoneController.text[5]}${phoneController.text[6]}${phoneController.text[7]}${phoneController.text[11]}${phoneController.text[12]}${phoneController.text[16]}${phoneController.text[17]}";

                 await LocalDatabase.updateContact(
                     contactsModelSql: contactModelSql.copyWith(
                         name: nameController.text,
                         surname: surnameController.text,
                         phone: name));
                 _updateContacts();
                 // ignore: use_build_context_synchronously
                 Navigator.pushReplacement(
                     context,
                     MaterialPageRoute(
                         builder: (context) => const ContactScreen()));
               }
               else{
                 ScaffoldMessenger.of(context).showSnackBar(
                   const SnackBar(
                     content: Text("Telefon nomer to'liq emas!"),
                   ),
                 );
               }
              },
              icon: const Icon(
                Icons.done,
                color: Colors.black,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Name",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter name",
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9E9E9E)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Surname",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              keyboardType: TextInputType.text,
              controller: surnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter surname",
                hintStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9E9E9E)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Phone number",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.phone,
              controller: phoneController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: SizedBox(
                    width: 66,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "+998",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF9E9E9E)),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
