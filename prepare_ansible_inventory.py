import json

HOSTS = "/tmp/ansible-hosts"

file = open('terraform_show.json')
show = json.load(file)

f = open(HOSTS, "w")

# List the master nodes
ip =  show['values']['outputs']['floating_ip']['value']

f.write("[server]\n")
f.write("%s ansible_host=%s ansible_user=root\n" % (ip['name'], ip['address']))
f.write("\n");


f.close()

