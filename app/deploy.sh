#!/usr/bin/env bash

# Can supply argument ($1) to be an image built by build.sh

if [ "$1" == "" ]; then
  # Use a public image that was built by us
  IMAGE=deciderwill/php-sleep-gvisor-tcp-debug:latest
else
  # Otherwise use specified image
  IMAGE=$1
fi

# Set mtls mode to strict before deploying the app
kubectl apply -f - << EOF
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: mtls-strict
spec:
  mtls:
    mode: STRICT
EOF

# With the image pushed to the registry deploy the job to the cluster
# Please add any image pull secrets if necessary
# The envs control the connection to the database and specify:
#  - HOST -> dns of the database
#  - DB -> the name of the database within mysql
#  - PASSWORD -> password of the user with access to the database DB
#  - USER -> user with access to the database DB
#  - TIMEOUT -> how long to sleep before and after an update statement
kubectl apply -f - << EOF
apiVersion: batch/v1
kind: Job
metadata:
  labels:
    app: php-mysql-tcp-test
  name: php-mysql-tcp-test
spec:
  activeDeadlineSeconds: 36000
  backoffLimit: 0
  completions: 1
  parallelism: 1
  template:
    metadata:
      annotations:
        sidecar.istio.io/inject: "true"
      labels:
        app: php-mysql-tcp-test
        jobName: php-mysql-tcp-test
    spec:
      automountServiceAccountToken: false
      containers:
      - env:
        - name: HOST
          value: mysql
        - name: USER
          value: local
        - name: PASSWORD
          value: "1234567890"
        - name: DB
          value: test-db
        - name: TIMEOUT
          # 10 mins
          value: "600000000"
        image: $IMAGE
        imagePullPolicy: IfNotPresent
        name: main
        resources:
          limits:
            cpu: 100m
            ephemeral-storage: 1Gi
            memory: 256M
          requests:
            cpu: 50m
            ephemeral-storage: 1Gi
            memory: 204800k
      runtimeClassName: gvisor
      # These may be needed if using private registry
      imagePullSecrets: []
      restartPolicy: Never
EOF
