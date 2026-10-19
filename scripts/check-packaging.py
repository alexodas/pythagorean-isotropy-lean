#!/usr/bin/env python3
"""Check preservation and exact statement extraction, without executing Lean."""
import json
import hashlib
from pathlib import Path
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
ARCHIVED = '64c8ea3ef05d621814bc6460223f1f14d208f543'

def git(*args):
    return subprocess.check_output(['git', *args], cwd=ROOT)

def signature(text, name):
    match = re.search(r'^theorem ' + re.escape(name) + r'(?=\s)', text, re.M)
    assert match, f'Missing theorem {name}'
    return text[match.start():text.index(' := by', match.start())]

record = json.loads((ROOT / 'preservation.json').read_text())
assert record['archived_commit'] == ARCHIVED
if (ROOT / '.git').exists():
    assert git('rev-parse', 'v0.1.0^{commit}').decode().strip() == ARCHIVED
digest = lambda data: hashlib.sha256(data).hexdigest()
current = (ROOT / 'PythagoreanIsotropy.lean').read_text(encoding='utf-8')
header, body = current.split('public section\n', 1)
assert header == ('module\n\npublic import Mathlib.Analysis.Calculus.Deriv.Basic\n'
                  'import Mathlib.Analysis.Calculus.Deriv.Pow\n'
                  'import Mathlib.Analysis.Calculus.MeanValue\n'
                  'import Mathlib.Tactic.Convert\n'
                  'import Mathlib.Tactic.Linarith\n'
                  'import Mathlib.Tactic.Ring\n\n')
reconstructed = 'import Mathlib\n' + body
reconstructed = reconstructed.replace('@[expose] def ', 'def ')
assert digest(reconstructed.encode()) == record['original_proof_text_sha256'], 'Proof development changed beyond module visibility'

for name in ['.zenodo.json', 'AXIOMS.md', 'RELEASE_NOTES.md',
             'manuscript/pythagorean_isotropy_ai_disclosure.pdf',
             'manuscript/pythagorean_isotropy_ai_disclosure.tex']:
    path = ROOT / name
    data = path.read_bytes() if path.suffix == '.pdf' else path.read_text(encoding='utf-8').encode()
    assert digest(data) == record['protected_files_sha256'][name], name
    if (ROOT / '.git').exists():
        assert digest(git('show', ARCHIVED + ':' + name)) == record['protected_files_sha256'][name], name

config = json.loads((ROOT / 'comparator.json').read_text())
challenge = (ROOT / 'Challenge.lean').read_text(encoding='utf-8')
for full_name in record['theorem_signatures_sha256']:
    name = full_name.removeprefix('PythagoreanIsotropy.')
    assert digest(signature(challenge, name).encode()) == record['theorem_signatures_sha256'][full_name], full_name
assert len(re.findall(r'^  sorry$', challenge, re.M)) == len(config['theorem_names'])
assert len(challenge.splitlines()) <= 1000
assert len(challenge.encode()) <= 100 * 1024
assert re.findall(r'^(?:public )?import (.+)$', challenge, re.M) == ['Mathlib.Analysis.Calculus.Deriv.Basic', 'Mathlib.Analysis.Real.Sqrt']
for proof_source in ROOT.glob('*.lean'):
    if proof_source.name != 'Challenge.lean':
        assert not re.search(r'^\s*(sorry|axiom)\b', proof_source.read_text(encoding='utf-8'), re.M), proof_source
assert config['permitted_axioms'] == ['propext', 'Quot.sound', 'Classical.choice']
assert 'external_kernels' not in config
lake_text = (ROOT / 'lakefile.toml').read_text()
lake_revisions = re.findall(r'^rev = "([0-9a-f]{40})"$', lake_text, re.M)
assert len(lake_revisions) == 1 and lake_text.count('[[require]]') == 1
manifest = json.loads((ROOT / 'lake-manifest.json').read_text())
mathlib = next(x for x in manifest['packages'] if x['name'] == 'mathlib')
assert lake_revisions[0] == mathlib['rev']
assert all(re.fullmatch('[0-9a-f]{40}', x['rev']) for x in manifest['packages'])
metadata = json.loads((ROOT / 'formalization.yaml').read_text(encoding='utf-8'))
assert metadata['project']['license'] == 'CC-BY-4.0'
assert (ROOT / 'LICENSE').is_file()
assert not (ROOT / '.github/workflows/publish-v0.1.0.yml').exists()
for workflow in (ROOT / '.github/workflows').glob('*.yml'):
    text = workflow.read_text(encoding='utf-8')
    assert 'contents: write' not in text, workflow
    assert 'git push' not in text and 'gh release create' not in text, workflow
print('PASS: archived tag, manuscript, Zenodo metadata and mathematical proof text preserved.')
print('PASS: all four archived Challenge signatures still exactly match the archived theorem signatures.')
print('PASS: independent Challenge, source limits, dependency pins and metadata consistency.')
