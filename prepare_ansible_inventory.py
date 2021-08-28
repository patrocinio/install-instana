import json

HOSTS = "/tmp/ansible-hosts"

file = open('terraform_show.json')
show = json.load(file)

f = open(HOSTS, "w")

# List the master nodes
ips =  show['values']['outputs']['nfs']['value']['floating_ips']

f.write("[server]\n")
f.write("%s ansible_host=%s ansible_user=root\n" % (ips['name'], ips['address']))
f.write("\n");


f.close()

