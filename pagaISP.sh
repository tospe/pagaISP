#!/bin/bash

clear

MOREF=`speedtest-cli`

#echo "$MOREF"
rm logs.json

echo "{" >> logs.json
UP_DOW_LOAD=""
while read line; do

    LINE_ARRAY=($line)
    if [ "Testing" = ${LINE_ARRAY[0]} ] && [ "from" = ${LINE_ARRAY[1]} ]  ; then

        ISP=`echo ${LINE_ARRAY[@]:2:${#LINE_ARRAY[@]}-3}`
        echo "\t\"isp\": \"$ISP\"," >> logs.json

        a=`echo ${LINE_ARRAY[ ${#LINE_ARRAY[@]}-1]}]`
        PUBLIC_IP=`echo ${a:1:${#a}-6}`
        echo "\t\"public_ip\": \"$PUBLIC_IP\"," >> logs.json
    fi
    if [ "Hosted" = ${LINE_ARRAY[0]} ]; then
        SERVER=`echo ${LINE_ARRAY[2]}`
        PING=`echo ${LINE_ARRAY[ ${#LINE_ARRAY[@]}-2 ]}${LINE_ARRAY[ ${#LINE_ARRAY[@]}-1 ]}`
        echo "\t\"server\": \"$SERVER\"," >> logs.json
        echo "\t\"ping\": \"$PING\"," >> logs.json
    fi
    if [ "Download:" = ${LINE_ARRAY[0]} ] || [ "Upload:" = ${LINE_ARRAY[0]} ]; then
        u=`echo "${LINE_ARRAY[0]}" | tr '[:upper:]' '[:lower:]'`
        u=`echo ${u:0:${#u}-1}`
        UP_DOW_LOAD=`echo $UP_DOW_LOAD ${LINE_ARRAY[1]} ${LINE_ARRAY[2]}`
        echo "\t\"$u\": \"${LINE_ARRAY[1]} ${LINE_ARRAY[2]}\"," >> logs.json
    fi

done <<< "$MOREF"

echo $UP_DOW_LOAD
DATE=`date`
echo "\t\"timestamp\": \"$DATE\"" >> logs.json

echo "}" >> logs.json

echo "\tdate \t\t\t isp\t public_ip\tserver\tping\tdownload\tupload " >>logs.txt
echo "$DATE $ISP $PUBLIC_IP $SERVER $PING $UP_DOW_LOAD" >>logs.txt
nl logs.json











