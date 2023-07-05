import 'package:contact_application/data/db/local_database.dart';
import 'package:contact_application/ui/contact_screen/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../model/contact_model.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({Key? key, required this.listening}) : super(key: key);

  final VoidCallback listening;

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) ### - ## - ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);


  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController  = TextEditingController();


  int selectImage = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(0.999),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const ContactScreen()));
        }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
        title: const Text("Add",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
        actions: [
          IconButton(onPressed: (){
            print(phoneController.text);
            if(phoneController.text.length==18){
              String phone = "${phoneController.text[1]}${phoneController.text[2]}${phoneController.text[5]}${phoneController.text[6]}${phoneController.text[7]}${phoneController.text[11]}${phoneController.text[12]}${phoneController.text[16]}${phoneController.text[17]}";
              LocalDatabase.insertContact(
                ContactModelSql(
                  photo: imagePath[selectImage],
                  phone: phone,
                  name: nameController.text,
                  surname: surnameController.text,
                ),
              );
              print(imagePath[selectImage]);
              print(phone);
              widget.listening.call();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Contact successfully added!!! "),
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ContactScreen()));
            }
              else{
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Telefon nomer to'liq emas!"),
                ),
              );
            }
          }, icon:const Icon(Icons.done,color: Colors.black,)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
             child: const Text("Name",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),),
           ),
            const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            child: TextField(
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
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            child: const Text("Surname",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),),
          ),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            child: TextField(
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
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            child: const Text("Phone number",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black),),
          ),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
            child: TextField(
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
                        Text("+998",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0xFF9E9E9E)),),
                      ],
                    ),
                  ),
                )
              ),
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            height: 100,
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                ...List.generate(imagePath.length, (index) => ZoomTapAnimation(
                  onTap: (){
                    setState(() {
                      selectImage = index;
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: Center(child: Image.asset(imagePath[index],width: 32,height: 32,),),
                      ),
                      selectImage==index ? Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Icon(Icons.done,size: 50,color: Colors.red,)) : SizedBox(),

                    ],
                  )
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}


List<String> imagePath = [
  "assets/images/rasm1.png",
  "assets/images/rasm2.png",
  "assets/images/rasm3.png",
  "assets/images/rasm4.png",
  "assets/images/rasm5.png",
  "assets/images/rasm6.png",
  "assets/images/rasm7.png",
  "assets/images/rasm8.png",
];