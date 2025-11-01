import re
import os
import shutil

def create_duplicate_report():
    """Create a report of all duplicate questions without modifying files"""
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
    duplicates = []
    
    print("ANALYZING ALL SUBJECT FILES FOR DUPLICATES")
    print("=" * 50)
    
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
                        duplicates.append({
                            'question': q,
                            'original_file': orig_file,
                            'original_index': orig_index,
                            'duplicate_file': filename,
                            'duplicate_index': i
                        })
                    else:
                        all_questions[clean_q] = (filename, i)
            except Exception as e:
                print(f"Error reading {filepath}: {e}")
    
    # Create detailed report
    print(f"Found {len(duplicates)} duplicate questions:")
    print()
    
    # Group duplicates by file
    file_duplicates = {}
    for dup in duplicates:
        file_key = f"{dup['original_file']} -> {dup['duplicate_file']}"
        if file_key not in file_duplicates:
            file_duplicates[file_key] = []
        file_duplicates[file_key].append(dup)
    
    for file_key, dup_list in file_duplicates.items():
        print(f"{file_key}:")
        for dup in dup_list:
            print(f"  Q{dup['original_index']} '{dup['question'][:50]}...' also in Q{dup['duplicate_index']}")
        print()
    
    # Create a summary file
    with open('duplicate_fix_guide.md', 'w', encoding='utf-8') as f:
        f.write("# Duplicate Questions Fix Guide\n\n")
        f.write("## Summary\n")
        f.write(f"This app contains {len(duplicates)} duplicate questions that should be addressed.\n\n")
        f.write("## Detailed List\n\n")
        
        for file_key, dup_list in file_duplicates.items():
            f.write(f"### {file_key}\n")
            for dup in dup_list:
                f.write(f"- **Question**: \"{dup['question']}\"\n")
                f.write(f"  - Original: {dup['original_file']} (Question {dup['original_index']})\n")
                f.write(f"  - Duplicate: {dup['duplicate_file']} (Question {dup['duplicate_index']})\n")
            f.write("\n")
    
    print("=" * 50)
    print("Detailed report saved as 'duplicate_fix_guide.md'")
    print("Please review this guide to manually fix the duplicates.")
    print("It is recommended to backup your files before making changes.")

# Run the analysis
if __name__ == "__main__":
    create_duplicate_report()