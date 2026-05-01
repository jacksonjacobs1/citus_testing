Steps to set up citus cluster:
1. Run a citus container on each node:
```bash
docker run -d --name citus -p 5432:5432 -e POSTGRES_PASSWORD=password citusdata/citus:14.0
```

2. Connect to a terminal session inside the docker container on the head node.
```bash
# Verify that the postgres server is running
psql -U postgres -h localhost -d postgres -c "SELECT * FROM citus_version();"

# Set the node as coordinator
psql -U postgres -h localhost -d postgres -c "SELECT citus_set_coordinator_host('10.0.0.144', 5432);"

# Add worker nodes to the cluster
psql -U postgres -h localhost -d postgres -c "SELECT * from citus_add_node('10.0.0.243', 5432);"
psql -U postgres -h localhost -d postgres -c "SELECT * from citus_add_node('10.0.0.54', 5432);"

# Confirm that the worker nodes have been added successfully
psql -U postgres -h localhost -d postgres -c "SELECT * FROM citus_get_active_worker_nodes();"
```

3. Modify the `pg_hba.conf` file on each node to allow connections from all IPs (development only, not recommended for production):
```bash
cat > /var/lib/postgresql/18/docker/pg_hba.conf << 'EOF'
local   all             all                                     trust
host    all             all             127.0.0.1/32            trust
host    all             all             ::1/128                 trust
local   replication     all                                     trust
host    replication     all             127.0.0.1/32            trust
host    replication     all             ::1/128                 trust
host    all             all             0.0.0.0/0               trust
host    all             all             ::/0                    trust
EOF
```

4. Restart the postgres server on each node to apply the changes:
```bash
su -c "pg_ctl -D /var/lib/postgresql/18/docker reload" postgres
```







Here's the connection string for the coordinator node:
```
postgresql://postgres:password@10.0.0.144:5432/postgres
```

