"""Export generated PNG masters as local mobile assets using macOS ImageIO."""
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[1]
for name in ['account_card_background', 'home_serenity', 'dream_vault', 'future_letter']:
    source = ROOT / f'assets/images/originals/{name}.png'
    target = ROOT / f'assets/images/{name}.jpg'
    subprocess.run(['/usr/bin/sips', '-s', 'format', 'jpeg', '-s', 'formatOptions', '82', str(source), '--out', str(target)], check=True, capture_output=True)
    print(f'{target.relative_to(ROOT)}: {target.stat().st_size:,} bytes')
