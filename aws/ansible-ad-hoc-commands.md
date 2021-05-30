# Create folder with ad-hoc ansible command using module file
```
ansible localhost -m file -a "path=/ansible state=directory"
```
## Retrieve facts for a file
```
ansible localhost -m stat -a "path=/ansible"
```
## Copy files
```
ansible localhost -m copy -a "src=/ansible/info.md dest=/ansible/to-dos.md"
```
## Replace text in a file
```
ansible localhost -m replace -a "path=/ansible/to-dos.md regexp='^\[\s' replace='[x'"
```
## Lookup the content of a file -> debug module with lookup plugin
```
ansible localhost -m debug -a "msg={{lookup('file', '/ansible/to-dos.md') }}"
```
## Remove file
```
ansible localhost -m file -a "path=/ansible/to-dos.md state=absent"
```
## Run a playbook against an inventory limited to certain hosts (only hit the Windows host for example)
```
ansible-playbook win_ping_no_vars.yml -i hosts --limit ec2-35-81-135-106.us-west-2.compute.amazonaws.com
```
## Run a playbook against a group of hosts
```
ansible-playbook win_ping_no_vars.yml -i hosts --limit windows
ansible-playbook ping_no_vars.yml -i hosts --limit linux
```
### Ad-hoc command with debug module -> verify if the host variable ip is loading
```
ansible all -i hosts -m debug -a "var=ip"
```
### ansible-inventory --list -> list of the hosts along with their variables, it combines all the vars and lists them alongside the host entries
```
ansible-inventory -i hosts --list
```
### ansible-vault encrypt -> encrypt a file
```
ansible-vault encrypt group_vars/linux.yml
```
### ansible-vault edit -> edit an encrypted file (uses vi editor)
```
ansible-vault edit group_vars/linux.yml
```
### ansible-vault decrypt -> decrypt encrypted file
```
ansible-vault decrypt group_vars/linux.yml
```