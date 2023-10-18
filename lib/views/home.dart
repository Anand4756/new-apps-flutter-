import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:newsapp/views/news.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List list = [];
  List<Map<String, dynamic>> newsData = []; // Store the fetched news data
String category= 'general';

 _readdata() async {
  String data = await DefaultAssetBundle.of(context)
      .loadString("assets/categories.json");
  setState(() {
    list = json.decode(data);
  });
  print(list);
}

Future<void> fetchNews() async {
  const String apiKey = '';
    final String apiUrl = 'https://newsapi.org/v2/top-headlines?country=in&pageSize=100&category=$category&apiKey=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    // Successful response, parse the JSON data
    final Map<String, dynamic> newsData = json.decode(response.body);
    final List<dynamic> articles = newsData['articles'];
 setState(() {
      this.newsData = articles.cast<Map<String, dynamic>>();
    });

       for (final article in articles) {
      print('Title: ${article['title']}');
      print('Description: ${article['description']}');
    }

   
  } else {
    // Handle errors, e.g., show an error message
    print('Failed to fetch news: ${response.statusCode}');
  }
}
void changeCategory(String newcategory) {
    setState(() {
      category = newcategory;
    });
    print(category);
    fetchNews();
  }



  void initState() {
    super.initState();
        _readdata();
          fetchNews();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Real"),
            Text(
              "News 🔥",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: SizedBox(
                child: Text(
                  "Categories",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              height: 80,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  // return ElevatedButton(
                  //     onPressed: () {
                  //       changeCategory(list[index]['title']); // Change category when a button is pressed
                  //     },
                  //     child: Text(list[index]['title']),
                  //   );
                  
                

                  return Categorytile(
                    imageurl: list[index]['imageurl'],
                    categoryname: list[index]['title'],
                       onTap: () {
        changeCategory(list[index]['title']); // Change the category when a category tile is tapped
      },
                  );
                },

                // ListTile(title: Text(list[index]['title']));
                // children: [
                //   Categorytile(),
                //   Categorytile(),
                //   Categorytile(),
                // ],
              ),
            ),
         ListView.separated(
  itemCount: newsData.length,
  shrinkWrap: true,
  physics: const ClampingScrollPhysics(),
  itemBuilder: (BuildContext context, int index) {
    final article = newsData[index];
    return News(
      title: article['title'],
      description: article['description'],
      url: article['url'],
      urlToImage: article['urlToImage'],
      content: article['content'],
    );
  },
  separatorBuilder: (BuildContext context, int index) {
    return const Divider(
      color: Colors.grey, 
      thickness: 1, 
    );
  },
)

          ],
        )),
      ),
    );
  }
}

class Categorytile extends StatelessWidget {
  final imageurl, categoryname;
final VoidCallback onTap;
  const Categorytile({super.key, required this.imageurl, required this.categoryname,required this.onTap,
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, //
   child: Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 18.0),
      child: Stack(children: [
        ClipRRect(
      borderRadius: BorderRadius.circular(17),
      child: Image.network(imageurl, width: 90.0),
        ),
        Text(categoryname),
      ]),
    ));
  }
}
