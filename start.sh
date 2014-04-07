#!/bin/sh
#echo -e "\033[1m This is bold text. \033[0m"
clear
echo "========================================================================="
rm ./*.json

contype="Content-Type: application/json" # charset=UTF-8
accept="Accept: application/json"

API='http://lotto-dev.lnk.co.ua/api/v1/'

printf "\nLogin user\n%suser/login\n" "$API"
login_string=$(curl -s -H "$accept" -H "$contype"  -c cookie_storage -X POST --data @login {$API}user/login) 
#-H "$token"
echo $login_string
sessid=$(expr "$login_string" : '.*"sessid":"\([^"]*\)"')
session_name=$(expr "$login_string" : '.*"session_name":"\([^"]*\)"')
uid=$(expr "$login_string" : '.*"uid":\([0-9]*\)')
TOKEN=$(expr "$login_string" : '.*"token":"\([^"]*\)"')
echo "\033[1m sessid=\033[0m $sessid"
echo "\033[1m session_name=\033[0m $session_name"
echo "\033[1m uid=\033[0m $uid"
echo "\033[1m token=\033[0m $TOKEN" 
token="X-CSRF-Token: $TOKEN"
cookie="$session_name=$sessid"
echo "\033[1m cookie=\033[0m $cookie"


printf "\nGet settings\n%ssettings\n" "$API"
#settings_string=$(curl -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}settings)
settings_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}settings | grep -Fi http)
echo "$settings_string"

printf "\nUpdate user \n%suser/%s\n" "$API" "$uid"
update_user_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X PUT -d @userupdate {$API}user/{$uid} | grep -Fi http)
echo "$update_user_string"

printf "\nGet history user \n%suser/%s/tickets/\n" "$API" "$uid"
user_tickets_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}user/{$uid}/tickets | grep -Fi http)
echo "$user_tickets_string"

printf "\nGet 1 ticket user \n%sticket/497\n" "$API"
user_1ticket_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}ticket/497 | grep -Fi http)
echo "$user_1ticket_string"

printf "\nGet user payment methosds \n%suser/%s/payment_methods\n" "$API" "$uid"
user_payment_string=$(curl -s -I -H "$accept" -H "$contype" -H "$token" -b cookie_storage -X GET {$API}user/{$uid}/payment_methods | grep -Fi http)
echo "$user_payment_string"

echo "\n\n"