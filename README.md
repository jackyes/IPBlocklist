# IPBlocklist
Script for downloading many ip blocklist and merge in one ipset, using iptable and ipset we can use huge blocklist with less performance impact.

#Requirements:  
* **ipset**  
  On RHEL/CentOS:  
    `yum install ipset`  
  On Debian:  
    `apt install ipset`
* **iptables**
* **wget**  
  On RHEL/CentOS:  
    `yum install wget`  
  On Debian:  
    `apt install wget`  

#Usage:  
`sh CreateBlocklist.sh`  
Optional:  
Add it to cron `crontab -e`  
Add this line:  
`30 2 * * * sh /path/to/script/CreateBlocklist.sh > /path/to/script/Create.log`  
Execute the script at 2.30 AM everyday and save output to /path/to/script/Create.log

