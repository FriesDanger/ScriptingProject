import os
#finding the current directory where the script's source code on.
dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "tracing_info")
print("Current directory where the script's source is" + dir)

# Walk through the directory and subdirectories
for dirpath, dirnames, filenames in os.walk(dir):
    print('Current Path:', dirpath)
    print('Directories:', dirnames)
    print('Files:', filenames)
    print()
