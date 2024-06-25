#!/bin/bash

RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "Auto Tools for MacOS"
echo ""
PS3='Please enter your choice: '
options=("Bypass on Recovery" "Disable Notification (SIP)" "Disable Notification (Recovery)" "Check MDM Enrollment" "Thoát")
select opt in "${options[@]}"; do
    case $opt in
    "Bypass on Recovery")
        echo -e "${GRN}Bypass on Recovery${NC}"
        if [ -d "/Volumes//Local\ Disk\ C" ]; then
            diskutil rename "/Volumes//Local\ Disk\ C" "Data"
        fi
        echo -e "${GRN}Tạo người dùng mới${NC}"
        echo -e "${BLU}Nhấn Enter để chuyển bước tiếp theo, có thể tidak diisi dan akan menggunakan nilai default${NC}"
        echo -e "Nhập tên người dùng (Mặc định: MAC)"
        read realName
        realName="${realName:=MAC}"
        echo -e "${BLU}Nhập username (tanpa spasi, Mặc định: MAC)${NC}"
        read username
        username="${username:=MAC}"
        echo -e "${BLU}Nhập mật khẩu (mặc định: 1234)${NC}"
        read passw
        passw="${passw:=1234}"
        dscl_path='/Volumes//Local\ Disk\ C/private/var/db/dslocal/nodes/Default'
        echo -e "${GRN}Đang tạo user${NC}"
        # Create user
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
        mkdir "/Volumes//Local\ Disk\ C/Users/$username"
        dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
        dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
        dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
        echo "0.0.0.0 deviceenrollment.apple.com" >> "/Volumes//Local\ Disk\ C/etc/hosts"
        echo "0.0.0.0 mdmenrollment.apple.com" >> "/Volumes//Local\ Disk\ C/etc/hosts"
        echo "0.0.0.0 iprofiles.apple.com" >> "/Volumes//Local\ Disk\ C/etc/hosts"
        echo -e "${GRN}Chặn host thành công${NC}"
        # Remove config profile
        touch "/Volumes//Local\ Disk\ C/private/var/db/.AppleSetupDone"
        rm -rf "/Volumes//Local\ Disk\ C/private/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord"
        rm -rf "/Volumes//Local\ Disk\ C/private/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound"
        touch "/Volumes//Local\ Disk\ C/private/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled"
        touch "/Volumes//Local\ Disk\ C/private/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound"
        echo "----------------------"
        break
        ;;
    "Disable Notification (SIP)")
        echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        sudo rm "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord"
        sudo rm "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound"
        sudo touch "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled"
        sudo touch "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound"
        break
        ;;
    "Disable Notification (Recovery)")
        rm -rf "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord"
        rm -rf "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound"
        touch "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled"
        touch "/Volumes//Local\ Disk\ C/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound"
        break
        ;;
    "Check MDM Enrollment")
        echo ""
        echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
        echo ""
        echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        echo ""
        sudo profiles show -type enrollment
        break
        ;;
    "Thoát")
        break
        ;;
    *) echo "Invalid option $REPLY" ;;
    esac
done
