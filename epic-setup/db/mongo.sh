#!/bin/bash

APP_NAME=$1

npm install mongoose \
     mongodb


mkdir -p ./src/db/{connect,model,entity}

#.env
echo "MONGO_URI=mongodb://mongo:27017/${APP_NAME}">>./"${APP_NAME}"/.env


#config
echo "import dotenv from 'dotenv';

interface Config {
  host: string;
  port: string;
  serverURI: string | undefined;
  appName: string | undefined;
  environment: string;
  mongoURI: string;
}

dotenv.config();

const config: Config = {
  host: '0.0.0.0',
  port: process.env.PORT || '5000',
  serverURI: process.env.SERVER_URI,
  appName: process.env.APP_NAME,
  environment: process.env.NODE_ENV || 'production',
  mongoURI: process.env.MONGO_URI
};

export { config };">./"${APP_NAME}"/src/config/index.ts

#docker-compose.yml
echo "mongo:
    image: mongo
    container_name: practicebin-services-db
    restart: unless-stopped
    volumes:
      - mongo-data:/data/db
      - mongo-configdb:/data/configdb
    ports:
      - \"27017:27017\"
    env_file: ./.env
    networks:
      - practicebin-services-net

volumes:
  mongo-data:
  mongo-configdb:">>./"${APP_NAME}"/.docker-compose.yml


#connect
echo "import { connect, connection } from 'mongoose';
import app from '../../config/app';
import { config } from '../../config';
import env from 'dotenv';

env.config();

if (config.mongoURI) {
  connect(config.mongoURI).catch(error => app.log.error(error));
}

connection
  .once('open', () => {
    app.log.info(`MongoDB connected:, ${config.mongoURI}`);
  })
  .on('error', () => {
    app.log.error('MongoDB ERROR');
  });">./"${APP_NAME}"/db/connect/index.ts


#customer.entity.ts
echo "// import { FilterQuery, QueryOptions, UpdateQuery } from 'mongoose';
import { QueryOptions } from 'mongoose';
import CustomerModel, { CustomerDocument } from '../model/customer.model';

export async function createCustomer(input: CustomerDocument) {
  try {
    const customer = await CustomerModel.create(input);
    return customer.toJSON();
  } catch (error: unknown) {
    throw error;
  }
}

export async function findCustomer(options: QueryOptions = { lean: true }) {
  try {
    const customers = await CustomerModel.find({}, {}, options);
    return customers;
  } catch (error) {
    throw error;
  }
}

">./"${APP_NAME}"/db/entity/customer.entity.ts



# customer.model.ts
echo "import { Schema, model } from 'mongoose'

export interface CustomerDocument {
  id: string;
  name: string;
}

const CustomerSchema = new Schema({
  id: { type: String, required: true, unique: true },
  name: { type: String, required: true }
});

const CustomerModel = model<CustomerDocument>('CustomerModel', CustomerSchema);
export default CustomerModel;
">./"${APP_NAME}"/db/model/customer.model.ts
