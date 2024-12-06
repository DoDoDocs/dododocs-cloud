#!/bin/bash
terraform apply -var-file="prod.tfvars"
terraform output -json > output.json
