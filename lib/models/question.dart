// Export all subject question files
export 'hindi_questions.dart';
export 'english_questions.dart';
export 'mathematics_questions.dart';
// Removed exports for deleted files: history_questions.dart and geography_questions.dart
export 'physics_questions.dart';
export 'chemistry_questions.dart';
export 'biology_questions.dart';

class Question {
  final String question;
  final String? questionHindi;
  final List<String> options;
  final List<String>? optionsHindi;
  final int correctAnswerIndex;

  Question({
    required this.question,
    this.questionHindi,
    required this.options,
    this.optionsHindi,
    required this.correctAnswerIndex,
  });
}

// Default quiz questions (combined from all subjects)
final List<Question> quizQuestions = [
  Question(
    question: 'हिंदी वर्णमाला में कितने स्वर होते हैं? / How many vowels are there in Hindi alphabet?',
    options: ['10', '11', '12', '13'],
    correctAnswerIndex: 1,
  ),
  Question(
    question: 'Which of the following is a noun? / निम्नलिखित में से कौन संज्ञा है?',
    options: ['Run / दौड़ना', 'Beautiful / सुंदर', 'Happiness / खुशी', 'Quickly / जल्दी'],
    correctAnswerIndex: 2,
  ),
  Question(
    question: 'What is the value of π (pi) approximately? / π (पाई) का अनुमानित मान क्या है?',
    options: ['3.14', '2.71', '1.61', '4.13'],
    correctAnswerIndex: 0,
  ),
  Question(
    question: 'What is the process by which plants make their food? / वह प्रक्रिया क्या है जिसके द्वारा पौधे अपना भोजन बनाते हैं?',
    options: ['Respiration / श्वसन', 'Photosynthesis / प्रकाश संश्लेषण', 'Transpiration / वाष्पोत्सर्जन', 'Digestion / पाचन'],
    correctAnswerIndex: 1,
  ),
  Question(
    question: 'Who was the first Prime Minister of India? / भारत के पहले प्रधान मंत्री कौन थे?',
    options: ['Mahatma Gandhi / महात्मा गांधी', 'Jawaharlal Nehru / जवाहरलाल नेहरू', 'Sardar Patel / सरदार पटेल', 'Dr. Rajendra Prasad / डॉ. राजेंद्र प्रसाद'],
    correctAnswerIndex: 1,
  ),
  Question(
    question: 'In which year did India gain independence? / भारत को स्वतंत्रता किस वर्ष मिली?',
    options: ['1942', '1945', '1947', '1950'],
    correctAnswerIndex: 2,
  ),
  Question(
    question: 'What is the capital of France? / फ्रांस की राजधानी क्या है?',
    options: ['London / लंदन', 'Berlin / बर्लिन', 'Paris / पेरिस', 'Rome / रोम'],
    correctAnswerIndex: 2,
  ),
  Question(
    question: 'What is Newton\'s First Law of Motion also called? / न्यूटन के गति के पहले नियम को और क्या कहा जाता है?',
    options: ['Law of Inertia / जड़त्व का नियम', 'Law of Acceleration / त्वरण का नियम', 'Law of Action-Reaction / क्रिया-प्रतिक्रिया का नियम', 'Law of Gravity / गुरुत्वाकर्षण का नियम'],
    correctAnswerIndex: 0,
  ),
  Question(
    question: 'What is the chemical formula for water? / पानी का रासायनिक सूत्र क्या है?',
    options: ['H2O', 'CO2', 'O2', 'H2SO4'],
    correctAnswerIndex: 0,
  ),
  Question(
    question: 'What is the powerhouse of the cell? / कोशिका का पावरहाउस कौन सा है?',
    options: [
      'Nucleus / नाभिक',
      'Ribosome / राइबोसोम',
      'Mitochondria / माइटोकॉन्ड्रिया',
      'Chloroplast / क्लोरोप्लास्ट'
    ],
    correctAnswerIndex: 2,
  ),
];