#!/bin/bash

# Trap Ctrl+Z to stop admin page scanning
trap 'echo -e "\n[!] 🔚 Stopping admin page scanning..."; exit' SIGTSTP

# Common admin paths (including hidden or unconventional ones)
COMMON_ADMIN_PATHS=(
    "/admin" "/login" "/dashboard" "/wp-admin" "/administrator" "/admin.php" "/admin.html"
    "/controlpanel" "/manager" "/adm" "/backend" "/user" "/users" "/secure" "/portal"
    "/console" "/sysadmin" "/root" "/system" "/hidden" "/secret" "/private" "/staff"
    "/superuser" "/moderator" "/cms" "/setup" "/install" "/config" "/phpmyadmin" "/dbadmin"
)

# A larger dictionary of common passwords for demonstration purposes
COMMON_PASSWORDS=(
    "password" "123456" "admin" "qwerty" "letmein" "welcome" "monkey" "sunshine" "password123"
    "123456789" "12345678" "12345" "1234567" "123123" "abc123" "football" "master" "iloveyou"
    "michael" "shadow" "dragon" "baseball" "superman" "trustno1" "jordan" "harley" "batman"
    # ... إضافة المزيد من كلمات المرور هنا ...
)

# Function to check for admin pages
check_admin_pages() {
    local base_url=$1
    echo "🔍 Searching for hidden admin pages at: $base_url"
    found_paths=()

    for path in "${COMMON_ADMIN_PATHS[@]}"; do
        url="${base_url%/}$path"
        response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        if [[ $response -eq 200 ]]; then
            echo "[+] ✅ Hidden admin page found: $url"
            found_paths+=("$url")
        elif [[ $response -ne 404 ]]; then
            echo "[-] ❗ Unexpected response ($response) for: $url"
        fi
    done

    if [[ ${#found_paths[@]} -eq 0 ]]; then
        echo "[!] ⚠️ No hidden admin pages found."
    else
        echo -e "\n[+] 🎯 Results:"
        for path in "${found_paths[@]}"; do
            echo "  - $path"
        done
        return 0
    fi
}

# Function to simulate brute-force attack on a found admin page
brute_force_demo() {
    local admin_url=$1
    echo -e "\n⚔️ Simulating a brute-force attack on the admin page: $admin_url"

    for password in "${COMMON_PASSWORDS[@]}"; do
        echo "🔑 Trying password: $password"
        if [[ "$password" == "password123" ]]; then
            echo "[+] 🔓 Password cracked! The password is: $password"
            return
        fi
    done

    echo "[-] 🔒 Password not found in the dictionary."
}

# Main function
main() {
    clear
    # Use figlet for a fancy banner
    if command -v figlet &> /dev/null; then
        figlet "Admin Finder"
    else
        echo " ██████╗ ██╗   ██╗██╗███████╗███████╗██████╗ "
        echo " ██╔══██╗██║   ██║██║╚══███╔╝██╔════╝██╔══██╗"
        echo " ██████╔╝██║   ██║██║  ███╔╝ █████╗  ██████╔╝"
        echo " ██╔═══╝ ██║   ██║██║ ███╔╝  ██╔══╝  ██╔══██╗"
        echo " ██║     ╚██████╔╝██║███████╗███████╗██║  ██║"
        echo " ╚═╝      ╚═════╝ ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝"
    fi

    echo -e "\n==============================="
    echo -e "🔐 Admin Finder Tool - v1.0"
    echo -e "==============================="
    echo -e "This tool searches for hidden admin pages and simulates password cracking."
    echo -e "Press Ctrl+Z to stop the scanning process.\n"

    read -p "🌐 Enter the target website URL (e.g., https://example.com): " target_url
    if [[ ! "$target_url" =~ ^https?:// ]]; then
        target_url="https://$target_url"
    fi

    # Check for admin pages
    if check_admin_pages "$target_url"; then
        read -p $'\n❓ Do you want to simulate a brute-force attack on the found admin page? (y/n): ' choice
        if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
            for admin_page in "${found_paths[@]}"; do
                brute_force_demo "$admin_page"
            done
        else
            echo "[!] Skipping brute-force simulation."
        fi
    fi
}

# Run the main function
main
