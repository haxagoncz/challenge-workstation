# Remote workstation docker image

Šablona pro vytvoření základního obrazu kontejneru, ke kterému se uživatelé připojují.
Jde o jednoduchý server, který je možné jednoduše konfigurovat za pomocí environment proměných.

## Options

| ENVIRONMENT  | default |Popis |
| - | - | - |
| **Vzdálený přístup** | | |
| ENABLE_SSH | false | Spuštění SSH serveru po startu
| USERNAME | student | Uživatelské jméno pro vzdálený přístup
| PASSWORD | password | Heslo jméno pro vzdálený přístup
| SHELL | /bin/bash | Výchozí shell uživatele
| SUDO | false | Přidá uživatele do skupiny sudo
| WEB_SHELL | false | Spuštění webové konzole
| WEB_SHELL_PORT | 80 | TCP port pro webovou konzoli
| **Entrypoint** | | |
| ENTRYPOINT_PATH | /tmp/entrypoint.sh | Cesta ke scriptu, který se spustí při startu kontejneru (musí být spustitelný, nesmí být `/var/lib/entrypoint.sh`)
| ENTRYPOINT_REMOVE | true | Odstranění scriptu po ukončení
| ENTRYPOINT_DEBUG | true | Zapnutí bash debug modu pro entrypoint
| ENTRYPOINT_SCENARIO_IS_READY | true | Vypsání `SCENARIO_IS_READY` na konci entrypointu
