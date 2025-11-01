import os
import re
from collections import defaultdict

# Directory containing the question files
questions_dir = "lib/models"

# Function to extract question text from a Question object
def extract_question_text(line):
    # Match question text in Question constructor
    match = re.search(r'question:\s*[\'"](.+?)[\'"]', line)
    if match:
        return match.group(1).strip()
    return None

# Function to read a file and extract all questions
def extract_questions_from_file(filepath):
    questions = []
    with open(filepath, 'r', encoding='utf-8') as file:
        lines = file.readlines()
        
    i = 0
    while i < len(lines):
        line = lines[i]
        if 'Question(' in line and 'question:' in line:
            # Extract the question text
            question_text = extract_question_text(line)
            
            # If the question spans multiple lines
            if question_text is None:
                i += 1
                while i < len(lines) and 'question:' not in lines[i]:
                    i += 1
                if i < len(lines):
                    question_text = extract_question_text(lines[i])
            
            if question_text:
                # Find the complete Question object
                question_lines = [line]
                i += 1
                bracket_count = line.count('(') - line.count(')')
                while i < len(lines) and bracket_count > 0:
                    question_lines.append(lines[i])
                    bracket_count += lines[i].count('(') - lines[i].count(')')
                    i += 1
                
                questions.append({
                    'text': question_text,
                    'lines': question_lines,
                    'file': os.path.basename(filepath)
                })
            else:
                i += 1
        else:
            i += 1
    
    return questions

# Collect all questions from all files
all_questions = []
for filename in os.listdir(questions_dir):
    if filename.endswith('_questions.dart'):
        filepath = os.path.join(questions_dir, filename)
        questions = extract_questions_from_file(filepath)
        all_questions.extend(questions)

# Group questions by text
question_groups = defaultdict(list)
for question in all_questions:
    question_groups[question['text']].append(question)

# Identify duplicates
duplicates = {text: questions for text, questions in question_groups.items() if len(questions) > 1}

# Print duplicate report
print(f"Found {len(duplicates)} duplicate questions:")
for text, questions in duplicates.items():
    print(f"\nDuplicate: {text}")
    for q in questions:
        print(f"  - {q['file']}")

# Create a set of questions to remove (keeping one instance of each duplicate)
questions_to_remove = set()
for text, questions in duplicates.items():
    # Keep the first occurrence, mark others for removal
    for question in questions[1:]:
        questions_to_remove.add((question['text'], question['file']))

print(f"\nMarked {len(questions_to_remove)} duplicate questions for removal.")

# Function to remove duplicate questions from files
def remove_duplicates_from_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        lines = file.readlines()
    
    # Find and remove duplicate questions
    new_lines = []
    i = 0
    removed_count = 0
    
    while i < len(lines):
        line = lines[i]
        if 'Question(' in line and 'question:' in line:
            # Extract the question text
            question_text = extract_question_text(line)
            
            # If the question spans multiple lines
            if question_text is None:
                j = i + 1
                while j < len(lines) and 'question:' not in lines[j]:
                    j += 1
                if j < len(lines):
                    question_text = extract_question_text(lines[j])
            
            # Check if this question should be removed
            if question_text and (question_text, os.path.basename(filepath)) in questions_to_remove:
                # Skip the entire Question object
                bracket_count = line.count('(') - line.count(')')
                i += 1
                while i < len(lines) and bracket_count > 0:
                    bracket_count += lines[i].count('(') - lines[i].count(')')
                    i += 1
                removed_count += 1
                continue  # Skip adding this question
        
        new_lines.append(line)
        i += 1
    
    # Write the modified content back to the file
    with open(filepath, 'w', encoding='utf-8') as file:
        file.writelines(new_lines)
    
    return removed_count

# Remove duplicates from all files
total_removed = 0
for filename in os.listdir(questions_dir):
    if filename.endswith('_questions.dart'):
        filepath = os.path.join(questions_dir, filename)
        removed = remove_duplicates_from_file(filepath)
        if removed > 0:
            print(f"Removed {removed} duplicate questions from {filename}")
        total_removed += removed

print(f"\nTotal duplicate questions removed: {total_removed}")

# Also fix placeholder questions (questions with "..." or empty text)
def fix_placeholder_questions(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Replace placeholder questions with a comment
    # This is a simple approach - in practice, you might want to remove them entirely
    modified_content = re.sub(r'Question\(\s*question:\s*["\']\.{3}["\'],[^)]+\),', 
                             '// Placeholder question removed', content)
    
    # Write the modified content back to the file
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(modified_content)

# Fix placeholder questions in hindi_questions.dart
hindi_file = os.path.join(questions_dir, 'hindi_questions.dart')
if os.path.exists(hindi_file):
    fix_placeholder_questions(hindi_file)
    print(f"Fixed placeholder questions in {os.path.basename(hindi_file)}")

print("\nDuplicate question fixing complete!")