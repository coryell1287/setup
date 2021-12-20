#!/bin/bash

npm install mongoose \
    mongodb 2>&1>  


import { connect, connection } from 'mongoose'
import app from '../config/app';
import { config } from '../config';

env.config();

connect(config.mongoURI, { useNewUrlParser: true, useUnifiedTopology: true });

connection.on('open', app.log.info.bind(app, 'MongoDB connected:'));
connection.on('error', app.log.error.bind(app, 'MongoDB connection error:'));


#/customer.model.ts
import { Schema, model } from 'mongoose'

export interface CustomerDocument {
  id: { type: String, required: true, unique: true };
  name: { type: String, required: true };
}

const CustomerSchema = new Schema({
  id: String,
  name: String
});


const CustomerModel = model<CustomerModel>('CustomerModel', CustomerSchema);
export default CustomerModel;



import { FilterQuery, QueryOptions, UpdateQuery } from "mongoose";
import CustomerModel, { CustomerDocument } from "../models/customer.model";


export async function createCustomer(input: CustomerDocument) {
  return CustomerModel.create(input);
}

export async function findProduct(
  options: QueryOptions = { lean: true }
) {
  return CustomerModel.find({}, {}, options);
}





  # redis:
  #   image: redis:alpine
  #   volumes:
  #     - redisdata:/data
  #   networks:
  #     - sdnet

  # redis-master:
  #   image: redis:alpine
  #   ports:
  #     - '6379'
  #   environment:
  #     - REDIS_REPLICATION_MODE=master
  #     - REDIS_PASSWORD=my_master_password
  #   volumes:
  #     - redisdata:/data

  # redis-replica:
  #   image: 'bitnami/redis:latest'
  #   ports:
  #     - '6379'
  #   depends_on:
  #     - redis-master
  #   environment:
  #     - REDIS_REPLICATION_MODE=slave
  #     - REDIS_MASTER_HOST=redis-master
  #     - REDIS_MASTER_PORT_NUMBER=6379
  #     - REDIS_MASTER_PASSWORD=my_master_password
  #     - REDIS_PASSWORD=my_replica_password