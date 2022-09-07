#!/bin/bash

installPath=$1
sekiPath=""

if [ "$installPath" != "" ]; then
    sekiPath=$installPath
else
    sekiPath=/usr/local/bin
fi

UNAME=$(uname)
ARCH=$(uname -m)

rmOldFiles() {
    if [ -f $sekiPath/seki ]; then
        sudo rm -rf $sekiPath/seki*
    fi
}


v=$(curl --silent "https://api.github.com/repos/Cencosud-X/seki-schemas/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

releases_api_url=https://github.com/Cencosud-X/seki-schemas/releases/download

successInstall() {
    echo "🙏 Thanks for installing Seki CLI! If this is your first time using the CLI, be sure to run `seki --help` first."
}

mainCheck() {
    echo "Installing seki version $v"
    name=""

    if [ "$UNAME" == "Linux" ]; then
      name="seki_linux_${v}"
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

        sekiURL=$releases_api_url/$v/$name.zip
        curl -LO $sekiURL
        sudo chmod 755 $name.zip
        unzip $name.zip
        rm $name.zip

        # instal
        sudo mv $name/seki $sekiPath

        rm -rf $name

    elif [ "$UNAME" == "Darwin" ]; then
      name="seki_macos_${v}"
#        if [ $ARCH = "x86_64" ]; then
#            name="instal_macos_${v}_amd64"
#        elif [ $ARCH = "arm64" ]; then
#            name="instal_macos_${v}_arm64"
#        fi


        sekiURL=$releases_api_url/$v/$name.zip
        echo "Downloading from: $sekiURL ..."
        curl -LO $sekiURL
        sudo chmod 755 $name.zip
        unzip $name.zip -d $name
        rm $name.zip

        # move to home path
        sudo mv $name/seki $sekiPath

        rm -rf $name

    fi

    # chmod
    sudo chmod 755 $sekiPath/seki
}

rmOldFiles
mainCheck

if [ -x "$(command -v seki)" ]; then
    successInstall
else
    echo "Download failed 😔"
    echo "Please try again."
fi