# buildcuckoo-trusty
Automated cuckoo build,<br />
This Automated script uses cuckoo-modified from brad,<br />
The installation tested on ubuntu 14.04 and its quite straight forward.<br />

#prequisites:<br />
ubuntu 14.04 machine with user named "cuckoo", VT-X/vhv enabled, internet,oracle java8 and 100GB free disk space at least.<br />

#installation<br />
git clone https://github.com/hemzaz/buildcuckoo-trusty.git <br />
cd buildcuckoo-trusty <br />
./buildworld.sh <br />
cd .. <br />
**important** <br />
make sure that cuckoo is in vboxusers group and can access to all app directories <br />

#database creation <br />
run the script setupmysql.sh, provide valid credentials, save the connection string for the sandbox configuration <br />

#sandbox configuration <br />
Edit /usr/local/suricata/etc/suricata.yaml according to your network, machine and needs <br />
Edit /etc/tor/torrc - tor configuration to set tor routing for your sandbox <br />
Edit /data/cuckoo/conf/cuckoo.conf, paste the mysql connetion string under the corresponding block <br />
Edit /data/cuckoo/conf/api.conf, enable all wanted api interface options <br />
Edit /data/cuckoo/conf/processing.conf, enable suricata, set the path to suricata executables and configuration file, uncomment wanted log moudles <br />
enable virustotal lookup and place your private API key if you have. <br />
Edit /data/cuckoo/conf/reporting.conf, enable all html modules, pdf creation module and mongo module <br />
Edit /data/cuckoo/conf/virtualbox.conf, fill in your virtual machine details, name, alias, tag, snapshot name, architecture, memory profile and ip address <br />
Edit /data/cuckoo/conf/auxiliary.conf, enable virustotal dl - place your api key if you do have one, enable display_et_portal/display_pt_portal <br />

#virtualbox configuration (the traditional way [there is an other way which involvs some black magic (:])<br />
create host only interface called vboxnet0 <br />
create machine and assign the hostonly interface to the machine <br />
assign static ip address as you filled in virtualbox.conf <br />
assign dns server addresses as vboxnet0 as primary and 8.8.8.8 as secondary
install your wanted software profile, flash, chrome, java, etc <br />
enable autologon <br />
disable ie welcome screen <br />
at the end take a snapshot of the machine and call it running
shutdown the machine and restore from the freshly born snapshot. <br />

#sandbox starting <br />
under cuckoo directory run python cuckoo.py -d <br />
under cuckoo/web directory run python manage.py runserver 0.0.0.0:8000 <br />
under cuckoo/utils directory run python api.py -H 0.0.0.0:8090 <br />
