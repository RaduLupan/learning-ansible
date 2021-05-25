# Create folder with ad-hoc ansible command using module file
```
ansible localhost -m file -a "path=/ansible state=directory"
```
# Retrieve facts for a file
```
ansible localhost -m stat -a "path=/ansible"
```
# Copy files
```
ansible localhost -m copy -a "src=/ansible/info.md dest=/ansible/to-dos.md"
```
# Replace text in a file
```
ansible localhost -m replace -a "path=/ansible/to-dos.md regexp='^\[\s' replace='[x'"
```
# Lookup the content of a file -> debug module with lookup plugin
```
ansible localhost -m debug -a "msg={{lookup('file', '/ansible/to-dos.md') }}"
```
# Remove file
```
ansible localhost -m file -a "path=/ansible/to-dos.md state=absent"
```