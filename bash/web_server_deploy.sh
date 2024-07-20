#!/bin/bash
#
#Update system
update_system() {
    apt update
    build_server 
}
#
#Check if script is being run as root
check_root() {
        echo "Checking..."
        if [ "$(id -u)" -ne 0 ] ; then 
    echo "Please run as root."
    exit 1
else
    echo "running as root"
    update_system
fi
}
#
#Allow user to choose between Apache or Nginx 
#Then install
build_server(){
        echo "Apache or Nginx?"
        echo "Apache: 1"
        echo "Nginx: 2"
        read -p "Enter selection: " userSelect
        if [ "$userSelect" -eq 1 ] ; then
            apt install apache -y
            if [ $? -ne 0 ] ; then
                    echo "Failed to install apache"
                    exit 1
            fi
            configure_host
        elif [ $userSelect -eq 2 ] ; then
            apt install nginx -y
            if [ $? -ne 0 ] ; then
                    echo "Failed to install nginx"
                    exit 1
            fi
            configure_host
        else
            echo "Please enter correct option"
            build_server
        fi
}
#
#validate input against predefined name rules
validate_hostname(){
        echo "Checking input..."
        local hostname=$1
        echo "hostname entered: '$hostname'"
        if [[ $hostname =~ ^[a-zA-Z0-9]+$ ]] ; then
                echo "Hostname is valid"
                return 0
        else
                echo 'Invalid hostname.'
                echo 
                echo 'Hostnames can only contain letters, numbers and hypens'
                return 1
                configure_host
        fi
}
#
#Configure the hosts file allowing user to input hostname
configure_host() {
        read -p "Enter a hostname: " userSelect
        echo "$userSelect"

        userSelect=$(echo "$userSelect" | xargs)
        if validate_hostname "$userSelect" ; then
                echo "valid hostname"
                echo "127.0.0.1 "+$userSelect >> /etc/hosts
                echo "hosts file updated"
                create_webpage
        fi
}
#create a default web page to display
create_webpage() {
        echo "Creating deafult webpage"
        local www="<html><head></head><body><br><div><p>Hello<br>World!</p></div></body></html>"
        touch /var/www/html/index.html
        local > /var/www/html/index.html
        echo "default page created in /var/www/html"
        configure_firewall
}
#
#configure ufw firewall to allow port 80
configure_firewall() {
        echo "Configuring firewall rule to allow port 80"
        ufw allow 80
        echo "Firewall configuration complete"
}

check_root