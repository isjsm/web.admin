#!/bin/bash

# Trap Ctrl+Z to stop the scanning process
trap 'echo -e "\n[!] 🔚 Stopping the scanning process..."; exit' SIGTSTP

# Combined list of common admin paths from multiple tools
COMMON_ADMIN_PATHS=(
    "/admin" "/login" "/dashboard" "/wp-admin" "/administrator" "/admin.php" "/admin.html"
    "/controlpanel" "/manager" "/adm" "/backend" "/user" "/users" "/secure" "/portal"
    "/console" "/sysadmin" "/root" "/system" "/hidden" "/secret" "/private" "/staff"
    "/superuser" "/moderator" "/cms" "/setup" "/install" "/config" "/phpmyadmin" "/dbadmin"
    "/admincp" "/administer" "/administration" "/admin_login" "/admin_area" "/adminpanel"
    "/administator" "/admincontrol" "/admin-console" "/admin-center" "/admin-site" "/adminpage"
    "/admin-login" "/adminhome" "/admin/index.php" "/admin/login.php" "/admin/control.php"
    "/admin/dashboard.php" "/admin/panel.php" "/admin/admin.php" "/admin/home.php"
)

# Function to check for admin pages using predefined paths
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
        return 0
    fi
}

# Function to analyze content for admin-related keywords
analyze_content_for_admin_pages() {
    local base_url=$1
    echo "🔍 Analyzing content for hidden admin pages at: $base_url"

    # Fetch the page content
    content=$(curl -s "$base_url")

    # Keywords that might indicate an admin page
    keywords=("admin" "login" "dashboard" "control" "panel" "manager" "secure" "portal")

    found_pages=()

    # Check for keywords in the content
    for keyword in "${keywords[@]}"; do
        if echo "$content" | grep -qi "$keyword"; then
            echo "[+] ✅ Potential admin-related keyword found: $keyword"
            found_pages+=("$keyword")
        fi
    done

    if [[ ${#found_pages[@]} -eq 0 ]]; then
        echo "[!] ⚠️ No admin-related keywords found."
    else
        echo -e "\n[+] 🎯 Results:"
        for keyword in "${found_pages[@]}"; do
            echo "  - Keyword: $keyword"
        done
        return 0
    fi
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
    echo -e "🔐 Admin Finder Tool - v2.0"
    echo -e "==============================="
    echo -e "This tool searches for admin pages using predefined paths and dynamic content analysis."
    echo -e "Press Ctrl+Z to stop the scanning process.\n"

    read -p "🌐 Enter the target website URL (e.g., https://example.com): " target_url
    if [[ ! "$target_url" =~ ^https?:// ]]; then
        target_url="https://$target_url"
    fi

    # Option to choose between predefined paths or dynamic analysis
    read -p "👉 Select search method ([1] Predefined Paths / [2] Dynamic Content Analysis): " choice

    case $choice in
        1)
            check_admin_pages "$target_url"
            ;;
        2)
            analyze_content_for_admin_pages "$target_url"
            ;;
        *)
            echo "[!] Invalid option selected. Exiting..."
            exit 1
            ;;
    esac
}

# Run the main function
main
