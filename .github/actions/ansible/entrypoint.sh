#!/bin/bash
ansible-galaxy install -r roles/requirments.yml

echo $ANSIBLE_VAULT_PASSWORD >> .vault

ansible-playbook -i hosts_aws_ec2.yml --vault-password-file .vault

# Avoids locally storing on a mounted volume
rm .vault
