import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignmentSubmissionCard extends StatelessWidget {
  String name='';
  String enrollment='';
  String ?url='';
  String desc='';

  AssignmentSubmissionCard({required this.desc, this.url,required this.name,required this.enrollment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.blue,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      // margin:EdgeInsets.all(8),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(name),
                SizedBox(
                  height: 10,
                ),
                Text(enrollment),
                SizedBox(
                  height: 10,
                ),
                Text(desc),
                SizedBox(
                  height: 10,
                ),
                Linkify(
                  text: url!,
                  onOpen: _onOpen,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )),
    );


  }
  Future _onOpen(LinkableElement link) async {
    await launchUrl(Uri.parse(link.url));
  }
}
