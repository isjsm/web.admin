import requests

# Common admin paths to check
COMMON_ADMIN_PATHS = [
    "/admin",
    "/login",
    "/dashboard",
    "/wp-admin",  # WordPress
    "/administrator",  # Joomla
    "/admin.php",
    "/admin.html",
    "/controlpanel",
    "/manager",
]

# A small dictionary of common passwords for demonstration purposes
COMMON_PASSWORDS = [
    "password",
    "123456",
    "admin",
    "qwerty",
    "letmein",
    "welcome",
    "monkey",
    "sunshine",
    "password123",
]

def check_admin_pages(base_url):
    """
    Check for common admin pages on the target website.
    """
    print(f"Searching for admin pages at: {base_url}")
    found_paths = []

    for path in COMMON_ADMIN_PATHS:
        url = base_url.rstrip("/") + path
        try:
            response = requests.get(url, timeout=5)
            if response.status_code == 200:
                print(f"[+] Admin page found: {url}")
                found_paths.append(url)
            elif response.status_code != 404:
                print(f"[-] Unexpected response ({response.status_code}) for: {url}")
        except requests.RequestException as e:
            print(f"[-] Failed to access: {url} due to: {e}")

    if not found_paths:
        print("[!] No admin pages found.")
    else:
        print("\n[+] Results:")
        for path in found_paths:
            print(f"  - {path}")

def test_password_strength(password_to_test):
    """
    Test the strength of a password by checking it against a list of common passwords.
    """
    print(f"\nTesting password strength for: {password_to_test}")
    if password_to_test in COMMON_PASSWORDS:
        print("[!] WARNING: This password is weak and commonly used!")
    else:
        print("[+] The password seems strong. Good job!")

def brute_force_demo(target_password):
    """
    Simulate a brute-force attack using a dictionary of common passwords.
    """
    print(f"\nSimulating a brute-force attack on password: {target_password}")
    for password in COMMON_PASSWORDS:
        print(f"Trying password: {password}")
        if password == target_password:
            print(f"[+] Password cracked! The password is: {password}")
            return
    print("[-] Password not found in the dictionary.")

def main():
    print("""
    ===============================
    Security Awareness Tool - v1.0
    ===============================
    This tool is designed for educational purposes only.
    Do not use this tool without explicit permission from the system owner.
    """)

    # Admin page checker
    target_url = input("Enter the target website URL (e.g., https://example.com): ").strip()
    if not target_url.startswith(("http://", "https://")):
        target_url = "https://" + target_url
    check_admin_pages(target_url)

    # Password strength tester
    password = input("\nEnter a password to test its strength: ").strip()
    test_password_strength(password)

    # Brute-force simulation
    target_password = input("\nEnter a password to simulate a brute-force attack: ").strip()
    brute_force_demo(target_password)

if __name__ == "__main__":
    main()
