#!/bin/bash
terraform apply -var-file="kkoform.tfvars"
terraform output -json > output.json
