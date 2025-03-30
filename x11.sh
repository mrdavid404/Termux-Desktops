#!/bin/bash
RED='\e[31m'
GREEN='\e[32m'
BLUE='\e[34m'
RESET='\e[0m'
CYAN='\e[36m'
BOLD='\e[1m' #for text bolding.
echo -e " ${CYAN} "
banner() {
cat << "EOF"

           _    _    _____ _    _  ______          __________      __
     /\   | |  | |  / ____| |  | |/ __ \ \        / /  ____\ \    / /
    /  \  | |__| | | (___ | |__| | |  | \ \  /\  / /| |__   \ \  / / 
   / /\ \ |  __  |  \___ \|  __  | |  | |\ \/  \/ / |  __|   \ \/ /  
  / ____ \| |  | |  ____) | |  | | |__| | \  /\  /  | |____   \  /   
 /_/    \_\_|  |_| |_____/|_|  |_|\____/   \/  \/   |______|   \/    
                                                                     
                     Termux Desktop environment.
                                                                     
EOF
}

clear
banner
echo -e "${GREEN} ${BOLD}\nUpdating package lists...\n${CYAN}"
sleep 2s 
apt update || exit 1  
sleep 1s
clear
banner
echo -e "${GREEN} ${BOLD}\nUpgrading existing packages...\n${CYAN}"
sleep 2s 
apt upgrade -y || exit 1  
sleep 1s
clear
banner
echo -e "${RED} ${BOLD}\nChanging Termux repository (Do this manually if needed)..."
echo -e "${RED} ${BOLD}Skipping termux-change-repo as it requires user input."
sleep 5s

banner
echo -e "${GREEN} ${BOLD}\nChecking and enabling external apps in Termux...\n${CYAN}"
TERMUX_PROPERTIES="$HOME/.termux/termux.properties"
if ! grep -q "allow-external-apps = true" "$TERMUX_PROPERTIES"; then
    echo "allow-external-apps = true" >> "$TERMUX_PROPERTIES"
    termux-reload-settings
fi

clear
banner
echo -e "${GREEN} ${BOLD}\nInstalling required packages...\n${CYAN}"
sleep 2s 
pkg install -y x11-repo || exit 1  
pkg install -y termux-x11-nightly xwayland || exit 1  
pkg install -y gimp firefox xfce4-terminal || exit 1  
pkg install -y xfce4 || exit 1  
sleep 1s
clear
banner
echo -e "${GREEN} ${BOLD}\nSetting up Termux X11 startup script...\n${CYAN}"
sleep 2s 
echo 'termux-x11 :1 -xstartup "xfce4-session"' > $PREFIX/bin/start-termux-x11  
chmod +x $PREFIX/bin/start-termux-x11  


<<EOF
echo "Downloading and setting up wallpapers..."
WALLPAPER_DIR="/data/data/com.termux/files/usr/share/backgrounds"
rm -rf "$WALLPAPER_DIR"
mkdir -p "$WALLPAPER_DIR"
git clone https://github.com/mrdavid404/backgrounds.git "$WALLPAPER_DIR" || echo "Failed to clone wallpapers."
EOF

clear
banner
echo -e "${GREEN} ${BOLD}\nDownloading and setting up wallpapers...\n${CYAN}"
sleep 2s 
pkg install -y git || exit 1  # Ensure git is installed

rm -rf /data/data/com.termux/files/usr/share/backgrounds/xfce

git clone https://github.com/mrdavid404/xfce.git /data/data/com.termux/files/usr/share/backgrounds/xfce/
clear
banner
echo -e "${GREEN} ${BOLD}\nWallpapers have been set up successfully!\n${CYAN}"
sleep 2s
clear
banner
echo -e "${GREEN} ${BOLD}\nSetup complete! Run ${RED} start-termux-x11 ${GREEN} to launch XFCE4.\n"
sleep 2s