import 'package:contact_application/data/db/local_database.dart';
import 'package:contact_application/ui/contact_screen/contact_screen.dart';
import 'package:contact_application/ui/single_contact/single_contact_screen.dart';
import 'package:flutter/material.dart';

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
  late ContactModelSql contactModelSql ;


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


    final TextEditingController nameController = TextEditingController(text: name);
    final TextEditingController surnameController = TextEditingController(text: surname);
    final TextEditingController phoneController  = TextEditingController(text: phone);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.999),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SingleContactScreen(id: widget.id)));
        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
        title: const Text("Add",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
        actions: [
          IconButton(onPressed: ()async {

            await LocalDatabase.updateContact(contactsModelSql: contactModelSql.copyWith(name: nameController.text,surname: surnameController.text,phone: phoneController.text));
            _updateContacts();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactScreen()));
          }, icon:const Icon(Icons.done,color: Colors.black,)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),),
            const SizedBox(height: 8,),
            TextField(
              keyboardType: TextInputType.text,
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter name",
                hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xFF9E9E9E)),
              ),
            ),
            const SizedBox(height: 20,),
            const Text("Surname",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),),
            const SizedBox(height: 8,),
            TextField(
              keyboardType: TextInputType.text,
              controller: surnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter surname",
                hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xFF9E9E9E)),
              ),
            ),
            const SizedBox(height: 20,),
            const Text("Phone number",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),),
            const SizedBox(height: 8,),
            TextField(
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
                          Text("+998",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xFF9E9E9E)),),
                        ],
                      ),
                    ),
                  )
              ),
            ),
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
