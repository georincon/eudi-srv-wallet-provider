# docker-compose — Spartans Wallet Provider

```bash
./up.sh      # verifica puertos y levanta el stack
./down.sh    # detiene (./down.sh -v borra también los datos)
```

Compose original: `../docker/docker-compose.yaml` (se incluye, no se modifica). Proyecto Docker: `spartans`.
Puertos publicados: 5436 (Postgres); usa la red externa 'uis-issuer_default' (requiere el stack del issuer)
