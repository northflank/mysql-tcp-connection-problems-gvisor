#!/usr/bin/env bash

# Create a pod that deploys the data to mysql
kubectl apply -f - << EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: insert-data
spec:
  activeDeadlineSeconds: 36000
  backoffLimit: 0
  completions: 1
  parallelism: 1
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "true"
    spec:
      restartPolicy: Never
      containers:
      - name: client
        image: arey/mysql-client:latest
        command:
        - /bin/ash
        args:
        - -c
        - |
          set +e
          echo "Creating table"
          mysql --host=mysql --user=local --password=1234567890 test-db -e "CREATE TABLE shops(id INT AUTO_INCREMENT, shop VARCHAR(255), installed INT, PRIMARY KEY (id));"
          echo "Inserting data"
          c=0
          while [ "\$c" -lt "10000" ]; do
            c=\$((c+1))
            mysql --host=mysql --user=local --password=1234567890 test-db -e "INSERT INTO shops(shop, installed) values (\$c, 0);"
          done
          echo "Done"
EOF