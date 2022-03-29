#!/usr/bin/env bash

##########################################
#  Create a directories for the server app
###########################################
APP_NAME="$1"-services
NODE_VERSION="$2"
MAJOR_VERSION=${NODE_VERSION%%.*}
GITHUB_URL="$3"
mkdir -p "${APP_NAME}"/{haproxy,src}/{config,data-store,controller,routes,schemas,services,types}


###################################
#  Create root files in SERVER app
###################################

# Dockerfile.dev
echo "FROM node:$NODE_VERSION-alpine as builder

LABEL description="${APP_NAME}"

WORKDIR /app

ARG NODE_ENV=development

ENV NODE_ENV=\${NODE_ENV}

ENV NPM_CONFIG_LOGLEVEL=warn

COPY package*.json ./

# COPY .snyk ./

RUN npm install && npm cache clean --force

COPY . .

EXPOSE 5000

CMD [ \"npm\", \"run\", \"dev\" ]">./"${APP_NAME}"/Dockerfile.dev




# Dockerfile

echo "FROM node:$NODE_VERSION-alpine as base

WORKDIR /code

COPY package*.json .

FROM base as test
RUN npm ci
COPY . .
RUN npm test

FROM base as prod
RUN npm ci --production
COPY . .
CMD [ \"node\", \"server.js\" ]">./"${APP_NAME}"/Dockerfile


echo "name: cd

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

env: 
  AWS_REGION: eu-west-3
  ECR_REPOSITORY: kubernetes-github-actions
  SHORT_SHA: $(echo ${{ github.sha }} | cut -c 1-8)

jobs:
  run-tests:
    runs-on: ubuntu-latest
    steps:
    - name: Clone
      uses: actions/checkout@v2

    - name: Test
      run: |
        cd site
        npm install
        npm test
  build:
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/master'
    needs:
      - run-tests

    steps:
    - name: Clone
      uses: actions/checkout@v2

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}
      
    - name: Login to Amazon ECR
      id: login-ecr
      uses: aws-actions/amazon-ecr-login@v1

    - name: Build, tag, and push image to Amazon ECR
      id: build-image
      env:
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
      run: |
        cd site
        docker image build \
        --tag ${{ env.ECR_REGISTRY }}/${{ env.ECR_REPOSITORY }}:latest \
        --tag ${{ env.ECR_REGISTRY }}/${{ env.ECR_REPOSITORY }}:${{ env.SHORT_SHA }} \
        .
        docker push ${{ env.ECR_REGISTRY }}/${{ env.ECR_REPOSITORY }}:latest
        docker push ${{ env.ECR_REGISTRY }}/${{ env.ECR_REPOSITORY }}:${{ env.SHORT_SHA }}
    - name: Install and configure kubectl
      run: |
        VERSION=$(curl --silent https://storage.googleapis.com/kubernetes-release/release/stable.txt)
        curl https://storage.googleapis.com/kubernetes-release/release/$VERSION/bin/linux/amd64/kubectl \
          --progress-bar \
          --location \
          --remote-name
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
        echo ${{ secrets.KUBECONFIG }} | base64 --decode > kubeconfig.yaml
    - name: Deploy
      env:
        ECR_REGISTRY: ${{ steps.login-ecr.outputs.registry }}
      run: |
        export ECR_REPOSITORY=${{ env.ECR_REGISTRY }}/${{ env.ECR_REPOSITORY }}
        export IMAGE_TAG=${{ env.SHORT_SHA }}
        export KUBECONFIG=kubeconfig.yaml
        envsubst < k8s/kustomization.tmpl.yaml > k8s/kustomization.yaml
        kubectl kustomize k8s | kubectl apply -f -">./"${APP_NAME}"/.github/amazon-erc.yml

# docker-compose
echo "version: '3'

networks:
  ${APP_NAME}-net:
    external: false
    name: '${APP_NAME}-net'

services:
  ${APP_NAME}:
    image: node:$NODE_VERSION-alpine
    restart: always
    networks:
      - ${APP_NAME}-net
    container_name: $APP_NAME
    build:
      context: .
      dockerfile: ./Dockerfile
    volumes:
      - '.:/app'
      - '/app/node_modules'
    ports:
      - 5000

  haproxy:
    image: haproxytech/haproxy-alpine:latest
    restart: always
    networks:
      - ${APP_NAME}-net
    links:
      - ${APP_NAME}
    depends_on:
      - ${APP_NAME}
    ports:
      - 8001:80
    volumes:
      - ./haproxy/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg
      - /var/run/docker.sock:/tmp/docker.sock">./"${APP_NAME}"/docker-compose.yml





#haproxy.cfg
echo "global
  pidfile /var/run/haproxy.pid
  chroot /var/lib/haproxy
  log stdout format raw local0 info
  maxconn 4000
  user haproxy
  group haproxy


defaults
    mode http
    retries 3
    option redispatch
    log global

    timeout queue 10s
    timeout http-request 10s
    timeout connect 10s
    timeout client 30s
    timeout server 10s


frontend ${APP_NAME}_client
    bind *:80
    default_backend ${APP_NAME}


    stick-table  type ipv6  size 100k  expire 30s  store http_req_rate(10s)
    tcp-request session track-sc0 src
    tcp-request session reject if { src_sess_rate gt 10 }
    tcp-request content track-sc0 src
    tcp-request content reject if { sc_conn_cur(0) gt 10 }
    http-request track-sc0 src
    http-request deny deny_status 429 if { sc_http_req_rate(0) gt 20 }

    acl url-microservice-customer path_beg /api/v1/customer/

    compression algo gzip
    compression type text/html text/plain text/css application/javascript

    option httplog
    option forwardfor
    option http-server-close

    use_backend microservice-customer if url-microservice-customer


backend ${APP_NAME}
    stick-table type ip size 1m expire 10s store conn_cur
    balance roundrobin
    server ${APP_NAME}-1 ${APP_NAME}:5000 check
    option httpchk GET /health
    http-check expect string success

backend microservice-customer
    balance roundrobin
    server microservice-customer-1 ${APP_NAME}:5000 check">./"${APP_NAME}"/haproxy/haproxy.cfg



# dockerignore
echo "docker-compose*
**/Dockerfile*
**/.git
**/.DS_Store
**/node_modules">./"${APP_NAME}"/.dockerignore



# editorconfig
echo "root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = t">./"${APP_NAME}"/.editorconfig




# .env
echo "NODE_ENV=development
APP_NAME="${APP_NAME}"
SERVER_URI=localhost:5000
SERVER_PORT=5000
REDIS_URI=redis://127.0.0.1:6379">./"${APP_NAME}"/.env





# prettierignore 
echo "dist
docker-compose.yml
Dockerfile">./"${APP_NAME}"/.prettierignore



# .gitignore
echo "# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.vscode
.history/
dist

# Diagnostic reports (https://nodejs.org/api/report.html)
report.[0-9]*.[0-9]*.[0-9]*.[0-9]*.json

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Directory for instrumented libs generated by jscoverage/JSCover
lib-cov

# Coverage directory used by tools like istanbul
coverage
*.lcov

# nyc test coverage
.nyc_output

# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
.grunt

# Bower dependency directory (https://bower.io/)
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons (https://nodejs.org/api/addons.html)
build/Release

# Dependency directories
node_modules/
jspm_packages/

# Snowpack dependency directory (https://snowpack.dev/)
web_modules/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# Next.js build output
.next
out

# Nuxt.js build / generate output
.nuxt

# Gatsby files
.cache/
# Comment in the public line in if your project uses Gatsby and not Next.js
# https://nextjs.org/blog/next-9-1#public-directory-support
# public

# vuepress build output
.vuepress/dist


# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# yarn v2
.yarn/cache
.yarn/unplugged
.yarn/build-state.yml
.yarn/install-state.gz
.pnp.*">./"${APP_NAME}"/.gitignore



# .prettierrc
echo "{
  \"arrowParens\": \"avoid\",
  \"bracketSpacing\": true,
  \"endOfLine\": \"lf\",
  \"printWidth\": 125,
  \"requirePragma\": false,
  \"semi\": true,
  \"singleQuote\": true,
  \"tabWidth\": 2,
  \"trailingComma\": \"all\",
  \"useTab\": false,
  \"overrides\": [
    {
      \"files\": \"*.json\",
      \"options\": {
        \"printWidth\": 150
      }
    }
  ]
}">./"${APP_NAME}"/.prettierrc



# tsconfig.json
echo "{
  \"\$schema\": \"https://json.schemastore.org/tsconfig\",
  \"display\": \"Node ${MAJOR_VERSION}\",
    
  \"extends\": \"@tsconfig/node${MAJOR_VERSION}/tsconfig.json\",
  \"compilerOptions\": {
    \"allowJs\": true,
    \"allowSyntheticDefaultImports\": true,
    \"alwaysStrict\": true,
    \"baseUrl\": \".\",
    \"checkJs\": true,
    \"composite\": true,
    \"declaration\": true,
    \"declarationMap\": true,
    \"downlevelIteration\": true,
    \"emitDecoratorMetadata\": true,
    \"esModuleInterop\": true,
    \"experimentalDecorators\": true,
    \"forceConsistentCasingInFileNames\": true,
    \"importHelpers\": true,
    \"isolatedModules\": true,
    \"lib\": [\"es2019\", \"es2020.promise\", \"es2020.bigint\", \"es2020.string\"],
    \"module\": \"CommonJS\",
    \"moduleResolution\": \"node\",
    \"noEmit\": true,
    \"noImplicitAny\": true,
    \"noImplicitThis\": true,
    \"noUnusedLocals\": true,
    \"noUnusedParameters\": true,
    \"outDir\": \"dist\",
    \"resolveJsonModule\": true,
    \"skipLibCheck\": true,
    \"sourceMap\": true,
    \"strict\": true,
    \"strictBindCallApply\": true,
    \"strictFunctionTypes\": true,
    \"strictNullChecks\": true,
    \"strictPropertyInitialization\": true,
    \"target\": \"ESNext\",
    \"types\": [\"Jest\", \"node\", \"webgl2\"],
    \"typeRoots\": [\"src/types\",\"node_modules/@types\"]
  },
  \"exclude\": [\"./dist\", \"**/node_modules\", \"**/.*/\", \"**/.(spec|test)*/\"],
  \"include\": [\"src/**/*\", \"./index.ts\", \"src/**/*.json\", \"**/*.d.ts\"]
}">./"${APP_NAME}"/tsconfig.json




# eslintrc
echo "{
  \"root\": true,
  \"parser\": \"@typescript-eslint/parser\",
  \"plugins\": [\"security-node\", \"security\", \"import\", \"@typescript-eslint\", \"sonarjs\", \"prettier\"],
  \"extends\": [
    \"plugin:jest/all\",
    \"plugin:security-node/recommended\",
    \"plugin:security/recommended\",
    \"plugin:@typescript-eslint/recommended\"
  ],
  \"jest/no-hooks\": [
    \"error\",
    {
      \"allow\": [\"afterEach\", \"beforeEach\"]
    }
  ],
  \"parserOptions\": {
    \"ecmaVersion\": 2018,
    \"sourceType\": \"module\"
  },
  \"overrides\": [
    {
      \"files\": [\"**/*.(spec|test).ts\"],
      \"env\": {
        \"jest\": true
      }
    }
  ],
  \"rules\": {
    \"@typescript-eslint/explicit-function-return-type\": \"error\",
    \"@typescript-eslint/no-explicit-any\": \"error\",
    \"@typescript-eslint/no-inferrable-types\": [
      \"warn\",
      {
        \"ignoreParameters\": true
      }
    ],
    \"@typescript-eslint/no-unused-vars\": \"warn\",
    \"no-console\": \"error\",
    \"sonarjs/cognitive-complexity\": \"error\",
    \"sonarjs/no-identical-expressions\": \"error\",
    \"sonarjs/no-collapsible-if\": \"error\",
    \"sonarjs/prefer-immediate-return\": \"error\",
    \"prettier/prettier\": \"error\",
    \"import/order\": [
      \"error\",
      {
        \"groups\": [\"builtin\", \"external\", \"internal\", \"parent\", \"sibling\", \"index\", \"unknown\"],
        \"newlines-between\": \"always\"
      }
    ],
    \"settings\": {
      \"import/resolver\": {
        \"alias\": {
          \"map\": [
            [\"schemas\", \"./src/schemas\"]
          ],
          \"extensions\": [\".js\", \".ts\", \".json\", \".d.ts\"]
        }
      }
    }
  }
}">./"${APP_NAME}"/.eslintrc.json



# .eslintignore
echo "node_modules/
dist/
build/
coverage/">./"${APP_NAME}"/.eslintignore





# jest
echo "{
  \"rootDir\": \".\",
  \"verbose\": true,
  \"transform\": {
    \"^.+\\\\.ts$\": \"ts-jest\"
  },
  \"testEnvironment\": \"node\",
  \"testMatch\": [\"<rootDir>/src/**/*.(spec|test).ts\"],
  \"moduleFileExtensions\": [\"ts\", \"js\"],
  \"coverageDirectory\": \"<rootDir>/coverage\",
  \"moduleDirectories\": [\"node_modules\"],
  \"coverageThreshold\": {
    \"global\": {
      \"branches\": 80,
      \"functions\": 80,
      \"lines\": 80,
      \"statements\": -10
    }
  },
  \"coveragePathIgnorePatterns\": [\"<rootDir>/coverage\", \"<rootDir>/src/mocks\", \"<rootDir>/src/index.ts?\"],
  \"globals\": {
    \"test-jest\": {
      \"diagnostics\": false
    }
  }
}">./"${APP_NAME}"/jest.config.json


# src/index.ts
echo "import util from 'util';

import env from 'dotenv';
  
import app from './src/config/app';
import { config } from './src/config';

env.config();

app.ready(function (error) {
  if (error) throw error;
  app.oas();
});

process.on('uncaughtException', function uncaughtException(error: Error) {
  app.log.error(\`\${config.appName} crashed \${error.stack} || \${error}\`);
});

process.on('unhandledRejection', function unhandledRejection(reason, promise) {
  app.log.error(\`unhandled rejection at \${util.inspect(promise)} reason \${reason}\`);
});

process.on('SIGINT', async function signalInt() {
  app.log.info(\`Shutting down the services of \${config.appName}\`);
  app.close().then(
    function close() {
      app.log.info('successfully closed!');
    },
    function (error: Error) {
      app.log.error('an error happened', error);
    },
  );
});

(async function start() {
  try {
    const address = await app.listen(config.port, '0.0.0.0');
    app.log.info(\`\${config.appName} is up and listening on \${address}\`);
  } catch (error) {
    app.log.error(\`Error starting server \${error}\`);
    process.exit(1);
  }
})();">./"${APP_NAME}/index.ts"



# src/config/app.ts
echo "import fastify, { FastifyInstance } from 'fastify';
import compress from 'fastify-compress';
import cors from 'fastify-cors';
import oas from 'fastify-oas';
import env from 'dotenv';
import favicon from '@wwa/fastify-favicon';
import helmet from 'fastify-helmet';
import healthCheck from 'fastify-healthcheck';

import { config } from '.';
import { CustomerRoutes } from '../routes';

env.config();

function build(opts = { logger: true }): FastifyInstance {
  const app = fastify(opts);

  app.register(healthCheck);
  app.register(helmet);
  app.register(compress);
  app.register(cors);
  app.register(favicon);
  app.register(oas, {
    routePrefix: '/documentation',
    swagger: {
      info: {
        title: config.appName,
        description: 'testing the fastify swagger api',
        version: '0.1.0',
      },
      externalDocs: {
        url: 'https://swagger.io',
        description: 'Find more info here',
      },
      host: config.serverURI,
      schemes: ['http'],
      consumes: ['application/json'],
      produces: ['application/json'],
      securityDefinitions: {
        apiKey: {
          type: 'apiKey',
          name: 'apiKey',
          in: 'header',
        },
      },
    },
    addModels: true,
    exposeRoute: true,
  });

  app.register(CustomerRoutes, { prefix: '/api/v1' });

 return app
}

export default build();">./"${APP_NAME}"/src/config/app.ts







# src/config/build.ts
echo "import app from '../config/app';
import fastify from 'fastify';

function build(opts = { logger: false }) {
  const app = fastify(opts);

  beforeEach(async () => await app.ready());
  afterEach(() => app.close());
  return app;
}

export default build();">./"${APP_NAME}"/src/config/build.ts




# src/config/index.ts
echo "import env from 'dotenv';

interface Config {
  host: string;
  port: string;
  serverURI: string | undefined;
  appName: string | undefined;
  environment: string;
}

env.config();

const config: Config = {
  host: '0.0.0.0',
  port: process.env.PORT || '5000',
  serverURI: process.env.SERVER_URI,
  appName: process.env.APP_NAME,
  environment: process.env.NODE_ENV || 'production',
};

export { config };">./"${APP_NAME}"/src/config/index.ts




# src/controller/customer.controller.ts
echo "import { FastifyInstance } from 'fastify';
import { CustomerService } from '../services/customer.service';
import CustomerResponseSchema from '../schemas/query-response.json';
import Response from '../schemas/response.json'
import SuccessStatusSchema from '../schemas/success.json';
import ParamsSchema from '../schemas/params.json';
import { IRequestBody, IParams } from '../types';

export async function CustomerController(fastify: FastifyInstance): Promise<void> {
  fastify.route<{ Body: IRequestBody }>({
    method: 'POST',
    url: '/customer/',
    schema: {
      response: Response,
    },
    handler: async function createCustomerController(request, reply) {
      const customer = new CustomerService();
      return reply.code(201).send(await customer.createCustomer(request.body));
    },
  });

  fastify.route({
    method: 'GET',
    url: '/customer/',
    schema: {
      response: CustomerResponseSchema,
    },
    handler: async function fetchCustomerController(_, reply) {
      const customer = new CustomerService();
      return reply.send(await customer.fetchCustomers());
    },
  });

  fastify.route<{ Params: IParams; Body: IRequestBody }>({
    method: 'PUT',
    url: '/customer/:id/',
    schema: {
      params: ParamsSchema,
      response: Response
    },
    handler: async function updateCustomerController(request, reply) {
      const customer = new CustomerService();
      return reply.send(await customer.updateCustomer(request.params.id, request.body));
    },
  });

  fastify.route<{ Params: IParams }>({
    method: 'DELETE',
    url: '/customer/:id/',
    schema: {
      response: SuccessStatusSchema,
    },
    handler: async function deleteCustomerController(request, reply) {
      const customer = new CustomerService();
      return reply.code(204).send(await customer.deleteCustomer(request.params.id));
    },
  });
}">./"${APP_NAME}"/src/controller/customer.controller.ts






# src/controller/customer.controller.spec.ts
echo "import { build } from '../config/build';
import { FastifyInstance } from 'fastify';
import { IRequestBody } from '../types';

const customers: IRequestBody[] = [
  { id: '1', name: 'Judy Hopps' },
  { id: '2', name: 'Nick Wilde' },
  { id: '3', name: 'Cheif Bogo' },
  { id: '4', name: 'Clawhauser' },
];

describe('Customer controller', () => {
  const app: FastifyInstance = build();
  it('should fetch customers list', async () => {
    expect.assertions(2);

    const res = await app.inject({
      url: '/api/v1/customer/',
    });

    expect(res.statusCode).toBe(200);
    expect(res.json()).toStrictEqual(customers);
  });

  it('should create a single customer', async () => {
    expect.assertions(2);

    const res = await app.inject({
      url: '/api/v1/customer/',
      method: 'POST',
      payload: { id: '5', name: 'Samantha' },
    });

    expect(res.statusCode).toBe(201);
    expect(res.json()).toStrictEqual(JSON.parse(res.payload));
  });

  it('should update a single user', async () => {
    expect.assertions(2);

    const res = await app.inject({
      url: '/api/v1/customer/1/',
      method: 'PUT',
      payload: { id: '4', name: 'Gregory' },
    });

    expect(res.statusCode).toBe(200);
    expect(res.json()).toStrictEqual(JSON.parse(res.payload));
  });

  it('should delete a single customer', async () => {
    expect.assertions(1);

    const res = await app.inject({
      url: '/api/v1/customer/1/',
      method: 'DELETE',
    });
    expect(res.statusCode).toBe(204);
  });
});">./"${APP_NAME}"/src/controller/customer.controller.spec.ts



# data-store
echo "import { IRequestBody } from '../types';

const customers: IRequestBody[] = [
  { id: '1', name: 'Judy Hopps' },
  { id: '2', name: 'Nick Wilde' },
  { id: '3', name: 'Cheif Bogo' },
  { id: '4', name: 'Clawhauser' },
];

function findElementByIndex(id: string) {
  if (!id) return -1;
  return customers.findIndex(function findIndex(item) {
    return item.id === id;
  });
}

export interface DatabaseInstance {
  fetch(): IRequestBody[];
  add(data: IRequestBody): IRequestBody;
  update(id:string, data: IRequestBody): IRequestBody;
  delete(id: string): void;
}

export default class DataStore implements DatabaseInstance {

  public fetch(): IRequestBody[] {
    return customers;
  }

  public add(data: IRequestBody): IRequestBody {
    customers.push(data);
    return data;
  }

  public update(id: string, data: IRequestBody): IRequestBody {
    const index = findElementByIndex(id)
    customers[index] = data;
    return data;
  }

  public delete(id: string): void {
    const index = findElementByIndex(id)
    customers.splice(index, 1);
  }
}">./"${APP_NAME}"/src/data-store/index.ts





# routes/index.ts
echo "import { CustomerController } from '../controller/customer.controller';

export { CustomerController as CustomerRoutes };">./"${APP_NAME}"/src/routes/index.ts




# src/service/customer.service.ts
echo "import { IRequestBody } from 'src/types';
import DataStore, { DatabaseInstance } from '../data-store';

export class CustomerService {
  private database: DatabaseInstance;

  constructor() {
    this.database = new DataStore();
  }

  public fetchCustomers() {
    return this.database.fetch();
  }

  public createCustomer(customer: IRequestBody) {
    return this.database.add(customer);
  }

  public updateCustomer(id: string, customer: IRequestBody) {
    return this.database.update(id, customer);
  }

  public deleteCustomer(id: string) {
    return this.database.delete(id);
  }

}">./"${APP_NAME}"/src/services/customer.service.ts


# customer.service.spec.ts
echo "import { IRequestBody as Customers } from 'src/types';
import { CustomerService } from './customer.service';

const customers: Customers[] = [
  { id: '1', name: 'Judy Hopps' },
  { id: '2', name: 'Nick Wilde' },
  { id: '3', name: 'Cheif Bogo' },
  { id: '4', name: 'Clawhauser' },
];

jest.mock('./customer.service');

describe('Customer Service', () => {
  it('should return a list of customers', async () => {
    expect.assertions(2);
    const customer = new CustomerService();

    (customer.fetchCustomers as jest.Mock).mockImplementation(() => customers);

    expect(customer.fetchCustomers()).toStrictEqual(customers);
    expect(customer.fetchCustomers).toHaveBeenCalledTimes(1);
  });

  it('should create a single customer', () => {
    expect.assertions(2);
    const customer = new CustomerService();
    const update = { id: '5', name: 'Samantha' };

    (customer.createCustomer as jest.Mock).mockImplementation((update: Customers) => {
      customers.splice(customers.length, 0, update);
      customers.slice().splice(customers.length, 0, update);
      return update;
    });

    expect(customer.createCustomer(update)).toStrictEqual(update);
    expect(customer.createCustomer).toHaveBeenCalledTimes(1);
  });

  it('should update a single customer', () => {
    expect.assertions(2);
    const customer = new CustomerService();
    const update = { id: '1', name: 'Samantha' };

    (customer.updateCustomer as jest.Mock).mockImplementation((id: string, update: Customers) => {
      const index = parseInt(id);
      const temp = customers.slice();
      temp[index - 1] = update;
      return update;
    });

    expect(customer.updateCustomer('1', update)).toStrictEqual(update);
    expect(customer.updateCustomer).toHaveBeenCalledTimes(1);
  });

  it('should delete a single customer', () => {
    expect.assertions(2);
    const customer = new CustomerService();

    (customer.deleteCustomer as jest.Mock).mockImplementation((id: string) => {
      const index = parseInt(id);
      const temp = customers.slice();
      temp.splice(index - 1, 1);
      return \`Customer \${id} deleted.\`;
    });

    expect(customer.deleteCustomer('1')).toEqual('Customer 1 deleted.');
    expect(customer.deleteCustomer).toHaveBeenCalledTimes(1);
  });
});">./"${APP_NAME}"/src/services/customer.service.spec.ts




# src/schemas/params.json
echo "{
  \"type\": \"object\",
  \"properties\": {
    \"id\": { \"type\": \"string\" }
  },
  \"additionalProperties\": false,
  \"required\": [\"id\"]
}">./"${APP_NAME}"/src/schemas/params.json


# src/schemas/request.json
echo "{
  \"type\": \"object\",
  \"properties\": {
    \"id\": { \"type\": \"string\" },
    \"name\": { \"type\": \"string\" }
  },
  \"additionalProperties\": false,
  \"required\": [\"id\", \"name\"]
}">./"${APP_NAME}"/src/schemas/schemas.json




# src/schemas/response.json
echo "{
  \"2xx\": {
    \"type\": \"object\",
    \"properties\": {
      \"id\": { \"type\": \"string\" },
      \"name\": { \"type\": \"string\" }
    }
  }
}">./"${APP_NAME}"/src/schemas/response.json



# src/schemas/success.json
echo "{
  \"2xx\": {
    \"type\": \"string\"
  }
}">./"${APP_NAME}"/src/schemas/success.json


# query-response.json
echo "{
  \"200\": {
    \"type\": \"array\",
    \"items\": {
      \"type\": \"object\",
      \"properties\": {
        \"id\": { \"type\": \"string\" },
        \"name\": { \"type\": \"string\" }
      }
    },
    \"additionalProperties\": false,
    \"required\": [\"id\", \"name\"]
  }
}">./"${APP_NAME}"/src/schemas/query-response.json


# src/types/index.ts
echo "export interface IParams {
  id: string;
}

export interface IRequestBody {
  id: string;
  name: string;
}">./"${APP_NAME}"/src/types/index.ts



#######################################
# Initialize github repo for SERVER 
#######################################
cd ./"${APP_NAME}" &&
git init > /dev/null 2>&1 &&
git remote add origin "${GITHUB_URL}" > /dev/null 2>&1

#######################################
# NPM package installation for SERVER 
#######################################
npm init -y > /dev/null 2>&1

npm i fastify \
    fastify-compress \
    fastify-cors \
    fastify-helmet \
    fastify-healthcheck \
    source-map-support \
    fastify-plugin \
    fastify-oas \
    @wwa/fastify-favicon \
    dotenv \
    ts-node \
    weak-napi \


npm i -D rimraf \
    commitizen \
    license-checker \
    @types/node \
    @types/webgl2 \
    @tsconfig/node${MAJOR_VERSION} \
    @types/jest \
    @typescript-eslint/eslint-plugin \
    @typescript-eslint/parser \
    typescript \
    ts-node-dev \
    @typescript-eslint/eslint-plugin \
    @typescript-eslint/parser \
    eslint-plugin-sonarjs \
    eslint-plugin-security-node \
    eslint-plugin-security \
    eslint \
    eslint-config-prettier \
    eslint-plugin-prettier \
    eslint-import-resolver-alias \
    eslint-plugin-import \
    eslint-plugin-jest \
    eslint-plugin-security \
    husky \
    prettier \
    npm-check-updates \
    standard-version \
    npm-check \
    ts-jest \
    jest \
    nodemon \

# setup husky and commitizen
npx husky install > /dev/null 2>&1
npx commitizen init cz-conventional-changelog --save-dev --save-exact > /dev/null 2>&1
npx husky add .husky/pre-commit "npm run lint" > /dev/null 2>&1
npx husky add .husky/pre-commit "npx pretty-quick --staged" > /dev/null 2>&1
npx husky add .husky/pre-commit "npm run inspect:doctor" > /dev/null 2>&1



################################################
# Install to help parse and manipulate the JSON
################################################

npm set-script build "npm run clean && tsc"
npm set-script clean "rimraf dist"
npm set-script commit 'cz'
npm set-script dev "nodemon --watch './**/*.ts' --exec 'ts-node-dev' ./index.ts"
npm set-script inspect:all "npm run inspect:updates && npm run inspect:audit"
npm set-script inspect:all:ci "npm run inspect:updates:ci && npm run inspect:license && npm run inspect:audit"
npm set-script inspect:audit "audit-ci -h -c"
npm set-script inspect:updates:ci "ncu -e 2"
npm set-script inspect:license "license-checker --production --json --out ./licenses/licenses.json --failOn GPLv2"
npm set-script inspect:sanity-testing "jest --grep \"sanity\"",
npm set-script inspect:doctor "ncu --doctor -u"
npm set-script inspect:updates "npm-check"
npm set-script lint "eslint --ext .ts,.js --format table"
npm set-script prepare "husky install"
npm set-script release "standard-version"
npm set-script start "node ./index.js"
npm set-script test "NODE_ENV=test jest --detectOpenHandles --forceExit --config jest.config.json"
npm set-script test:coverage "NODE_ENV=test jest --config jest.config.json --coverage"