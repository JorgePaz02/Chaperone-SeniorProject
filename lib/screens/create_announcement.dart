import 'package:flutter/material.dart';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateAnnouncementform();
  }
}

class CreateAnnouncementform extends State<CreateAnnouncement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
child: Column(          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[TextField(
  keyboardType: TextInputType.multiline,
  maxLines: 10,
)]      


                
          )
      )
    );
  }
}
