#!/usr/bin/env python3

import os
import subprocess

# Definindo cores
red = '\033[31m'
orage = '\033[1;91m'
green = '\033[1;92m'
incolor = '\033[0m'

def del_lock():
    os.system("sudo rm /var/lib/dpkg/lock")
    os.system("sudo rm /var/lib/dpkg/lock-frontend")

def apt_update():
    os.system("sudo apt update -y")
    os.system("sudo apt dist-upgrade -y")

def auto_clean():
    apt_update()
    os.system("sudo apt autoclean -y")
    os.system("sudo apt autoremove -y")

def install_yad():
    vrf_yad = subprocess.run(["dpkg", "-s", "yad"], stdout=subprocess.PIPE, text=True).stdout
    if "Status: install ok installed" not in vrf_yad:
        print("Será instalado o visualizador shell YAD. AGUARDE")
        os.system("sudo apt install yad -y")

def test_net():
    if os.system("ping -c 3 8.8.8.8 -q > /dev/null") != 0:
        print(f"{red}[ERROR] - Your computer cannot access the internet{incolor}")
        exit(1)
    else:
        print(f"{green}[INFO] - You have connect with the internet.{incolor}")

def backup_programs():
    apt_update()
    programs_for_install = [
        "virtualbox",
        "code",
        "eclipse",
        "libreoffice",
        "nmap",
        "python3",
        "openjdk-11-jdk",
        "openvpn",
        "ssh"
    ]

    for name_program in programs_for_install:
        if subprocess.run(["dpkg", "-l", name_program], stdout=subprocess.PIPE, text=True).returncode != 0:
            os.system(f"sudo apt install {name_program} -y")
        else:
            print(f"{orage}[INFO] - This {name_program} is already installed")

    auto_clean()

def backup_programs_DPKG():
    apt_update()
    programs_for_install_with_dpkg = "/media/mamede/6ceb22a0-df7d-453a-941c-90681a0d1d46/Script backup/list_programs.txt"

    with open(programs_for_install_with_dpkg) as file:
        for name_program in file:
            name_program = name_program.strip()
            if subprocess.run(["dpkg", "-l", name_program], stdout=subprocess.PIPE, text=True).returncode != 0:
                os.system(f"sudo apt install {name_program} -y")
            else:
                print(f"{orage}[INFO] - This {name_program} is already installed")

    auto_clean()

# Menu
print("\n Choice an option")
print("1. All")
print("2. Apt update")
print("3. Backup Programs")
print("4. Backup Programs with dpkg")

choice = input("Your choice: ")

if choice == "1":
    del_lock()
    test_net()
    apt_update()
    install_yad()
    backup_programs()
elif choice == "2":
    del_lock()
    test_net()
    apt_update()
elif choice == "3":
    del_lock()
    test_net()
    backup_programs()
elif choice == "4":
    del_lock()
    test_net()
    backup_programs_DPKG()
else:
    print(f"{red} [ERROR] - None of the valid selects")

# Finalizado
print(f"{green}[INFO] - Finished script")
