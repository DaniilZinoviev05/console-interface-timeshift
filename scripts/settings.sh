#! /bin/bash

CONF="/home/$(whoami)/Scripts/setgs.conf"
if [[ -f $CONF ]]; then
	source "$CONF"
	echo "User email / Почта пользователя: $user_email"
fi

CheckConfMailFunc() {
	EXPECTED_ENTRY="user_email"

	if [[ -f $CONF ]]; then
		echo "$CONF file found /Файл $CONF найден"
	  
		if grep -q "$EXPECTED_ENTRY" "$CONF"; then
			echo "The $EXPECTED_ENTRY entry was found in the file / Запись $EXPECTED_ENTRY найдена в файле"
			EMAIL=$user_email
		else
			echo "The $EXPECTED_ENTRY entry was not found in the file / Запись $EXPECTED_ENTRY не найдена в файле"
			read -p "Enter email / Введите email: " EMAIL
			echo "user_email=\"$EMAIL\"" >  $CONF 
		fi
	else
		echo "$CONF file not found / Файл $CONF не найден"
	fi	
}

CheckConfDistroFunc() {
	EXPECTED_ENTRY="user_distro"

	if [[ -f  $CONF ]]; then
		echo "$CONF file found / Файл $CONF найден"
	  
		if grep -q "$EXPECTED_ENTRY" "$CONF"; then
			echo "The $EXPECTED_ENTRY entry was found in the file / Запись $EXPECTED_ENTRY найдена в файле"
			DISTRO=$user_distro
		else
			echo "The $EXPECTED_ENTRY entry was not found in the file / Запись $EXPECTED_ENTRY не найдена в файле"
			DISTRO=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"' | sed 's/ Linux//')
			echo "user_distro=\"$DISTRO\"" >> $CONF 
			echo "$EXPECTED_ENTRY is now defined / $EXPECTED_ENTRY теперь определен"
		fi
	else
		echo "$CONF file not found / Файл $CONF не найден"
	fi	
}

CheckConfLangFunc() {
	EXPECTED_ENTRY="user_lang"

	if [[ -f $CONF ]]; then
		echo "$CONF file found / Файл $CONF найден"
	  
		if grep -q "$EXPECTED_ENTRY" "$CONF"; then
			echo "The $EXPECTED_ENTRY entry was found in the file / Запись $EXPECTED_ENTRY найдена в файле"
			LANG=$user_lang
		else
			echo "The $EXPECTED_ENTRY entry was not found in the file / Запись $EXPECTED_ENTRY не найдена в файле"
			read -p "Enter language / Введите язык(en - english, ru - russian): " LANG 
			echo "user_lang=\"$LANG\"" >>  $CONF 
		fi
	else
		echo "$CONF file not found / Файл $CONF не найден"
	fi	
}

createShortcut() {
	echo "$(whoami) ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
	SHORTCUT="/home/$(whoami)/Scripts/script.desktop"
	if [[ -f $SHORTCUT ]]; then
		chmod +x $SHORTCUT
		sudo mv $SHORTCUT /usr/share/applications/
		sudo mv /usr/share/applications/timeshift-gtk.desktop $SHORTCUT 
		echo "Shortcut created / Ярлык создан"
	else
		echo " .desktop file does not exist or has it already been created / Для ярлыка не найден соответствующий файл или ярлык уже был создан"
	fi
	sudo rm /etc/sudoers.d/$(whoami)
}

echo "---------------------------------------------------------------------------"
CheckConfMailFunc
echo "---------------------------------------------------------------------------"
CheckConfDistroFunc
echo "---------------------------------------------------------------------------"
CheckConfLangFunc
echo "---------------------------------------------------------------------------"
createShortcut
echo "---------------------------------------------------------------------------"

echo -e "\e[32mYour settings / Ваши настройки\e[0m"

echo $EMAIL
echo $DISTRO
echo $LANG