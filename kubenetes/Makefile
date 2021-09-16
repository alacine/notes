VCPUS = 2
RAM = 2048
SIZE = 20
KS_DIR = .

DOMAIN = fedora
OS_VARIANT = fedora34
ISO = /home/ryan/Qemu/Fedora-Server-dvd-x86_64-34-1.2.iso
KS_NAME = fedora-kube.cfg
#DOMAIN = "centos"
#OS_VARIANT = centos-stream8
#ISO = "/home/ryan/Qemu/CentOS-Stream-8-x86_64-latest-dvd1.iso"
#KS_CFG = "./centos-ks/ks.cfg"

KS_CFG := ${KS_DIR}/${KS_NAME}

create:
	virt-install --connect qemu:///system \
				 --hvm \
				 --name=${DOMAIN} \
				 --vcpus=${VCPUS} \
				 --ram=${RAM} \
				 --disk size=${SIZE},format=qcow2,bus=virtio,cache=writeback \
				 --os-type=linux \
				 --os-variant=${OS_VARIANT} \
				 --accelerate \
				 --nographics \
				 --noautoconsole \
				 --wait=-1 \
				 --location=${ISO} \
				 --network bridge=virbr0,model=virtio \
				 --initrd-inject ${KS_CFG} \
				 --extra-args "inst.ks=file:/${KS_NAME} console=tty0 console=ttyS0,115200n8"

	#--extra-args "inst.ks=file:/ks.cfg console=ttyS0,115200n8"
	#--console pty,target_type=serial \
	#-x 'console=ttyS0,115200n8 serial'

start:
	virsh -c qemu:///system start ${DOMAIN}

stop:
	virsh -c qemu:///system shutdown ${DOMAIN}

clean:
	virsh -c qemu:///system destroy ${DOMAIN}
	virsh -c qemu:///system undefine ${DOMAIN} --remove-all-storage
