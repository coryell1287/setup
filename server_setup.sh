#!/bin/bash

echo -e "\n\n\t\e[1;35mBeginning server setup.\n\n\e[0m"

#Install dependencies

sudo npm i -S express
sudo npm i -S cors
sudo npm i -S http-server
sudo npm i -S nodemon
sudo npm i -S helmet

sudo npm i -S babel-cli babel-es6-polyfill
sudo npm i -S babel-preset-env
sudo npm i -S babel-preset-stage-0
sudo npm i -S bcrypt-nodejs
sudo npm i -S morgan
sudo npm i -S body-parser

mkdir ./{dist,lib,api}

sed -i '/"clean":/a \\t"server": "nodemon lib\/server.js --exec babel-node --presets env,stage-2",' package.json
sed -i '/"start":/a \\t"build": "babel lib -d dist --presets env,stage-2",' package.json
sed -i '/"build":/a \\t"server": "node dist\/server.js",' package.json

echo -e "export default app => {
  app.get('/rest', (req, res) => {
   res.setHeader('Content-Type', 'application/json');
   res.send({ message: 'Service is properly working.' });
  });
}">./lib/router.js

echo "import express, { favicon } from 'express';
import path from 'path';
import cors from 'cors';
import morgan from 'morgan';
import http from 'http';
import bodyParser from 'body-parser';
import helmet from 'helmet';
import router from './router';

const port = process.env.PORT || 4000;
const app = express();
const publicPath = path.join(__dirname, '../public');

app.use(cors());
app.use(helmet());
app.use(favicon());
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
});">./server.js


echo -e "\n\n\t\e[1;32mLaunching appliction.\n\n\e[0m"

npm run server
