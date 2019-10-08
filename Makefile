VAGRANT_HOST_CPUS ?= 2
VAGRANT_HOST_RAM ?= 1024
VAGRANT_VM_PROVIDER ?= virtualbox
ALL_HOST_NAMES ?= vm1 vm2
VAGRANT_BOX ?= generic/ubuntu1804
VAGRANT_NETWORK ?= enp2s0
VAGRANT_CWD ?= $(PWD)

export VAGRANT_HOST_CPUS
export VAGRANT_HOST_RAM
export VAGRANT_BOX
export VAGRANT_NETWORK

VAGRANT_UP_ALL_HOSTS = $(addprefix vagrant-up-, $(ALL_HOST_NAMES))

$(VAGRANT_UP_ALL_HOSTS): HOST_NAME=$(patsubst vagrant-up-%,%,$@)
$(VAGRANT_UP_ALL_HOSTS):
	VAGRANT_CWD=$(VAGRANT_CWD) \
        VAGRANT_VAGRANTFILE=vagrant.rb \
        VAGRANT_DOTFILE_PATH=.$(HOST_NAME) \
        HOST_NAME=$(HOST_NAME) \
        vagrant up --provider $(VAGRANT_VM_PROVIDER)

VAGRANT_DESTROY_ALL_HOSTS = $(addprefix vagrant-destroy-, $(ALL_HOST_NAMES))

$(VAGRANT_DESTROY_ALL_HOSTS): HOST_NAME=$(patsubst vagrant-destroy-%,%,$@)
$(VAGRANT_DESTROY_ALL_HOSTS):
	VAGRANT_CWD=$(VAGRANT_CWD) \
        VAGRANT_VAGRANTFILE=vagrant.rb \
        VAGRANT_DOTFILE_PATH=.$(HOST_NAME) \
	VAGRANT_NETWORK=$(VAGRANT_NETWORK) \
        HOST_NAME=$(HOST_NAME) \
	vagrant destroy --force $(HOST_NAME)

VAGRANT_RESUME_ALL_HOSTS = $(addprefix vagrant-resume-, $(ALL_HOST_NAMES))

$(VAGRANT_RESUME_ALL_HOSTS): HOST_NAME=$(patsubst vagrant-resume-%,%,$@)
$(VAGRANT_RESUME_ALL_HOSTS):
	VAGRANT_CWD=$(VAGRANT_CWD) \
        VAGRANT_VAGRANTFILE=vagrant.rb \
        VAGRANT_DOTFILE_PATH=.$(HOST_NAME) \
	VAGRANT_NETWORK=$(VAGRANT_NETWORK) \
        HOST_NAME=$(HOST_NAME) \
	vagrant resume $(HOST_NAME)

VAGRANT_SUSPEND_ALL_HOSTS = $(addprefix vagrant-suspend-, $(ALL_HOST_NAMES))

$(VAGRANT_SUSPEND_ALL_HOSTS): HOST_NAME=$(patsubst vagrant-suspend-%,%,$@)
$(VAGRANT_SUSPEND_ALL_HOSTS):
	VAGRANT_CWD=$(VAGRANT_CWD) \
        VAGRANT_VAGRANTFILE=vagrant.rb \
        VAGRANT_DOTFILE_PATH=.$(HOST_NAME) \
	VAGRANT_NETWORK=$(VAGRANT_NETWORK) \
        HOST_NAME=$(HOST_NAME) \
	vagrant suspend $(HOST_NAME)

VAGRANT_STATUS_ALL_HOSTS = $(addprefix vagrant-status-, $(ALL_HOST_NAMES))

$(VAGRANT_STATUS_ALL_HOSTS): HOST_NAME=$(patsubst vagrant-status-%,%,$@)
$(VAGRANT_STATUS_ALL_HOSTS):
	VAGRANT_CWD=$(VAGRANT_CWD) \
        VAGRANT_VAGRANTFILE=vagrant.rb \
        VAGRANT_DOTFILE_PATH=.$(HOST_NAME) \
	VAGRANT_NETWORK=$(VAGRANT_NETWORK) \
        HOST_NAME=$(HOST_NAME) \
	vagrant status $(HOST_NAME)


vagrant-up: $(VAGRANT_UP_ALL_HOSTS)
	echo $(VAGRANT_UP_ALL_HOSTS)
vagrant-destroy: $(VAGRANT_DESTROY_ALL_HOSTS)
vagrant-resume: $(VAGRANT_RESUME_ALL_HOSTS)
vagrant-suspend: $(VAGRANT_SUSPEND_ALL_HOSTS)
vagrant-status: $(VAGRANT_STATUS_ALL_HOSTS)

install-plugins:
	vagrant plugin install vagrant-hostmanager
