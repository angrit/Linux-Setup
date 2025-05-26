# XServer & X11

Default Port: 6000 (TCP)

# Is it running
```bash
> echo $DISPLAY
:0
```

# Available for connections ?
```bash
> telnet 127.0.0.1 6000
Trying 127.0.0.1...
telnet: Unable to connect to remote host: Connection refused
```

## In case you need to check a more standard way...
```bash
netstat -ant | grep 6000
# OR
ss -tln | grep 6000
# OR
ss -tl | grep -i x11
# OR
ss -an | grep 6000
```
Yeah, that's right, i'm liking `ss` LOL

# What security is enabled ?
https://www.stitson.com/pub/book_html/node72.html
```bash
> xhost
access control enabled, only authorized clients can connect
SI:localuser:rich
```

## Allow user or device to use it
Tells XServer to allow access on ALL Local connections made via Unix Sockets.

Yes, the colon is needed! A User/Group can follow the colon to further restrict the access.

> Only ever used this for providing a GUI to my machine from an app in a Container

> All bets are off if port 6000 is not open
```bash
> xhost +local:
non-network local connections being added to access control list
```

### Note you can add Hosts too
```bash
> xhost +localhost
localhost being added to access control list
```

FYI in case you're wondering... it will look like this
```bash
> xhost
access control enabled, only authorized clients can connect
INET:localhost
SI:localuser:rich
```

# XServer not listening ?? Why ?
Well... security. So it is set that way for a reason... you can check your display manager or XServer directly (Xorg) to check if enabled/disabled.

https://wiki.netbsd.org/tutorials/x11/how_to_stop_x11_from_listening_on_port_6000/

If this security issue is not a valid convern then move ahead and enable it
> X11 displays everything **without** encryption so anyone who can connect to the port can observe or more

Alternatives ? Yeah there are some
- X11-Forwarding with SSH (SSH secures the transmission)
- [Wayland](https://wayland.freedesktop.org/docs/html/)
- [x11docker](https://github.com/mviereck/x11docker/wiki)
- [Xephyr](https://wiki.archlinux.org/title/Xephyr)


## Check XServer
The unmagic word is `nolisten`
```bash
ps aux | grep X
root        1045  3.2  0.7 27375248 249068 tty7  Ssl+ 09:00  20:04 /usr/lib/xorg/Xorg -core :0 -seat seat0 -auth /var/run/lightdm/root/:0 -nolisten tcp vt7 -novtswitch
rich       60898  0.0  0.0   9092  2624 pts/0    S+   19:20   0:00 grep --color=auto X
```

## Check Display Manager
The unmagic word is `nolisten`
```bash
> systemctl status display-manager
...
/usr/lib/xorg/Xorg -nolisten tcp :0 -seat seat0 -auth /var/run/lightdm/root/:0 -nolisten tcp vt7 -novtswitch
```

## Enable Listening on TCP (Mint -> Ubtuntu -> Debian)
I enabled on root as this is how i'm running Docker on my local

_**Once you're done restart your display manager**_

### Enable on XServer
`sudo vi /etc/X11/xinit/xserverrc`

Remove the nolisten part
```bash
#!/bin/sh

#exec /usr/bin/X -nolisten tcp "$@"
exec /usr/bin/X "$@"
```

### Enable on Display Manager: LightDM
`sudo vi /etc/lightdm/lightdm.conf.d/70-linuxmint.conf`

```bash
[SeatDefaults]
user-session=cinnamon
xserver-allow-tcp=true        # <-- Need this
xserver-command=X -listen tcp # <-- Need this
```

# Restart your Display Manager
ALL your open Windows... go Bye-Bye 👋
```bash
sudo systemctl restart lightdm
```

# What IS my Display Manager ?
- https://wiki.archlinux.org/title/LightDM
- https://wiki.debian.org/LightDM

There are several ways, one of these should work 😉

ALL
```bash
> systemctl status display-manager
● lightdm.service - Light Display Manager
...
/var/run/lightdm/root/:0
```

Minty
```bash
> inxi -Sxx
dm: LightDM
```

Linux XServer
```bash
> cat /etc/X11/default-display-manager
/usr/sbin/lightdm
```

# How do i test XServer works ?
You probably already have the apps installed, but if you're in a Docker Container you likely don't

Install the apps
```bash
apt install -y x11-apps
```

Run some apps that use XServer:
- `xclock`
- `xeyes` <-- this one is great 🤣
