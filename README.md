## arkOS Vagrant Image

This repository contains configuration files required to build and start arkOS Vagrant images for VirtualBox x86_64. This is the `master` branch, which will build a stably-released version of arkOS. For development builds, check the `dev` branch.

To build and run:
```
vagrant up
```

To package: 
```
vagrant package --vagrantfile Vagrantfile.pkg
```

To run from package:
```
vagrant init <name> arkos.box
vagrant up
```
