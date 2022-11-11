import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/question_controller.dart';
import 'options.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    required Key key,
    // it means we have to pass this
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    const kSecondaryColor = Color(0xFF8B94BC);
    const kGreenColor = Color(0xFF6AC259);
    const kRedColor = Color(0xFFE92E30);
    const kGrayColor = Color(0xFFC1C1C1);
    const kBlackColor = Color(0xFF101010);
    const kPrimaryGradient = LinearGradient(
      colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    const double kDefaultPadding = 20.0;
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.question,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: kBlackColor),
          ),
          SizedBox(height: kDefaultPadding / 2),
          ...List.generate(
            question.options.length,
                (index) => Option(
              index: index,
              text: question.options[index],
              press: () => _controller.checkAns(question, index), key: null, 
            ),
          ),
        ],
      ),
    );
  }
}
