# StorijOS

[![storij](https://storij.net/storij-icon-final-S.png)](https://storij.net)


Storij is an operating system and a collection of tools for easy hosting on HyperSpace and Sia (and more) blockchains. The features include:

  - Easy hosting management through a graphical user interface with one time password as the login mechanism
  - Either bootstrap the blockchain or download a pre-verified one and quickly deploy hosting
  - Supports both HyperSpace and Sia chains; more are being implemented
  - Requires minimal supervision; auto updates the blockchain software
  - Utilizes upnp for transparent port forwarding

StorijOS can be built both on AMD64 and ARM64. Prebuilt images are availabe on [storij.net](https://storij.net). Do NOT download the images from any other sources, or from someone else who claims to be a developer of Storij. Siaberry and now Storij has always had only one developer and that is me i.e., Kete Tefid. 

## How to build
StorijOS is based on Gentoo so clearly you need a [Gentoo](https://gentoo.org) machine and with OpenRC, since systemd is not supported. This can be a newly installed one or from an old installation. In order to build StorijOS, you will need [layman](https://wiki.gentoo.org/wiki/Layman) to already be installed on your system. Then you can easily add this repo by doing the following as root:
```sh
layman -o https://storij.net/storij.xml -f -a storij
```
Once the repository is installed, do an ```emerge storij-tools```. This will provide the OS with the needed scripts and tools for the transition to a full StorijOS. Then, integrate options from /etc/portage/make.conf_storijos and check if you want to edit files in /etc/portage/package*. Make sure you have set ```-network-sandbox``` in the ```FEATURES``` of make.conf.
Finally run ```emerge @storijos``` to *convert* your current Gentoo machine to Storij and if you are on ARM64 (like a Raspberry Pi 3), issue ```emerge @storijos-arm``` instead. You might need to keyword some packages depending on the state of your Gentoo. There are also some optional development packages which can be installed by ```emerge @storijos-extra```.

In the next step, to finalize the transformation, enable these services:

```sh
rc-update add copy_parameters boot
```
If the installed kernel is capable of zram:
```
rc-update add zram-init boot
```
For the rest of the needed services:
```
for service in sc_drivesetup xsc_drivesetup net.eth0 syslog-ng apache2 \
               fail2ban shellinaboxd chronyd avahi-daemon cronie miniupnpd watchdog sshd; do
rc-update add $service default
done
```

To get miniupnpd ready, if this is from a new Gentoo installation, ```touch /var/lib/iptables/rules-save```. Finally, fetch the latest WebUI by issuing ```update-webui```.

Restart the machine and then you would be able to view the WebUI at ```http://storijos.local``` from a locally connected device and start hosting. Remember that in order to access the WebUI, your machine must support mDNS like MacOS. If you are in Linux, enable and start avahi daemon. If you are in Windows, install [Bonjour Print Services](https://support.apple.com/kb/dl999?locale=en_US). Use Google Chrome or a Chrome based browser.
From your Android phone, you will need to enter the IP addresses manually.

### Note
- The WebUI writes to the Storij configuration file located in ```/boot/storij/parameters.txt```. If /boot is on a vfat partition (e.g. the case for StorijOS on a RPi3), you must mount it with ```umask=000``` or the webserver and portage will not be able to write into ```parameters.txt```.
If /boot is on a properly permissioned filesystem like ext4, just issue ```chown -R apache /boot/storij```.

- StorijOS assumes that the machine is connected to the internet through ```eth0```. In case you want to manipulate the network layer through the WebUI and the interface name is different, either rename it via a udev rule or create an appropriate symlink to net.eth0. For most systems including RPi3, no change is needed.
- The static IP gained by setting auto in the Internal IP setting of the WebUI will result in an address like xxx.xxx.xxx.133. If 133 was already engaged, either release it or set a complete IP in the WebUI instead of auto.

## How to work with StorijOS
Please see the quick start guide at https://storij.net/How-To-Setup/. 

## Bugs and Suggestions

If a piece of software does not run properly or as intended, please submit a bug in this repository. If you need general support or have any questions, please create a thread in our Reddit channel, [/r/Storij](https://www.reddit.com/r/Storij/). You may also join https://t.me/storij Telegram group for a discussion. However, if you are seeking technical help, please choose Reddit as your question and the answers can remain for further reference.
