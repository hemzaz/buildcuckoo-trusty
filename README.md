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
Edit /usr/local/suricata/etc/suricata.yaml according to your network, machine and needs
Edit /etc/tor/torrc - tor configuration to set tor routing for your sandbox
Edit /data/cuckoo/conf/cuckoo.conf, paste the mysql connetion string under the corresponding block
Edit /data/cuckoo/conf/api.conf, enable all wanted api interface options
Edit /data/cuckoo/conf/processing.conf, enable suricata, set the path to suricata executables and configuration file, uncomment wanted log moudles
enable virustotal lookup and place your private API key if you have.
Edit /data/cuckoo/conf/reporting.conf, enable all html modules, pdf creation module and mongo module
Edit /data/cuckoo/conf/virtualbox.conf, fill in your virtual machine details, name, alias, tag, snapshot name, architecture, memory profile and ip address
Edit /data/cuckoo/conf/auxiliary.conf, enable virustotal dl - place your api key if you do have one, enable display_et_portal/display_pt_portal

#virtualbox configuration
create host only interface called vboxnet0
create machine and assign the hostonly interface to the machine
assign static ip address as you filled in virtualbox.conf
assign dns server addresses as vboxnet0 as primary and 8.8.8.8 as secondary
install your wanted software profile, flash, chrome, java, etc
enable autologon
disable ie welcome screen
at the end take a snapshot of the machine and call it running
shutdown the machine and restore from the freshly born snapshot.

#sandbox starting
under cuckoo directory run python cuckoo.py -d
under cuckoo/web directory run python manage.py runserver 0.0.0.0:8000
under cuckoo/utils directory run python api.py -H 0.0.0.0:8090
