HOSTS := /tmp/ansible-hosts

create-ssh-key:
	mkdir -p ssh-keys/
	rm -f ssh-keys/*
	ssh-keygen -f ssh-keys/ssh-key -q -t rsa -N '' <<< '\ny' >/dev/null 2>&1
	chmod 600 ssh-keys/ssh-key*
	cat ssh-keys/ssh-key.pub | cut -d' ' -f2 | sed 's/^/export TF_VAR_SSH_PUBLIC_KEY="/' | sed 's/$$/"/' >> ./.envrc

create-vm:
	(cd terraform && terraform init && terraform apply -auto-approve)

get_terraform_show:
	(cd terraform && terraform show -json > ../terraform_show.json)

prep_ansible_inventory: get_terraform_show
	python prepare_ansible_inventory.py

prepare-instana: prep_ansible_inventory
	(cd ansible && ansible-playbook -v -i $(HOSTS) prepare_instana.yaml  --key-file "../ssh-keys/ssh-key" -e "floating_ip=$(shell cd terraform && terraform output -json floating_ip | jq .address | tr -d '"')" -e "sales_id=${SALES_ID}" -e "agent_key=${AGENT_KEY}")

install-instana: prep_ansible_inventory
	(cd ansible && ansible-playbook -v -i $(HOSTS) install_instana.yaml  --key-file "../ssh-keys/ssh-key" -e "floating_ip=$(shell cd terraform && terraform output -json floating_ip | jq .address | tr -d '"')" -e "sales_id=${SALES_ID}" -e "agent_key=${AGENT_KEY}")

ssh:
	ssh -i ssh-keys/ssh-key root@$(shell cd terraform && terraform output -json floating_ip | jq .address | tr -d '"')

destroy:
	(cd terraform && terraform destroy -auto-approve)

prepare: create-vm prepare-instana

all: prepare install-instana
