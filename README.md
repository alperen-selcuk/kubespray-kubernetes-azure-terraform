# kubespray-kubernetes-azure-terraform


### pre-req

after the servers creation. you can check ansible host has a python3 or not. ansible use python. 

then clone the kubespray repo and go to stable branch. mine 2.24.3.

```
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray/
git checkout v2.24.3
```

we use python venv for all process. you need to install venv.

```sudo apt update && sudo apt install python3.10-venv```

this plugin will start venv process. inside the venv we will install all dependencies.

```
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

with this install also ansible will installed.

after that copy the inventory

```cp -rfp inventory/sample inventory/mycluster```

and declare servers IP address.

```declare -a IPS=(10.255.0.7 10.255.0.6 10.255.0.5)```

after the declare we use below command to create config file.

```CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}```

### kubespray 

3 config file you can update for basic installation. also you can install withouth any changing. 

these files 

```
inventory/mycluster/group_vars/all/all.yml
inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
inventory/mycluster/hosts.yaml
```

final step is run ansible-playbook with config files.

i changed my hosts yaml. i want 2 master and 1 control plane. you can declare this config on hosts.yaml

```
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
```

### kubernetes

you can find kubeconfig on any master servers etc/kubernetes/admin.conf 

copy the this file to your ansible host. and change serverip to master server ip. mine is 10.255.0.7 

for kubectl you can run my script

```curl https://raw.githubusercontent.com/alperen-selcuk/kubectl-install/refs/heads/main/install-kubectl-helm.sh | bash -```

or directly download binary 

```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
```

everyting is work


![image](https://github.com/user-attachments/assets/c52d66e5-ba06-4e9a-a39a-9822f44ee817)


