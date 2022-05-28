#!/bin/bash

BASEURL="https://cs6.swfu.edu.cn/~wx672"
WGET="wget --no-check-certificate"
EMAIL="wx672ster@gmail.com"
DOTFILE="$HOME/.dotfile"

ERR_USAGE=1
ERR_INT=2

####################### color code ##########
ERR=$(tput setaf 1)     # red
WARN=$(tput setaf 3)    # yellow
INFO=$(tput setaf 6)    # cyan
SUCCESS=$(tput setaf 2) # green
BOLD=$(tput bold)

colorEcho(){
	echo -e $(tput bold)"$1""$2"$(tput sgr0)
}
#############################################

pause(){
	colorEcho $INFO "\nNow, press any key to continue..."
    while true
    do
        printf "\r-";  sleep 0.1
        printf "\r\\"; sleep 0.1
        printf "\r|";  sleep 0.1
        printf "\r/"
        read -s -n1 -t 0.1
        [ $? -eq 0 ] && break
    done
    echo -en "\r \r" # wipe out the waiting -\|/
}

pause_err(){
	colorEcho $INFO "\nScared? Press q to quit."
	colorEcho $INFO "Feeling lucky? Press any key (other than q) to continue..."
    while read -s -n1
    do
		case $REPLY in
			q) exit $ERR_INT ;;
			*) break ;;
		esac
    done
}

note(){
	colorEcho $INFO "****************************** NOTE ******************************"
	cat<<EOF
This script WON'T work unless you have the Debian base system successfully installed.
If not yet, follow my installation guide to do it now.

	- https://cs6.swfu.edu.cn/~wx672/debian-install/install.html

NOTE: DO NOT set the root password while installing the base system!
EOF
	colorEcho $INFO "******************************************************************"

	pause_err
}

checkIP(){
	colorEcho $INFO "Checking network..."

	while ! ip a | grep dynamic
	do
		colorEcho $ERR 'Oops! No IP address found!'
		echo "Trying dhclient..."
		while ! sudo dhclient
		do
			colorEcho $ERR "*** Failed to get an IP address! ***"
			cat<<EOF
The installation cannot proceed without a working Internet connection.
Now you have two choices:

1. Press Ctrl-Alt-F2 to login another console, and try fixing the network problem yourself.
   If succeed, press Ctrl-Alt-F1 to come back and continue.

2. Press q to quit the installation.
EOF
			pause_err
		done
	done
	
	colorEcho $SUCCESS 'Great! IP address is ready!'
	colorEcho $INFO "Checking cs6 reachability..."

	while ! ping -c3 cs6.swfu.edu.cn
	do
		colorEcho $ERR "********** ERROR! cs6 is unreachable! **********"
		cat<<EOF
Try:

1. Press Ctrl-Alt-F2 to login to another console, fix the network problem and then hit Ctrl-Alt-F1 to come back and continue.

2. If you can't fix the network, press q to quit the installation.
EOF
		colorEcho $ERR "************************************************"
		pause_err
	done
	
	colorEcho $SUCCESS "cs6 is reachable!"
}

sudo_nopass(){
	colorEcho $INFO "adding /etc/sudoers.d/$USER"
	while ! type -p sudo
	do
		colorEcho $ERR "********** ERROR! sudo is not installed! **********"
		cat<<EOF
You shouldn't set the root password while installing the base system!
Now you have to install 'sudo' yourself. 

1. Type Ctrl-Alt-F2 to open another console. login as root.
2. Install 'sudo' by typing 'apt install sudo'. 
3. Type Ctrl-Alt-F1 to come back and continue.
EOF
		colorEcho $ERR "***************************************************"
		pause_err
	done
	echo -e "$USER\tALL = NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
	sudo chmod 440 /etc/sudoers.d/$USER
}


dist_upgrade(){
    # setup sources.list
	colorEcho $INFO "Modifying /etc/apt/sources.list ..."
    
    cat <<EOF | sudo tee /etc/apt/sources.list
deb http://mirrors.163.com/debian sid main contrib non-free
deb http://ftp2.cn.debian.org/debian sid main contrib non-free
deb http://mirrors.ustc.edu.cn/debian sid main contrib non-free
EOF

	colorEcho $INFO "Upgrading the base system..."

	while ! { sudo apt update && sudo apt-get -y dist-upgrade; }; do	
		colorEcho $ERR "************* apt update/dist-upgrade failed! ********************"
		cat<<EOF
Most probably this is a network problem. You should check the error message carefully to see what's exactly happening.

Press Ctrl-Alt-F2 to login another console, fix the problem, 
and then come back to continue.
EOF
		colorEcho $ERR "******************************************************************"
		pause_err
	done

	colorEcho $SUCCESS "Done upgrading the base system!"

    sudo apt-get -y install wget aria2

    $WGET $BASEURL/debian-install/apt-fast.deb && \
	    sudo dpkg -i apt-fast.deb
}

more_pkgs(){
	echo "Downloading package lists from $BASEURL ..."
    
	cd	

    while ! $WGET $BASEURL/debian-install/{01-important,02-recommend,03-chinese,debconf.txt}; do
		rm -f 0* debconf.txt

		colorEcho $ERR "********** Oops! Failed downloading files! **********"

        cat<<EOF
Guess it's a temporary network failure. Try the following steps:

1. Make sure your Ethernet cable is firmly connected.
2. Press Ctrl-Alt-F2 to login another console.
3. Type 'sudo dhclient' to get an IP address. If success,
4. Type Ctrl-Alt-F1 to come back and continue.
EOF
		colorEcho $ERR "*****************************************************"
		pause_err
	done
	
	cat<<EOF
Package lists downloaded successfully!
Installing $(cat 0* | wc -l) packages and all the dependencies...
This step usually takes about an hour to finish. It could take longer if your network is slow.
EOF
	pause

    sudo debconf-set-selections debconf.txt
    
    if APT=$(type -p apt-fast) && type -p aria2c; then
        colorEcho $INFO "Great, apt-fast is available."
    else
        APT="apt-get"
    fi
           
	while ! sudo $APT -y install $(cat 0*)
	do
		colorEcho $ERR "********** Oops! $APT error! **********"
		cat<<EOF
Don't panic, you still have chances:

1. Press any key to try your luck again.

2. If step 1 doesn't help, press Ctrl-Alt-F2 to login another console to fix the problem. Usually, re-connect your Ethernet cable, and then "sudo dhclient" should help.

3. Type Ctrl-Alt-F1 to come back and try your luck again.

4. If failed, press q to quit the installation.
EOF

        colorEcho $ERR "******************************************"
		pause_err
    done

    unset APT
}

misc_files(){
	cd
    
	cat /dev/null > .xsession-errors && sudo chattr +i .xsession-errors

	colorEcho $INFO "Downloading misc files..."
    
	while ! $WGET $BASEURL/debian-install/{elpa.tgz,tmux-plugins.tgz,FiraCodeNerdFont.tgz,cn/dict-cn.tgz,cargo.bin.tgz}; do
		colorEcho $ERR "********** Oops! Failed downloading misc files! **********"
		cat<<EOF
It could be:
1. A network failure. If so, you should go fix it, and come back to continue.
2. A server side error (server down, files missing, etc.). In this case, you should press q to quit this script, and alarm me with a bug report ($EMAIL).
EOF
		colorEcho $ERR "**********************************************************"
		pause_err
	done
	
	tar zxf elpa.tgz -C ~/.emacs.d/

	cd; tar zxf tmux-plugins.tgz

	sudo tar zxf dict-cn.tgz -C /usr/share/dictd/ && \
        sudo dpkg-reconfigure --frontend noninteractive dictd

    sudo mkdir -p /usr/local/share/fonts/truetype/nerd-fonts && \
        sudo tar zxf FiraCodeNerdFont.tgz -C /usr/local/share/fonts/truetype/nerd-fonts/

    cd; tar zxf cargo.bin.tgz
}

auto_login(){
    sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
    
    cat <<EOF | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $USER --noclear %I \$TERM
EOF
}

locale_zh(){
    # generating locales
    cat <<EOF | sudo tee /etc/locale.gen
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
	sudo dpkg-reconfigure -fnoninteractive locales

    # update /etc/default/locale; locales have to be selected and generated in advance
    sudo update-locale \
         LANG \
         LANGUAGE="en_US:en" \
         LC_CTYPE="zh_CN.UTF-8" \
         LC_NUMERIC="en_US.UTF-8" \
         LC_TIME="en_US.UTF-8" \
         LC_COLLATE="en_US.UTF-8" \
         LC_MONETARY="en_US.UTF-8" \
         LC_MESSAGES="en_US.UTF-8" \
         LC_PAPER="en_US.UTF-8" \
         LC_NAME="en_US.UTF-8" \
         LC_ADDRESS="en_US.UTF-8" \
         LC_TELEPHONE="en_US.UTF-8" \
         LC_MEASUREMENT="en_US.UTF-8" \
         LC_IDENTIFICATION="en_US.UTF-8" \
         LC_ALL
}

xkey(){
    cat <<EOF | sudo tee /etc/default/keyboard 
XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS="terminate:ctrl_alt_bksp,ctrl:nocaps"
BACKSPACE="guess"
EOF
}

dotfile(){
	cd
	rm -rf $DOTFILE .bash*

	cat<<EOF > .gitconfig
[https]
    sslVerify = false
[http]
    sslVerify = false
EOF

	colorEcho $INFO "Cloning dotfiles from $BASEURL/dotfile/.git ..."

    while ! git clone $BASEURL/dotfile/.git $DOTFILE
	do
		colorEcho $ERR "********** Oops! git clone dotfile failed! **********"
		cat<<EOF
It could be:
1. A network failure. If so, you should go fix it, and come back to continue.
2. A server side error (server down? git repo changed?). In this case, you should press q to quit this script, and alarm me with a bug report ($EMAIL).
EOF
		colorEcho $ERR "*****************************************************"
		pause_err
	done

	rm -f .gitconfig
	ln -sf $DOTFILE/dot.* .
	ln -sf $DOTFILE/help/dot.* .
	rename 's/dot//' dot.*
    ln -sf $DOTFILE/dot.config/stumpwm/init.lisp .stumpwmrc

	for f in lf st st-copyout st-urlhandler stud uni; do
		sudo ln -sf $DOTFILE/usr/local/bin/"$f" /usr/local/bin/"$f"
	done

	sudo ln -f /usr/local/bin/st /usr/local/bin/xterm
    sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
    sudo ln -sf /usr/bin/batcat /usr/local/bin/cat
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd

	sudo cp $DOTFILE/etc/X11/xorg.conf.d/30-touchpad.conf /etc/X11/xorg.conf.d/

	misc_files
	auto_login
	locale_zh
	xkey

    # config timezone
    echo 'Asia/Shanghai' | sudo tee /etc/timezone
    sudo dpkg-reconfigure -fnoninteractive tzdata

    # use large font in console
    cat <<EOF | sudo tee /etc/default/console-setup 
ACTIVE_CONSOLES="/dev/tty[1-2]"
CHARMAP="UTF-8"
CODESET="Lat15"
FONTFACE="Terminus"
FONTSIZE="16x32"
VIDEOMODE=
EOF
    sudo dpkg-reconfigure -fnoninteractive console-setup

	[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:${PATH}"
	ALACRITTY="$(command -v alacritty)"
	if [ -n "$ALACRITTY" ]; then
        sudo update-alternatives --install /usr/bin/x-terminal-emulator \
			 x-terminal-emulator "$ALACRITTY" 90 
        sudo update-alternatives --set x-terminal-emulator "$ALACRITTY"
	fi

    type -p stumpwm && \
        sudo update-alternatives --set x-window-manager $(type -p stumpwm)

### The ubuntu deb package is no longer valid for Debian.	
#     cat <<EOF | sudo tee /etc/apt/sources.list.d/apt-fast.list 
# deb http://ppa.launchpad.net/apt-fast/stable/ubuntu bionic main
# EOF
#     sudo apt-key adv --keyserver keyserver.ubuntu.com \
#          --recv-keys A2166B8DE8BDC3367D1901C11EE2FF37CA8DA16B
}

sawfish_ugliness(){
	cd
	UGLINESS="sawfish-merlin-ugliness_1.3.1-1_all.deb"
	if $WGET $BASEURL/debian-install/sawfish/$UGLINESS
	then
		sudo dpkg -i $UGLINESS
		sudo sed -i '/expert/s/^/;/' /usr/share/sawfish/site-lisp/merlin/uglicon.jl
		sudo sed -i '/gnome/s/^/;/' /etc/X11/sawfish/site-init.d/00debian.jl
		sudo sed -i '/debian/s/^/;/' /etc/X11/sawfish/site-init.d/00menu.jl
	else
		colorEcho $ERR "********** Failed downloading sawfish-merlin-ugliness package! **********"
		cat<<EOF
It could be:
1. A network failure.
2. A server side error (server down? file missing?).

In any case, this is an optional package. That means you can live without it. So, now you can just ignore this error message, and press any key to continue. But don't forget to send me a bug report ($EMAIL).
EOF
		colorEcho $ERR "*************************************************************************"
		pause
	fi
}

congrats(){
	dialog --title "Installation completed successfully!" \
		   --msgbox "Now, I am going to reboot your computer.

Upon finishing boot up, if you are lucky to see the mouse cursor showing on the screen, you can hit
   	   * Super-t to bring up a terminal. Or,
	   * Super-F1 to show the cheat sheet.
	   * use 'nmtui' to activate your wifi.
	   * trigger Chinese input (fcitx5) by hitting Shift-space. Try fcitx5-configtool otherwise. 

If the mouse cursor isn't there at all, that probably means the Xorg doesn't work well. This usually has something to do with the graphic card driver. In this unlucky case, you have to ask google for more info.

Have fun!" 20 80
# 	colorEcho $SUCCESS "******************** Congrats! ********************"
# 	cat<<EOF
# Done installation! Now, I am going to reboot your computer.

	# <cropped>
	
# EOF
# 	colorEcho $SUCCESS "**************************************************"
# 	pause
	sudo reboot
}

note
checkIP
sudo_nopass
dist_upgrade
more_pkgs
dotfile
sawfish_ugliness
congrats
