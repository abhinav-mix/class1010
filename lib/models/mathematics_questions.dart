import 'question.dart';

final List<Question> mathematicsQuestions = [
  
  
  Question(
    question: "1. If f(x) = x³ - 6x² + 9x + 15, then f′(x) = 0 gives critical points at.\nयदि f(x) = x³ - 6x² + 9x + 15 है, तो f′(x) = 0 के लिए क्रिटिकल पॉइंट कौन से हैं?",
    options: ["x = 3", "x = 1 और x = 3", "x = 2 और x = 3", "x = 1 और x = 2"],
    correctAnswerIndex: 2
  ),
  Question(
    question: "2. If A = [2 1; 1 2], then det(A) equals.\nयदि A = [2 1; 1 2] है, तो det(A) = ?",
    options: ["3", "4", "2", "5"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "3. The value of ∫(cos²x) dx is.\n∫(cos²x) dx का मान क्या है?",
    options: ["(x/2) + (sin2x/4) + C", "(x/2) - (sin2x/4) + C", "(x/2) + C", "sinxcosx + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "4. If y = tan⁻¹(2x / (1 - x²)), then dy/dx = ?\nयदि y = tan⁻¹(2x / (1 - x²)) है, तो dy/dx = ?",
    options: ["2/(1+x²)", "2/(1−x²)", "1/(1+x²)", "2x/(1+x²)"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "5. The order of matrix A = [aᵢⱼ] where i = 1,2,3 and j = 1,2,3,4 is.\nमैट्रिक्स A = [aᵢⱼ] (i = 1,2,3 और j = 1,2,3,4) का ऑर्डर क्या है?",
    options: ["3×3", "4×3", "3×4", "4×4"],
    correctAnswerIndex: 2
  ),
  Question(
    question: "6. The value of (sin⁻¹x + cos⁻¹x) is.\n(sin⁻¹x + cos⁻¹x) का मान क्या है?",
    options: ["π/2", "π", "0", "π/4"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "7. If a = 2i + j − 3k and b = i − 2j + k, then a·b = ?\nयदि a = 2i + j − 3k और b = i − 2j + k हैं, तो a·b = ?",
    options: ["−3", "4", "1", "−2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "8. The direction cosines of x-axis are.\nx-अक्ष के दिशा कोसाइन क्या हैं?",
    options: ["(1,0,0)", "(0,1,0)", "(0,0,1)", "(1,1,1)"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "9. If A = [1 2; 3 4], then A⁻¹ = ?\nयदि A = [1 2; 3 4], तो A⁻¹ = ?",
    options: ["[−2 1; 1.5 −0.5]", "[2 −1; −1.5 0.5]", "[−2 1; 1 −0.5]", "[−2 1; 1.5 −0.5]"],
    correctAnswerIndex: 3
  ),
  Question(
    question: "10. The value of limit x→0 (sinx/x) = ?\nlim x→0 (sinx/x) का मान क्या है?",
    options: ["1", "0", "∞", "−1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "11. The slope of tangent to curve y = x² + 3x at x = 2 is.\ny = x² + 3x के ग्राफ पर x = 2 पर टैन्जेंट का ढलान क्या है?",
    options: ["7", "6", "5", "4"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "12. If A and B are independent events, then P(A ∩ B) = ?\nयदि A और B स्वतंत्र घटनाएँ हैं, तो P(A ∩ B) = ?",
    options: ["P(A) + P(B)", "P(A)P(B)", "P(A)/P(B)", "P(A)−P(B)"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "13. The value of ∫₀^π sinx dx = ?\n∫₀^π sinx dx का मान क्या है?",
    options: ["2", "0", "1", "−2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "14. The vector perpendicular to both i + 2j + 3k and 2i + j + k is.\ni + 2j + 3k और 2i + j + k दोनों के लम्बवत वेक्टर क्या है?",
    options: ["i−5j+3k", "i+j−5k", "i−3j+5k", "5i−3j+k"],
    correctAnswerIndex: 2
  ),
  Question(
    question: "15. If y = eˣtanx, then dy/dx = ?\nयदि y = eˣtanx है, तो dy/dx = ?",
    options: ["eˣtanx + eˣsec²x", "eˣtanx − eˣsec²x", "eˣ(sec²x − tanx)", "eˣ(sec²x + tanx)"],
    correctAnswerIndex: 3
  ),
  Question(
    question: "16. The sum of the roots of x² − 5x + 6 = 0 is.\nx² − 5x + 6 = 0 के मूलों का योग कितना है?",
    options: ["5", "6", "−5", "−6"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "17. The eccentricity of ellipse x²/9 + y²/16 = 1 is.\nअण्डाकार x²/9 + y²/16 = 1 की विकेन्द्रता (eccentricity) क्या है?",
    options: ["√7/4", "√7/3", "√7/5", "√7/2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "18. The equation of line passing through (1,2,3) and parallel to (2,−1,1) is.\n(1,2,3) से गुजरने वाली और (2,−1,1) के समानांतर रेखा का समीकरण क्या है?",
    options: ["r = (i + 2j + 3k) + t(2i − j + k)", "r = (i + j + k) + t(2i + j − k)", "r = (i − j + k) + t(2i + j + k)", "r = (i + 2j + 3k) + t(i − j + k)"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "19. If log₃x = 2, then x = ?\nयदि log₃x = 2 है, तो x = ?",
    options: ["9", "6", "3", "27"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "20. The range of f(x) = sinx + cosx is.\nf(x) = sinx + cosx का परास (range) क्या है?",
    options: ["[−√2, √2]", "[0,1]", "[−1,1]", "[−2,2]"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "21. Rank of A = [1 2 3; 0 1 4; 5 6 0] is.\nA = [1 2 3; 0 1 4; 5 6 0] का रैंक कितना है?",
    options: ["3", "2", "1", "0"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "22. If two lines are perpendicular, their direction ratios satisfy.\nयदि दो रेखाएँ लम्बवत हैं, तो उनके दिशा अनुपातों का संबंध क्या है?",
    options: ["a₁a₂ + b₁b₂ + c₁c₂ = 0", "a₁b₂ + b₁c₂ = 0", "a₁/a₂ = b₁/b₂", "a₁b₂ = b₁a₂"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "23. The maximum value of sinx + cosx is.\nsinx + cosx का अधिकतम मान क्या है?",
    options: ["√2", "1", "2", "½"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "24. The determinant of a skew-symmetric matrix of odd order is.\nविषम क्रम की स्क्यू-सममित मैट्रिक्स का डिटरमिनेंट क्या होता है?",
    options: ["0", "1", "−1", "2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "25. If tanA = 3/4, then sinA = ?\nयदि tanA = 3/4 है, तो sinA = ?",
    options: ["3/5", "4/5", "5/3", "3/2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "26. If A = [1 2; 3 6], then |A| = ?\nयदि A = [1 2; 3 6], तो |A| = ?",
    options: ["0", "3", "6", "12"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "27. The point (2,3) satisfies which of the following?\nबिन्दु (2,3) निम्न में से किस रेखा पर स्थित है?",
    options: ["y = x + 1", "y = 2x", "y = 3x", "y = x − 1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "28. A line of slope 3 passing through (0,2) has equation.\nढलान 3 वाली रेखा जो (0,2) से गुजरती है, उसका समीकरण क्या होगा?",
    options: ["y = 3x + 2", "y = 2x + 3", "y = 3x − 2", "y = x + 2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "29. Derivative of sin⁻¹x is.\nsin⁻¹x का अवकलज क्या है?",
    options: ["1/√(1−x²)", "−1/√(1−x²)", "x/√(1−x²)", "√(1−x²)"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "30. If P(A)=½, P(B)=⅓, P(A∩B)=¼, then P(A∪B)= ?\nयदि P(A)=½, P(B)=⅓ और P(A∩B)=¼ है, तो P(A∪B)= ?",
    options: ["7/12", "1/2", "5/6", "2/3"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "31. The slope of the line perpendicular to y = 3x + 2 is.\ny = 3x + 2 के लम्बवत रेखा का ढलान क्या होगा?",
    options: ["−1/3", "3", "1/3", "−3"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "32. The general solution of sinx = 0 is.\nsinx = 0 का सामान्य हल क्या है?",
    options: ["x = nπ", "x = 2nπ", "x = (2n+1)π/2", "x = nπ/2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "33. Sum of coefficients in (x + y)ⁿ is.\n(x + y)ⁿ के गुणांकों का योग कितना है?",
    options: ["2ⁿ", "n", "n²", "n!"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "34. Centroid of triangle (1,2), (3,4), (5,0) is.\nत्रिभुज (1,2), (3,4), (5,0) का केन्द्रक क्या है?",
    options: ["(3,2)", "(2,3)", "(3,3)", "(2,2)"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "35. Projection of (2i + 3j) on (i + j) is.\n(2i + 3j) का (i + j) पर प्रक्षेप क्या है?",
    options: ["(5/√2)", "√2", "2√2", "1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "36. Solution of dy/dx = y is.\ndy/dx = y का हल क्या है?",
    options: ["y = Ceˣ", "y = eˣ + C", "y = e⁻ˣ", "y = x + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "37. Value of ∫ e²ˣ dx is.\n∫ e²ˣ dx का मान क्या है?",
    options: ["(e²ˣ)/2 + C", "2e²ˣ + C", "e²ˣ + C", "(eˣ)² + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "38. Slope of tangent to y = ln(x) at x = 1 is.\ny = ln(x) पर x = 1 पर टैन्जेंट का ढलान क्या है?",
    options: ["1", "0", "−1", "2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "39. If P(A)=0.6, P(B)=0.5 and A,B independent, then P(A∩B)= ?\nयदि P(A)=0.6, P(B)=0.5 और A,B स्वतंत्र हैं, तो P(A∩B)= ?",
    options: ["0.3", "0.1", "0.25", "0.5"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "40. Direction ratios of line perpendicular to plane x + 2y + 3z = 5 are.\nसमतल x + 2y + 3z = 5 के लम्बवत रेखा के दिशा अनुपात क्या हैं?",
    options: ["(1,2,3)", "(−1,−2,−3)", "(2,1,3)", "(3,2,1)"],
    correctAnswerIndex: 0
  ),
  Question( 
    question: "1. यदि f(x) = x³ - 3x² + 2x है, तो f’(x) क्या होगा? / If f(x) = x³ - 3x² + 2x, then what is f’(x)?",
    options: ["3x² - 6x + 2", "3x² + 2x - 3", "x² - 3x + 2", "3x - 6x² + 2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "2. ∫x·eˣ dx का मान क्या है? / What is the value of ∫x·eˣ dx?",
    options: ["x·eˣ - eˣ + C", "x·eˣ + eˣ + C", "eˣ - x + C", "x²·eˣ + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "3. lim (x→0) (sinx / x) का मान क्या है? / What is the value of lim (x→0) (sinx / x)?",
    options: ["0", "1", "∞", "Does not exist"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "4. यदि A = [2 3; 1 4] हो, तो det(A) का मान क्या है? / If A = [2 3; 1 4], what is det(A)?",
    options: ["5", "8", "2", "7"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "5. (a+b)³ का विस्तार क्या है? / What is the expansion of (a+b)³?",
    options: ["a³ + b³ + 3ab(a+b)", "a³ + 3a²b + 3ab² + b³", "a³ + b³ + 6ab", "a² + b² + 3ab"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "6. यदि tanθ = 3/4 हो, तो sinθ क्या होगा? / If tanθ = 3/4, then sinθ = ?",
    options: ["3/5", "4/5", "5/3", "3/4"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "7. sin²θ + cos²θ का मान क्या होता है? / What is the value of sin²θ + cos²θ?",
    options: ["1", "0", "2", "Depends on θ"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "8. यदि A और B दो घटनाएँ स्वतंत्र हैं, तो P(A∩B) = ? / If A and B are independent, then P(A∩B) = ?",
    options: ["P(A)+P(B)", "P(A)×P(B)", "P(A)/P(B)", "P(A)-P(B)"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "9. यदि f(x)=logx, तो f’(x) = ? / If f(x)=logx, then f’(x) = ?",
    options: ["1/x", "x", "eˣ", "lnx"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "10. ∫sec²x dx का मान क्या है? / What is ∫sec²x dx?",
    options: ["tanx + C", "secx + C", "cosx + C", "sinx + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "11. (1+i)⁴ का मान क्या है? / What is (1+i)⁴?",
    options: ["-4", "4", "2", "0"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "12. यदि A एक 3×3 मैट्रिक्स है, तो det(Aᵗ) = ? / For a 3×3 matrix A, det(Aᵗ) = ?",
    options: ["det(A)", "-det(A)", "0", "1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "13. यदि y = eˣ, तो d²y/dx² = ? / If y = eˣ, then d²y/dx² = ?",
    options: ["eˣ", "x·eˣ", "2eˣ", "0"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "14. ∫1/(1+x²) dx = ?",
    options: ["tan⁻¹x + C", "sin⁻¹x + C", "cos⁻¹x + C", "x/(1+x²) + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "15. (x² - 4) का कारक रूप क्या है? / Factorize (x² - 4).",
    options: ["(x-2)(x+2)", "(x-4)(x+4)", "(x-2)²", "(x+4)²"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "16. ∑₁ⁿ k = ? / Sum of first n natural numbers?",
    options: ["n(n+1)/2", "n²", "n³/2", "2n"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "17. Mean of first 10 even numbers?",
    options: ["11", "10", "9", "12"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "18. यदि cosA = 4/5, तो sinA = ?",
    options: ["3/5", "5/4", "1/5", "4/3"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "19. (x - 1)² का विस्तार क्या है? / Expand (x - 1)².",
    options: ["x² - 2x + 1", "x² + 2x + 1", "x² - 1", "x² + 1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "20. यदि f(x) = x² + 3x + 2, तो f(2) = ?",
    options: ["12", "10", "8", "14"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "21. Probability always lies between?",
    options: ["0 and 1", "-1 and 1", "1 and ∞", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "22. यदि tanA = 1, तो A = ?",
    options: ["45°", "60°", "30°", "90°"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "23. Matrix with same number of rows and columns is?",
    options: ["Square Matrix", "Rectangular", "Diagonal", "Null"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "24. यदि sinA = 0, तो A = ?",
    options: ["0°, 180°, 360°", "90°", "45°", "60°"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "25. यदि log₁₀100 = ?",
    options: ["2", "1", "0", "10"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "26. ∫dx/x = ?",
    options: ["log|x| + C", "1/x + C", "x²/2 + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "27. Derivative of cosx?",
    options: ["-sinx", "sinx", "cosx", "-cosx"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "28. ∫sinx dx = ?",
    options: ["-cosx + C", "cosx + C", "sinx + C", "tanx + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "29. Derivative of ln(x)?",
    options: ["1/x", "x", "eˣ", "0"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "30. logₐ(a) = ?",
    options: ["1", "0", "a", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "31. Determinant of identity matrix?",
    options: ["1", "0", "n", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "32. ∫0ⁿ x dx = ?",
    options: ["n²/2", "n", "n²", "n³/2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "33. Area under y = x² from 0 to 2?",
    options: ["8/3", "4/3", "2", "1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "34. Slope of line y = 3x + 2?",
    options: ["3", "2", "1", "0"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "35. Equation of x-axis?",
    options: ["y = 0", "x = 0", "y = x", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "36. Equation of y-axis?",
    options: ["x = 0", "y = 0", "x + y = 0", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "37. Slope of a line parallel to x-axis?",
    options: ["0", "1", "∞", "-1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "38. Slope of a line perpendicular to x-axis?",
    options: ["∞", "0", "-1", "1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "39. If a line has equation y = mx + c, slope = ?",
    options: ["m", "c", "x", "y"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "40. Distance between (0,0) and (3,4)?",
    options: ["5", "4", "3", "2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "1. यदि f(x) = sin⁻¹x हो, तो f’(x) क्या होगा? / If f(x) = sin⁻¹x, then f’(x) = ?",
    options: ["1/√(1−x²)", "−1/√(1−x²)", "x/√(1−x²)", "√(1−x²)"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "2. ∫e^(2x) dx = ?",
    options: ["(1/2)e^(2x) + C", "2e^(2x) + C", "e^(2x) + C", "x·e^(2x) + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "3. यदि f(x) = cos²x, तो f’(x) = ?",
    options: ["−2cosx·sinx", "2cosx·sinx", "sin2x", "cos2x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "4. lim (x→∞) (1 + 1/x)ˣ = ?",
    options: ["e", "0", "1", "∞"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "5. ∫tanx dx = ?",
    options: ["−ln|cosx| + C", "ln|cosx| + C", "−cosx + C", "sinx + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "6. यदि |x| = 5, तो x के संभव मान क्या होंगे? / If |x| = 5, possible x values?",
    options: ["5, −5", "0, 5", "Only 5", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "7. यदि A और B skew symmetric हैं, तो (A + B)’ = ?",
    options: ["−(A + B)", "A + B", "A − B", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "8. ∫secx dx = ?",
    options: ["ln|secx + tanx| + C", "tanx + C", "secx + C", "−ln|cosx| + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "9. यदि y = log₁₀x, तो dy/dx = ?",
    options: ["1/(xln10)", "xln10", "logₑx", "1/x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "10. sin(90° − θ) = ?",
    options: ["cosθ", "sinθ", "tanθ", "cotθ"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "11. यदि tanA = 1/√3, तो A = ?",
    options: ["30°", "45°", "60°", "90°"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "12. ∫x³ dx = ?",
    options: ["x⁴/4 + C", "4x³ + C", "3x² + C", "x³ + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "13. यदि determinant का मान 0 है, तो matrix कैसी होगी? / If determinant = 0, then matrix is?",
    options: ["Singular", "Non-Singular", "Identity", "Square"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "14. log(ab) = ?",
    options: ["log a + log b", "log a − log b", "log a × log b", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "15. (sinx)’ = ?",
    options: ["cosx", "−cosx", "sinx", "−sinx"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "16. (cosx)’ = ?",
    options: ["−sinx", "sinx", "cosx", "−cosx"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "17. ∫cosx dx = ?",
    options: ["sinx + C", "−sinx + C", "cosx + C", "tanx + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "18. Derivative of tanx?",
    options: ["sec²x", "−sec²x", "cos²x", "sin²x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "19. यदि sinθ = 3/5, तो cosθ = ?",
    options: ["4/5", "5/3", "2/5", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "20. Integration of 1/x² dx?",
    options: ["−1/x + C", "1/x + C", "logx + C", "x + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "21. ∫(x² + 3x + 2) dx = ?",
    options: ["x³/3 + (3x²)/2 + 2x + C", "x³ + 3x² + 2x + C", "x³/2 + 2x + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "22. e⁰ का मान क्या है? / What is e⁰?",
    options: ["1", "0", "e", "∞"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "23. log₁₀10 = ?",
    options: ["1", "0", "10", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "24. ∫dx = ?",
    options: ["x + C", "1/x + C", "logx + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "25. यदि tanA = sinA/cosA, तो cotA = ?",
    options: ["cosA/sinA", "sinA/cosA", "1/sinA", "1/cosA"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "26. lim (x→0) (1−cosx)/x² = ?",
    options: ["1/2", "0", "∞", "1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "27. If f(x) = |x|, then f’(x) at x = 0?",
    options: ["Not defined", "0", "1", "−1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "28. Slope of tangent to y = x² at x = 2?",
    options: ["4", "2", "8", "1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "29. Area under y = 2x from x = 0 to 3?",
    options: ["9", "6", "3", "12"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "30. ∫cos2x dx = ?",
    options: ["(1/2)sin2x + C", "2sinx + C", "sin2x + C", "(1/2)cosx + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "31. ∫0¹ x² dx = ?",
    options: ["1/3", "1/2", "1", "2/3"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "32. If y = 3x² + 2x, find dy/dx.",
    options: ["6x + 2", "3x + 2", "2x + 3", "6x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "33. If f(x) = sin2x, f’(x) = ?",
    options: ["2cos2x", "cos2x", "sin2x", "−2sin2x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "34. ∫x·cosx dx = ?",
    options: ["x·sinx + cosx + C", "x·sinx − cosx + C", "sinx + C", "−sinx + C"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "35. If aₙ = 2n + 1, then a₅ = ?",
    options: ["11", "9", "10", "12"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "36. nth term of arithmetic progression?",
    options: ["a + (n−1)d", "a + nd", "nd + a", "a + n/d"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "37. Sum of first n odd numbers?",
    options: ["n²", "2n", "n(n+1)", "n³"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "38. If a = 2, d = 3, n = 4, find nth term.",
    options: ["11", "10", "12", "14"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "39. If sinA = 0, A = ?",
    options: ["0°, 180°, 360°", "90°", "45°", "30°"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "40. ∫x²·eˣ dx = ?",
    options: ["(x²−2x+2)eˣ + C", "x²eˣ + C", "x³eˣ + C", "2x·eˣ + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "1. If y = e^(x²), then dy/dx = ? / यदि y = e^(x²) हो तो dy/dx क्या होगा?",
    options: ["2x·e^(x²)", "x·e^(x²)", "e^(x²)", "2e^x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "2. ∫x·e^x dx = ?",
    options: ["(x−1)e^x + C", "x·e^x + C", "(x+1)e^x + C", "e^x + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "3. d/dx (tan⁻¹x) = ?",
    options: ["1/(1+x²)", "−1/(1+x²)", "x/(1+x²)", "1/x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "4. If y = logₑ(sin x), find dy/dx.",
    options: ["cotx", "tanx", "1/sinx", "−cotx"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "5. ∫(1 + x²)/(1 − x²) dx = ?",
    options: ["x + tanh⁻¹x + C", "x − tan⁻¹x + C", "tan⁻¹x + C", "None"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "6. lim (x→0) (sin3x)/(x) = ?",
    options: ["3", "1", "0", "∞"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "7. ∫(cosx)/(1+sinx) dx = ?",
    options: ["log|1+sinx| + C", "tanx + C", "sinx + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "8. If matrix A = [[1,2],[3,4]], find det(A).",
    options: ["−2", "2", "10", "−10"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "9. For matrix A = [[2,0],[0,2]], A⁻¹ = ?",
    options: ["(1/2)I", "2I", "I", "−I"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "10. If A = [[1,0],[0,1]], then A² = ?",
    options: ["I", "0", "2I", "A"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "11. Derivative of x^x = ?",
    options: ["x^x(1 + ln x)", "x^(x−1)", "x^x(ln x)", "lnx + 1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "12. If y = sin⁻¹(2x√(1−x²)), then dy/dx = ?",
    options: ["2cos(2sin⁻¹x)", "2√(1−4x²)", "4(1−2x²)", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "13. ∫dx/(1+x²) = ?",
    options: ["tan⁻¹x + C", "cot⁻¹x + C", "x/(1+x²)", "log(1+x²) + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "14. ∫dx/√(1−x²) = ?",
    options: ["sin⁻¹x + C", "cos⁻¹x + C", "tan⁻¹x + C", "sec⁻¹x + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "15. If y = tanx, then d²y/dx² = ?",
    options: ["2tanx·sec²x", "sec⁴x", "tan²x", "2sec²x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "16. ∫(x³ + 2x² + 3) dx = ?",
    options: ["x⁴/4 + (2x³)/3 + 3x + C", "x⁴ + 2x³ + 3x + C", "x³ + x² + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "17. If a vector A = 2i + 3j + 4k, then |A| = ?",
    options: ["√29", "9", "7", "√14"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "18. If A ⊥ B, then A·B = ?",
    options: ["0", "1", "AB", "A×B"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "19. Derivative of secx?",
    options: ["secx·tanx", "tanx·cosx", "sec²x", "cosx"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "20. ∫sin²x dx = ?",
    options: ["x/2 − (sin2x)/4 + C", "sinx + C", "x − sinx + C", "x/2 + (sin2x)/4 + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "21. ∫x·logx dx = ?",
    options: ["(x²/2)(logx − 1/2) + C", "x²·logx + C", "x²/2 + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "22. If f(x) = e^(sinx), then f’(x) = ?",
    options: ["e^(sinx)·cosx", "e^(cosx)", "cosx + sinx", "e^(sinx)·sinx"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "23. ∫x²·sinx dx = ?",
    options: ["2sinx − x²cosx + 2xcosx − 2sinx + C", "x²sinx − 2xcosx + 2sinx + C", "x²cosx + C", "None"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "24. ∫tan²x dx = ?",
    options: ["tanx − x + C", "tanx + x + C", "x − tanx + C", "sec²x + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "25. If A = i + j + k and B = 2i + 3j + 4k, find A·B.",
    options: ["9", "8", "7", "10"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "26. If A = 2i + 3j and B = 3i − 2j, A×B = ?",
    options: ["−13k", "13k", "k", "0"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "27. If |A| = 3, |B| = 4, and angle between them = 90°, then |A×B| = ?",
    options: ["12", "7", "5", "1"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "28. If y = sinx·cosx, then dy/dx = ?",
    options: ["cos2x", "cos²x − sin²x", "1/2sin2x", "cos2x/2"],
    correctAnswerIndex: 1
  ),
  Question(
    question: "29. ∫x·e^(3x) dx = ?",
    options: ["(e^(3x)(x/3 − 1/9)) + C", "(e^(3x)(x/3 + 1/9)) + C", "x·e^(3x)/3 + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "30. If A = [[1,2,3],[0,1,4],[5,6,0]], rank(A) = ?",
    options: ["3", "2", "1", "0"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "31. ∫dx/(x² + a²) = ?",
    options: ["(1/a)tan⁻¹(x/a) + C", "tan⁻¹(x) + C", "x/(a²+x²) + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "32. If dy/dx = 3x² + 2x, then y = ?",
    options: ["x³ + x² + C", "x³ + x + C", "x³ + 2x² + C", "3x³ + 2x + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "33. If cosA = 4/5, then sinA = ?",
    options: ["3/5", "5/3", "1/5", "2/5"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "34. ∫(1/cos²x) dx = ?",
    options: ["tanx + C", "cotx + C", "secx + C", "x + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "35. Derivative of logₑx²?",
    options: ["2/x", "1/x", "logx", "2x"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "36. ∫(secx + tanx) dx = ?",
    options: ["log|secx + tanx| + C", "secx + tanx + C", "log|sinx| + C", "tanx + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "37. ∫e^(−x) dx = ?",
    options: ["−e^(−x) + C", "e^(−x) + C", "−e^x + C", "None"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "38. If f(x) = x³ − 3x² + 2x, then f’(x) = ?",
    options: ["3x² − 6x + 2", "3x² − 2x + 2", "2x² + 2x", "x² − 6x + 2"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "39. ∫x/(x² + 4) dx = ?",
    options: ["(1/2)log(x² + 4) + C", "log(x + 2) + C", "tan⁻¹x + C", "x²/4 + C"],
    correctAnswerIndex: 0
  ),
  Question(
    question: "40. ∫e^(2x)·sinx dx = ?",
    options: ["(e^(2x)(2sinx − cosx))/5 + C", "(e^(2x)(cosx + 2sinx))/5 + C", "(e^(2x)(sinx − 2cosx))/5 + C", "None"],
    correctAnswerIndex: 0
  ),
  
];