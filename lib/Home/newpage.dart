import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Blog {
  final String title;
  final String slug;
  final String content;
  final String imageUrl;
  final String publishedAt;

  Blog({
    required this.title,
    required this.slug,
    required this.content,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['featured_image']['file_path'] ?? '',
      publishedAt: json['published_on'] ?? '',
    );
  }
}

class NewPage extends StatefulWidget {
  final String slug;

  const NewPage({super.key, required this.slug});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  late Blog detailedBlog;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBlogDetails();
  }

  Future<void> fetchBlogDetails() async {
    final response = await http.get(
      Uri.parse('https://dashboard.cptguide.org/api/blogs/${widget.slug}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        detailedBlog = Blog.fromJson(jsonDecode(response.body)['data']);
        isLoading = false;
      });
    } else {
      print(
          'Failed to fetch blog details. Status code: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          detailedBlog.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    child: Image.network(
                      detailedBlog.imageUrl.isNotEmpty
                          ? detailedBlog.imageUrl
                          : 'assets/img/new.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/img/new.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 2,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detailedBlog.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Published on: ${detailedBlog.publishedAt}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          detailedBlog.content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: Image.asset(
          'assets/img/icon.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
