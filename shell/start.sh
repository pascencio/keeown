#!/bin/sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
. ~/.bashrc
nvm install node
cd src/ui
npm install
npm run build
cd ~
bin/keeown