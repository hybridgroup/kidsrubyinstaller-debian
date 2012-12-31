#Kidsruby debian package creator
This ruby script creates a kidsruby debian installer package which is compatiable with Ubuntu 10.04 - 12.10 and Raspbian

This script requires ruby and bundler, it is suggested you use [rvm](https://rvm.io/)

To configure your system and create the package
~~~
  $ sudo apt-get install bison openssl libreadline5 libreadline-dev git-core zlib1g \
    zlib1g-dev libsqlite3-0 libsqlite3-dev sqlite3 libreadline-dev libreadline6-dev \
    libxml2-dev autoconf xorg-dev libgl1-mesa-dev libglu1-mesa-dev libc6-dev libssl-dev \
    libmysql++-dev libsqlite3-dev make build-essential libssl-dev libgpm2 vim libqt4-dev cmake \
    libyaml-dev g++ libpango1.0-dev libboost-dev libopenal-dev libsndfile-dev libxdamage-dev \
    libsdl-ttf2.0-dev libfreeimage3 libfreeimage-dev libxinerama-dev wget libphonon4 curl
  $ git clone https://github.com/hybridgroup/kidsrubyinstaller-debian.git
  $ cd ./kidsrubyinstaller-debian
  $ bundle install
  $ rake deb:make
~~~
These commands will create a debian installer based upon the current Kidsruby release branch and place the debain package in the kidsrubyinstaller-debian project root directory.

The package can be installed through your systems debian package installer or by issuing the command
~~~
  $ sudo dpkg -i kidsruby.deb
~~~
NOTE: For a raspberry pi compatible package you must build this package on a raspberry pi. It is also recommended that you do not overlock your raspberry pi,
      if you do unpredictable results may occur.  
      This script has been tested to build on Ubuntu 10.04 LTS for maximum Ubuntu compatibility.
