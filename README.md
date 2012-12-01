#Kidsruby debian package creator
This ruby script creates a kidsruby debian installer package which is compatiable with Ubuntu 11.04, 11.10, 12.04,Debian 6 and raspberry pi.

To configure your system for package creation
~~~
  $ sudo apt-get -y install libc6-dev libssl-dev libmysql++-dev libsqlite3-dev make build-essential libssl-dev libreadline6-dev zlib1g-dev git libqt4-dev cmake libyaml-dev
  $ sudo gem install bundler
  $ git clone https://github.com/hybridgroup/kidsrubyinstaller-debian.git
  $ cd ./kidsrubyinstaller-debian
  $ bundle install
  $ rake deb:make
~~~
These commands will create a debian installer based upon the current Kidsruby master branch and place the debain package in the kidsrubyinstaller-debian project root directory.
