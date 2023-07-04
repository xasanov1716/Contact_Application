import 'package:contact_application/data/db/local_database.dart';
import 'package:contact_application/ui/contact_screen/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../model/contact_model.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key}) : super(key: key);

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController  = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.999),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactScreen()));
        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
        title: const Text("Add",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
        actions: [
          IconButton(onPressed: (){
            if(phoneController.text.length==9){
              LocalDatabase.insertContact(
                ContactModelSql(
                  phone: phoneController.text,
                  name: nameController.text,
                  surname: surnameController.text,
                ),
              );
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactScreen()));
            }

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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
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
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
              ],
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
