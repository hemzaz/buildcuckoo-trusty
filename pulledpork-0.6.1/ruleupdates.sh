#!/bin/sh
/usr/local/bin/pulledpork.pl -c /etc/suricata/rules/pp.config
cd /etc/suricata/rules/et-luajit-scripts/ && git pull
cp -f /etc/suricata/rules/et-luajit-scripts/*.lua /etc/suricata/rules
cp -f /etc/suricata/rules/et-luajit-scripts/d*.rules /etc/suricata/rules

