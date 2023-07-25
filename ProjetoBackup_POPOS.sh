#!/bin/bash


#Definindo cores
red='\e[31m'; 
orage='\e[1;91m'; 
green='\e[1;92m';
incolor='\e[0m';

#Deletar o lock e lockfrontend
#caso seja necessário
del_lock(){
 sudo rm /var/lib/dpkg/lock;
 sudo rm /var/lib/dpkg/lock-frontend;
}

apt_update(){
    sudo apt update -y;
    sudo apt dist-upgrade -y;
}

auto_clean(){
    sudo apt_update -y
    sudo apt autoclean -y
    sudo apt auto-remove -y
}

#VRF se tem YAD Instalado, para monstrar um display em modo gráfico
install_yad(){
    vrf_yad=$(sudo dpkg -s yad | egrep -e Status | grep -o installed);
    if [ "$vrf_yad" = "installed" ] > /dev/null; then
        :
    else
        echo "Será instalado o visualizador shell YAD. AGUARDE";
        yad=$(sudo apt install yad -y);
    fi
}

#testando a internet
test_net(){
    if ! ping -c 3 8.8.8.8 -q &> /dev/null; then
        echo -e "${red}[ERROR] \
        - Your computer cannot access the internet${incolor}" 
        exit 1   
    else 
        echo -e "${green}[INFO] - You have connect with the internet.${incolor} "  
    fi       
}

backup_programs(){
    apt_update;
    programs_for_install=(
        virtualbox
        code
        eclipse
        libreoffice
        nmap
        python3
        openjdk-19-jdk
        openvpn
        ssh
    )

    for name_program in ${programs_for_install[0]}; do
        if ! dpkg -l | grep -q ${name_program}; then
            sudo apt install "${name_program} -y"
        else    
            echo "${orage}[INFO] - This ${name_program} is already installed"
        fi
    done

    auto_clean;

}

backup_programs_DPKG(){
    apt_update;
    #   ou   # é preciso fazer a lista antes de rodar, ter salvo a lista antes de formatar
    programs_for_install_with_dpkg=(
       /media/mamede/6ceb22a0-df7d-453a-941c-90681a0d1d46/
        Script backup//list_programs.txt)
    #sudo dpkg -l | grep '^ii' | awk '{print $2}' > /mnt/list_programs.txt
    #comando para ver todos progrmas instalados na maquina e salvar em um arquivo


    for name_program in ${programs_for_install[0]}; do
        if ! dpkg -l | grep -q ${name_program}; then
            sudo apt install "${name_program} -y"
        else    
            echo "${orage}[INFO] - This ${name_program} is already installed"
        fi
    done

    auto_clean;
}



#MENU
selects=$( yad --list --radiolist --title="CHOICE" \
            --text "\n Choice an option" --column "Option" --column "Choice" \
            False "All" \
            False "Apt update" \
            False "Backup Programs" \
            False "Backup Programs with dpkg" \
            --on-top --center --skip-taskbar --justify=center --width="800" --height="300");


new_select=$(echo -e ${selects} | sed 's/[TRUE|]//g');

yad --title "Your choice" --text "Your choice is ${new_select}" \
                    --on-top --center --skip-taskbar --justify=center \
                    --width 550 --height 90 \
                    --button="Next":0 --button="Exit":1;

if [ $? -eq 0 ]; then
    case "${new_select}" 
        in "All")
            del_lock;
            test_net;
            apt_update;
            install_yad;
            backup_programs;
            ;;
        "Apt update")
            del_lock;
            test_net;
            apt_update;
            ;;
        "Backup Programs")
            del_lock;
            test_net;
            backup_programs;
            ;;
        "Backup Programs with dpkg")
            del_lock;
            test_net;
            backup_programs_DPKG;
            ;;
        *)
            yad --title "ERRO" --text "None of the valid selects" \
                    --on-top --center --skip-taskbar --justify=center \
                    --width 550 --height 90;
            ;;
    esac
else 
    echo -e "${red} [ERROR] - Script was closed!"
    exit 0
fi

#Finalizado
echo -e "${green}[INFO] - Finished script";










                    
