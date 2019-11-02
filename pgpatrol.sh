#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

# KEY VARIABLE RECALL & EXECUTION
mkdir -p /var/plexguide/pgpatrol

# FUNCTIONS START ##############################################################

# FIRST FUNCTION
variable() {
  file="$1"
  if [ ! -e "$file" ]; then echo "$2" >$1; fi
}

deploycheck() {
  dcheck=$(systemctl is-active pgpatrol)
  if [ "$dcheck" == "active" ]; then
    dstatus="✅ DEPLOYED"
  else dstatus="⚠️ NOT DEPLOYED"; fi
}

plexcheck() {
  pcheck=$(docker ps --format {{.Names}} | grep "plex")
  if [ "$pcheck" == "" ]; then

    tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Plex is Not Installed or Running! Exiting!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
    read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
    exit
  fi
}

token() {
  touch /var/plexguide/plex.token
  ptoken=$(cat /var/plexguide/plex.token)
  if [ "$ptoken" == "" ]; then
    bash /opt/plexguide/menu/plex/token.sh
    ptoken=$(cat /var/plexguide/plex.token)
    if [ "$ptoken" == "" ]; then
      tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  WARNING! - Failed to Generate a Valid Plex Token! Exiting Deployment!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
      read -p 'Confirm Info | PRESS [ENTER] ' typed </dev/tty
      exit
    fi
  fi
}

# BAD INPUT
badinput() {
  echo
  read -p '⛔️ ERROR - BAD INPUT! | PRESS [ENTER] ' typed </dev/tty
  question1
}

selection1() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Instantly Kick Video Transcodes?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] False
[2] True

EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [ "$typed" == "1" ]; then
    echo "False" >/var/plexguide/pgpatrol/video.transcodes && question1
  elif [ "$typed" == "2" ]; then
    echo "True" >/var/plexguide/pgpatrol/video.transcodes && question1
  else badinput; fi
}

selection2() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Instantly Kick Video Transcodes?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] False
[2] True

EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [ "$typed" == "1" ]; then
    echo "False" >/var/plexguide/pgpatrol/video.transcodes4k && question1
  elif [ "$typed" == "2" ]; then
    echo "True" >/var/plexguide/pgpatrol/video.transcodes4k && question1
  else badinput; fi
}

selection3() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Limit Amount of Different IPs a User Can Make?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Set a Number from [ 1 ] - [ 99 ]

EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "99" ]]; then
    echo "$typed" >/var/plexguide/pgpatrol/multiple.ips && question1
  else badinput; fi
}

selection4() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Limit How Long a User Can Pause For!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


Set a Number from [5] 999 Mintues

EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "999" ]]; then
    echo "$typed" >/var/plexguide/pgpatrol/kick.minutes && question1
  else badinput; fi
}

# FIRST QUESTION
question1() {

  video=$(cat /var/plexguide/pgpatrol/video.transcodes)
  video4k=$(cat /var/plexguide/pgpatrol/video.transcodes4k)
  ips=$(cat /var/plexguide/pgpatrol/multiple.ips)
  minutes=$(cat /var/plexguide/pgpatrol/kick.minutes)

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex - Patrol Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


[1] Instantly Kick Video Transcodes?      [ $video ]
[2] Instantly Kick Video 4k Transcodes?   [ $video4k ]
[3] UserName | Multiple IPs?              [ $ips ]
[4] Minutes  | Kick Paused Transcode?     [ $minutes ]

[5] Deploy Plex - Patrol                  [ $dstatus ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Z] Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  if [ "$typed" == "1" ]; then
    selection1
  elif [ "$typed" == "2" ]; then
    selection2
  elif [ "$typed" == "3" ]; then
    selection3
  elif [ "$typed" == "4" ]; then
    selection4
  elif [ "$typed" == "5" ]; then
    ansible-playbook /opt/pgpatrol/pgpatrol.yml && question1
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    exit
  else badinput; fi
}

# FUNCTIONS END ##############################################################
plexcheck
token
variable /var/plexguide/pgpatrol/video.transcodes "False"
variable /var/plexguide/pgpatrol/video.transcodes4k "True"
variable /var/plexguide/pgpatrol/multiple.ips "2"
variable /var/plexguide/pgpatrol/kick.minutes "1"
deploycheck
question1
