import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'newpage.dart';

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
      content: json['short_description'] ?? '',
      imageUrl: json['featured_image']['file_path'] ?? '',
      publishedAt: json['published_on'] ?? '',
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Blog> blogs = [];
  int _selectedIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs() async {
    final response =
        await http.get(Uri.parse('https://dashboard.cptguide.org/api/blogs'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      setState(() {
        blogs = data.map((item) => Blog.fromJson(item)).toList();
        isLoading = false;
      });
    } else {
      print("Failed to fetch data. Status code: ${response.statusCode}");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget blogCard(Blog blog, BuildContext context, int index) {
    String fallbackImage;
    if (index % 3 == 0) {
      fallbackImage = 'assets/img/69c61abdc00223e6f2740ac799449e0895416c82.jpg';
    } else if (index % 3 == 1) {
      fallbackImage = 'assets/img/7fcfe2abdb2c76b6b9d1cef9a83e37fce052776f.jpg';
    } else {
      fallbackImage = 'assets/img/1279679f20420e71f53008269e726db07501f440.png';
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                blog.imageUrl.isNotEmpty ? blog.imageUrl : fallbackImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    fallbackImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  );
                },
              ),
            ),
            Positioned(
              left: 8.0,
              bottom: 8.0,
              right: 8.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    blog.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final featured = blogs.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Latest News',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: const [
                  Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blue,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (blogs.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: () {
                      if (blogs.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewPage(slug: blogs[0].slug),
                          ),
                        );
                      }
                    },
                    child: Image.network(
                      blogs.isNotEmpty && blogs[0].imageUrl.isNotEmpty
                          ? blogs[0].imageUrl
                          : 'https://your_default_image_url.com',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/img/home.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 300,
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: blogs
                        .asMap()
                        .map((index, blog) {
                          return MapEntry(
                            index,
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => NewPage(slug: blog.slug),
                                    ),
                                  );
                                },
                                child: blogCard(blog, context, index),
                              ),
                            ),
                          );
                        })
                        .values
                        .toList(),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 8, offset: Offset(0, -2)),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey[400],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
