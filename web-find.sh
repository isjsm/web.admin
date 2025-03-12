#!/bin/bash

# Trap Ctrl+Z to stop link scanning
trap 'echo -e "\n[!] 🔚 Stopping link scanning..."; exit' SIGTSTP

# Trap Ctrl+X to stop password brute-forcing
trap 'echo -e "\n[!] 🔚 Stopping brute-force simulation..."; exit' SIGINT

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

# A larger dictionary of common passwords for demonstration purposes
COMMON_PASSWORDS=(
    "password" "123456" "admin" "qwerty" "letmein" "welcome" "monkey" "sunshine" "password123"
    "123456789" "12345678" "12345" "1234567" "123123" "abc123" "football" "master" "iloveyou"
    "michael" "shadow" "dragon" "baseball" "superman" "trustno1" "jordan" "harley" "batman"
    "1234" "soccer" "killer" "mustang" "hello" "charlie" "robert" "thomas" "hockey" "ranger"
    "daniel" "starwars" "george" "asshole" "computer" "michelle" "jennifer" "1234qwer" "buster"
    "whatever" "freedom" "ginger" "princess" "joshua" "cheese" "amanda" "summer" "love" "ashley"
    "nicole" "chelsea" "biteme" "matthew" "access" "yankees" "987654321" "dallas" "austin" "thunder"
    "taylor" "matrix" "william" "corvette" "testing" "shannon" "murphy" "cooper" "batman1" "fuckyou"
    "hunter" "fucker" "fuckme" "suckit" "madison" "bailey" "enter" "ashley1" "junior" "zxcvbn" "pepper"
    "111111" "131313" "123321" "123abc" "123qwe" "1qaz2wsx" "aa123456" "abcd1234" "alexis" "apollo"
    "badboy" "bigdog" "bigdaddy" "blonde" "booboo" "booger" "boomer" "butter" "calvin" "camaro"
    "carlos" "casper" "chester" "chicken" "cocacola" "coffee" "cowboys" "dakota" "dexter" "diamond"
    "doctor" "dolphin" "donald" "eagle1" "edward" "extreme" "falcon" "fender" "firebird" "fishing"
    "florida" "football1" "forever" "freddy" "gandalf" "gateway" "gators" "gibson" "golden" "hammer"
    "hannah" "hardcore" "heather" "helpme" "hentai" "hooters" "horny" "hotdog" "hunter1" "iwantu"
    "jackie" "jasmine" "jessica" "johnny" "jordan1" "kawasaki" "kevin" "killer1" "knight" "ladies"
    "lakers" "lauren" "legend" "leopard" "little" "lovers" "maggie" "marina" "marine" "midnight"
    "millie" "monkey1" "mother" "mountain" "muffin" "nascar" "nathan" "newyork" "nikita" "nintendo"
    "orange" "packers" "panther" "panties" "patrick" "peanut" "phantom" "player" "please" "pokemon"
    "porsche" "prince" "purple" "qwerty1" "rabbit" "racing" "raiders" "rainbow" "redskins" "redwings"
    "richard" "rocky" "rosebud" "runner" "rush2112" "sandra" "scorpio" "scorpion" "sebastian" "secret"
    "sexsex" "shadow1" "shannon1" "shaved" "sierra" "silver" "skippy" "slayer" "smokey" "sniper"
    "snowball" "soccer1" "sparky" "spider" "squirt" "steven" "sticky" "stupid" "success" "suckit"
    "super" "surfing" "sydney" "taylor1" "teddy" "teens" "tennis" "theman" "thunder1" "tiffany"
    "tomcat" "topgun" "toyota" "travis" "trouble" "turtle" "united" "victor" "viking" "warrior"
    "welcome1" "whatever1" "willie" "winner" "winston" "wizard" "wolfpack" "xxxxxx" "yellow" "zxcvbn"
)

# Function to extract all links from a webpage
extract_links() {
    local base_url=$1
    echo "🔍 Extracting all links from: $base_url"
    curl -s "$base_url" | grep -oP '(https?://[^\s"]+)' | sort -u
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
    clear
    echo "
    ===============================
    🔐 Security Awareness Tool - v1.0
    ===============================
    [1] Extract all links from a webpage
    [2] Test password strength
    [3] Simulate brute-force attack
    ===============================
    "

    read -p "👉 Select an option (1/2/3): " choice

    case $choice in
        1)
            read -p "🌐 Enter the target website URL (e.g., https://example.com): " target_url
            if [[ ! "$target_url" =~ ^https?:// ]]; then
                target_url="https://$target_url"
            fi
            extract_links "$target_url"
            ;;
        2)
            read -p $'\n🔐 Enter a password to test its strength: ' password
            test_password_strength "$password"
            ;;
        3)
            read -p $'\n⚔️ Enter a password to simulate a brute-force attack: ' target_password
            brute_force_demo "$target_password"
            ;;
        *)
            echo "❌ Invalid option selected."
            ;;
    esac
}

# Run the main function
main
