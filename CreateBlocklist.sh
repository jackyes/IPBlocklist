#!/bin/bash

########## CONFIG
#___________________________
#
# A firewall blacklist composed from IP lists, providing maximum protection with minimum false positives.
# Suitable for basic protection on all internet facing servers, routers and firewalls.
# includes: bambenek_c2 dshield feodo fullbogons palevo spamhaus_drop spamhaus_edrop sslbl zeus_badips ransomware_rw)
FIREHOL_LEVEL1=1
#____________________________
# An ipset made from blocklists that track attacks, during about the last 48 hours.
# (includes: blocklist_de dshield_1d greensnow openbl_1d virbl)
FIREHOL_LEVEL2=1
#____________________________
# An ipset made from blocklists that track attacks, spyware, viruses.
# It includes IPs than have been reported or detected in the last 30 days.
# (includes: bruteforceblocker ciarmy dragon_http dragon_sshpauth dragon_vncprobe dshield_30d dshield_top_1000
# malc0de maxmind_proxy_fraud myip openbl_30d shunlist snort_ipfilter sslbl_aggressive talosintel_ipfilter zeus vxvault)
FIREHOL_LEVEL3=1
#____________________________
# An ipset made from blocklists that track attacks, but may include a large number of false positives.
# (includes: cleanmx_viruses blocklist_net_ua botscout_30d cruzit_web_attacks cybercrime haley_ssh
# iblocklist_hijacked iblocklist_spyware iblocklist_webexploit ipblacklistcloud_top iw_wormlist malwaredomainlist)
FIREHOL_LEVEL4=0
#____________________________
# A web server IP blacklist made from blocklists that track IPs that should never be your web users.
# (This list includes IPs that are servers hosting malware, bots, etc or users having a long criminal history.
# This list is to be used on top of firehol_level1, firehol_level2, firehol_level3 and possibly firehol_proxies
# or firehol_anonymous) . (includes: hphosts_emd hphosts_exp hphosts_fsa hphosts_hjk hphosts_psh hphosts_wrz
# maxmind_proxy_fraud myip pushing_inertia_blocklist stopforumspam_toxic)
FIREHOL_WEBSERVER=0
#____________________________
# An ipset that includes all the anonymizing IPs of the world. (includes: anonymous bm_tor dm_tor firehol_proxies tor_exits)
FIREHOL_ANONYMOUS=0
#____________________________
# An ipset made from blocklists that track abusers in the last 30 days.
# (includes: cleantalk_new_30d cleantalk_updated_30d php_commenters_30d php_dictionary_30d php_harvesters_30d
# php_spammers_30d stopforumspam sblam)
FIREHOL_ABUSERS30D=0
#____________________________
# List of ip related to advertising and tracking
YOYO_ADLIST=1
#____________________________

##Enable to remove specified ip from list
ENABLE_REMOVING=1
##Set the iptables chain to block on
IPTABLESCHAIN="FORWARD"
##Block if ip is blacklisted and present as source (src) or destination (dst) or both (src,dst)
BLOCKON="dst"

###Change accordingly to your system
IPT="/sbin/iptables"
IPTRST="/sbin/iptables-restore"
IPSET="/sbin/ipset"
BASE="/etc"
FOLDER_BL="sysconfig"
BLACKLIST="$BASE/$FOLDER_BL/blocklist"
WHITELIST="$BASE/$FOLDER_BL/whitelist" #Manually create this file
#___________________________________

rm $BASE/$FOLDER_BL/bl.tmp
rm $BASE/$FOLDER_BL/bl1.tmp
rm $BASE/$FOLDER_BL/b2.tmp
rm $BASE/$FOLDER_BL/blocklist

if [ $FIREHOL_LEVEL1 -ne 0 ]; then
        wget -t 3 --no-verbose https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset -O $BASE/$FOLDER_BL/firehol_level1.tmp
        cat $BASE/$FOLDER_BL/firehol_level1.tmp > $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in firehol_level1  %s \n"  `cat $BASE/$FOLDER_BL/firehol_level1.tmp | wc -l`
        rm $BASE/$FOLDER_BL/firehol_level1.tmp
fi

if [ $FIREHOL_LEVEL2 -ne 0 ]; then
        wget -t 3 --no-verbose https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level2.netset -O $BASE/$FOLDER_BL/firehol_level2.tmp
        cat $BASE/$FOLDER_BL/firehol_level2.tmp >> $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in firehol_level2  %s \n"  `cat $BASE/$FOLDER_BL/firehol_level2.tmp | wc -l`
        rm $BASE/$FOLDER_BL/firehol_level2.tmp
fi

if [ $FIREHOL_LEVEL3 -ne 0 ]; then
        wget -t 3 --no-verbose https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level3.netset -O $BASE/$FOLDER_BL/firehol_level3.tmp
                cat $BASE/$FOLDER_BL/firehol_level3.tmp >> $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in firehol_level3  %s \n"  `cat $BASE/$FOLDER_BL/firehol_level3.tmp | wc -l`
        rm $BASE/$FOLDER_BL/firehol_level3.tmp
fi

if [ $FIREHOL_LEVEL4 -ne 0 ]; then
        wget -t 3 --no-verbose https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level4.netset -O $BASE/$FOLDER_BL/firehol_level4.tmp
        cat $BASE/$FOLDER_BL/firehol_level4.tmp >> $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in firehol_level4  %s \n"  `cat $BASE/$FOLDER_BL/firehol_level4.tmp | wc -l`
        rm $BASE/$FOLDER_BL/firehol_level4.tmp
fi

if [ $FIREHOL_WEBSERVER -ne 0 ]; then
        wget -t 3 --no-verbose https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_webserver.netset -O $BASE/$FOLDER_BL/firehol_webserver.tmp
        cat $BASE/$FOLDER_BL/firehol_webserver.tmp >> $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in firehol_webserver  %s \n"  `cat $BASE/$FOLDER_BL/firehol_webserver.tmp | wc -l`
        rm $BASE/$FOLDER_BL/firehol_webserver.tmp
fi

if [ $FIREHOL_ANONYMOUS -ne 0 ]; then
        wget -t 3 --no-verbose https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_anonymous.netset -O $BASE/$FOLDER_BL/firehol_anonymous.tmp
        cat $BASE/$FOLDER_BL/firehol_anonymous.tmp >> $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in firehol_anonymous  %s \n"  `cat $BASE/$FOLDER_BL/firehol_anonymous.tmp | wc -l`
        rm $BASE/$FOLDER_BL/firehol_anonymous.tmp
fi

if [ $FIREHOL_ABUSERS30D -ne 0 ]; then
        wget -t 3 --no-verbose https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_abusers_30d.netset -O $BASE/$FOLDER_BL/firehol_abusers_30d.tmp
        cat $BASE/$FOLDER_BL/firehol_abusers_30d.tmp >> $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in firehol_abusers_30d  %s \n"  `cat $BASE/$FOLDER_BL/firehol_abusers_30d.tmp | wc -l`
        rm $BASE/$FOLDER_BL/firehol_abusers_30d.tmp
fi

if [ $YOYO_ADLIST -ne 0 ]; then
        wget -t 3 --no-verbose "http://pgl.yoyo.org/adservers/iplist.php?ipformat=plain&showintro=0&mimetype=plaintext" -O $BASE/$FOLDER_BL/yoyo_ad.tmp
        cat $BASE/$FOLDER_BL/yoyo_ad.tmp >> $BASE/$FOLDER_BL/bl.tmp
        printf "\n Amount of lines in YOYO_ADLIST  %s \n"  `cat $BASE/$FOLDER_BL/yoyo_ad.tmp | wc -l`
        rm $BASE/$FOLDER_BL/yoyo_ad.tmp
fi

printf "\n Amount of lines in the combined blocklist before any cleanup is done %s \n"  `cat $BASE/$FOLDER_BL/bl.tmp | wc -l`
printf "\n Remove comments etc."

cat $BASE/$FOLDER_BL/bl.tmp | sort | uniq > $BASE/$FOLDER_BL/bl1.tmp
sed /#/d $BASE/$FOLDER_BL/bl1.tmp > $BASE/$FOLDER_BL/bl2.tmp

if [ $ENABLE_REMOVING -ne 0 ]; then
        ### use this to remove ipadress or range from the blocklist (if needed)
        ### Add ip(s), one per line, in $BASE/$FOLDER_BL/whitelist
        awk '{if (f==1) { r[$0] } else if (! ($0 in r)) { print $0 } } ' f=1 $BASE/$FOLDER_BL/whitelist f=2 $BASE/$FOLDER_BL/bl2.tmp > $BASE/$FOLDER_BL/blocklist
else
        mv $BASE/$FOLDER_BL/bl2.tmp > $BASE/$FOLDER_BL/blocklist
fi



printf "\n Amount of lines in final blocklist %s \n"  `cat $BASE/$FOLDER_BL/blocklist | wc -l`
echo "Starting At:"
date
echo "Adding blocklist to ipset"
$IPSET create -exist blocklist hash:net hashsize 16777216 maxelem 16777216
$IPSET flush blocklist
        for BLACKLIST in `cat $BLACKLIST`; do
                $IPSET add  blocklist $BLACKLIST
        done
echo "Finish At:"
date

$IPT -I $IPTABLESCHAIN -m set --match-set blocklist $BLOCKON -j DROP
