#!/bin/bash

jeshile='\e[40;38;5;82m' 
jo='\e[0m'  
red='\e[31m'
yellow='\e[0;93m'

echo " "
echo -e "${yellow} ┌──────────────────────────────────────────────┐ \e[0m"
echo -e "${yellow} │           installer mysql 5.5.62             │ \e[0m"
echo -e "${yellow} └──────────────────────────────────────────────┘ \e[0m"
echo " " 
sleep 5

echo " "
echo -e "${jeshile} ┌──────────────────────────────────────────────┐ \e[0m"
echo -e "${jeshile} │               Update System                  │ \e[0m"
echo -e "${jeshile} └──────────────────────────────────────────────┘ \e[0m"
echo " " 
sudo apt update
sudo apt install -y --force-yes lsb-core 

osname=$(lsb_release -si)
osrelease=$(lsb_release -sr)
oscodename=$(lsb_release -sc) 
osDisc=$(lsb_release -sd)
arch=$(uname -m)
file=/etc/rc.local

echo " "
echo -e "${jeshile} ┌──────────────────────────────────────────────┐ \e[0m"
echo -e "${jeshile} │            Checking System Version           │ \e[0m"
echo -e "${jeshile} └──────────────────────────────────────────────┘ \e[0m"
echo " " 
if [ "$osname" == "Ubuntu"  ]; then

if [ "$arch" == "x86_64"  ]; then
echo "" 
else
echo -e "${red} ┌──────────────────────────────────────────────┐ \e[0m"
echo -e "${red} │[+]        The system is not supported        │ \e[0m"
echo -e "${red} └──────────────────────────────────────────────┘ \e[0m"
exit 3
fi

else
echo -e "${red} ┌──────────────────────────────────────────────┐ \e[0m"
echo -e "${red} │[+]        The system is not supported        │ \e[0m"
echo -e "${red} └──────────────────────────────────────────────┘ \e[0m"
exit 3
fi

echo " "
echo -e "${jeshile} ┌──────────────────────────────────────────────┐ \e[0m"
echo -e "${jeshile} │         NEW password for your MySQL          │ \e[0m"
echo -e "${jeshile} └──────────────────────────────────────────────┘ \e[0m"
echo " " 
read -p "New password for the MySQL "root" user: " SQL
echo " "
echo -e "${jeshile} ┌──────────────────────────────────────────────┐ \e[0m"
echo -e "${jeshile} │            Install MySQL Server              │ \e[0m"
echo -e "${jeshile} └──────────────────────────────────────────────┘ \e[0m"
echo " " 

if [ "$osrelease" == "14.04"  ]; then
sudo apt install mysql-server
sleep 3
else
groupadd mysql
sleep 1
useradd -r -g mysql mysql
sleep 1
apt-get install libaio1
sleep 1
if [ "$osrelease" == "16.04" ] ; then 
sudo apt-get install libfile-copy-recursive-perl
sleep 1
sudo apt-get install sysstat  
fi
sleep 1
if [ "$osrelease" == "19.04" ] ; then 
sudo apt-get install libncurses5  
fi
sleep 1
cd /usr/local
wget https://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz
sleep 1
sudo tar -xvf mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz
sleep 1
sudo mv  mysql-5.5.62-linux-glibc2.12-x86_64 mysql
sleep 1
cd mysql
sleep 1
sudo chown -R mysql:mysql *
sleep 1
sudo scripts/mysql_install_db --user=mysql
sleep 1
echo -e " \n "
sleep 1
sudo chown -R root .
sleep 1
sudo chown -R mysql data
sleep 1
sudo cp support-files/my-medium.cnf /etc/my.cnf
sleep 1
sudo bin/mysqld_safe --user=mysql &
sleep 2
echo -e " \n "
sleep 1
sudo cp support-files/mysql.server /etc/init.d/mysql.server
sleep 1
sudo bin/mysqladmin -u root password $SQL 
sleep 1
sleep 1
ln -s /usr/local/mysql/bin/* /usr/local/bin/
sleep 1
sudo /etc/init.d/mysql.server start
sleep 1
sudo /etc/init.d/mysql.server status
sleep 1

if [ -f "$file" ]
then
sed --in-place '/exit 0/d' /etc/rc.local 
echo "sleep 2" >> /etc/rc.local
echo "sudo /etc/init.d/mysql.server start" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
else 
echo "#!/bin/sh -e" >> /etc/rc.local
echo "#">> /etc/rc.local
echo "# rc.local">> /etc/rc.local
echo "#">> /etc/rc.local
echo "# This script is executed at the end of each multiuser runlevel." >> /etc/rc.local
echo "# value on error." >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# In order to enable or disable this script just change the execution" >> /etc/rc.local
echo "# bits." >> /etc/rc.local
echo "#" >> /etc/rc.local
echo "# By default this script does nothing." >> /etc/rc.local
echo -e " \n " >> /etc/rc.local
echo "sleep 2" >> /etc/rc.local
echo "sudo /etc/init.d/mysql.server start" >> /etc/rc.local
echo "exit 0" >> /etc/rc.local
sleep 1
chmod +x /etc/rc.local  
fi


fi

echo -e " \n "
read -p "$(tput setaf 1)Reboot now (y/n)?$(tput sgr0) " CONT
if [ "$CONT" == "y" ] || [ "$CONT" == "Y" ]; then
reboot
fi

exit 3

fi

