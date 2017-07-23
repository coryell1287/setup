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

mkdir ./{dist,lib}

sed -i '/"test":/i \\t"server": "nodemon lib\/server.js --exec babel-node --presets env,stage-2",' package.json
sed -i '/"server":/i \\t"build:sever": "babel lib -d dist --presets env,stage-2",' package.json
sed -i '/"build:sever":/a \\t"server": "node dist\/server.js",' package.json

echo -e "export default app => {
  app.get('/rest', (req, res) => {
   res.setHeader('Content-Type', 'application/json');
   res.send({ message: 'Service is properly working.' });
  });
}">./lib/router.js

echo "import express from 'express';
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
const server = http.createServer(app);

app.use(cors());
app.use(helmet());
app.use(bodyParser.json());
app.use(morgan('combined'));

router(app);

app.use(express.static(publicPath));

app.get('*', (request, response) => {
  response.sendFile(path.resolve(publicPath, 'index.html'));
});


server.listen(port, () => {
  console.log(\`Server has started and is listening on \${port}\`);
});">./lib/server.js


echo -e "\n\n\t\e[1;32mLaunching appliction.\n\n\e[0m"

npm run server
