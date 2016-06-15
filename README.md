# IPBlocklist
Script for downloading many ip blocklist and merge in one ipset, using iptable and ipset we can use huge blocklist with less performance impact.

#Requirements:  
* **ipset**  
  On RHEL/CentOS:  
    `yum install ipset`  
  On Debian:  
    `apt install ipset`
* **iptables**
* **git**  
  On RHEL/CentOS:  
    `yum install git`  
  On Debian:  
    `apt install git` 
* **wget**  
  On RHEL/CentOS:  
    `yum install wget`  
  On Debian:  
    `apt install wget` 
* **iprange**  
  On RHEL/CentOS:  
    `yum install autoconf automake make`
    `yum groupinstall "Development tools"`  
  On Debian:  
    `apt install autoconf automake make build-essential` 
      
    `git clone https://github.com/firehol/iprange.git`  
    `cd iprange`  
    `./autogen.sh`    
    `./configure --disable-man && make && make install`    
    



#Usage:  
Edit the script config section acordingly to your needs. (ex. location of iptables and ipset, wich blocklist to use, etc..)  
`./CreateBlocklist.sh`  
Optional:  
Add it to cron `crontab -e`  
(Is suggested to create copy of your iptables rules and reset it before running this script, use `iptables-save` and `iptables-restore`)  
Add this line:  
`30 2 * * * sh /path/to/script/CreateBlocklist.sh > /path/to/script/Create.log`  
Execute the script at 2.30 AM everyday and save output to /path/to/script/Create.log

#Avaible blocklist:
- [x] FIREHOL_LEVEL1  
A firewall blacklist composed from IP lists, providing maximum protection with minimum false positives.
Suitable for basic protection on all internet facing servers, routers and firewalls.
includes: bambenek_c2 dshield feodo fullbogons palevo spamhaus_drop spamhaus_edrop sslbl zeus_badips ransomware_rw)
- [X] FIREHOL_LEVEL2  
An ipset made from blocklists that track attacks, during about the last 48 hours.
(includes: blocklist_de dshield_1d greensnow openbl_1d virbl)
- [x] FIREHOL_LEVEL3  
An ipset made from blocklists that track attacks, spyware, viruses.
It includes IPs than have been reported or detected in the last 30 days.
(includes: bruteforceblocker ciarmy dragon_http dragon_sshpauth dragon_vncprobe dshield_30d dshield_top_1000
malc0de maxmind_proxy_fraud myip openbl_30d shunlist snort_ipfilter sslbl_aggressive talosintel_ipfilter zeus vxvault)
- [x] FIREHOL_LEVEL4
An ipset made from blocklists that track attacks, but may include a large number of false positives.
(includes: cleanmx_viruses blocklist_net_ua botscout_30d cruzit_web_attacks cybercrime haley_ssh
iblocklist_hijacked iblocklist_spyware iblocklist_webexploit ipblacklistcloud_top iw_wormlist malwaredomainlist)
- [x] FIREHOL_WEBSERVER  
A web server IP blacklist made from blocklists that track IPs that should never be your web users.
(This list includes IPs that are servers hosting malware, bots, etc or users having a long criminal history.
This list is to be used on top of firehol_level1, firehol_level2, firehol_level3 and possibly firehol_proxies
or firehol_anonymous) . (includes: hphosts_emd hphosts_exp hphosts_fsa hphosts_hjk hphosts_psh hphosts_wrz
maxmind_proxy_fraud myip pushing_inertia_blocklist stopforumspam_toxic)
- [x] FIREHOL_ANONYMOUS  
An ipset that includes all the anonymizing IPs of the world. (includes: anonymous bm_tor dm_tor firehol_proxies tor_exits)
- [x] FIREHOL_ABUSERS30D  
An ipset made from blocklists that track abusers in the last 30 days.
(includes: cleantalk_new_30d cleantalk_updated_30d php_commenters_30d php_dictionary_30d php_harvesters_30d
php_spammers_30d stopforumspam sblam)
- [x] YOYO_ADLIST  
List of ip related to advertising and tracking
