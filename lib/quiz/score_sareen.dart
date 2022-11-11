import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/question_controller.dart';


class ScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
         Image.network('https://images.pexels.com/photos/13435572/pexels-photo-13435572.jpeg?auto=compress&cs=tinysrgb&w=600&lazy=load'),

          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "Score",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    ?.copyWith(color: Colors.black),
              ),
              Spacer(),
              Text(
                "${_qnController.correctAns * 10}/${_qnController.questions.length * 10}",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(color: Colors.black),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }
}