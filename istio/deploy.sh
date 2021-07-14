#!/usr/bin/env bash

# Deploy the istio profile with istioctl
istioctl manifest install -y -f ./profile.yaml