import 'rating.dart';

class RatingList {
  final List<Rating> ratings;

  RatingList({
    required this.ratings,
  });

  factory RatingList.fromJson(List<dynamic> json) {
    List<Rating> ratings = <Rating>[];
    ratings = json.map((rating) => Rating.fromMap(rating)).toList();

    return RatingList(
      ratings: ratings,
    );
  }
}
