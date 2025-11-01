import os
import re

# Directory containing Dart files
lib_dir = "lib"

# Function to fix withOpacity to withValues in a file
def fix_withopacity_in_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Pattern to match withOpacity method calls
    pattern = r'(\w+)\.withOpacity\((0\.\d+)\)'
    
    # Replace with withValues(alpha: ...)
    fixed_content = re.sub(pattern, r'\1.withValues(alpha: \2)', content)
    
    # Count how many replacements were made
    count = len(re.findall(pattern, content))
    
    # Write the fixed content back to the file
    with open(filepath, 'w', encoding='utf-8') as file:
        file.write(fixed_content)
    
    return count

# Fix withOpacity in all Dart files
total_fixed = 0
for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith('.dart'):
            filepath = os.path.join(root, file)
            fixed_count = fix_withopacity_in_file(filepath)
            if fixed_count > 0:
                print(f"Fixed {fixed_count} instances in {filepath}")
                total_fixed += fixed_count

print(f"\nTotal fixed: {total_fixed} instances")