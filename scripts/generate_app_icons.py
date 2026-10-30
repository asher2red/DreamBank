"""Export platform launcher icons from the generated DreamBank master."""
from pathlib import Path
import json
import subprocess

ROOT = Path(__file__).resolve().parents[1]
MASTER = ROOT / 'assets/brand/app_icon_master.png'

if __name__ == '__main__':
    targets = {}
    for density, size in [('mdpi',48), ('hdpi',72), ('xhdpi',96), ('xxhdpi',144), ('xxxhdpi',192)]:
        targets[ROOT/f'android/app/src/main/res/mipmap-{density}/ic_launcher.png'] = size
    catalog = ROOT/'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    for item in json.loads((catalog/'Contents.json').read_text())['images']:
        if 'filename' in item:
            targets[catalog/item['filename']] = round(float(item['size'].split('x')[0])*float(item['scale'].rstrip('x')))
    for path, size in targets.items():
        subprocess.run(['/usr/bin/sips', '-z', str(size), str(size), str(MASTER), '--out', str(path)], check=True, capture_output=True)
    print(f'Exported {len(targets)} platform icon files from generated master.')
