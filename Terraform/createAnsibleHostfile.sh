#!/bin/bash
if [ -f ../Ansible/Hosts ]
then
    rm ../Ansible/Hosts
fi
touch ../Ansible/Hosts
echo "[Docker-Swarm-Init]" >> ../Ansible/Hosts
cat vm_info-1 >> ../Ansible/Hosts
echo "" >> ../Ansible/Hosts
echo "[Docker-Swarm-Join]" >> ../Ansible/Hosts
count=$(ls vm_info-* | wc -l)
counter=1
while [[ counter -le $((count-1)) ]]
do 
    cat vm_info-$((counter+1)) >> ../Ansible/Hosts
    echo "" >> ../Ansible/Hosts
    ((counter++))
done