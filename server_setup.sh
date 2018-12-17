#!/bin/bash

echo -e "\n\n\t\e[1;35mBeginning server setup.\n\n\e[0m"

#Install dependencies

npm i express
npm i cors
npm i http-server
npm i nodemon
npm i helmet
npm i bcrypt-nodejs
npm i morgan
npm i body-parser
npm i compression

mkdir -p ./server/{controllers,config,models,routes/services}


echo -e "const router = require('express').Router();

router.use('/api', require('./services'));

module.exports = router;
">./server/routes/index.js

echo -e "const router = require('express').Router();

router.use('/profile', require('./demoProfile.service'));
module.exports = router;
">./server/routes/services/index.js

echo -e "const router = require('express').Router();
const { getUser } = require('../../controllers/demoProfile.controller');

router.route('/fairy')
  .get(getUser);

module.exports = router;
">./server/routes/services/demoProfile.service.js

echo -e "function getUser(request, response) {
  return response.send({ message: 'Demo service is working.' });
}

module.exports = {
  getUser
};
">./server/controllers/demoProfile.controller.js

echo "const path = require('path');
const express = require('express');
const cors = require('cors');
const http = require('http');
const bodyParser = require('body-parser');
const helmet = require('helmet');
const compression = require('compression');

const port = process.env.PORT || 5000;
const app = express();
const publicPath = path.join(__dirname, '../dist');
const server = http.createServer(app);

app.use(cors());
app.use(helmet());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(require('morgan')('dev'));
app.use(compression());
app.use(express.static(publicPath));

app.use(require('./routes'));

app.get('*', async (request, response) => {
  try {
    response.sendFile(path.resolve(publicPath, 'index.html'));
  } catch (e) {
    response.json(new Error('Something went wrong.'));
  }
});

process.on('SIGINT', async () => {
  console.info('SIGINT signal received.');
  try {
    await server.close();
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
});

(async () => {
  await server.listen(port);
  console.log(\`Server has started and is listening on \${port}\`);
})();
">./server/index.js

echo -e "module.exports = {
  apps: [{
    name: 'ai-dashboard',
    script: 'server/index.js',
    output: './info.log',
    error: './error.log',
    log_type: 'txt',
    merge_logs: true,
    mode: 'cluster',
    instance: 4,
    env: {
      NODE_ENV: 'development',
    },
    env_production: {
      NODE_ENV: 'production',
    },
  }],
};
">./ecosystem.config.js

sed -i '/"test":/i \\t"server": "nodemon server\/index.js",' package.json
sed -i '/"server":/a \\t"start": "pm2-runtime start ecosystem.config.js --env production",' package.json


echo -e "\n\n\t\e[1;32mLaunching appliction.\n\n\e[0m"

npm run server
