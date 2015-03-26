## arkOS Vagrant Image

This repository contains configuration files required to build and start arkOS Vagrant images for VirtualBox x86_64. At present, master builds a development image; in the future a stable master will be kept with a development branch.

To build:
```
vagrant up
```

To package: 
```
vagrant package --vagrantfile Vagrantfile.pkg
```
