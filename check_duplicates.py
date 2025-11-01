import re
import os

def check_duplicates_in_file(filepath):
    """Check for duplicate questions in a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Extract all questions using regex
        questions = re.findall(r'question:\s*[\'\"](.*?)[\'\"]', content)
        
        # Find duplicates
        seen = {}
        duplicates = []
        
        for i, q in enumerate(questions, 1):
            if q in seen:
                duplicates.append((q, seen[q], i))
            else:
                seen[q] = i
        
        return duplicates, len(questions)
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return [], 0

def check_all_subjects():
    """Check for duplicates across all subject files"""
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
    
    all_questions = {}
    duplicates = []
    
    for filename in subject_files:
        filepath = os.path.join(models_dir, filename)
        if os.path.exists(filepath):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Extract all questions using regex
                questions = re.findall(r'question:\s*[\'\"](.*?)[\'\"]', content)
                
                for i, q in enumerate(questions, 1):
                    if q in all_questions:
                        # Duplicate found across subjects
                        orig_file, orig_index = all_questions[q]
                        duplicates.append((q, orig_file, orig_index, filename, i))
                    else:
                        all_questions[q] = (filename, i)
            except Exception as e:
                print(f"Error reading {filepath}: {e}")
    
    return duplicates

# Check individual files
print("=== Checking for duplicates within each subject file ===")
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

total_questions = 0
for filename in subject_files:
    filepath = os.path.join(models_dir, filename)
    if os.path.exists(filepath):
        duplicates, count = check_duplicates_in_file(filepath)
        total_questions += count
        print(f"\n{filename}:")
        print(f"  Total questions: {count}")
        if duplicates:
            print(f"  Found {len(duplicates)} duplicate questions:")
            for q, first, second in duplicates:
                print(f"    '{q[:50]}...' appears at positions {first} and {second}")
        else:
            print("  No duplicates found")

print(f"\n=== Total questions across all subjects: {total_questions} ===")

# Check for duplicates across subjects
print("\n=== Checking for duplicates across different subjects ===")
cross_subject_duplicates = check_all_subjects()
if cross_subject_duplicates:
    print(f"Found {len(cross_subject_duplicates)} questions that appear in multiple subjects:")
    for q, orig_file, orig_index, dup_file, dup_index in cross_subject_duplicates:
        print(f"  '{q[:50]}...' appears in:")
        print(f"    {orig_file} at position {orig_index}")
        print(f"    {dup_file} at position {dup_index}")
        print()
else:
    print("No cross-subject duplicates found")