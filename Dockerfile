FROM nvidia/opengl:1.0-glvnd-devel-centos7
#cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.origin.bak \
#			&& curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
RUN  yum -y install epel-release \
	&& mkdir /build

COPY image/etc /etc

COPY image/bin /bin

RUN yum -y install tigervnc-server supervisor xorg-x11-server-Xorg
#gcc pkgconfig glx-utils kmod


#RUN yum -y install libmatekbd libmatemixer mate-applets mate-backgrounds mate-control-center mate-control-center-filesystem mate-desktop mate-desktop-libs mate-icon-theme ann apg mate-system-monitor mintmenu
#RUN yum -y install cinnamon-applet-blueberry cinnamon-control-center cinnamon-control-center-filesystem cinnamon-desktop cinnamon-menus cinnamon-screensaver cinnamon-session cinnamon-settings-daemon cinnamon-translations cinnamon nemo

RUN yum -y groups install "Xfce"
RUN yum -y install xfce4-panel f22-backgrounds-xfce fonts

#RUN yum -y groups install "Mate Desktop" --skip-broken
#RUN yum -y groups install "Cinnamon Desktop" --skip-broken

COPY image/start.sh  /start.sh

RUN rm -rf /etc/X11 \
	&& mkdir /etc/X11 \
	&& chmod +x /start.sh \
	&& chmod +x /bin/nvidia-xconfig
RUN yum clean all && rm -rf /usr/lib64/xorg && rm -rf /var/cache/yum/
ENV DISPLAY=:0.0

CMD ["/start.sh"]












# THESE ARE TEST COMMANDS

# docker run -it --name test-gl --rm  -p 5900:5900 -v /docker/ff:/work  -e NVIDIA_DRIVER_CAPABILITIES=all --device=/dev/tty0  -v /usr/bin/ test-gl bash
# printf "123456\n123456\n\n" | vncpasswd vncpass
# x0vncserver -PasswordFile=vncpass -AlwaysShared=on -AcceptPointerEvents=on -AcceptKeyEvents=on
# X :0 vt0 -sharevts -novtswitch
# X :0 vt0 -sharevts -modulepath /usr/lib64/xorg/modules
# xinit --  :0  vt0 -sharevts -novtswitch
# startx /usr/bin/startlxde -- :0 vt0 -sharevts -novtswitch
# gtk-window-decorator --replace