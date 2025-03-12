#!/bin/bash

# Common admin paths to check
COMMON_ADMIN_PATHS=(
    "/admin"
    "/login"
    "/dashboard"
    "/wp-admin"  # WordPress
    "/administrator"  # Joomla
    "/admin.php"
    "/admin.html"
    "/controlpanel"
    "/manager"
)

# A small dictionary of common passwords for demonstration purposes
COMMON_PASSWORDS=(
    "password"
    "123456"
    "admin"
    "qwerty"
    "letmein"
    "welcome"
    "monkey"
    "sunshine"
    "password123"
)

# Function to check for admin pages
check_admin_pages() {
    local base_url=$1
    echo "🔍 Searching for admin pages at: $base_url"
    found_paths=()

    for path in "${COMMON_ADMIN_PATHS[@]}"; do
        url="${base_url%/}$path"
        response=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        if [[ $response -eq 200 ]]; then
            echo "[+] ✅ Admin page found: $url"
            found_paths+=("$url")
        elif [[ $response -ne 404 ]]; then
            echo "[-] ❗ Unexpected response ($response) for: $url"
        fi
    done

    if [[ ${#found_paths[@]} -eq 0 ]]; then
        echo "[!] ⚠️ No admin pages found."
    else
        echo -e "\n[+] 🎯 Results:"
        for path in "${found_paths[@]}"; do
            echo "  - $path"
        done
    fi
}

# Function to test password strength
test_password_strength() {
    local password_to_test=$1
    echo -e "\n🔒 Testing password strength for: $password_to_test"

    for password in "${COMMON_PASSWORDS[@]}"; do
        if [[ "$password" == "$password_to_test" ]]; then
            echo "[!] ⚠️ WARNING: This password is weak and commonly used!"
            return
        fi
    done

    echo "[+] ✅ The password seems strong. Good job!"
}

# Function to simulate brute-force attack
brute_force_demo() {
    local target_password=$1
    echo -e "\n⚔️ Simulating a brute-force attack on password: $target_password"

    for password in "${COMMON_PASSWORDS[@]}"; do
        echo "🔑 Trying password: $password"
        if [[ "$password" == "$target_password" ]]; then
            echo "[+] 🔓 Password cracked! The password is: $password"
            return
        fi
    done

    echo "[-] 🔒 Password not found in the dictionary."
}

# Main function
main() {
    echo "
    ===============================
    🔐 Security Awareness Tool - v1.0
    ===============================
    This tool is designed for educational purposes only.
    Do not use this tool without explicit permission from the system owner.
    "

    # Admin page checker
    read -p "🌐 Enter the target website URL (e.g., https://example.com): " target_url
    if [[ ! "$target_url" =~ ^https?:// ]]; then
        target_url="https://$target_url"
    fi
    check_admin_pages "$target_url"

    # Password strength tester
    read -p $'\n🔐 Enter a password to test its strength: ' password
    test_password_strength "$password"

    # Brute-force simulation
    read -p $'\n⚔️ Enter a password to simulate a brute-force attack: ' target_password
    brute_force_demo "$target_password"
}

# Run the main function
main
