import 'dart:math';
import 'package:flutter/material.dart';
import 'package:technicalassessment/Class/Constant.dart';
import 'package:technicalassessment/Class/Contacts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:rolling_switch/rolling_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final ScrollController scrollController = ScrollController();
  bool value2 =
      false; //For toggle switch to different time format,FALSE=TIME AGO(default)
  bool Endlist = false; //For toggle the ending list notification
  late int _showallcardsetnum;
  List<Widget> ContactListData = [];

  void getContactData() {
    List<Contacts> responseList = User_Contacts;
    List<Widget> listContacts = [];

    responseList.forEach((post) {
      listContacts.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (value2 == true) ...[
                      Text(
                        post.user,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.phone.toString(),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      Text(
                        post.CheckIn, //Original time format
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ] else if (value2 == false) ...[
                      Text(
                        post.user,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.phone.toString(),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      Text(
                        timeago.format(DateTime.parse(post.CheckIn),
                            // Time ago format
                            locale: 'en'),
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          )));
    });
    setState(() {
      ContactListData = listContacts;
    });
  }

  void ContactByDate() {
    User_Contacts.sort(
        (a, b) => a.CheckIn.compareTo(b.CheckIn)); // sorting the list by date
  }



  @override
  void initState() {

    int halfshowedcard_current = (ContactListData.length/2).ceil(); // num of current showed list(half)
    super.initState();
    ContactByDate();
    getContactData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (halfshowedcard_current != ContactListData.length) {
          if (!Endlist) {
            _showallcardsetnum = ContactListData.length - halfshowedcard_current;
            halfshowedcard_current = halfshowedcard_current + _showallcardsetnum;
            setState(() {});
          }
        } else {
          if (scrollController.position.atEdge) {
            final BtmListReached = scrollController.position.pixels == 0;
            if (BtmListReached) {
            } else {
              Fluttertoast.showToast(
                  msg: "This is Center Short Toast",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          }
          Endlist = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 30,
          backgroundColor: Colors.white,
          title: const Text(
            "Contact List",
            style: TextStyle(color: Colors.black, fontSize: 28),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          actions: <Widget>[
            RollingSwitch.icon(
              height: 50,
              width: 140,
              onChanged: (bool value) {
                print("turned $value");
                setState(() {
                  value2 = value;
                  getContactData();
                });
              },
              rollingInfoRight: const RollingIconInfo(
                icon: Icons.alarm_add,
                text: Text('DateTime'),
              ),
              rollingInfoLeft: const RollingIconInfo(
                icon: Icons.alarm_off,
                backgroundColor: Colors.grey,
                text: Text('TimeAgo'),
              ),
            )
          ],
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              Expanded(
                  child: ListView.builder(
                      //int halfshowedcard_current = (ContactListData.length/2).ceil();
                      itemCount: (ContactListData.length / 2).ceil(),
                      //showed only half
                      itemBuilder: (context, index) {
                        //ContactListData.sort((a,b)=> a.CheckIn.compareTo(b.CheckIn)) ;

                        return ContactListData[index];
                      })),
            ],
          ),
        ),
      ),
    );
  }

}

