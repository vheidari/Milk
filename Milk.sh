#!/usr/bin/bash

#=========================[ Milk PHP Version Manager ]============================
# Author : vheidari
# Email  : vahid-heidari@hotmail.com
# GitHub : https://github.com/vheidari/Milk
# Versuib : 0.1.0
# ----------------------------------------------------------------------------------

# [App Variables]
appName="🥛 Milk"
appVersion="0.1.0"

# [Output stream variables ]
bold=$(tput bold)
normal=$(tput sgr0)
# [Text color]
redColor="\e[31m"
greeColor="\e[32m"
blueColor="\e[34m"
whiteColor="\e[97m"
grayColor="\e[90m"
cyanColor="\e[36m"
endColor="\e[0m"
# [Background color]
bgRedColor="\033[41m"
bgGreeColor="\033[42m"
bgBlueColor="\033[44m"
bgYellowColor="\033[43m"
bgWhiteColor="\033[47m"
bgEndColor="\033[0m"



# [PHP Packages Variables]
baseUrl="https://www.php.net"
#lastVersion="https://www.php.net/distributions/php-8.2.9.tar.xz"
lastVersion="https://www.php.net/distributions/php-7.4.27.tar.xz"
currentDir=$(pwd)
packagesDir="$currentDir/packages"
phpInstallDir="$currentDir/versions/php"
packageName=$(echo $lastVersion | sed 's/https:\/\/.*\///g') 
packageDirName=$(echo $packageName | sed 's/.tar.xz//g')
packageNameAndVersion=${packageDirName}
currentPhpVersion=
listOfPackages=
listOfComposers=

# [GetUser Password]
getUserPassword=

# [Default User And Group For PHP-FPM]
fpmUserName="www-data"
fpmGroupName="www-data"


# [Compulation variables]
numberOfCore=$(nproc)

printStartLine () {
	echo "-------------------------------------------------------------------------------------------"
}

printEndLine () {
	echo "==========================================================================================="
}

setUserPassword () {
    echo -e "${redColor}‼️  Note: To Installing${endColor} ${appName} ${redColor}requirement tools and compiling source code${endColor} ${appName} ${redColor}needed your password.${endColor}"
    echo "${bold}Please input your password :${normal}"
    read getUserPassword
    
    if echo "$getUserPassword" | sudo -S true 2>/dev/null; then
        clear
        echo -e "${bold}${greeColor}👌️ Awesome thank You, your password is correct and let's go ...${endColor}${normal}"
        echo ""
    else 
        clear
        echo -e ${bgRedColor}
        echo "‼️ :(, Your Password is incorrect. let's try again !"
        echo -e ${bgEndColor}
        echo ""
        setUserPassword
    fi
}


downloadLastVersion () {

	# [Check wget is exist if not install it] 
	local isWgetExist=$(which wget)
	if [ ! -f "$isWgetExist" ]; then
		printStartLine
		echo "	 				Start to install latest version of the wget"
		printStartLine

		echo ""
		echo " ⌛️ Please wait..."
		echo " ‼️  Note: ${appName} use wget to manage package on your machine. be pation to install it"
		sudo apt-get install wget 
		echo " 🔥️ Done :). wget install successfuly"
	fi
    
    local packagePath="$packagesDir/$packageName"
	#  [ Check local package is exist if not download it. if yep extract it]
	if [ ! -f "${packagePath}" ]; then
		printStartLine
		echo "	 Start to downloading latest version of PHP : ${packageName} from ${baseUrl}"
		printStartLine

		echo ""
		echo " ⌛️ Please wait..."
		echo " ‼️  Note: Downloading package ${packageName} should be take some minutes ;)"
		echo ""
		wget -P $packagesDir  $lastVersion
		echo " 🔥️ Done :). Downloading package is succesfull : ${packageNameAndVersion}"
		
	
		printStartLine
		echo "				Start extracting ${packageName}"
		printStartLine

		tar -xf $packageName -C $phpInstallDir > /dev/null
		cd "$phpInstallDir/$packageDirName"
		echo " 🔥️ Extraction is Done : ${packageName}"

		printEndLine
		
	else
		printStartLine
		echo "				Start extracting ${packageName}"
		printStartLine
		tar -xf $packagePath -C $phpInstallDir > /dev/null
		cd "$phpInstallDir/$packageDirName"
		echo " 🔥️ Extraction is Done : ${packageName}"
		
		printEndLine
	fi
}

startConfigureCommonPackage () {

	printStartLine
	echo "				 start configure $packageNameAndVersion"
	printStartLine

	echo ""
	echo " There are a list of default package and configure that ${appName} configure for ${packageNameAndVersion}  : "
	echo "📦️cli,  📦️fpm,  📦️intl,  📦️mbstring,  📦️opcache,  📦️sockets,  📦️soap,  📦️curl,  📦️freetype"
    echo "📦️fpm-user=www-data,  📦️fpm-group=www-data,  📦️jpeg,  📦️mysql-sock,  📦️mysqli,  📦️openssl" 
    echo "📦️pdo-mysql,  📦️pgsql,  📦️xsl,  📦️zlib,  📦️ffi,  📦️calendar,  📦️bcmath,  📦️exif,  📦️gd,  "
	echo "📦️ftp,  📦️zip,  📦️sysvmsg,  📦️sysvsem,  📦️sysvshm,  📦️shmop,  📦️readline,  📦️gettext"
	echo ""
	echo " ⌛️ Plase wait ..."
	echo " ‼️  Note: Configuring ${packageNameAndVersion} should be take some minutes. be patient ;) "

	echo " ⚙️ Start PreConfig ..."
	echo $getUserPassword | sudo -S ./buildconf
	echo " 🔥️ Done :), successfully PreConfig !!!"
	
	echo "⚙️ Start Configuring ..."
	echo $getUserPassword | sudo -S ./configure \
 		--with-config-file-path=/etc/php/${packageNameAndVersion}/cli \
	    --enable-cli \
		--enable-fpm \
 		--enable-intl \
 		--enable-mbstring \
		--enable-opcache \
 		--enable-sockets \
 		--enable-soap \
		--with-curl \
 		--with-freetype \
 		--with-fpm-user=www-data \
 		--with-fpm-group=www-data \
 		--with-jpeg \
 		--with-mysql-sock \
 		--with-mysqli \
 		--with-openssl \
 		--with-pdo-mysql \
 		--with-pgsql \
 		--with-xsl \
 		--with-zlib \
 		--with-ffi \
 		--enable-calendar \
 		--enable-bcmath \
 		--enable-exif \
 		--enable-gd \
 		--enable-ftp \
 		--with-zip \
 		--enable-sysvmsg \
 		--enable-sysvsem \
 		--enable-sysvshm \
 		--enable-shmop \
 		--with-readline=/usr \
 		--with-gettext=/usr \
		> /dev/null

	echo " 🔥️ Done :), $packageNameAndVersion successfully configure!!!"
	printEndLine
}


startBuildProject () {
	printStartLine
	echo "				 Start Build $packageNameAndVersion"
	printStartLine


	echo ""
	echo " ⌛️ Plase wait ..."
	echo " ‼️  Note: Building ${packageNameAndVersion} should be take some minutes. be patient  ;) "	
	echo $getUserPassword | sudo -S make -j${numberOfCore} > /dev/null
	echo " 🔥️ Done :), $packageNameAndVersion successfully compiled!!!"
}


#todo
getPhpVersion () {
	identifyPHP=$( which php )
	if [ -f "$identifyPHP" ]; then
		# php --version | head -1 | awk '{print $2}' 
		currentPhpVersion=$( /usr/local/bin/php --version | grep -o -w '[0-9].[0-9].[0-9]' | head -1 ) 

	else 
		echo "couldn't find any php on your machine";
	fi
	echo $currentPhpVersion
	echo $identifyPHP
}

# [Display building tools chain ]
displayBuildToolsInfo () {
	# for this part we should use dpkg-query
	local getGpp=$(which g++)
	local getGcc=$(which gcc) 
	local getMake=$(which make)
	local getCmake=$(which cmake)
	local getGppVersion=$(g++ --version | grep -iE '[[:digit:]].[[:digit:]].[[:digit:]]' | awk '{print $4}')
	local getGccVersion=$(gcc --version | grep -iE '[[:digit:]].[[:digit:]].[[:digit:]]' | awk '{print $4}') 
	local getMakeVersion=$(make --version | grep -iE '[[:digit:]].[[:digit:]].[[:digit:]]' | head -1 | awk '{print $3}')
	local getCmakeVersion=$(cmake --version | head -1 | awk '{print $3}')
	
	
	echo -e "${bold}${greeColor}1). G++   :${endColor}${normal}"
	echo -e "       -- g++ version     -> $getGppVersion"
    echo -e "       -- g++ location    -> ${cyanColor}$getGpp ${endColor}"
	echo -e "${bold}${greeColor}2). Gcc   :${endColor}${normal}"
	echo -e "       -- gcc version     -> $getGccVersion"
    echo -e "       -- gcc location    -> ${cyanColor}$getGcc ${endColor}"
	echo -e "${bold}${greeColor}3). Make  :${endColor}${normal}"
	echo -e "       -- make version    -> $getMakeVersion"
    echo -e "       -- make location   -> ${cyanColor}$getMake ${endColor}"
	echo -e "${bold}${greeColor}4). Cmake :${endColor}${normal}"
	echo -e "       -- cmake version   -> $getCmakeVersion"
    echo -e "       -- cmake location  -> ${cyanColor}$getCmake ${endColor}"

}



#todo
queryForComoserVersion() {
	curl https://getcomposer.org/download/ | grep 'composer.phar' | sed 's/<a href="\///g' | grep "download/" | sed 's/"//g' | sed 's/download\//📦<fe0f> https:\/\/getcomposer.org\/download\//g' | sed 's/ //g' | sed 's/(//g' > phpComposerList.txt
}

#todo
queryListOfPackage () {
	curl https://www.php.net/releases/ | grep tar.xz | sed 's/<a href="/https:\/\/www.php.net/g' | sed 's/">.*//g' | sed 's/<li>//g' | sed 's/https:\/\//📦️ https:\/\//g'
}


# [Display available packages]
listOfLocalPackage () {
	printStartLine
	echo "			📦 ${bold} List of local packages ${normal} :											 "
	printStartLine

	packages=$(ls $packagesDir | grep .tar.xz)
	echo $packages |  sed 's/ /\n/g' | sed 's/php/📦 php/g';
}



#todo
fpmUserNameAndGroupName () {
	echo 🙋 "PHP-FPM Username  : " ${fpmUserName}
	echo 🙋 "PHP-FPM Groupname : " ${fpmGroupName}
}


# [Looking for .bashrc and .zshrc file]
lookingForZshOrBashConfigFile () {
    local bashrc=$($HOME/.bashrc);
    local zshrc=$($HOME/.zshrc);
    
    if [ -f "$zshrc" ]; then
        # do somethings
        echo ""
    else 
        echo ""
        # do somethings
    fi
    
}


# [Installing requirement packages through apt on the machine]
installIt () {
    tool=$1
    echo ""
    echo " ⌛️ Please wait..."
    echo " ‼️  Note: ${appName} use ${tool} to manage package on your machine. be pation to install it"
    echo $getUserPassword | sudo -S apt-get update >/dev/null
    echo $getUserPassword | sudo -S apt-get install $tool -y >/dev/null
    echo " 🔥️ Done :). ${tool} install successfuly"
}



# [ Checking requirement tools for Milk]
checkingRequirements () {
    # [checking for system tools.]
    isWgetInstalled=$(dpkg-query -s wget 2>/dev/null | grep -iE installed | head -1)
    isCurlInstalled=$(dpkg-query -s curl 2>/dev/null | grep -iE installed | head -1)
    isTarInstalled=$(dpkg-query -s tar 2>/dev/null | grep -iE installed | head -1)
    isGzipInstalled=$(dpkg-query -s gzip 2>/dev/null | grep -iE installed | head -1)
    isSedInstalled=$(dpkg-query -s sed 2>/dev/null | grep -iE installed | head -1)
    isAwkInstalled=$(dpkg-query -s gawk 2>/dev/null | grep -iE installed | head -1)
    isGrepInstalled=$(dpkg-query -s grep 2>/dev/null | grep -iE installed | head -1)
    isJqInstalled=$(dpkg-query -s jq 2>/dev/null | grep -iE installed | head -1)
    isTrInstalled=$(dpkg-query -s coreutils 2>/dev/null | grep -iE installed | head -1)
    
    # [install wget]
    if [[ ${isWgetInstalled} ]]; then
        echo -e "${bold}🍼️ [wget]${normal}  ->  ${greeColor}package was install${endColor}"
    else 
        installIt wget
    fi
    
    # [install curl] 
    if [[ ${isCurlInstalled} ]]; then
         echo -e "${bold}🍼️ [curl]${normal}  -> ${greeColor}package was install${endColor}"
    else 
        installIt curl
    fi
    
    # [install tar]
    if [[ ${isTarInstalled} ]]; then
        echo -e "${bold}🍼️ [tar]${normal}   -> ${greeColor}package was install${endColor}"
    else 
        installIt tar
    fi
    
    # [install gzip]
    if [[ ${isGzipInstalled} ]]; then
        echo -e "${bold}🍼️ [gzip]${normal}  -> ${greeColor}package was install${endColor}"
    else 
        installIt gzip
    fi
    
    # [install sed]
    if [[ ${isSedInstalled} ]]; then
        echo -e "${bold}🍼️ [sed]${normal}   -> ${greeColor}package was install${endColor}"
    else 
        installIt sed
    fi
    
    # [install awk]
    if [[ ${isAwkInstalled} ]]; then
        echo -e "${bold}🍼️ [awk]${normal}   -> ${greeColor}package was install${endColor}"
    else 
        installIt gawk
    fi
    
    # [install grep]
    if [[ ${isGrepInstalled} ]]; then
         echo -e "${bold}🍼️ [grep]${normal}  -> ${greeColor}package was install${endColor}"
    else 
        installIt grep
    fi
    
    # [install jq]
    if [[ ${isJqInstalled} ]]; then
        echo -e "${bold}🍼️ [jq]${normal}    -> ${greeColor}package was install${endColor}"
    else 
        installIt jq
    fi
    
    # [install tr]
    if [[ ${isTrInstalled} ]]; then
        echo -e "${bold}🍼️ [tr]${normal}    -> ${greeColor}package was install${endColor}"
    else 
        installIt coreutils
    fi
    
    
}

# [Checking building requirement]
checkBuildingRequirement () {
    local isbuildEssentialInstalled=$(dpkg-query -s build-essential 2>/dev/null | grep -iE Installed | head -1)
    
    if [[ ${isbuildEssentialInstalled} ]]; then
         echo -e "${bold}🍼️ [build-essential] ${normal} was install"
    else 
        installIt $isbuildEssentialInstalled
    fi
    
    
}


# []
setProperPHPVersion () {
    echo ""
}


# [Show all Options/Switches that use could use as input argument]
help () {
    echo "you call help function"
}

# [Handeling input Options/Switches]
handelingInputCommand () {

    local inputArgs=$@
    
    # [options/switches]
    local helpSwitch="--help"
    local shortHelpSwittch="--h"
    local add="--add"
    local packageLists="--localPackages"
    local install="--install"
    local set="--set"
    local buildTools="--buildTools"
    
    case "$inputArgs" in
         $helpSwitch | $shortHelpSwittch | "")
            help
         ;;         
         $packageLists)
            listOfLocalPackage
         ;;
         $buildTools)
            displayBuildToolsInfo
        ;;
    esac
}


# [Get all user input arguments]
getInputsArgs=$@

# printStartLine
echo "${bold}Welcome to ${appName}. Version (${appVersion}) ${normal}"
# printStartLine



#=========================[ Milk RunTime ]============================


setUserPassword

# [First Stage / checkingRequirements ]
# checkingRequirements

# [Checking Building Tools requirement]
# checkBuildingRequirement


handelingInputCommand $getInputsArgs
checkingRequirements


getPhpVersion

# checkBuildToolsVersion

# downloadLastVersion
# startConfigureCommonPackage
#startBuildProject
# getPhpVersion
# listOfLocalPackage
# checkingRequirements
# fpmUserNameAndGroupName
# echo $packagesDir

