class SpaService {
  const SpaService({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.image,
    required this.rating,
    required this.isPopular,
    required this.tag,
    required this.benefits,
    required this.process,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final int price;
  final int durationMinutes;
  final String image;
  final double rating;
  final bool isPopular;
  final String tag;
  final List<String> benefits;
  final List<String> process;
}
