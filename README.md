#BUILDCUCKOO-TRUSTY
Automated cuckoo build,<br />
This Automated script uses cuckoo-modified from brad,<br />
The installation tested on ubuntu 14.04 and its quite straight forward.<br />

#PREQUISITES:<br />
Ubuntu 14.04 machine with user named "cuckoo", VT-X/vhv enabled, Internet, Oracle java8 and 100GB free disk space at least.<br />

#INSTALLATION<br />
git clone https://github.com/hemzaz/buildcuckoo-trusty.git <br />
cd buildcuckoo-trusty <br />
./buildworld.sh <br />
cd .. <br />
**IMPORTANT** <br />
make sure that cuckoo is in vboxusers group and can access to all app directories <br />

#DB CREATION <br />
run the script setupmysql.sh, provide valid credentials, save the connection string for the sandbox configuration <br />

#SANDBOX CONFIGURATION <br />
Edit /usr/local/suricata/etc/suricata.yaml according to your network, machine and needs <br />
Edit /etc/tor/torrc - tor configuration to set tor routing for your sandbox <br />
Edit /data/cuckoo/conf/cuckoo.conf, paste the mysql connetion string under the corresponding block <br />
Edit /data/cuckoo/conf/api.conf, enable all wanted api interface options <br />
Edit /data/cuckoo/conf/processing.conf, enable suricata, set the path to suricata executables and configuration file, uncomment wanted log moudles, enable virustotal lookup and place your private API key if you have. <br />
Edit /data/cuckoo/conf/reporting.conf, enable all html modules, pdf creation module and mongo module <br />
Edit /data/cuckoo/conf/virtualbox.conf, fill in your virtual machine details, name, alias, tag, snapshot name, architecture, memory profile and ip address <br />
Edit /data/cuckoo/conf/auxiliary.conf, enable virustotal dl - place your api key if you do have one, enable display_et_portal/display_pt_portal <br />

#VIRTUALBOX CONFIGURATION <br /> 
#(the traditional way indeed [there is an other way which involvs some black magic :)])<br />
Create host only interface called vboxnet0 <br />
Create machine and assign the hostonly interface to the machine <br />
Assign static ip address as you filled in virtualbox.conf <br />
Assign dns server addresses as vboxnet0 as primary and 8.8.8.8 as secondary
Install your wanted software profile, flash, chrome, java, etc <br />
Enable autologon <br />
Disable ie welcome screen <br />
At the end take a snapshot of the machine and call it running
Shutdown the machine and restore from the freshly born snapshot. <br />

#MOLOCH CONFIGURATION <br />
Start moloch and elasticsearch services with: /etc/init.d/moloch start <br />
Browse into /data/moloch <br />
Edit etc/config.ini  <br />
Set a listening address <br />
add a BPF filter to except your own network from being sniffed <br />
Under bpf= add not src net (<your ur own eth0 network>/24) and dst net (<your own eth0 network>/24)<br />
Ensure that elasticsearch service is running.(moloch is shipped with it's own elasticsearch service so there is no need to install from repo) <br />
Run moloch_init.sh script in order to initialize the local elasticsearch db <br />
Run moloch_add_user.sh script in order to create user and password for moloch <br />
Restart moloch_add_user.sh and elasticsearch services with /etc/init.d/moloch restart <br />
Browse to https://localhost:8005 and ensure that moloch is up and running <br />
*moloch integration to cuckoo* <br />
Edit /data/cuckoo/conf/reporting.conf <br />
Locate the block that refers to moloch <br />
Enable moloch, set moloch address, credentials and elasticsearch instance name (derived from moloch starting script)<br />
Restart cuckoo services and ensure its added to the web dashboard<br />

#SANDBOX STARTING <br />
Ensure that suricata is up and running with ps aux |grep -i suricata - if not, start it with /etc/init.d/suricata start <br />
run /etc/init.d/iptables start <br />
Run sudo /sbin/routetor & <br />
Run sudo torstart <your vboxnet0 interface ip>
Under cuckoo directory run python cuckoo.py -d <br />
Under cuckoo/web directory run python manage.py runserver 0.0.0.0:8000 <br />
Under cuckoo/utils directory run python api.py -H 0.0.0.0:8090 <br />
VOILA! you can submit samples now! browse to http://yourcuckooserver:8000 and start playing!
