class Blog {
  final int id;
  final String slug;
  final String title;
  final String shortDescription;
  final String publishedOn;
  final String content;
  final String imageUrl;
  final String featuredImageUrl;
  final String authorName;
  final String authorDesignation;
  final String authorImageUrl;

  Blog({
    required this.id,
    required this.slug,
    required this.title,
    required this.shortDescription,
    required this.publishedOn,
    required this.content,
    required this.imageUrl,
    required this.featuredImageUrl,
    required this.authorName,
    required this.authorDesignation,
    required this.authorImageUrl,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      shortDescription: json['short_description'],
      publishedOn: json['published_on'],
      content: json['content'],
      imageUrl: json['image_url'],
      featuredImageUrl: json['featured_image']['file_path'],
      authorName: json['published_by']['name'],
      authorDesignation: json['published_by']['designation'],
      authorImageUrl: json['published_by']['featured_image']['file_path'],
    );
  }
}
