# iptorrents.c.1h.sh

> THIS SCRIPT IS ONLY IN ENGLISH

## **IMPORTANT:**

[<img src="https://github.com/scoony/iptorrents.c.1h.sh/blob/master/.cache-icons/extensions-gnome.png">](https://extensions.gnome.org/extension/1176/argos/) 
[<img src="https://github.com/scoony/iptorrents.c.1h.sh/blob/master/.cache-icons/pushover.png">](https://pushover.net/)

+ This script is based on Argos, you must install it first.
  - Official website for the Argos extension: https://extensions.gnome.org/extension/1176/argos/
  - GitHub for Argos: https://github.com/p-e-w/argos
- This script contain a notification feature based on PushOver, an account is required.
  - Official PushOver's website: https://pushover.net
  - Pushover for Android: https://play.google.com/store/apps/details?id=net.superblock.pushover
  - Pushover for Apple: https://itunes.apple.com/us/app/pushover-notifications/id506088175

**Feature(s):**
- an homemade auto-update system is integrated so no need to use the Git's one
- collect important informations on IPTORRENTS (ratio, download, upload, credits left, bonus amount, hit and run...)
- check the current url of the website (will try to track if any change)
- check the IP sent to this particular website (for the ones who want to make sure that their VPN is properly set)
- some push notifications can be sent to phones thru PushOver

**Required Dependencies:**
- `sudo apt-get install yad`
- `sudo apt-get install curl`
- `sudo apt-get install gawk`

**Easy Install:**

Simply copy/paste this in a terminal:

`wget -q https://raw.githubusercontent.com/scoony/iptorrents.c.1h.sh/master/iptorrents.c.1h.sh -O ~/.config/argos/iptorrents.c.1h.sh && sed -i -e 's/\r//g' ~/.config/argos/iptorrents.c.1h.sh && chmod +x ~/.config/argos/iptorrents.c.1h.sh`

**Screenshots:**
