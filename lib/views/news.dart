import 'package:flutter/material.dart';

class News extends StatelessWidget {
    final  String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? content;
  const News({Key? key, required this.title, required this.description, this.url, required this.urlToImage, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
    Expanded(
        child: Padding(
    padding: const EdgeInsets.all(15.0), // Adjust
        child: Text(title,
        maxLines: 2, 
        style: TextStyle(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
))),
Container(
  margin: EdgeInsets.all(15.0),
  width: 40,
  child: urlToImage != null ? Image.network(urlToImage!) : const Text('error'), 
)
    // Container(
    //     margin: EdgeInsets.all(20.0),
    //     child: Icon(Icons.access_alarms_sharp)),
      ],
    );
  }
}
