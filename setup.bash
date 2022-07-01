
source utils.bash

function generate_password {
	openssl rand -base64 15
}

# create a db to influxdb
oc rsh dc/influxdb curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE db" -X POST


grafana_password="$(generate_password)"

oc rsh dc/grafana grafana-cli --config /usr/share/grafana/conf/custom.ini admin reset-admin-password $grafana_password

curl https://grafana-$(get_project).$(get_domain)/api/datasources -u admin:$grafana_password -X POST --data-binary '{ "name": "InfluxDB", "type": "influxdb", "url": "http://influxdb:8086", "access": "proxy", "basicAuth": false, "database": "db" }' -H Content-Type:application/json

echo 
echo grafana_password: $grafana_password
echo