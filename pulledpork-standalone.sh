#! /bin/sh
sudo apt-get install -y libcrypt-ssleay-perl libwww-Perl libswitch-perl libwww-Perl libcrypt-ssleay-perl
echo "alert http any any -> any any (msg:\"FILE store all\"; filestore; flowbits:noalert; sid:44444; rev:1;)" > local.rules
echo "alert http any any -> any any (msg:\"FILE store all\"; filestore; flowbits:noalert sid:15; rev:1;)" >> local.rules
sudo cp local.rules /etc/suricata/rules/
#cp rules/files.rules /usr/local/suricata/etc/etpro/

sudo git clone https://github.com/EmergingThreats/et-luajit-scripts /etc/suricata/rules/et-luajit-scripts
sudo cp /etc/suricata/rules/et-luajit-scripts/* /etc/suricata/rules
read -p  "Enter your ETPRO oinkcode if you have one [ENTER]: " oinkcode
if ["$oinkcode" = ""]; then
 rule_url="https://rules.emergingthreatspro.com/|emerging.rules.tar.gz|open"
else
 rule_url="https://rules.emergingthreatspro.com/|etpro.rules.tar.gz|$oinkcode"
fi

echo "rule_url=$rule_url
ignore=local.rules
temp_path=/tmp
rule_path=/etc/suricata/rules/all.rules
sid_msg=/etc/suricata/rules/sid-msg.map
sid_changelog=/var/log//suricata/etpro_sid_changes.log
disablesid=/etc/suricata/rules/disablesid.conf
engine=suricata
suricata_version=3.0.0
version=0.6.0
" > pp.config
#sudo cp pp.config /etc/suricata/rules/pp.config
#wget https://pulledpork.googlecode.com/files/pulledpork-0.6.1.tar.gz
tar -xzvf pulledpork-0.6.1.tar.gz
cd pulledpork-0.6.1
patch -p1 < ../pulledpork-etpro-fix.diff
sudo cp -f pulledpork.pl /usr/local/bin/
echo "#!/bin/sh
/usr/local/bin/pulledpork.pl -c /etc/suricata/rules/pp.config
cd /etc/suricata/rules/et-luajit-scripts/ && git pull
cp -f /etc/suricata/rules/et-luajit-scripts/*.lua /etc/suricata/rules
cp -f /etc/suricata/rules/et-luajit-scripts/d*.rules /etc/suricata/rules
" > ruleupdates.sh
chmod +x ruleupdates.sh
echo "pcre:SURICATA (STMP|IP|TCP|ICMP|HTTP|STREAM)" >> etc/disablesid.conf 
echo "pcre:GPL NETBIOS" >> etc/disablesid.conf
sudo cp ruleupdates.sh /usr/local/bin/
sudo cp ../pp.config /etc/suricata/rules
sudo cp etc/modifysid.conf /etc/suricata/rules
sudo cp etc/enablesid.conf /etc/suricata/rules
sudo cp etc/disablesid.conf /etc/suricata/rules
cd ..
ruleupdates.sh

