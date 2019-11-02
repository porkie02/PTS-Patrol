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

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
🚀 Instantly Kick 4k - Video Transcodes?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] False
[2] True

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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
🚀 Instantly Kick Audio Transcodes?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] False
[2] True

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [ "$typed" == "1" ]; then
    echo "False" >/var/plexguide/pgpatrol/audio.transcodes && question1
  elif [ "$typed" == "2" ]; then
    echo "True" >/var/plexguide/pgpatrol/audio.transcodes && question1
  else badinput; fi
}

selection4() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Limit Amount of Different IPs a User Can Make?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Set a Number from [ 1 ] - [ 10 ]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "10" ]]; then
    echo "$typed" >/var/plexguide/pgpatrol/multiple.ips && question1
  else badinput; fi
}


selection5() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Limit How Long a User Can Pause For!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Set a Number from [ 5 ] - [ 250 ] Mintues

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "250" ]]; then
    echo "$typed" >/var/plexguide/pgpatrol/kick.minutes && question1
  else badinput; fi
}

selection5() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Check Interval # how often to check the active streams in seconds
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Set a Number from [ 60 ] - [ 240 ] seconds

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p 'Type Number | PRESS [ENTER] ' typed </dev/tty
  if [[ "$typed" -ge "59" && "$typed" -le "241" ]]; then
    echo "$typed" /var/plexguide/pgpatrol/check.interva && question1
  else badinput; fi
}
selection7() {
  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Remove Plex Patrol
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[ 1 ] - NO

[ 2 ] - YES

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Number | Press [ENTER]: ' typed </dev/tty

  if [ "$typed" == "1" ]; then
    selection1
  elif [ "$typed" == "2" ]; then
	ansible-playbook /opt/pgpatrol/remove-pgpatrol.yml && question1
  else badinput; fi
}

# FIRST QUESTION
question1() {

  video=$(cat /var/plexguide/pgpatrol/video.transcodes)
  video4k=$(cat /var/plexguide/pgpatrol/video.transcodes4k)
  ips=$(cat /var/plexguide/pgpatrol/multiple.ips)
  minutes=$(cat /var/plexguide/pgpatrol/kick.minutes)
  audio=$(cat /var/plexguide/pgpatrol/audio.transcodes)
  interval=$(cat /var/plexguide/pgpatrol/check.interval)

  tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Plex - Patrol Interface
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


[1] Instantly Kick Video Transcodes?      [ $video ]
[2] Instantly Kick Video 4k Transcodes?   [ $video4k ]
[3] Instantly Kick Audio Transcodes?      [ $audio ]
[4] UserName | Multiple IPs?              [ $ips ]
[5] Minutes  | Kick Paused Transcode?     [ $minutes ]
[6] Check Interval                        [ $interval ]

[7] Deploy Plex - Patrol                  [ $dstatus ]

[8] Remove Plex - Patrol

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
    selection5
  elif [ "$typed" == "6" ]; then
    selection6
  elif [ "$typed" == "7" ]; then
	ansible-playbook /opt/pgpatrol/pgpatrol.yml && question1
  elif [ "$typed" == "8" ]; then
	selection7
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
    exit
  else badinput; fi
}

# FUNCTIONS END ##############################################################
plexcheck
token
variable /var/plexguide/pgpatrol/video.transcodes "False"
variable /var/plexguide/pgpatrol/video.transcodes4k "True"
variable /var/plexguide/pgpatrol/audio.transcodes "False"
variable /var/plexguide/pgpatrol/check.interval "90"
variable /var/plexguide/pgpatrol/multiple.ips "1"
variable /var/plexguide/pgpatrol/kick.minutes "5"
deploycheck
question1
