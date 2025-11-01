import re
import os
import shutil

def remove_duplicates_from_file(filepath):
    """Remove duplicate questions from a single file"""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Split content into lines
        lines = content.split('\n')
        
        # Find all Question blocks
        question_blocks = []
        current_block = []
        in_question_block = False
        
        for line in lines:
            if 'Question(' in line and not in_question_block:
                in_question_block = True
                current_block = [line]
            elif in_question_block and line.strip() == '  ),':
                current_block.append(line)
                question_blocks.append('\n'.join(current_block))
                in_question_block = False
            elif in_question_block:
                current_block.append(line)
            # Keep non-question lines as they are
            else:
                pass  # We'll reconstruct the file differently
        
        # Extract just the question text for comparison
        unique_questions = {}
        unique_blocks = []
        
        for block in question_blocks:
            # Extract question text
            question_match = re.search(r'question:\s*[\'\"](.*?)[\'\"]', block)
            if question_match:
                question_text = question_match.group(1).strip().lower()
                # Also check for placeholder questions
                if question_text not in ['', '...', '..', '.'] and question_text not in unique_questions:
                    unique_questions[question_text] = True
                    unique_blocks.append(block)
        
        # Reconstruct the file
        # Find the parts before and after the questions list
        before_questions = []
        after_questions = []
        in_questions_section = False
        
        for line in lines:
            if 'final List<Question>' in line:
                in_questions_section = True
                before_questions.append(line)
            elif in_questions_section and line.strip() == '];':
                # Add the unique blocks
                before_questions.extend(['  ' + block for block in unique_blocks])
                before_questions.append('];')
                in_questions_section = False
            elif not in_questions_section:
                if not before_questions or '];' in line:
                    after_questions.append(line)
                else:
                    before_questions.append(line)
        
        # Write the cleaned content back to file
        cleaned_content = '\n'.join(before_questions + after_questions)
        
        # Backup the original file
        backup_path = filepath + '.backup'
        shutil.copy2(filepath, backup_path)
        
        # Write the cleaned content
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(cleaned_content)
        
        print(f"Processed {filepath}:")
        print(f"  Original questions: {len(question_blocks)}")
        print(f"  Unique questions: {len(unique_blocks)}")
        print(f"  Duplicates removed: {len(question_blocks) - len(unique_blocks)}")
        print(f"  Backup saved as: {backup_path}")
        print()
        
        return len(question_blocks) - len(unique_blocks)
        
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return 0

def fix_all_subjects():
    """Fix duplicates in all subject files"""
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
    
    total_duplicates = 0
    
    print("FIXING DUPLICATES IN ALL SUBJECT FILES")
    print("=" * 50)
    print()
    
    for filename in subject_files:
        filepath = os.path.join(models_dir, filename)
        if os.path.exists(filepath):
            duplicates_removed = remove_duplicates_from_file(filepath)
            total_duplicates += duplicates_removed
    
    print("=" * 50)
    print(f"TOTAL DUPLICATES REMOVED: {total_duplicates}")
    print("All files have been processed and backed up.")
    print("Please review the changes and verify the results.")

# Run the fix
if __name__ == "__main__":
    fix_all_subjects()