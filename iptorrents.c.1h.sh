#!/usr/bin/env bash

version="0.0.0.1"

#### Checking Dependencies
if [[ ! -f "/bin/yad" ]] && [[ ! -f "/usr/bin/yad" ]]; then yad_missing="1"; fi
if [[ ! -f "/bin/curl" ]] && [[ ! -f "/usr/bin/curl" ]]; then curl_missing="1"; fi
if [[ ! -f "/bin/gawk" ]] && [[ ! -f "/usr/bin/gawk" ]]; then gawk_missing="1"; fi
if [[ ! -f "/bin/wget" ]] && [[ ! -f "/usr/bin/wget" ]]; then wget_missing="1"; fi
if [[ ! -f "/bin/grep" ]] && [[ ! -f "/usr/bin/grep" ]]; then grep_missing="1"; fi
if [[ ! -f "/bin/sed" ]] && [[ ! -f "/usr/bin/sed" ]]; then sed_missing="1"; fi
if [[ "$yad_missing" == "1" ]] || [[ "$curl_missing" == "1" ]] || [[ "$gawk_missing" == "1" ]] || [[ "$wget_missing" == "1" ]] || [[ "$grep_missing" == "1" ]] || [[ "$sed_missing" == "1" ]]; then
  IPTORRENTS_BAD_ICON=$(curl -s "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/iptorrents-bad.png" | base64 -w 0)
  echo " Error(s) | image='$IPTORRENTS_BAD_ICON' imageWidth=25"
  echo "---"
  if [[ "$yad_missing" == "1" ]]; then echo -e "\e[1mDependencie missing     :\e[0m sudo apt-get install yad | ansi=true font='Ubuntu Mono'"; fi
  if [[ "$curl_missing" == "1" ]]; then echo -e "\e[1mDependencie missing       :\e[0m sudo apt-get install curl | ansi=true font='Ubuntu Mono'"; fi
  if [[ "$gawk_missing" == "1" ]]; then echo -e "\e[1mDependencie missing       :\e[0m sudo apt-get install gawk | ansi=true font='Ubuntu Mono'"; fi
  if [[ "$wget_missing" == "1" ]]; then echo -e "\e[1mDependencie missing       :\e[0m sudo apt-get install wget | ansi=true font='Ubuntu Mono'"; fi
  if [[ "$grep_missing" == "1" ]]; then echo -e "\e[1mDependencie missing       :\e[0m sudo apt-get install grep | ansi=true font='Ubuntu Mono'"; fi
  if [[ "$sed_missing" == "1" ]]; then echo -e "\e[1mDependencie missing       :\e[0m sudo apt-get install sed | ansi=true font='Ubuntu Mono'"; fi
  echo "---"
  echo "Refresh | refresh=true"
  exit 1
fi

#### Checking if the folder of this extension is there (if not create it)
if [[ ! -d "$HOME/.config/argos/iptorrents" ]]; then
  mkdir -p $HOME/.config/argos/iptorrents
fi

#### Checking files versions (localy and remotely)
script_pastebin="https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/iptorrents.c.1h.sh"
local_version=$version
pastebin_version=`wget -O- -q "$script_pastebin" | grep "^version=" | sed '/grep/d' | sed 's/.*version="//' | sed 's/".*//'`

#### Comparing versions (updating if required)
vercomp () {
  if [[ $1 == $2 ]]
  then
    return 0
  fi
  local IFS=.
  local i ver1=($1) ver2=($2)
  for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
  do
    ver1[i]=0
  done
  for ((i=0; i<${#ver1[@]}; i++))
  do
    if [[ -z ${ver2[i]} ]]
    then
      ver2[i]=0
    fi
    if ((10#${ver1[i]} > 10#${ver2[i]}))
    then
      return 1
    fi
    if ((10#${ver1[i]} < 10#${ver2[i]}))
    then
      return 2
    fi
  done
  return 0
}
testvercomp () {
  vercomp $1 $2
  case $? in
    0) op='=';;
    1) op='>';;
    2) op='<';;
  esac
  if [[ $op != $3 ]]
  then
    echo "FAIL: Expected '$3', Actual '$op', Arg1 '$1', Arg2 '$2'"
  else
    echo "Pass: '$1 $op $2'"
  fi
}
compare=`testvercomp $local_version $pastebin_version '<' | grep Pass`
if [[ "$compare" != "" ]] ; then
  update_required="Update Available"
  (
  echo "0"
  echo "# Creating the updater." ; sleep 2
  touch ~/iptorrents-update.sh
  echo "25"
  echo "# Chmod of the updater." ; sleep 2
  chmod +x ~/iptorrents-update.sh
  echo "50"
  echo "# Editing the updater." ; sleep 2
  echo "#!/bin/bash" > ~/iptorrents-update.sh
  echo "(" >> ~/iptorrents-update.sh
  echo "echo \"75\"" >> ~/iptorrents-update.sh
  echo "echo \"# Update in progress.\" ; sleep 2" >> ~/iptorrents-update.sh
  echo "curl -o ~/.config/argos/iptorrents.c.1h.sh $script_pastebin" >> ~/iptorrents-update.sh
  echo "sed -i -e 's/\r//g' ~/.config/argos/iptorrents.c.1h.sh" >> ~/iptorrents-update.sh
  echo "echo \"100\"" >> ~/iptorrents-update.sh
  echo ") |" >> ~/iptorrents-update.sh
  echo "yad --undecorated --width=500 --progress --center --no-buttons --no-escape --skip-taskbar --image=\"$HOME/.config/argos/.cache-icons/updater.png\" --text-align=\"center\" --text=\"\rAn update for <b>iptorrents.c.1h.sh</b> was detected.\r\rLocal Version: <b>$local_version</b>\rRemote Version: <b>$pastebin_version</b>\r\r<b>Installation of the Update...</b>\r\" --auto-kill --auto-close" >> ~/iptorrents-update.sh  echo "75"
  echo "# Starting the updater." ; sleep 2
  bash ~/iptorrents-update.sh
  exit 1
) |
yad --undecorated --width=500 --progress --center --no-buttons --no-escape --skip-taskbar --image="$HOME/.config/argos/.cache-icons/updater.png" --text-align="center" --text="\rAn update for <b>iptorrents.c.1h.sh</b> was detected.\r\rLocal Version: <b>$local_version</b>\rRemote Version: <b>$pastebin_version</b>\r\r<b>Installation of the Update...</b>\r" --auto-kill --auto-close
fi

#### Checking the cache folder for icons (create if required)
icons_cache=`echo $HOME/.config/argos/.cache-icons`
if [[ ! -f "$icons_cache" ]]; then
  mkdir -p $icons_cache
fi
if [[ ! -f "$icons_cache/updater.png" ]] ; then curl -o "$icons_cache/updater.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/updater.png" ; fi
if [[ ! -f "$icons_cache/iptorrents.png" ]] ; then curl -o "$icons_cache/iptorrents.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/iptorrents.png" ; fi
if [[ ! -f "$icons_cache/iptorrents-bad.png" ]] ; then curl -o "$icons_cache/iptorrents-bad.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/iptorrents-bad.png" ; fi
if [[ ! -f "$icons_cache/iptorrents-big.png" ]] ; then curl -o "$icons_cache/iptorrents-big.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/iptorrents-big.png" ; fi
if [[ ! -f "$icons_cache/iptorrents-message.png" ]] ; then curl -o "$icons_cache/iptorrents-message.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/iptorrents-message.png" ; fi
if [[ ! -f "$icons_cache/settings.png" ]] ; then curl -o "$icons_cache/settings.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/settings.png" ; fi
if [[ ! -f "$icons_cache/ratio.png" ]] ; then curl -o "$icons_cache/ratio.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/ratio.png" ; fi
if [[ ! -f "$icons_cache/upload.png" ]] ; then curl -o "$icons_cache/upload.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/upload.png" ; fi
if [[ ! -f "$icons_cache/download.png" ]] ; then curl -o "$icons_cache/download.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/download.png" ; fi
if [[ ! -f "$icons_cache/credits.png" ]] ; then curl -o "$icons_cache/credits.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/credits.png" ; fi
if [[ ! -f "$icons_cache/url.png" ]] ; then curl -o "$icons_cache/url.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/url.png" ; fi
if [[ ! -f "$icons_cache/vpn.png" ]] ; then curl -o "$icons_cache/vpn.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/vpn.png" ; fi
if [[ ! -f "$icons_cache/unprotected.png" ]] ; then curl -o "$icons_cache/unprotected.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/unprotected.png" ; fi
if [[ ! -f "$icons_cache/message.png" ]] ; then curl -o "$icons_cache/message.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/message.png" ; fi
if [[ ! -f "$icons_cache/bonus.png" ]] ; then curl -o "$icons_cache/bonus.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/bonus.png" ; fi
if [[ ! -f "$icons_cache/warning.png" ]] ; then curl -o "$icons_cache/warning.png" "https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/.cache-icons/warning.png" ; fi

#### Declaration of my icons as variable
IPTORRENTS_ICON=$(curl -s "file://$icons_cache/iptorrents.png" | base64 -w 0)
IPTORRENTS_BAD_ICON=$(curl -s "file://$icons_cache/iptorrents-bad.png" | base64 -w 0)
IPTORRENTS_MESSAGE_ICON=$(curl -s "file://$icons_cache/iptorrents-message.png" | base64 -w 0)
SETTINGS_ICON=$(curl -s "file://$icons_cache/settings.png" | base64 -w 0)
RATIO_ICON=$(curl -s "file://$icons_cache/ratio.png" | base64 -w 0)
UPLOAD_ICON=$(curl -s "file://$icons_cache/upload.png" | base64 -w 0)
DOWNLOAD_ICON=$(curl -s "file://$icons_cache/download.png" | base64 -w 0)
CREDITS_ICON=$(curl -s "file://$icons_cache/credits.png" | base64 -w 0)
URL_ICON=$(curl -s "file://$icons_cache/url.png" | base64 -w 0)
VPN_ICON=$(curl -s "file://$icons_cache/vpn.png" | base64 -w 0)
UNPROTECTED_ICON=$(curl -s "file://$icons_cache/unprotected.png" | base64 -w 0)
MESSAGE_ICON=$(curl -s "file://$icons_cache/message.png" | base64 -w 0)
BONUS_ICON=$(curl -s "file://$icons_cache/bonus.png" | base64 -w 0)
WARNING_ICON=$(curl -s "file://$icons_cache/warning.png" | base64 -w 0)

#### Collecting local settings for IPTORRENTS
iptorrents_login=`cat $HOME/.config/argos/.iptorrents-account | awk '{print $1}' FS="§"`
iptorrents_password=`cat $HOME/.config/argos/.iptorrents-account | awk '{print $2}' FS="§"`
website_url="https://www.iptorrents.com"
wget_user_agent=`cat $HOME/.config/argos/.iptorrents-account | awk '{print $8}' FS="§"`
if [[ "$wget_user_agent" != "" ]]; then
  webbrowser_agent=`echo "--user-agent=\""$wget_user_agent"\" "`
fi

#### Checking the URL (tracking) -- IN PROGRESS
if [[ ! -f "$HOME/.config/argos/iptorrents/.website_url.conf" ]]; then
  echo $website_main_url > $HOME/.config/argos/iptorrents/.website_url.conf
fi
##website_url=`cat $HOME/.config/argos/iptorrents/.website_url.conf`
##current_url=`wget -q -O- "$website_url" "$webbrowser_agent"| grep favicon | sed 's/.*href="//' | sed -n '1p' | sed 's/\/static.*//'`
##if [[ "$website_url" != "$current_url" ]]; then
##  sed -i 's/'$website_url'/'$current_url'/g' "$HOME/.config/argos/yggtorrent/.website_url.conf"
##  website_url=`echo $current_url`
##fi

#### If the website is too slow to respond
website_response_time=`curl --max-time 5 -s -w %{time_total}\\n -o /dev/null $website_url | sed 's/,.*//'`
if [ "$website_response_time" -ge "5" ]; then
  echo " Website too slow | image='$IPTORRENTS_BAD_ICON' imageWidth=25"
  echo "---"
  echo "The website is currently really slow."
  echo "It took over 5s to even respond."
  echo "Usually it's an issue on their side."
  echo "---"
  echo "Refresh | refresh=true"
  exit 1
fi

#### If the login page has a captcha
captcha_check=`wget -q -O- "$website_url" "$webbrowser_agent"| grep 'div class="g-recaptcha"'`
if [ "$captcha_check" != "" ]; then
  echo " Captcha Detected | image='$IPTORRENTS_BAD_ICON' imageWidth=25"
  echo "---"
  echo "A Captcha was detected in the login page."
  echo "Sadly their is no way to script this."
  echo "Change your IP if possible."
  echo "---"
  echo "Refresh | refresh=true"
  exit 1
fi


#### Creating the authentication cookie
if [[ "$iptorrents_login" != "" ]] && [[ "$iptorrents_password" != "" ]]; then
  website_login_page=`echo $website_url"/take_login.php"`
  wget -q --save-cookies $HOME/.config/argos/iptorrents/cookies.txt --keep-session-cookies --post-data="username=$iptorrents_login&password=$iptorrents_password" "$website_login_page" "$webbrowser_agent"
else
  account_infos=`echo -e "yad --fixed --undecorated --no-escape --skip-taskbar --width=\"700\" --height=\"300\" --center --borders=20 --window-icon=\"$HOME/.config/argos/.cache-icons/iptorrents-big.png\" --title=\"Global Settings\" --text=\"<big>\r\rPlease, enter your account(s) details.\rThose informations are not stored on internet.\r\r</big>\" --text-align=center --image=\"$HOME/.config/argos/.cache-icons/iptorrents-big.png\" --form --separator=\"§\" --field=\"Login\" --field=\"Password\" --field=\" \":LBL --field=\"Activate notification thru PushOver:CHK\" --field=\"API KEY\" --field=\"USER_KEY\" --field=\" \":LBL --field=\"User-Agent de Wget\" \"$iptorrents_login\" \"$iptorrents_password\" \"\" \"$push_system_status\" \"$token_app\" \"$destinataire_1\" \"\" \"$wget_user_agent\" --button=gtk-ok:0 2>/dev/null >~/.config/argos/.iptorrents-account"`
  echo " IPTORRENTS | image='$IPTORRENTS_BAD_ICON' imageWidth=25"
  echo "---"
  echo "You must press \"settings\" to add your login/password"
  echo "---"
  printf "%-2s %s | image='$SETTINGS_ICON' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false bash='$account_infos' terminal=false \n" "" "Settings"
  exit 1
fi

#### Function: dehumanize
dehumanise() {
  for v in "$@"
  do  
    echo $v | awk \
      'BEGIN{IGNORECASE = 1}
       function printpower(n,b,p) {printf "%u\n", n*b^p; next}
       /[0-9]$/{print $1;next};
       /K(iB)?$/{printpower($1,  2, 10)};
       /M(iB)?$/{printpower($1,  2, 20)};
       /G(iB)?$/{printpower($1,  2, 30)};
       /T(iB)?$/{printpower($1,  2, 40)};
       /KB$/{    printpower($1, 10,  3)};
       /MB$/{    printpower($1, 10,  6)};
       /GB$/{    printpower($1, 10,  9)};
       /TB$/{    printpower($1, 10, 12)}'
  done
}

#### Function: humanize
humanise() {
  b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,E,P,Y,Z}B)
  while ((b > 1024)); do
    d="$(printf ".%02d" $((b % 1000 * 100 / 1000)))"
    b=$((b / 1000))
    let s++
  done
  echo "$b$d ${S[$s]}"
}

#### Function: push-message (including a zenity notification)
## usage: push-message "title" "message"
push_system_status=`cat $HOME/.config/argos/.iptorrents-account | awk '{print $4}' FS="§"`
token_app=`cat $HOME/.config/argos/.iptorrents-account | awk '{print $5}' FS="§"`
destinataire_1=`cat $HOME/.config/argos/.iptorrents-account | awk '{print $6}' FS="§"`
push-message() {
  push_title=$1
  push_content=$2
  zenity --notification --window-icon="$HOME/.config/argos/.cache-icons/iptorrents-bad.png" --text "$push_content" 2>/dev/null
  for user in {1..10}; do
    destinataire=`eval echo "\\$destinataire_"$user`
    if [ -n "$destinataire" ]; then
      curl -s \
        --form-string "token=$token_app" \
        --form-string "user=$destinataire" \
        --form-string "title=$push_title" \
        --form-string "message=$push_content" \
        --form-string "html=1" \
        --form-string "priority=0" \
        https://api.pushover.net/1/messages.json > /dev/null
    fi
  done
}

#### Collecting user's informations on the website
wget -q --load-cookies=$HOME/.config/argos/iptorrents/cookies.txt "$website_url" -O $HOME/.config/argos/iptorrents/page.html "$webbrowser_agent"
my_ratio=`cat $HOME/.config/argos/iptorrents/page.html | grep -Po '(?<=title="Ratio"></i> )[^<]*'`
if [[ "$my_ratio" != "" ]]; then
  my_upload_raw=`cat $HOME/.config/argos/iptorrents/page.html | grep -Po '(?<=class="fa fa-upload" style="color:#99FF00"></i> )[^<]*'`
  my_download_raw=`cat $HOME/.config/argos/iptorrents/page.html | grep -Po '(?<=class="fa fa-download" style="color:red"></i> )[^<]*'`
  my_upload=`echo $my_upload_raw | sed 's/ //'`
  my_download=`echo $my_download_raw | sed 's/ //'`
  my_bonus=`cat $HOME/.config/argos/iptorrents/page.html | grep -Po '(?<=class="fa fa-gift fa-lg"></i> )[^<]*'`
  my_upload_detail=`dehumanise $my_upload`
  my_download_detail=`dehumanise $my_download`
  my_credit=$(($my_upload_detail-$my_download_detail))
  my_credit_clean=`humanise $my_credit`
  wget -q --load-cookies=$HOME/.config/argos/iptorrents/cookies.txt "$website_url/seeding_required.php" -O $HOME/.config/argos/iptorrents/hit_run.html "$webbrowser_agent"
  cat $HOME/.config/argos/iptorrents/hit_run.html | grep "upload credit)" | grep -Po '(?<=class="zap" id=")[^"]*' | uniq > $HOME/.config/argos/iptorrents/hitandrun.txt
  my_hit_run=`cat $HOME/.config/argos/iptorrents/hitandrun.txt | wc -l`
  if [[ "$my_hit_run" == "" ]]; then
    my_hit_run="0"
  fi
fi

#### If no ratio at all (probably wrong credentials)
if [[ "$my_ratio" == "" ]]; then
  account_infos=`echo -e "yad --fixed --undecorated --no-escape --skip-taskbar --width=\"700\" --height=\"300\" --center --borders=20 --window-icon=\"$HOME/.config/argos/.cache-icons/iptorrents-big.png\" --title=\"Global Settings\" --text=\"<big>\r\rPlease, enter your account(s) details.\rThose informations are not stored on internet.\r\r</big>\" --text-align=center --image=\"$HOME/.config/argos/.cache-icons/iptorrents-big.png\" --form --separator=\"§\" --field=\"Login\" --field=\"Password\" --field=\" \":LBL --field=\"Activate notification thru PushOver:CHK\" --field=\"API KEY\" --field=\"USER_KEY\" --field=\" \":LBL --field=\"User-Agent de Wget\" \"$iptorrents_login\" \"$iptorrents_password\" \"\" \"$push_system_status\" \"$token_app\" \"$destinataire_1\" \"\" \"$wget_user_agent\" --button=gtk-ok:0 2>/dev/null >~/.config/argos/.iptorrents-account"`
  echo " IPTORRENTS | image='$IPTORRENTS_BAD_ICON' imageWidth=25"
  echo "---"
  echo "Unable to connect to your account."
  echo "Check the login/password in the settings."
  echo "---"
  printf "%-2s %s | image='$SETTINGS_ICON' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false bash='$account_infos' terminal=false \n" "" "Settings"
  exit 1
fi

#### Collecting the user's avatar
iptorrents_user_id=`cat $HOME/.config/argos/iptorrents/page.html | grep -Po '(?<=href="/u/)[^"]*'`
wget -q --load-cookies=$HOME/.config/argos/iptorrents/cookies.txt "$website_url/u/$iptorrents_user_id" -O $HOME/.config/argos/iptorrents/page_account.html "$webbrowser_agent"
avatar_url=`cat $HOME/.config/argos/iptorrents/page_account.html | grep -Po '(?<=img src=")[^"]*' | tail -1`
IMAGE=$(curl -s "$avatar_url" | base64 -w 0)

#### Checking if the real IP is hidden (for this website)
vpn_domain=$(echo $website_url | sed 's/^http:\/\/www\.//' | sed 's/^https:\/\/www\.//' | sed 's/^http:\/\///' | sed 's/^https:\/\///')
vpn_ip_check=`ip route get $(host $vpn_domain | sed -n '1p' | awk '{print $4}') | awk '{print $5}' | sed -n '1p'`
if [[ "$vpn_ip_check" == "tun0" ]]; then
  ip_status="hidden by a VPN"
  ip_status_icon=$VPN_ICON
else
  ip_status="unprotected"
  ip_status_icon=$UNPROTECTED_ICON
fi

#### Creating the "settings" button
account_infos=`echo -e "yad --fixed --undecorated --no-escape --skip-taskbar --width=\"700\" --height=\"300\" --center --borders=20 --window-icon=\"$HOME/.config/argos/.cache-icons/iptorrents-big.png\" --title=\"Global Settings\" --text=\"<big>\r\rPlease, enter your account(s) details.\rThose informations are not stored on internet.\r\r</big>\" --text-align=center --image=\"$HOME/.config/argos/.cache-icons/iptorrents-big.png\" --form --separator=\"§\" --field=\"Login\" --field=\"Password\" --field=\" \":LBL --field=\"Activate notification thru PushOver:CHK\" --field=\"API KEY\" --field=\"USER_KEY\" --field=\" \":LBL --field=\"User-Agent de Wget\" \"$iptorrents_login\" \"$iptorrents_password\" \"\" \"$push_system_status\" \"$token_app\" \"$destinataire_1\" \"\" \"$wget_user_agent\" --button=gtk-ok:0 2>/dev/null >~/.config/argos/.iptorrents-account"`

#### cleaning unnecessary files
rm -f take_login.* 2>/dev/null
rm -f take_login.php 2>/dev/null
rm -f index.* 2>/dev/null
rm -f login 2>/dev/null
rm -f login.* 2>/dev/null
rm -f iptorrents-update.sh 2>/dev/null

#### Displaying the result
echo " $my_credit_clean | image='$IPTORRENTS_ICON' imageWidth=25"
echo "---"
printf "%19s | ansi=true font='Ubuntu Mono' trim=false size=20 href=$website_url terminal=false image=$IMAGE imageWidth=80 \n" "$iptorrents_login"
echo "---"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "" "Ratio" "$my_ratio" "$RATIO_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "" "Upload" "$my_upload_raw" "$UPLOAD_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "" "Download" "$my_download_raw" "$DOWNLOAD_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "" "Credits left" "$my_credit_clean" "$CREDITS_ICON"
echo "---"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false href=$website_url/mybonus.php \n" "" "Bonus Points" "$my_bonus" "$BONUS_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false href=$website_url/seeding_required.php \n" "" "Hit and Run" "$my_hit_run" "$WARNING_ICON"
echo "---"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "" "Current URL" "$website_url" "$URL_ICON"
printf "%-2s \e[1m%-20s\e[0m : %s | image='%s' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false \n" "" "IP Status" "$ip_status" "$ip_status_icon"
echo "---"
printf "%-2s %s | image='$SETTINGS_ICON' imageWidth=18 ansi=true font='Ubuntu Mono' trim=false bash='$account_infos' terminal=false \n" "" "Settings"
