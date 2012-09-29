#Kidsruby debian package creator
This ruby script creates a kidsruby debian installer package which is compatiable with Ubuntu 11.04, 11.10, 12.04, Debian 6, 7 and raspbian.

This script depends upon Rake and Git, so to configure your system for script generation run 'bundle install' in your kidsrubyinstaller-debian project root directory.

A debian package is then created by issuing:
  rake deb:make
  
Which will create a debian installer based upon the current Kidsruby master branch and place the debain package in the kidsrubyinstaller-debian project root directory.

The package can be installed through your systems debian package installer or by issuing the commands

sudo dpkg -i kidsruby-{version}.deb; sudo apt-get install -f;
