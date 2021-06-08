#!/bin/bash
ansible-galaxy install -r /aws/roles/requirements.yml

echo $ANSIBLE_VAULT_PASSWORD >> .vault

ansible-playbook -i hosts_aws_ec2.yml /aws/site.yml --vault-password-file .vault

# Avoids locally storing on a mounted volume
rm .vault
