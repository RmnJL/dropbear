#!/bin/bash
<<<<<<< HEAD
#HighVPN RmnJL
echo "Install Dropbear ..."
apt-get -y remove dropbear 1> /dev/null 2> /dev/null
apt-get -y purge dropbear 1> /dev/null 2> /dev/null

apt-get install dropbear -y

rm -rf /etc/default/dropbear

echo "/bin/false" >> /etc/shells

echo ""

echo "Enter Port Dropbear"
read port

echo "NO_START=0" >> /etc/default/dropbear
echo "DROPBEAR_PORT=$port" >> /etc/default/dropbear
echo "DROPBEAR_EXTRA_ARGS='-p 442 -p 8080 -p 8484 -p 143 -p 109'" >> /etc/default/dropbear
=======
# HighVPN RmnJL - نسخه بهبود یافته و پایدار
set -euo pipefail

echo "Install Dropbear ..."
apt-get -y remove dropbear 1> /dev/null 2> /dev/null || true
apt-get -y purge dropbear 1> /dev/null 2> /dev/null || true
apt-get update
apt-get install dropbear -y

rm -f /etc/default/dropbear

grep -qxF "/bin/false" /etc/shells || echo "/bin/false" >> /etc/shells

echo ""

while true; do
    read -p "Enter Port Dropbear: " port
    if [[ "$port" =~ ^[0-9]{2,5}$ ]] && [ "$port" -ge 1 ] && [ "$port" -le 65535 ]; then
        break
    else
        echo "Invalid port. Please enter a number between 1 and 65535."
    fi
done

echo "NO_START=0" > /etc/default/dropbear
echo "DROPBEAR_PORT=$port" >> /etc/default/dropbear
echo "DROPBEAR_EXTRA_ARGS='-p $port -p 442 -p 8080 -p 8484 -p 143 -p 109'" >> /etc/default/dropbear
>>>>>>> f103409 (Initial stable and improved version upload)
#echo "DROPBEAR_BANNER='/etc/banner'" >> /etc/default/dropbear

service dropbear start 
service dropbear restart 
<<<<<<< HEAD
curl -o /var/www/html/dropbear.sh https://raw.githubusercontent.com/RmnJL/dropbear/main/dropbear.sh
chmod +x /var/www/html/dropbear.sh
sed -i "s/PORT_DROPBEAR=.*/PORT_DROPBEAR=$port/g" /var/www/html/panel/.env
(crontab -l | grep . ; echo -e "* * * * * /var/www/html/dropbear.sh") | crontab -
echo "Port Connection $port"

=======

# دانلود اسکریپت dropbear.sh فقط در صورت نیاز
if [ ! -f /var/www/html/dropbear.sh ]; then
    curl -fsSL -o /var/www/html/dropbear.sh https://raw.githubusercontent.com/RmnJL/dropbear/main/dropbear.sh
    chmod +x /var/www/html/dropbear.sh
fi

# اطمینان از وجود فایل .env
if [ -f /var/www/html/panel/.env ]; then
    sed -i "s/PORT_DROPBEAR=.*/PORT_DROPBEAR=$port/g" /var/www/html/panel/.env
fi

# اضافه کردن به کرون فقط اگر وجود ندارد
croncmd="/var/www/html/dropbear.sh"
cronjob="* * * * * $croncmd"
(crontab -l 2>/dev/null | grep -Fv "$croncmd"; echo "$cronjob") | crontab -

echo "Port Connection $port"
>>>>>>> f103409 (Initial stable and improved version upload)
echo "DROPBEAR CONFIGURADO."
