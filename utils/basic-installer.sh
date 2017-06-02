
wget --no-check-certificate https://github.com/cibinmathew/cbn_gits/raw/master/ported_files/cibin/.bashrc -O ~/.bashrc
wget --no-check-certificate https://github.com/cibinmathew/cbn_gits/raw/master/ported_files/cibin/.vimrc -O ~/.vimrc
wget --no-check-certificate https://github.com/cibinmathew/cbn_gits/raw/master/ported_files/cibin/lib.sh -O ~/lib.sh
wget --no-check-certificate https://github.com/cibinmathew/cbn_gits/raw/master/ported_files/cibin/misc_lib.sh -O ~/misc_lib.sh
wget --no-check-certificate https://github.com/cibinmathew/cbn_gits/raw/master/ported_files/cibin/set_defaults.sh -O ~/set_defaults.sh
wget --no-check-certificate https://github.com/cibinmathew/cbn_gits/raw/master/ported_files/cibin/myalias.sh -O ~/myalias.sh

# wget --no-check-certificate https://github.com/cibinmathew/cbn_gits/raw/master/ported_files/cibin/rc.conf -O ~/.config/ranger/rc.conf.sh


## TODO cd to tmp directory
mkdir ~/tmp-installers
cd ~/tmp-installers


## ranger
# We will also install some other applications that allow ranger to preview various file formats effectively.
# sudo apt-get update

#if debian
# sudo apt-get install ranger caca-utils highlight atool w3m poppler-utils mediainfo


# or
git clone https://github.com/hut/ranger.git
cd ranger
sudo make install

# git clone git://git.savannah.nongnu.org/ranger.git
# or
# tar xvf ranger-stable.tar.gz
# cd ranger-stable
# cd ranger


cd ~/tmp-installers

### FASD
git clone https://github.com/clvv/fasd.git
cd fasd
sudo make install









