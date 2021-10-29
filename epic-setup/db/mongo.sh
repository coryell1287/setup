#!/bin/bash

APP_NAME=$1
# cd ./"${APP_NAME}-service"

npm install mongoose \
     mongodb


mkdir -p ./src/db/{connect,model,entity}

echo "import { connect, connection } from 'mongoose'
import app from '../../config/app';
import { config } from '../../config';
import env from 'dotenv';

env.config();

if (config.mongoURI) {
  connect(config.mongoURI);
}

connection.on('open', app.log.info.bind(app, 'MongoDB connected:'));
connection.on('error', app.log.error.bind(app, 'MongoDB connection error:'));">./src/db/connect/index.ts 



echo "import { Schema, model } from 'mongoose'

export interface CustomerDocument {
  id: { type: String, required: true, unique: true };
  name: { type: String, required: true };
}

const CustomerSchema = new Schema({
  id: String,
  name: String
});

const CustomerModel = model<CustomerDocument>('CustomerModel', CustomerSchema);
export default CustomerModel;">./src/db/model/customer.model.ts



echo "import { FilterQuery, QueryOptions, UpdateQuery } from 'mongoose';
import CustomerModel, { CustomerDocument } from '../model/customer.model';

export async function createCustomer(input: CustomerDocument) {
  return CustomerModel.create(input);
}

export async function findProduct(
  options: QueryOptions = { lean: true }
) {
  return CustomerModel.find({}, {}, options);
}">./src/db/entity/customer.entity.ts


echo "MONGO_URI=mongodb://localhost:27017/${APP_NAME}">>.env

echo "import env from 'dotenv';

interface Config {
  host: string;
  port: string;
  serverURI: string | undefined;
  appName: string | undefined;
  environment: string;
  mongoURI: string | undefined;
}

env.config();

export const config: Config = {
  host: '0.0.0.0',
  port: process.env.PORT || '5000',
  serverURI: process.env.SERVER_URI,
  appName: process.env.APP_NAME,
  environment: process.env.NODE_ENV || 'production',
  mongoURI: process.env.MONGO_URI
};">./src/config/index.ts


echo "  mongodb:
    image: mongo:latest
    container_name: ${APP_NAME}-services-db
    restart: always
    volumes:
      - mongo-data:/data/db
      - mongo-configdb:/data/configdb
    ports:
      - 27017:27017
    environment:
      - MONGO_INITDB_ROOT_USERNAME=app_user
      - MONGO_INITDB_ROOT_PASSWORD=app_password
      - MONGO_INITDB_DATABASE=admin
    networks:
      - ${APP_NAME}-services-net

volumes:
  mongo-data:
  mongo-configdb:  
">>./docker-compose.yml