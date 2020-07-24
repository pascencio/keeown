#!/bin/sh
go build -o ~/bin/keeown -v ~/src/api
if [ ! -d .nvm ];
then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    source ~/.bashrc
    nvm install npm
fi
cd src/ui
npm install
npm run build
cd ~
bin/keeown