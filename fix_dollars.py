import os
import re

def escape_dollar_one(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                if '$1' in content:
                    # We need to replace literal '$1' with '\$1'
                    # To avoid replacing already escaped '\$1', we can use regex
                    # Negative lookbehind: (?<!\\)\$1
                    new_content = re.sub(r'(?<!\\)\$1', r'\\$1', content)
                    
                    if new_content != content:
                        with open(filepath, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"Fixed {filepath}")

escape_dollar_one('lib')
