#!/bin/bash
ARCH=$(uname -a)
PCPU=$(grep 'cpu cores' < /proc/cpuinfo | awk -F ': ' '{print $2}')
VCPU=$(grep "^processor" /proc/cpuinfo | wc -l)
MEM=$(free --mega | awk '$1 == "Mem:" {print $3}')
TMEM=$(free --mega | awk '$1 == "Mem:" {print $2}')
PMEM=$(free --mega | awk '$1 == "Mem:" {printf("%.2f%%\n"), $3/$2*100}')
LBOOT=$(who -b | awk '$1 == "system" {print $3 " " $4 " " $5}')
ULOG=$(users | wc -l)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
IP=$(hostname -I | awk -F " " '{print $1}')
SUDO=$(journalctl _COMM=sudo |grep COMMAND | wc -l)
TDSK=$(df -BG --total | grep total | awk '{print $2}')
UDSK=$(df -BG --total | grep total | awk '{print $3}')
PDSK=$(df -BG --total | grep total | awk '{print $5}')
TCP=$(grep TCP /proc/net/sockstat | awk '{print $3}')
LVM=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)
LOAD=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')


wall "
#Architecture	 : ${ARCH}
#CPU Physical	 : ${PCPU}
#vCPU		 : ${VCPU}
#MEM usage	 : ${MEM}/${TMEM} (${PMEM})
#Disk usage	 : ${UDSK}/${TDSK} (${PDSK})
#CPU load	 : ${LOAD} 
#Last boot	 : ${LBOOT}
#LVM use	 : ${LVM}
#TCP conn.	 : ${TCP}
#Log users	 : ${ULOG}
#Network	 : ${IP} (${MAC})
#Sudo comm.	 : ${SUDO}
"
