#/bin/sh
mkdir src/ui/dist
cp index.html src/ui/dist
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
. ~/.bashrc
nvm install node
cd src/ui
npm install
npm run build