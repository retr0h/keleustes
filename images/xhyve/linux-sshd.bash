#!/bin/sh

KERNEL="../linuxkit/linux-sshd-kernel"
INITRD="../linuxkit/linux-sshd-initrd.img"
CMDLINE="console=ttyS0 console=tty0 page_poison=1"

MEM="-m 1G"
PCI_DEV="-s 0:0,hostbridge -s 31,lpc"
LPC_DEV="-l com1,stdio"
ACPI="-A"
#SMP="-c 2"

# sudo if you want networking enabled
NET="-s 2:0,virtio-net"

xhyve \
	${ACPI} \
	${MEM} \
	${SMP} \
	${PCI_DEV} \
	${LPC_DEV} \
	${NET} \
	-f kexec,${KERNEL},${INITRD},"${CMDLINE}"
