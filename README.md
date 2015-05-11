## arkOS Vagrant Image

This repository contains configuration files required to build and start arkOS Vagrant images for VirtualBox x86_64. This is the `dev` branch, which will build a development version of arkOS from current masters. For stable builds, check the `master` branch.

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
vagrant init <name> arkos-dev.box
vagrant up
```
