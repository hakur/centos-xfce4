#!bin/bash
#create vnc password
if [[ -z "$VNC_PWD" ]];then
	VNC_PWD="123456"
else
	VNC_PWD="123456"
fi


printf "$VNC_PWD\n$VNC_PWD\n\n" | vncpasswd /etc/x0vncpass

#query nvidia info for generate X11 config
nvidia-smi -x -q > /nvidia-smi-log.xml
GPU_NUM=$(xmllint  -xpath "string(/nvidia_smi_log/attached_gpus)" /nvidia-smi-log.xml)
PCI_BUS_ID=$(xmllint  -xpath "string(/nvidia_smi_log/gpu/@id)" /nvidia-smi-log.xml)
BUS_ID=$(echo $PCI_BUS_ID|sed 's/00000000://')
BUS_ID=$(echo $BUS_ID|sed 's/\./:/')
rm -rf /nvidia-smi-log.xml

# create x11 config

#if gpu card number attached is 1 , nvidia-xconfig will not automatic set BusID to /etc/X11/xorg.conf at Device Section , it will get no device error when run X , and --preserve-busid flag also not set BusID

if [ $GPU_NUM -eq 1 ];then
	nvidia-xconfig -s --use-display-device=None --virtual=1280x720 --depth=24 --allow-glx-with-composite --busid="$BUS_ID"
else
	nvidia-xconfig -s -a --use-display-device=None --virtual=1280x720 --depth=24 --allow-glx-with-composite
fi

#start supervisor
supervisord -c /etc/supervisor/conf.d/x11.conf -n