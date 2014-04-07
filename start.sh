#!/bin/sh
#echo -e "\033[1m This is bold text. \033[0m"
clear

#rm ./*.json

declare -i ISDEBUG=0
if [[ "$1" == "-d" ]]; then
	ISDEBUG=1
	echo "========================================================================="
	echo "DEBUG MODE"
fi

contype="Content-Type: application/json" # charset=UTF-8
accept="Accept: application/json"

API='http://lotto-dev.lnk.co.ua/api/v1/'

declare -i validator=0
declare -i counter=0
function validator
{
	counter=$((counter+1))
	if [[ $1 == *"200 OK"* ]]; then
		validator=$((validator+1))
	fi
} 

login_string=$(curl -s -H "$accept" -H "$contype"  -c cookie_storage -X POST -d @login {$API}user/login) 
sessid=$(expr "$login_string" : '.*"sessid":"\([^"]*\)"')
session_name=$(expr "$login_string" : '.*"session_name":"\([^"]*\)"')
uid=$(expr "$login_string" : '.*"uid":\([0-9]*\)')
TOKEN=$(expr "$login_string" : '.*"token":"\([^"]*\)"')
token="X-CSRF-Token: $TOKEN"
cookie="$session_name=$sessid"

if [[ $ISDEBUG == 1 ]]; then
	printf "\nLogin user\n%suser/login\n" "$API"
	echo $login_string
	echo "\033[1m sessid=\033[0m $sessid"
	echo "\033[1m session_name=\033[0m $session_name"
	echo "\033[1m uid=\033[0m $uid"
	echo "\033[1m token=\033[0m $TOKEN" 	
	echo "\033[1m cookie=\033[0m $cookie"
fi

settings_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}settings | grep -Fi http)
validator "$settings_string"
if [[ $ISDEBUG == 1 ]]; then
	printf "\nGet settings\n%ssettings\n" "$API"
	echo "$settings_string"
fi



update_user_string=$(curl -s -i -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X PUT -d @userupdate {$API}user/{$uid} | grep -Fi http)
validator "$update_user_string"
if [[ $ISDEBUG == 1 ]]; then
	printf "\nUpdate user \n%suser/%s\n" "$API" "$uid"	
	echo "$update_user_string"
fi



user_tickets_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}user/{$uid}/tickets | grep -Fi http)
validator "$user_tickets_string"
if [[ $ISDEBUG == 1 ]]; then
	printf "\nGet history user \n%suser/%s/tickets/\n" "$API" "$uid"	
	echo "$user_tickets_string"
fi


user_1ticket_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}ticket/497 | grep -Fi http)
validator "$user_1ticket_string"

if [[ $ISDEBUG == 1 ]]; then
	printf "\nGet 1 ticket user \n%sticket/497\n" "$API"
	echo "$user_1ticket_string"
	echo "\n"
fi

if [[ $validator == $counter ]]; then
	echo "\033[1m PASSED \033[0m "
else
	echo "\033[1m FAILED \033[0m "
fi
#printf "\nGet user payment methosds \n%suser/%s/payment_methods\n" "$API" "$uid"
#user_payment_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}user/{$uid}/payment_methods | grep -Fi http)
#echo "$user_payment_string"