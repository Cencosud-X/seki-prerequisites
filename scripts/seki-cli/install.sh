#!/bin/bash

installPath=$1      # INSTALL PATH ARG
version=$2           # VERSION TO INSTALL
UNAME=$(uname)      # OS NAME
ARCH=$(uname -m)    # ARCH OS IDENTIFIER
releases_api_url=https://github.com/Cencosud-X/seki-schemas/releases/download
sekiPath=""         # SEKI INSTALLATION PATH
v=""         # SEKI VERSION

if [ "$installPath" != "" ]; then
    sekiPath=$installPath
else
    sekiPath=/usr/local/bin
fi

if [ "$version" != "" ]; then
    v=$version
else
    v=$(curl --silent "https://api.github.com/repos/Cencosud-X/seki-schemas/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
fi

rmOldFiles() {
    if [ -f $sekiPath/seki ]; then
        rm -rf $sekiPath/seki*
    fi
}

mainCheck() {
    echo "\r\n> Installing seki version $v ...";
    name="";

    if [ "$UNAME" == "Darwin" ]; then
        name="seki_macos_${v}";
#        if [ $ARCH = "x86_64" ]; then
#            name="instal_macos_${v}_amd64"
#        elif [ $ARCH = "arm64" ]; then
#            name="instal_macos_${v}_arm64"
#        fi
        sekiURL=$releases_api_url/$v/$name.zip;
        echo "> Downloading $sekiURL \r\n";
        curl -LO $sekiURL;
        chmod 755 $name.zip;
        unzip -o $name.zip -d $name;

        rm $name.zip;

        # create install path if not exist
        if [ ! -d "$sekiPath" ]; then
            echo "$sekiPath not found, creating instead";
            mkdir -p -m 775 $sekiPath
        fi

        # move to install path
        cp $name/seki $sekiPath/seki;
        rm -rf $name;

    elif [ "$UNAME" == "Linux" ]; then
        name="seki_linux_${v}";
#        if [ $ARCH = "x86_64" ]; then
#            name="instal_linux_${v}_amd64"
#        elif [ $ARCH = "i686" ]; then
#            name="instal_linux_${v}_386"
#        elif [ $ARCH = "i386" ]; then
#            name="instal_linux_${v}_386"
#        elif [ $ARCH = "arm64" ]; then
#            name="instal_linux_${v}_arm64"
#        elif [ $ARCH = "arm" ]; then
#            name="instal_linux_${v}_arm"
#        fi
        sekiURL=$releases_api_url/$v/$name.zip;
        curl -LO $sekiURL;
        chmod 755 $name.zip;
        unzip $name.zip -d $name;
        rm $name.zip;
        mv $name/seki $sekiPath;
        rm -rf $name;
    fi
    
    # chmod
    chmod 755 $sekiPath/seki;
}

rmOldFiles
mainCheck

res=$($sekiPath/seki --version)
if [[ $res ]]; then
    echo "\r\n> 🙏 Thanks for installing Seki CLI! If this is your first time using the CLI, be sure to run `$sekiPath/seki --help` first."
else
    echo "Download failed 😔"
    echo "Please try again."
    exit 1;
fi
