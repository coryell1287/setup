#!/usr/bin/env bash

echo -e "\n\n\t\e[1;35mBeginning Karma setup.\n\n\e[0m"

#Install dependencies

sudo npm install --save-dev express
sudo npm install --save-dev nodemon
sudo npm install --save-dev cors
sudo npm install --save-dev http-server

mkdir ./{dist,lib}

sed -i '/"clean":/a \\t"start": "nodemon lib\/server.js --exec babel-node --presets es2015,stage-2",' package.json
sed -i '/"start":/a \\t"build": "babel lib -d dist --presets es2015,stage-2",' package.json
sed -i '/"build":/a \\t"serve": "node dist\/server.js",' package.json


echo "import express from 'express';
import path from 'path';
import cors from 'cors';

const port = process.env.PORT || 4000;
const app = express();
const publicPath = path.join(__dirname, '../public');

app.use(cors());

app.use(express.static(publicPath));

app.get('*', (request, response) => {
  response.sendFile(path.resolve(publicPath, 'index.html'));
});

app.listen(port, () => {
  console.log(\`Server has started and is listening on \${port}\`);
});

export default app;">./lib/server.js

echo -e "\n\n\t\e[1;32mLaunching appliction.\n\n\e[0m"

npm start
