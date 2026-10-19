#!/usr/bin/env bash
# Levanta este stack. Antes de lanzar, avisa si algún puerto que publica ya está ocupado.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
busy=$(docker compose config --format json | python3 -c "
import json,sys,subprocess
cfg=json.load(sys.stdin); mine={'spartans'}
used={}
for l in subprocess.check_output(['docker','ps','--format','{{.Names}}|{{.Label \"com.docker.compose.project\"}}|{{.Ports}}'],text=True).splitlines():
    n,p,ports=(l.split('|',2)+['',''])[:3]
    for c in ports.split(','):
        if '->' in c:
            h=c.strip().split('->')[0].rsplit(':',1)[-1]
            if h.isdigit(): used[int(h)]=(n,p)
for s,v in cfg.get('services',{}).items():
    for p in v.get('ports',[]) or []:
        pub=p.get('published')
        if pub and int(pub) in used and used[int(pub)][1]!=cfg.get('name'):
            print(f\"  - :{pub} ({s}) ya lo usa '{used[int(pub)][0]}' (proyecto '{used[int(pub)][1]}')\")
")
if [[ -n "$busy" ]]; then echo "Colisión de puertos:"; echo "$busy"; echo "Detén ese servicio o cambia el puerto y vuelve a intentar."; exit 1; fi
docker compose up -d --build "$@"
docker compose ps
