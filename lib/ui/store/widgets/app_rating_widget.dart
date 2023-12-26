import 'package:flutter/material.dart';

import '../../../constants/assets.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final double starSize;

  bool isInteger(num value) => (value % 1) == 0;

  StarRating({
    Key? key,
    this.starCount = 5,
    this.rating = .0,
    required this.onRatingChanged,
    required this.starSize
  }): super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Widget icon;
    if (index >= rating) {
      icon = Image.asset(Assets.star2EmptyIcon, height: starSize,);
    }
    else {
      if (rating - index < 1)
        icon = Image.asset(Assets.starHalfIcon, height: starSize,);
      else
        icon = Image.asset(Assets.star2FullIcon, height: starSize,);
    }
    return InkWell(
      onTap: () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(children: new List.generate(starCount, (index) => buildStar(context, index)));
  }
}