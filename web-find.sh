#!/bin/bash

# -------------------------------------------------
# Author: Moj
# Telegram ID: @iranLwner
# Instagram ID: @MJi_Devil
# GitHub: https://github.com/C4ssif3r
# Comment: Please give me a star ⭐ :)
# -------------------------------------------------

# Clear the screen
clear

# Print the banner
echo "
██   ██▄   █▀▄▀█ ▄█    ▄       █ ▄▄  ██      ▄   ▄███▄   █         ▄████  ▄█    ▄   ██▄   ▄███▄   █▄▄▄▄ 
█ █  █  █  █ █ █ ██     █      █   █ █ █      █  █▀   ▀  █         █▀   ▀ ██     █  █  █  █▀   ▀  █  ▄▀ 
█▄▄█ █   █ █ ▄ █ ██ ██   █     █▀▀▀  █▄▄█ ██   █ ██▄▄    █         █▀▀    ██ ██   █ █   █ ██▄▄    █▀▀▌  
█  █ █  █  █   █ ▐█ █ █  █     █     █  █ █ █  █ █▄   ▄▀ ███▄      █      ▐█ █ █  █ █  █  █▄   ▄▀ █  █  
   █ ███▀     █   ▐ █  █ █     █       █ █  █ █ ▀███▀       ▀      █      ▐ █  █ █ ███▀  ▀███▀     █   
  █          ▀      █   ██      ▀     █  █   ██                   ▀        █   ██                ▀    
 ▀                             ▀     ▀                                       
"

# Prompt for target URL
read -p "[#] Enter target URL (example: google.com without http/https/www): " target_url

# Ensure the URL starts with http://
if [[ "$target_url" != http://* && "$target_url" != https://* ]]; then
    target_url="http://$target_url"
fi

# Test connection to the target
response=$(curl -o /dev/null -s -w "%{http_code}" "$target_url")
if [[ "$response" -ne 200 ]]; then
    echo -e "\e[31m[ERROR]\e[0m Can't connect to target $target_url"
    exit 1
fi

# Remove http:// or https:// for further processing
target_url=$(echo "$target_url" | sed 's|^http[s]*://||')

# Display methods
echo -e "
Methods:

    Method 1:
        Subdomain search for finding subdomains of $target_url
        Example:
        Target > $target_url
        Example[1] > admin.$target_url
        Example[2] > cpanel.$target_url
    
    Method 2:
        Manual list search for admin panels using [path(dirs)]
        Example:
        Target > $target_url
        Example[1] > $target_url/admin
        Example[2] > $target_url/cpanel
"

# Prompt for method selection
read -p "Select [method]: 1[subdomain[finder]] —— 2[patch-dirs[finder]] > " select_method

# Function to find subdomains
sub_manual() {
    echo -e "[*] TARGET >>> \e[32m$target_url\e[0m"
    while read -r link; do
        url="http://$link.$target_url"
        response=$(curl -o /dev/null -s -w "%{http_code}" "$url" --connect-timeout 20)
        if [[ "$response" -eq 200 ]]; then
            echo -e "[\e[32mOK\e[0m] Found a page - URL > $url"
        else
            echo -e "[\e[31mNOT\e[0m] Can't find page - URL > $url"
        fi
    done < .sub.txt
}

# Function to search admin panels
manual_list() {
    echo -e "[*] TARGET >>> \e[32m$target_url\e[0m"
    while read -r link; do
        url="http://$target_url/$link"
        response=$(curl -o /dev/null -s -w "%{http_code}" "$url" --connect-timeout 20)
        if [[ "$response" -lt 400 ]]; then
            echo -e "[\e[32mOK\e[0m] Found a page - URL > $url"
        elif [[ "$response" -ge 500 ]]; then
            echo -e "[\e[33mServer-ERROR\e[0m] Server error - URL > $url"
        else
            echo -e "[\e[31mNOT\e[0m] Can't find page - URL > $url"
        fi
    done < .link.txt
}

# Execute the selected method
if [[ "$select_method" == "1" ]]; then
    sub_manual
elif [[ "$select_method" == "2" ]]; then
    manual_list
else
    echo -e "\e[31m[ERROR]\e[0m Please enter a valid method (1 or 2)."
    exit 1
fi
