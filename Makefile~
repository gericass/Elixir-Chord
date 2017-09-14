migrate/down:
	mysql -u root -pmysql -h 127.0.0.1 -P 13306 \
	-e "use chord_dht_repo" \
	-e "drop table schema_migrations;"