#!/bin/bash
ipaddress=$(echo $1 | xargs)
if [ ! -z $ipaddress ]; then
	#do nothing
	echo "Using Supplied Host : $ipaddress"
else
	ipaddress="bprcipatujahjabar.com:7890"
fi

ulogin=$(echo $2 | xargs)
if [ ! -z $ulogin ]; then
	#do nothing
	echo "Using Supplied User : $ulogin"
else
	ulogin="juliandfx"
fi

upass=$(echo $3 | xargs)
if [ ! -z $upass ]; then
	#do nothing
	if [ $upass = "-p" ]; then
		echo -n "Password : "
		#read -s upass
		upass=$(zenity --password --title="Passwordna Jangeun RDP na ?")
		echo "\"Using Supplied Password\""
	else
		echo "\"Becareful When Using Arguments Password ! \""
		#exit 0
	fi
else
	upass=""
fi

pixel=$(echo $4 | xargs)
if [ -z $pixel ]; then
	$pixel=16
else
	if [[ $pixel =~ [^0-9] ]]; then
		zenity --error --text="Parameter jangeun kualitas gambar salah ($pixel) !\n ngan angka hungkul euy nu ditarimana oge."
		exit 0
	fi
fi

full=$(echo $5 | xargs)
if [ ! -z $full ]; then
	if [[ $full =~ -(f|F) ]]; then
		full="/f"
	else
		if [[ $full =~ ^[0-9]{1,4}x[0-9]{1,4}$ ]]; then
			full="/size:$full"
		else
			zenity --error --text="Parameter jangeun resolusi salah ($full) !\n Pake -(f|F) jang fullscreen atau 0000x0000 keur custom."
		fi			
	fi
fi
#resolution="1280x720"
drive=68 #D
driveinchar=
tomount=
for j in $(mount | grep /media | grep rw | grep -v "\." | cut -d" " -f3);
do
	driveinchar=$(printf "\x$(printf %x $drive)")
	drive=$((drive+1))
	to_mount+="/drive:DRIVE_$driveinchar,"$j"/ "
done
#echo $to_mount
xfreerdp /v:$ipaddress /u:$ulogin /p:$upass /bpp:$pixel $full +compression +clipboard +auto-reconnect +smart-sizing -wallpaper -themes /printer /drive:DOCUMENT_LINUX,/home/$USER/ $to_mount 
#/app:"C:\Windows\System32\loadibs.cmd"
