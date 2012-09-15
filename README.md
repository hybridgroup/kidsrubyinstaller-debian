#Kidsruby debian package creator
This ruby script creates a kidsruby debian installer package which is compatiable with Ubuntu 11.04, 11.10, 12.04 and Debian 6.

This script depends upon Rake and Git, so to configure your system for script generation run 'bundle install' in your kidsrubyinstaller-debian project root directory.

A debian package is then created by issuing:
  rake deb:make
  
Which will create a debian installer based upon the current Kidsruby master branch and place the debain package in the kidsrubyinstaller-debian project root directory.
