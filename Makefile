VAGRANT_HOST_CPUS ?= 2
VAGRANT_HOST_RAM ?= 1024
VAGRANT_VM_PROVIDER ?= virtualbox
ALL_HOST_NAMES ?= vm1 vm2
VAGRANT_BOX ?= generic/ubuntu1804
VAGRANT_NETWORK ?= enp2s0

export VAGRANT_HOST_CPUS
export VAGRANT_HOST_RAM
export VAGRANT_BOX
export VAGRANT_NETWORK

VAGRANT_UP_ALL_HOSTS = $(addprefix vagrant-up-, $(ALL_HOST_NAMES))

$(VAGRANT_UP_ALL_HOSTS): HOST_NAME=$(patsubst vagrant-up-%,%,$@)
$(VAGRANT_UP_ALL_HOSTS):
	@VAGRANT_CWD=$(PWD) \
        VAGRANT_VAGRANTFILE=vagrant.rb \
        VAGRANT_DOTFILE_PATH=.$(HOST_NAME) \
        HOST_NAME=$(HOST_NAME) \
        vagrant up --provider $(VAGRANT_VM_PROVIDER)

VAGRANT_DESTROY_ALL_HOSTS = $(addprefix vagrant-destroy-, $(ALL_HOST_NAMES))

$(VAGRANT_DESTROY_ALL_HOSTS): HOST_NAME=$(patsubst vagrant-destroy-%,%,$@)
$(VAGRANT_DESTROY_ALL_HOSTS):
	@VAGRANT_CWD=$(PWD) \
        VAGRANT_VAGRANTFILE=vagrant.rb \
        VAGRANT_DOTFILE_PATH=.$(HOST_NAME) \
	VAGRANT_NETWORK=$(VAGRANT_NETWORK) \
        HOST_NAME=$(HOST_NAME) \
	vagrant destroy --force $(HOST_NAME)

vagrant-up: $(VAGRANT_UP_ALL_HOSTS)
	echo $(VAGRANT_UP_ALL_HOSTS)
vagrant-destroy: $(VAGRANT_DESTROY_ALL_HOSTS)

install-plugins:
	vagrant plugin install vagrant-hostmanager
