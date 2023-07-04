import 'package:contact_application/ui/edit_contact/edit_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../data/db/local_database.dart';
import '../../model/contact_model.dart';
import '../contact_screen/contact_screen.dart';

class SingleContactScreen extends StatefulWidget {
  const SingleContactScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<SingleContactScreen> createState() => _SingleContactScreenState();
}

class _SingleContactScreenState extends State<SingleContactScreen> {

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactScreen()));
        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.white,
        title:const Text("Contacts",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.search,color: Colors.black,),),
          IconButton(onPressed: (){}, icon:const Icon(Icons.more_vert,color: Colors.black,),),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 100,),
            Row(
              children: [
                const SizedBox(width: 130,),
                SvgPicture.asset("assets/svg/big_account.svg"),
                const Spacer(),
               Column(
                 children: [
                   const SizedBox(height: 50,),
                  Row(
                    children: [
                      ZoomTapAnimation(
                        onTap: (){
                          LocalDatabase.deleteContact(contactModelSql.id!);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactScreen()));
                        },
                          child: SvgPicture.asset("assets/svg/delete.svg")),
                      const SizedBox(width: 15,),
                      ZoomTapAnimation(
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> EditContactScreen(id: widget.id)));
                          },
                          child: SvgPicture.asset("assets/svg/edit.svg")),
                    ],
                  )
                 ],
               )
              ],
            ),
            const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
              const SizedBox(width: 10,),
              Text(surname,style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
            ],
          ),
            const SizedBox(height: 40,),
            Row(
              children: [
                Text("+998${phone[0]}${phone[1]} ${phone[2]}${phone[3]}${phone[4]} ${phone[5]}${phone[6]} ${phone[7]}${phone[8]}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),),
                const Spacer(),
                SvgPicture.asset("assets/svg/phone.svg"),
                const SizedBox(width: 15,),
                SvgPicture.asset("assets/svg/sms.svg"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
