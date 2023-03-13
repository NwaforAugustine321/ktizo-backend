#!/usr/bin/env bash

docker exec -i ktizo-postgres /bin/bash -c "PGPASSWORD=ktizoismysecretpassword psql --username ktizo ktizo_local" \
 < ./scripts/pg_dump/Ktizo__init_dev_dump.sql