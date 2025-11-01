import re
import os

def find_cross_subject_duplicates():
    """Find questions that appear in multiple subject files"""
    models_dir = 'lib/models'
    subject_files = [
        'biology_questions.dart',
        'chemistry_questions.dart', 
        'english_questions.dart',
        'geography_questions.dart',
        'hindi_questions.dart',
        'history_questions.dart',
        'mathematics_questions.dart',
        'physics_questions.dart',
        'science_questions.dart',
        'social_science_questions.dart'
    ]
    
    # Dictionary to store all questions with their source file
    all_questions = {}
    
    # Process each subject file
    for filename in subject_files:
        filepath = os.path.join(models_dir, filename)
        if os.path.exists(filepath):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Extract all questions using regex
                questions = re.findall(r'question:\s*[\'\"](.*?)[\'\"]', content)
                
                for i, q in enumerate(questions, 1):
                    # Clean the question text for better matching
                    clean_q = q.strip().lower()
                    if clean_q in all_questions:
                        # Duplicate found across subjects
                        orig_file, orig_index = all_questions[clean_q]
                        print(f"Cross-subject duplicate found:")
                        print(f"  Question: '{q[:70]}...'")
                        print(f"  Appears in: {orig_file} (Q{orig_index}) and {filename} (Q{i})")
                        print()
                    else:
                        all_questions[clean_q] = (filename, i)
            except Exception as e:
                print(f"Error reading {filepath}: {e}")

def find_within_subject_duplicates():
    """Find duplicate questions within each subject file"""
    models_dir = 'lib/models'
    subject_files = [
        'biology_questions.dart',
        'chemistry_questions.dart', 
        'english_questions.dart',
        'geography_questions.dart',
        'hindi_questions.dart',
        'history_questions.dart',
        'mathematics_questions.dart',
        'physics_questions.dart',
        'science_questions.dart',
        'social_science_questions.dart'
    ]
    
    print("=== Checking for duplicates within each subject ===")
    
    for filename in subject_files:
        filepath = os.path.join(models_dir, filename)
        if os.path.exists(filepath):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Extract all questions using regex
                questions = re.findall(r'question:\s*[\'\"](.*?)[\'\"]', content)
                
                # Find duplicates within this file
                seen = {}
                duplicates = []
                
                for i, q in enumerate(questions, 1):
                    clean_q = q.strip().lower()
                    if clean_q in seen:
                        duplicates.append((q, seen[clean_q], i))
                    else:
                        seen[clean_q] = i
                
                if duplicates:
                    print(f"\n{filename}:")
                    for q, first, second in duplicates:
                        print(f"  Duplicate: '{q[:60]}...' (Q{first} and Q{second})")
                        
            except Exception as e:
                print(f"Error reading {filepath}: {e}")

# Run the analysis
print("ANALYSIS OF DUPLICATE QUESTIONS IN THE QUIZ APP")
print("=" * 50)
print()

find_within_subject_duplicates()
print()
print("=" * 50)
print()

find_cross_subject_duplicates()