#!/bin/bash

echo -e "\n\n\t\e[1;35mBeginning server setup.\n\n\e[0m"

#Install dependencies

sudo npm install --save-dev express
sudo npm install --save-dev cors
sudo npm install --save-dev http-server
sudo npm install --save-dev nodemon

sudo npm i babel-cli babel-es6-polyfill
sudo npm i babel-preset-es2015
sudo npm i babel-preset-stage-0
sudo npm i bcrypt-nodejs
sudo npm i morgan
sudo npm i body-parser

# react dependencies
sudo npm install --save react react-dom react-addons-test-utils
sudo npm install --save object-assign
sudo npm install --save es6-promise
sudo npm install --save es6-shim
sudo npm install --save whatwg-fetch

#Install bootstrap
sudo npm install --save bootstrap

# Development dependencies
sudo npm install --save-dev babelify babel-core
sudo npm install --save-dev babel-preset-react babel-preset-es2015 babel-es6-polyfill babel-preset-stage-0
sudo npm install --save-dev babel-plugin-transform-class-properties
sudo npm install --save-dev babel-plugin-transform-react-jsx


mkdir ./{dist,lib}

sed -i '/"clean":/a \\t"start": "nodemon lib\/server.js --exec babel-node --presets es2015,stage-2",' package.json
sed -i '/"start":/a \\t"build": "babel lib -d dist --presets es2015,stage-2",' package.json
sed -i '/"build":/a \\t"serve": "node dist\/server.js",' package.json


echo "import express from 'express';
import path from 'path';
import cors from 'cors';
import morgan from 'morgan';
import http from 'http';
import bodyParser from 'body-parser';
import router from './router';

const port = process.env.PORT || 4000;
const app = express();
const publicPath = path.join(__dirname, '../public');

app.use(cors());
app.use(morgan('combined'));
app.use(bodyParser.json({ type: '*/* }));

router(app);

app.use(express.static(publicPath));

app.get('*', (request, response) => {
  response.sendFile(path.resolve(publicPath, 'index.html'));
});

const port = process.env.PORT || 4000;
const server = http.createServer(app);

server.listen(port, () => {
  console.log(\`Server has started and is listening on \${port}\`);
});

export default app;">./lib/server.js


echo -e "export default app => {
  app.get('/', (req, res) => {
   res.send({ message: 'Service is properly working.' });
  });
}
">./lib/router.js

echo -e "\n\n\t\e[1;32mLaunching appliction.\n\n\e[0m"

npm start
