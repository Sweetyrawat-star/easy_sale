import 'package:boilerplate/constants/assets.dart';
import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/widgets/app_simple_input_widget.dart';
import 'package:boilerplate/widgets/flash_message_widget.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/simple_app_bar_widget.dart';
import 'package:boilerplate/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import '../../di/components/service_locator.dart';
import '../../models/rating/rating.dart';
import '../../models/store/store.dart';
import '../../widgets/common_dialog_widget.dart';
import '../store/widgets/app_rating_widget.dart';

class ReviewAndCommentScreen extends StatefulWidget {
  final Store store;

  const ReviewAndCommentScreen({
    required this.store,
  });
  @override
  State<StatefulWidget> createState() => _ReviewAndCommentScreenState();
}

class _ReviewAndCommentScreenState extends State<ReviewAndCommentScreen> {
  final Repository _repository = getIt<Repository>();
  TextEditingController _commentController = TextEditingController();
  double rating = 5;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: SimpleAppBar(title: widget.store.name,),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyLabelWidget(text: "Review & Comment", style: AppStyles.textStyle24Medium),
              SizedBox(height: 30,),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: _startMotion(),
                  ),
                  Image.asset(Assets.lineVerticalIcon, height: 37,),
                  SizedBox(width: 18,),
                  StarRating(
                    starSize: 36,
                    rating: rating,
                    onRatingChanged: (rating) {
                      setState(() => this.rating = rating);
                      print(rating);
                    },
                  )
                ],
              ),
              SizedBox(height: 30,),
              AppSimpleInputWidget(
                "Write your comment",
                textController: _commentController,
                maxLines: 5,
                height: 150,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: PrimaryButtonWidget(
            buttonWidth: MediaQuery.of(context).size.width - 40,
            buttonText: "Submit",
            onPressed: () {
              if (_commentController.text.isEmpty) {
                FlashMessageWidget.flashError(context, "Pls input your comment!");
              } else {
                _repository.createRating(Rating(
                    comment: _commentController.text,
                    star: this.rating.round() ,
                    storeId: widget.store.id
                )).then((data) {
                  CommonDialogWidget.success(
                      context,
                      this.rating > 4 ? "Very glad to know you are satisfied":
                      (this.rating < 3 ? "I'm very sorry that you're not satisfied":"Thank you for your review!"),
                          (p0) => {
                        Navigator.of(context).pop(),
                        Navigator.of(context).pop(true),
                      });
                }).catchError((err) {
                  FlashMessageWidget.flashError(context, err.toString());
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _startMotion() {
    var img = Assets.starSmileIcon;
    var motionText = "Satisfied";
    if (this.rating < 3) {
      img = Assets.starSadIcon;
      motionText = "Not satisfied";
    }
    else if (this.rating < 5) {
      img = Assets.starNormalIcon;
      motionText = "Normal";
    }
    return Container(
      width: 115,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(img, height: 55,),
          SizedBox(height: 7,),
          MyLabelWidget(text: motionText, style: AppStyles.textStyle14Regular)
        ],
      ),
    );
  }
}
