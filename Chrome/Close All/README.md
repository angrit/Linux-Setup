# Close all Chrome Apps on Exit
We dont want `~/.bash_logout` as this will run on any shell exiting 😱

We can do one of the following:
1. Invoke on Service
2. Invoke of Display Manager

# Invoke on Service
A more general way we could hack this is to create a placeholder service, and then use the logout to invoke our killer script.

Copy the file like this
`/etc/systemd/system/cleanup-chrome-close-all.service`

Enable it, it makes it very easy to disable it too :wink:
```bash
systemctl enable cleanup-chrome-close-all.service
systemctl status cleanup-chrome-close-all.service
```

NOTE if you manually start it, it will of course... Close... Everything... 🤯

## Determine that it is ready to invoke on logout
Check if we're on the exit target
```bash
> systemctl list-dependencies exit.target
exit.target
● ├─cleanup-chrome-close-all.service
● └─systemd-exit.service
```

# Invoke on Display Manager
Sooo of we're gonna run it on Display Manager, then edit this file
`/etc/lightdm/lightdm.conf.d/70-linuxmint.conf`

Add this line
```bash
session-cleanup-script=/usr/local/bin/cleanup_chrome_close_all.sh
```

Copy the script file to: `/usr/local/bin/cleanup_chrome_close_all.sh`

Add exec permission
```bash
sudo chmod +x /usr/local/bin/cleanup_chrome_close_all.sh
```

# Check the application name
```bash
ps -ec
```

That is sufficient as we can see that both `chrome` and `chrome-beta` are matched by the command `chrome`
```bash
ps -ef | grep -i chrome
```
