#!/bin/bash

if [ -f ./ssh_copy_id.sh ]
then
    rm ./ssh_copy_id.sh
fi

touch ./ssh_copy_id.sh
echo "#!/bin/bash" >> ../Ansible/Hosts
count=$(ls ssh-* | wc -l)
list=1
while [[ list -le $((count)) ]]
do 
    cat ssh-$((list)) >> ./ssh_copy_id.sh
    echo "" >> ./ssh_copy_id.sh
    ((list++))
done