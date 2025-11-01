import os

# Check if we're in the right directory
print("Current working directory:", os.getcwd())
print("Files in lib/models:")
try:
    files = os.listdir("lib/models")
    for f in files:
        print("  ", f)
except Exception as e:
    print("Error listing files:", e)