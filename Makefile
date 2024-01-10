
provider := virtualbox
vagrant:
	cd hashiqube && vagrant up --provider=$(provider)
	cd hashiqube && vagrant status

vagrant-debug:
	cd hashiqube && vagrant up --provider=$(provider) --debug &> vagrant.log
	cd hashiqube && vagrant status


vagrant-fix:
	cd hashiqube && vagrant status
	vagrant plugin repair

vagrant-update:
	cd hashiqube && vagrant box update

vagrant-ssh:
	cd hashiqube && vagrant ssh

# SEE: https://github.com/avillela/hashiqube#dns-resolution-issues-with-localhost
setup-system:
	brew install dnsmasq
	cp -f $(shell brew list dnsmasq | grep dnsmasq.conf) /usr/local/etc/dnsmasq.conf
	echo "address=/localhost/127.0.0.1" >> /usr/local/etc/dnsmasq.conf
	sudo brew services restart dnsmasq
	sudo mkdir -p /etc/resolver
	sudo touch /etc/resolver/localhost
	sudo echo "nameserver 127.0.0.1" >> /etc/resolver/localhost

test-setup-system:
	ping foo.localhost

setup-vagrant:
	brew install virtualbox
	brew install --cask virtualbox-extension-pack
	vagrant plugin install $(provider)
	vagrant init

setup-temporal:
	brew install tctl
	brew install grpcurl

temporal:
	nomad job run temporal-db.nomad
	nomad job run temporal.nomad
	open http://temporal-web.localhost

status-temporal:
	nomad alloc status $(shell nomad job allocs -json temporal | jq -r '.[0].ID') | grep "^Task \""

temporal_grpc := temporal-app.localhost:7233
test-temporal:
	grpcurl --plaintext $(temporal_grpc) list
	tctl --address $(temporal_grpc) --context_timeout 45 namespace list

example := temporal-example/examples
temporal-example-worker:
	 cd $(example) && go run worker/main.go

temporal-example-workflow:
	cd $(example) && go run start/main.go

temporal-example-extended:
	nomad job run registry.nomad

ui:
	open http://localhost:3333
	open http://traefik.localhost/dashboard/#/
	open http://localhost:8200
	open http://localhost:8500
	open http://localhost:4646

vagrant_ip := 192.168.56.1
waypoint:
	cat hashiqube/hashicorp/waypoint/waypoint_user_token.txt
	open https://$(vagrant_ip):9702

vagrant-ip:
	@echo "$(vagrant_ip)"
