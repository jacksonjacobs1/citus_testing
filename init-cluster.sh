#!/bin/bash
set -e

echo "Waiting for all nodes to be healthy..."
sleep 5

echo "Registering workers with coordinator..."
docker exec citus_coordinator psql -U citus -d citus -c "SELECT citus_add_node('worker1', 5432);"
docker exec citus_coordinator psql -U citus -d citus -c "SELECT citus_add_node('worker2', 5432);"

echo "Verifying cluster nodes..."
docker exec citus_coordinator psql -U citus -d citus -c "SELECT * FROM citus_get_active_worker_nodes();"

echo "Citus cluster is ready!"