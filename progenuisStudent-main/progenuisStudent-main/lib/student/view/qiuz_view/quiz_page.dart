import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswerIndex: json['correctAnswerIndex'] ?? 0,
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }
}

class QuizController extends GetxController {
  var currentQuestionIndex = 0.obs;
  var selectedAnswerIndex = (-1).obs;
  var score = 0.obs;
  var isQuizCompleted = false.obs;
  var quizQuestions = <QuizModel>[].obs;

  void loadQuiz(List<QuizModel> questions) {
    quizQuestions.value = questions;
    currentQuestionIndex.value = 0;
    selectedAnswerIndex.value = -1;
    score.value = 0;
    isQuizCompleted.value = false;
  }

  void selectAnswer(int index) {
    selectedAnswerIndex.value = index;
  }

  void nextQuestion() {
    if (selectedAnswerIndex.value == quizQuestions[currentQuestionIndex.value].correctAnswerIndex) {
      score.value++;
    }

    if (currentQuestionIndex.value < quizQuestions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswerIndex.value = -1;
    } else {
      isQuizCompleted.value = true;
    }
  }

  void restartQuiz() {
    currentQuestionIndex.value = 0;
    selectedAnswerIndex.value = -1;
    score.value = 0;
    isQuizCompleted.value = false;
  }
}

class QuizPage extends StatelessWidget {
  final QuizController controller = Get.put(QuizController());
  final String lessonId;

  QuizPage({required this.lessonId}) {
    // Sample quiz data - replace with API call
    controller.loadQuiz([
      QuizModel(
        id: '1',
        question: 'What is Flutter?',
        options: ['A framework', 'A language', 'A database', 'An IDE'],
        correctAnswerIndex: 0,
        explanation: 'Flutter is a UI framework developed by Google.',
      ),
      QuizModel(
        id: '2',
        question: 'Which language does Flutter use?',
        options: ['Java', 'Kotlin', 'Dart', 'Swift'],
        correctAnswerIndex: 2,
        explanation: 'Flutter uses Dart programming language.',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isQuizCompleted.value) {
          return _buildResultScreen();
        }
        return _buildQuizScreen();
      }),
    );
  }

  Widget _buildQuizScreen() {
    final question = controller.quizQuestions[controller.currentQuestionIndex.value];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (controller.currentQuestionIndex.value + 1) / controller.quizQuestions.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
          ),
          SizedBox(height: 20),
          
          // Question number
          Text(
            'Question ${controller.currentQuestionIndex.value + 1} of ${controller.quizQuestions.length}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          
          // Question text
          Text(
            question.question,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          
          // Options
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {
                return Obx(() => _buildOptionCard(index, question.options[index]));
              },
            ),
          ),
          
          // Next button
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.selectedAnswerIndex.value != -1
                  ? controller.nextQuestion
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                controller.currentQuestionIndex.value < controller.quizQuestions.length - 1
                    ? 'Next Question'
                    : 'Finish Quiz',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildOptionCard(int index, String option) {
    final isSelected = controller.selectedAnswerIndex.value == index;
    
    return GestureDetector(
      onTap: () => controller.selectAnswer(index),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.purple : Colors.grey[300],
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                option,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (controller.score.value / controller.quizQuestions.length * 100).toInt();
    final passed = percentage >= 60;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.cancel,
              size: 100,
              color: passed ? Colors.green : Colors.red,
            ),
            SizedBox(height: 24),
            Text(
              passed ? 'Congratulations!' : 'Keep Trying!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'You scored',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              '${controller.score.value}/${controller.quizQuestions.length}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: passed ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$percentage%',
              style: TextStyle(fontSize: 24, color: Colors.grey[700]),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.restartQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Retake Quiz',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.purple),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Back to Lesson',
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
