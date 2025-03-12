#!/bin/bash

# Trap Ctrl+Z to stop the scanning process
trap 'echo -e "\n[!] 🔚 Stopping the scanning process..."; exit' SIGTSTP

# Function to extract links from a webpage
extract_links() {
    local base_url=$1
    echo "🔍 Extracting links from: $base_url"
    curl -s "$base_url" | grep -oP '(https?://[^\s"]+)' | sort -u
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
        figlet "Hidden Admin Finder"
    else
        echo " ██████╗ ██╗   ██╗██╗███████╗███████╗██████╗ "
        echo " ██╔══██╗██║   ██║██║╚══███╔╝██╔════╝██╔══██╗"
        echo " ██████╔╝██║   ██║██║  ███╔╝ █████╗  ██████╔╝"
        echo " ██╔═══╝ ██║   ██║██║ ███╔╝  ██╔══╝  ██╔══██╗"
        echo " ██║     ╚██████╔╝██║███████╗███████╗██║  ██║"
        echo " ╚═╝      ╚═════╝ ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝"
    fi

    echo -e "\n==============================="
    echo -e "🔐 Hidden Admin Finder Tool - v1.0"
    echo -e "==============================="
    echo -e "This tool searches for hidden admin pages without using predefined paths."
    echo -e "Press Ctrl+Z to stop the scanning process.\n"

    read -p "🌐 Enter the target website URL (e.g., https://example.com): " target_url
    if [[ ! "$target_url" =~ ^https?:// ]]; then
        target_url="https://$target_url"
    fi

    # Analyze content for admin-related keywords
    if analyze_content_for_admin_pages "$target_url"; then
        echo "[+] 🎯 Potential admin pages detected based on content analysis."
    else
        echo "[!] ⚠️ No potential admin pages detected."
    fi
}

# Run the main function
main
