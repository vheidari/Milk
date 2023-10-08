#!/usr/bin/bash

#=========================[ Milk PHP Version Manager ]============================
# Author : vheidari
# Email  : vahid-heidari@hotmail.com
# GitHub : https://github.com/vheidari/Milk
# Versuib : 0.1.0
# ----------------------------------------------------------------------------------

# Todo : (refactoring sed part) through -e switch we could run multiple replacement replacement -e with multiple pipe 
#   - link : https://unix.stackexchange.com/questions/268640/make-multiple-edits-with-a-single-call-to-sed


# [App variables]
appName="🥛 Milk"
appVersion="0.1.0"
milkConfigFile="MilkConfig.json"

# [Output stream variables]
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

# [PHP/PHPFpm Version variables]
currentPhpVersion=
currentPhpFpmVersion=
isPhpExist=
phpServerIp="127.0.0.1"
phpServerPort="1520"

# [Proxy Variables]
httpProxy=
httpsProxy=

# [PHP Packages Variables]
baseUrl="https://www.php.net"
baseDownloadUrl="https://www.php.net/distributions"
fileExt="tar.xz"
# ["https://www.php.net/distributions/php-7.4.27.tar.xz"]
lastVersion=
currentDir=$(pwd)
packagesDir="$currentDir/packages"
phpInstallDir="$currentDir/versions/php"
phpSrouceDir="$currentDir/src/php"
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

# [Get user system pa$$word]
setUserPassword () {
    echo -e "${redColor}‼️  Note 1: To Installing${endColor}${bold} ${appName} ${normal}${redColor} and its requirement tools ${endColor}${bold} ${appName} ${normal}${redColor}need your system password.${endColor}"
    echo -e "${redColor}‼️  Note 2: If you have any question about Pa\$\$word please check ${bold}FAQ Questions${normal} ${redColor}in the README.md file. ${endColor}"
    echo "${bold}🛡️  Please input your pa\$\$word :${normal}"
    
    # [-s stand for a secure read input]
    read -s getUserPassword
    
    # [checking password is correct or not]
    if echo "$getUserPassword" | sudo -S true 2>/dev/null; then
        clear
        echo -e "${bold}${greeColor}👌️ Awesome thank You, your pa\$\$word is correct and let's go ...${endColor}${normal}"
        echo ""
    else 
        clear
        echo -e ${bgRedColor}
        echo "‼️ :(, Your Pa\$\$word is incorrect. let's try It again !"
        echo -e ${bgEndColor}
        echo ""
        setUserPassword
    fi
}

# [Create a download url through input argument]
createDownloadUrl () {
    local getInputsArgs=$1
    local patternOne="^php-[0-9]+\.[0-9]+\.[0-9]+\.tar\.xz$"
    local patternTwo="^php-[0-9]+\.[0-9]+\.[0-9]+$"
    local downloadUrl=
        
    if [[ $getInputsArgs != "" && $getInputsArgs =~ $patternOne ]]; then
        downloadUrl="${baseDownloadUrl}/${getInputsArgs}"
        echo $downloadUrl
    elif [[ $getInputsArgs =~ $patternTwo ]]; then
        downloadUrl="${baseDownloadUrl}/${getInputsArgs}.$fileExt"
        echo $downloadUrl
    else
        echo -e ${bgRedColor}
             echo "Unfortuanly this \"$getInputsArgs\" package name isn't valid!. please use Milk with [--help] switch. "
        echo -e ${bgEndColor}
    fi
}

# [Downloading the latest version of PHP]
downloadLastVersion () {
    # [create package path]
    local packagePath="$packagesDir/$packageName"
    
	# [check local package is exist if not download it. if yep extract it]
	if [ ! -f "${packagePath}" ]; then
		printStartLine
		echo "Start to downloading latest version of PHP : ${packageName} from ${baseUrl}"
		printStartLine

		echo ""
		echo " ⌛️ Please wait..."
		echo " ‼️  Note: Downloading package ${packageName} should be take some minutes ;)"
		echo ""
		wget -P $packagesDir  $lastVersion
		echo " 🔥️ Done :). Downloading package is succesfull : ${packageNameAndVersion}"
		
	
		printStartLine
		echo "Start extracting ${packageName}"
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

# [Configure Common PHP package before compulation]
startConfigureCommonPackage () {

	printStartLine
	echo "start configure $packageNameAndVersion"
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

# [Start Building PHP Engine by Make]
startBuildProject () {
	printStartLine
	echo "Start Build $packageNameAndVersion"
	printStartLine


	echo ""
	echo " ⌛️ Plase wait ..."
	echo " ‼️  Note: Building ${packageNameAndVersion} should be take some minutes. be patient  ;) "	
	echo $getUserPassword | sudo -S make -j${numberOfCore} > /dev/null
	echo " 🔥️ Done :), $packageNameAndVersion successfully compiled!!!"
}

# [Set PHP/PHPFpm version variables if them are exist ]
setDefaultPhpPhpFpmVersion () {
    # [get input arguments]
    getInputsArgs=$1
    
    # [checking php exist on this machine]
    checkingIsPhpInstalled
    
    # [set php version if its installed on the system]
    if [[ ${isPhpExist} == "PHP" ]]; then
    
        case "$getInputsArgs" in  
            "--phpVersion")
                currentPhpVersion=$(php -v 2>/dev/null | head -1 | awk '{print $2}')
            ;;
            "--phpFpmVerison")
                currentPhpFpmVersion=$(php-fpm --version 2>/dev/null | head -1 | awk '{print $2}')
            ;;
            
            "--both")
                currentPhpVersion=$(php -v 2>/dev/null | head -1 | awk '{print $2}')
                currentPhpFpmVersion=$(php-fpm --version 2>/dev/null | head -1 | awk '{print $2}')
            ;;
            
        esac
        
        if [[ $getInputsArgs != "" && ${currentPhpVersion} == "" && ${currentPhpFpmVersion} == "" ]]; then
            echo -e ${bgRedColor}
            echo "👀️ Error: Milk cannot find any [PHP] or [PHP Fpm] engines on your system or you might use a wrong input : ${getInputsArgs} argument !!"
            echo -e ${bgEndColor}
        fi
        
        
    else 
            echo -e ${bgRedColor}
            echo "👀️ Error: Milk cannot find any [PHP] or [PHP Fpm] engines on your system !!"
            echo -e ${bgEndColor}
    fi
        
}

# [Display BuildingToolsChain]
displayBuildToolsInfo () {
    
    # [force update/recheck for BuildingToolsChain on system ]
    inputArg=$1
   
    # [checking for first time run]
    firstRunCheck=$(cat "$currentDir/$milkConfigFile" | jq ".BuildingToolsRequirement.isAllBuildToolsInstall")
   
   
   if [[ ${inputArg} == "--updateIt" || ${firstRunCheck} == "false" ]]; then
    
	# [get BuildingTool information]
	local getGpp=$(which g++)
	local getGcc=$(which gcc) 
	local getMake=$(which make)
	local getCmake=$(which cmake)
	local getGppVersion=$(g++ --version | grep -iE '[[:digit:]].[[:digit:]].[[:digit:]]' | awk '{print $4}')
	local getGccVersion=$(gcc --version | grep -iE '[[:digit:]].[[:digit:]].[[:digit:]]' | awk '{print $4}') 
	local getMakeVersion=$(make --version | grep -iE '[[:digit:]].[[:digit:]].[[:digit:]]' | head -1 | awk '{print $3}')
	local getCmakeVersion=$(cmake --version | head -1 | awk '{print $3}')
	
    # [updating MilkConfig.json with BuildingTools info ]
	local updateMilkConfig=$(cat "$currentDir/$milkConfigFile" | jq ".BuildingToolsRequirement.Gpp[0].version =\"${getGppVersion}\"")
	updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.Gpp[1].location =\"${getGpp}\"")
	updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.Gcc[0].version =\"${getGccVersion}\"")
	updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.Gcc[1].location =\"${getGcc}\"")
	updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.Make[0].version =\"${getMakeVersion}\"")
	updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.Make[1].location =\"${getMake}\"")
	updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.CMake[0].version =\"${getCmake}\"")
	updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.CMake[1].location =\"${getCmakeVersion}\"")
	
	# [checking mark isAllBuildToolsInstall to true. if all build requirement were install]
	if [[  ${getGpp} != "" && ${getGppVersion} != "" && ${getGcc} != "" && ${getGccVersion} != "" && ${getMake} != "" &&  ${getMakeVersion} != "" &&  ${getCmake} != "" && ${getCmakeVersion} != "" ]]; then
       updateMilkConfig=$(echo $updateMilkConfig | jq ".BuildingToolsRequirement.isAllBuildToolsInstall =true")
	fi
	
    # [update MilkConfig.json with new BuildingToolsChain info]
	echo $updateMilkConfig > "$currentDir/$milkConfigFile"
	
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
    
    fi

}

# [Todo: getting avaibles Composer list]
queryForComoserVersion() {
	curl https://getcomposer.org/download/ | grep 'composer.phar' | sed 's/<a href="\///g' | grep "download/" | sed 's/"//g' | sed 's/download\//📦<fe0f> https:\/\/getcomposer.org\/download\//g' | sed 's/ //g' | sed 's/(//g' > phpComposerList.txt
}

# [Getting and Display available PHP Engine list]
queryForPHPPackages () {
    
    # [get input argument]
    local getInputsArgs=$1
    
    # [checking request is for lattest version ?]
    if [[ ${getInputsArgs} == "--get-last-version" ]]; then
        local getLastVersion=$(curl -s https://www.php.net/releases/ | grep tar.xz | sed 's/<a href="/https:\/\/www.php.net/g' | sed 's/">.*//g' | sed 's/<li>//g' | sed 's/https:\/\//📦️ https:\/\//g' | sed 's/http:\/\/museum.php.net\/*//g' | sed 's/https:\/\/www.php.netphp5\/php-.*//g' | head -1)
        echo "$getLastVersion"
    else 
        # [ just display all avaibles php packages ]
        getAllPHPPackages=$(curl -s https://www.php.net/releases/ | grep tar.xz | sed 's/<a href="/https:\/\/www.php.net/g' | sed 's/">.*//g' | sed 's/<li>//g' | sed 's/https:\/\//📦️ https:\/\//g' | sed 's/http:\/\/museum.php.net\/*//g' | sed 's/https:\/\/www.php.netphp5\/php-.*//g')
        
        echo "$getAllPHPPackages"
    fi
	
    
}


# [Getting lastes version of php through queryForPHPPackages function ]
getLatestPHPVersion () {
    local getInputsArgs=$1
    local lastPHPVersion=$( queryForPHPPackages "--get-last-version" )
    
    # [if is true just show last PHP Version URL]
    if [[  ${getInputsArgs} == "--display-last-version" ]]; then 
        echo $lastPHPVersion
    else 
        # [update lastVersion variable]
        lastVersion=$lastPHPVersion
    fi
}


# [Display all package that downloaded on the disk]
# [@Callable: Direct Callable function]
listOfLocalPackage () {
	printStartLine
	echo "📦 ${bold} List of local packages ${normal} :"
	printStartLine

	packages=$(ls $packagesDir | grep .tar.xz)
	echo $packages |  sed 's/ /\n/g' | sed 's/php/📦 php/g';
}


# [Display PHP-FPM UserName/GroupName]
# [@Callable: Direct Callable function]
fpmUserNameAndGroupName () {
	echo 🙋 "PHP-FPM Username  : " ${fpmUserName}
	echo 🙋 "PHP-FPM Groupname : " ${fpmGroupName}
}


# [Todo: Looking for .bashrc and .zshrc file]
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


# [Installing requirement Tools through apt on the machine]
installIt () {
    tool=$1
    echo ""
    echo " ⌛️ Please wait..."
    echo " ‼️  Note: ${appName} use ${tool} to manage package on your machine. be pation to install it"
    echo $getUserPassword | sudo -S apt-get update >/dev/null
    echo $getUserPassword | sudo -S apt-get install $tool -y >/dev/null
    echo " 🔥️ Done :). ${tool} install successfuly"
}


# [Checking/Installing requirement tools for Milk]
checkingRequirements () {
    
    # [get input argument]
    inputArg=$1

    # [checking for system tools]
    isWgetInstalled=$(dpkg-query -s wget 2>/dev/null | grep -iE installed | head -1)
    isCurlInstalled=$(dpkg-query -s curl 2>/dev/null | grep -iE installed | head -1)
    isCatInstalled=$(dpkg-query -s coreutils 2>/dev/null | grep -iE installed | head -1)
    isTarInstalled=$(dpkg-query -s tar 2>/dev/null | grep -iE installed | head -1)
    isGzipInstalled=$(dpkg-query -s gzip 2>/dev/null | grep -iE installed | head -1)
    isSedInstalled=$(dpkg-query -s sed 2>/dev/null | grep -iE installed | head -1)
    isAwkInstalled=$(dpkg-query -s gawk 2>/dev/null | grep -iE installed | head -1)
    isGrepInstalled=$(dpkg-query -s grep 2>/dev/null | grep -iE installed | head -1)
    isJqInstalled=$(dpkg-query -s jq 2>/dev/null | grep -iE installed | head -1)
    isTrInstalled=$(dpkg-query -s coreutils 2>/dev/null | grep -iE installed | head -1)
    
    
    local updateMilkConfig=$(cat ./MilkConfig.json)
    
    # [install wget]
    if [[ ${isWgetInstalled} ]]; then
        local wgetVersion=$(wget --version | head -1 |  grep -o -iE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
        local wgetLocation=$(which wget)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.wget[0].version=\"${wgetVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.wget[1].location=\"${wgetLocation}\"")
        echo -e "${bold}🍼️ [wget]${normal}  -> ${greeColor}package was install${endColor}"
    else 
        installIt wget
    fi
    
    # [install curl] 
    if [[ ${isCurlInstalled} ]]; then
        local curlVersion=$(curl --version | head -1 | awk '{print $2}')
        local curlLocation=$(which curl)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.curl[0].version=\"${curlVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.curl[1].location=\"${curlLocation}\"")
        echo -e "${bold}🍼️ [curl]${normal}  -> ${greeColor}package was install${endColor}"
    else 
        installIt curl
    fi
    
    # [install cat] 
    if [[ ${isCatInstalled} ]]; then
        local catVersion=$(cat --version | head -1 | awk '{print $4}')
        local catLocation=$(which cat)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.cat[0].version=\"${catVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.cat[1].location=\"${catLocation}\"")
        echo -e "${bold}🍼️ [cat]${normal}   -> ${greeColor}package was install${endColor}"
    else 
        installIt coreutils
    fi
    
    # [install tar]
    if [[ ${isTarInstalled} ]]; then
        local tarVersion=$(tar --version | head -1 | awk '{print $4}')
        local tarLocation=$(which tar)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.tar[0].version=\"${tarVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.tar[1].location=\"${tarLocation}\"")
        echo -e "${bold}🍼️ [tar]${normal}   -> ${greeColor}package was install${endColor}"
    else 
        installIt tar
    fi
    
    # [install gzip]
    if [[ ${isGzipInstalled} ]]; then
        local gzipVersion=$(gzip --version | head -1 | awk '{print $2}')
        local gzipLocation=$(which gzip)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.gzip[0].version=\"${gzipVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.gzip[1].location=\"${gzipLocation}\"")
        echo -e "${bold}🍼️ [gzip]${normal}  -> ${greeColor}package was install${endColor}"
    else 
        installIt gzip
    fi
    
    # [install sed]
    if [[ ${isSedInstalled} ]]; then
        local sedVersion=$(sed --version | head -1 | awk '{print $4}')
        local sedLocation=$(which sed)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.sed[0].version=\"${sedVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.sed[1].location=\"${sedLocation}\"")
        echo -e "${bold}🍼️ [sed]${normal}   -> ${greeColor}package was install${endColor}"
    else 
        installIt sed
    fi
    
    # [install awk]
    if [[ ${isAwkInstalled} ]]; then
        local awkVersion=$(awk --version | head -1 | awk '{print $3}' | sed 's/,//g')
        local awkLocation=$(which awk)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.gawk[0].version=\"${awkVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.gawk[1].location=\"${awkLocation}\"")
        echo -e "${bold}🍼️ [awk]${normal}   -> ${greeColor}package was install${endColor}"
    else 
        installIt gawk
    fi
    
    # [install grep]
    if [[ ${isGrepInstalled} ]]; then
        local grepVersion=$(grep --version | head -1 | awk '{print $4}')
        local grepLocation=$(which grep)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.grep[0].version=\"${grepVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.grep[1].location=\"${grepLocation}\"")
         echo -e "${bold}🍼️ [grep]${normal}  -> ${greeColor}package was install${endColor}"
    else 
        installIt grep
    fi
    
    # [install jq]
    if [[ ${isJqInstalled} ]]; then
        local jqVersion=$(jq --version | tr "-" " " | awk '{print $2}')
        local jqLocation=$(which jq)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.jq[0].version=\"${jqVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.jq[1].location=\"${jqLocation}\"")
        echo -e "${bold}🍼️ [jq]${normal}    -> ${greeColor}package was install${endColor}"
    else 
        installIt jq
    fi
    
    # [install tr]
    if [[ ${isTrInstalled} ]]; then
        local trVersion=$(tr --version | head -1 | awk '{print $4}')
        local trLocation=$(which tr)
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.tr[0].version=\"${trVersion}\"")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkRequirementTools.tr[1].location=\"${trLocation}\"")
        echo -e "${bold}🍼️ [tr]${normal}    -> ${greeColor}package was install${endColor}"
    else 
        installIt coreutils
    fi
    
    # [updating MilkConfig.json with new information ]
    echo $updateMilkConfig > ./MilkConfig.json
    
}

# [Forcing update MilkConfig.json ]
forceUpdateMilkConfig () {
    checkingRequirements
    displayBuildToolsInfo
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


# [Set Proxy for curl/wget]
# [@Callable: Dircet callable function]
setProxy () {
    local getInputsArgs=$@
    local getOption=$(echo $getInputsArgs | awk '{print $1}')
    
    if [[ $getOption == "--proxy" ]]; then
        httpProxy=$(echo $getInputsArgs | awk '{print $2}')
        httpsProxy=$(echo $getInputsArgs | awk '{print $3}')
        
        # [set proxy in config file]
        if [[ ${httpProxy} != "" && ${httpsProxy} != "" ]]; then
            local updateMilkConfig=$(cat "$currentDir/$milkConfigFile" | jq ".proxyInfo.http=\"$httpProxy\"")
            updateMilkConfig=$(echo $updateMilkConfig | jq ".proxyInfo.https=\"$httpsProxy\"")
            echo $updateMilkConfig > "$currentDir/$milkConfigFile"
        fi
        
    else 
        echo -e ${bgRedColor}
        echo "👀️ Error [setProxy]: Wrong input argument you passing : ( ${getOption} ) as input argument. you should use '[--proxy]' as input argument in [setProx] function !!"
        echo -e ${bgEndColor}
    fi
    
    
}


# [Get Php info InBrowsers/Cli]
# [@Callable: Direct callable function]
getPhpInfo() {
    local getInputsArgs=$1
    
    # [checking is php installed]
    checkingIsPhpInstalled
    
    
    # [get Milk local server port]
    getMilkLocalServerPort=$(cat "$currentDir/$milkConfigFile" |  jq ".MilkLocalServerPort" | sed 's/\"//g')
    
    # [checking getMilkLocalServerPort]
    if [[ $getMilkLocalServerPort != "" ]]; then
        phpServerPort=$getMilkLocalServerPort
    fi
    
    if [[ ${isPhpExist} == "PHP" ]]; then
        case "$getInputsArgs" in
            "--cli")
                php -i
            ;;
            "--inbrowser")
                cd "$phpSrouceDir/phpinfo"
                echo -e $bgBlueColor
                echo "${bold}🔥️ To See your PHP Engine information. Please open this address [ http://$phpServerIp:$phpServerPort ] in your browsers. ${normal}"
                echo -e $bgEndColor
                echo -e "${redColor}${bold}‼️  [getPhpInfo]: To stop PHP information server, please use ${whiteColor}[CTRL+C]${endColor}${redColor}${bold} on your keyboard ${normal}${endColor}"
                php -S "$phpServerIp:$phpServerPort"
            ;;
            
        esac
        
    fi
    
    
}


# [Set Milk local server port]
# [@Callable: Direct callable function]
setLocalServerPort () {
    local getInputsArgs=$@
    local setOption="--setlocalport"
    local getOption=$(echo $getInputsArgs | awk '{print $1}')
    local getOptionValue=$(echo $getInputsArgs | awk '{print $2}')
    if [[ ${getInputsArgs} != "" && ${getOption} != "" && ${getOption} == ${setOption} &&  ${getOptionValue} != "" ]]; then
        local updateMilkConfig=$(cat "$currentDir/$milkConfigFile")
        updateMilkConfig=$(echo $updateMilkConfig | jq ".MilkLocalServerPort=\"${getOptionValue}\"")
        echo $updateMilkConfig > "$currentDir/$milkConfigFile"
    else 
       echo -e ${bgRedColor}
       echo -e "👀️Error [setLocalServerPort]: You should pass at least an input argument as [port number] in to this function. !!!${normal}${endColor}" 
       echo -e ${bgEndColor}
    fi
    
}


# [Todo: Setup appropriate php version on the path base on user request]
setPHPOnThePath () {
    echo ""
}


# [Is PHP Installed]
checkingIsPhpInstalled () {
    isPhpExist=$(php --version 2>/dev/null | head -1 | awk '{print $1}')
}


# [Todo: Show all Options/Switches that use could use as input argument]
help () {
    echo "${bold}🤓️ Help :${normal}"
    echo "this is help functions"
}

# [Todo: Handeling input Options/Switches]
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



# [Todo : Managing phpfpm service start/stop/restart/status]
managePHPFpmEngineService () {
     echo ""
}

# [Todo : Running/Configuring Milk through browsers - dep:netcat http server]
managerTroughtUI () {
    echo ""
}




# [Get all user input arguments]
getInputsArgs=$@

# printStartLine
echo "${bold}Welcome to ${appName}. Version (${appVersion}) ${normal}"
printStartLine



#=========================[ Milk RunTime ]============================


# setUserPassword

# [First Stage / checkingRequirements ]
# checkingRequirements

# [Checking Building Tools requirement]
# checkBuildingRequirement


handelingInputCommand $getInputsArgs
setLocalServerPort "--setlocalport 2022"
getPhpInfo --inbrowser


# setProxy --proxy http://127.0.0.1:2512 https://127.0.0.1:2513


# 
# checkingIsPhpInstalled
# setDefaultPhpPhpFpmVersion --both


# setDefaultPhpPhpFpmVersion
# 
# echo $isPhpExist
# echo $currentPhpVersion
# echo $currentPhpFpmVersion

# createDownloadUrl "php-7.4.27.tar.xz"
# createDownloadUrl "php-7.4.7"

# queryForPHPPackages --get-last-version
# queryForPHPPackages
# getLatestPHPVersion --display-last-version
# forceUpdateMilkConfig
# listOfLocalPackage


# checkingRequirements
# 
# displayBuildToolsInfo
# getPhpVersion

# checkBuildToolsVersion

# downloadLastVersion
# startConfigureCommonPackage
#startBuildProject
# getPhpVersion
# listOfLocalPackage
# checkingRequirements
# fpmUserNameAndGroupName
# echo $packagesDir

