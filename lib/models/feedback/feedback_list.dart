import 'feedback.dart';

class FeedbackList {
  final List<Feedback>? feedbacks;

  FeedbackList({
    this.feedbacks,
  });

  factory FeedbackList.fromJson(List<dynamic> json) {
    List<Feedback> feedbacks = <Feedback>[];
    feedbacks = json.map((feedback) => Feedback.fromMap(feedback)).toList();

    return FeedbackList(
      feedbacks: feedbacks,
    );
  }
}
