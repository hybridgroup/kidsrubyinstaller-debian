#Kidsruby debian package creator
This ruby script creates a kidsruby debian installer package which is compatiable with debian based distributions

This script requires ruby and bundler, it is suggested you use [rvm](https://rvm.io/)

To configure your system and create the package
~~~
  $ sudo apt-get -y install libc6-dev libssl-dev libmysql++-dev libsqlite3-dev make build-essential libssl-dev libreadline6-dev zlib1g-dev git libqt4-dev cmake libyaml-dev g++ libgl1-mesa-dev libpango1.0-dev libboost-dev libopenal-dev libsndfile-dev libxdamage-dev libsdl-ttf2.0-dev libfreeimage3 libfreeimage-dev libxinerama-dev wget
  $ git clone https://github.com/hybridgroup/kidsrubyinstaller-debian.git
  $ cd ./kidsrubyinstaller-debian
  $ bundle install
  $ rake deb:make
~~~
These commands will create a debian installer based upon the current Kidsruby master branch and place the debain package in the kidsrubyinstaller-debian project root directory.

NOTE: For a raspberry pi compatible package you must build this package on a raspberry pi
