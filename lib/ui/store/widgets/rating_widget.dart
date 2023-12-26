import 'package:flutter/material.dart';

import '../../../constants/styles.dart';
import '../../../widgets/my_label_widget.dart';
import 'app_rating_widget.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final double starSize;
  final TextStyle? textStyle;
  final bool? hideRating;

  const RatingWidget({
    Key? key,
    required this.rating,
    required this.starSize,
    this.textStyle,
    this.hideRating
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StarRating(
          starSize: starSize,
          rating: rating,
          onRatingChanged: (rating) {},
        ),
        Padding(padding: EdgeInsets.only(left: 10),),
        hideRating == true ? Container() : MyLabelWidget(text: rating.toString(), style: textStyle ?? AppStyles.textStyle14Regular)
      ],
    );
  }
}
