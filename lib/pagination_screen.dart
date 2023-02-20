import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'pagination/pagination_list_view.dart';

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({Key? key}) : super(key: key);

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  late final Client _client;
  @override
  void initState() {
    super.initState();
    _client = Client();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination'),
        centerTitle: true,
      ),
      body: PaginationListView(
        itemBuilder: (context, index, data) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(data[index].id.toString()),
            ),
            title: Text(
              data[index].title.toString(),
              maxLines: 1,
            ),
            subtitle: Image.network(data[index].url.toString()),
          );
        },
        fetchData: (int currentPage) {
          log('call api - page $currentPage');
          return _fetchData(currentPage);
        },
      ),
    );
  }

  Future<List<Post>> _fetchData(int currentPage) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await _client.get(
        Uri.https(
          'jsonplaceholder.typicode.com',
          '/photos',
          {
            '_page': '$currentPage',
            '_limit': '10',
          },
        ),
      );
      if (response.statusCode == 200) {
        final dataList = json.decode(response.body) as List<dynamic>;
        final data = dataList.map((e) => Post.fromMap(e)).toList();
        return data;
      } else {
        return Future.error('Something went wrong!');
      }
    } catch (e) {
      return Future.error('Something went wrong!');
    }
  }
}

class Post {
  final int id;
  final String title;
  final String url;
  Post({
    required this.id,
    required this.title,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'url': url,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      title: map['title'] as String,
      url: map['url'] as String,
    );
  }
}
