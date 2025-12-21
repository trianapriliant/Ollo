
import json
import glob

def get_keys(filepath):
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            data = json.load(f)
            return set(k for k in data.keys() if not k.startswith('@'))
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return set()

en_keys = get_keys('d:/2MainFile/Project/Ollo/lib/l10n/app_en.arb')
print(f"EN Keys: {len(en_keys)}")

for filepath in glob.glob('d:/2MainFile/Project/Ollo/lib/l10n/app_*.arb'):
    if 'app_en.arb' in filepath: continue
    
    other_keys = get_keys(filepath)
    missing = en_keys - other_keys
    print(f"\n{filepath}: {len(other_keys)}")
    if missing:
        print(f"Missing keys in {filepath}:")
        for k in missing:
            print(f" - {k}")
