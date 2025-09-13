#!/bin/bash
minikube start --driver=docker --memory=8192 --cpus=4
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons enable dashboard
