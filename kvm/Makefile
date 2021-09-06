DOMAIN = "cent-ks"
VCPUS = 2
RAM = 1536
SIZE = 20
ISO = "/home/ryan/Qemu/CentOS-Stream-8-x86_64-latest-dvd1.iso"
KS_CFG = "./ks.cfg"

create:
	virt-install --connect qemu:///system \
				 --hvm \
				 --name=${DOMAIN} \
				 --vcpus=${VCPUS} \
				 --ram=${RAM} \
				 --disk size=${SIZE},format=qcow2,bus=virtio,cache=writeback \
				 --os-type=linux \
				 --os-variant=auto \
				 --accelerate \
				 --nographics \
				 --noautoconsole \
				 --wait=-1 \
				 --location=${ISO} \
				 --network bridge=virbr0,model=virtio \
				 --initrd-inject ${KS_CFG} \
				 --extra-args "inst.ks=file:/ks.cfg console=tty0 console=ttyS0,115200n8"

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
