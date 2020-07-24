#!/bin/sh
go build -o ../bin/keeown -v ../src/api
if [ ! -f ~/.bashrc ];
then
    touch ~/.bashrc
fi
if [ ! -d .nvm ];
then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    nvm install npm
fi
source ~/.bashrc
cd src/ui
npm install
npm run build
cd ../..
./bin/keeown