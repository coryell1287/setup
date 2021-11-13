#!/bin/bash


APP_NAME=$1
SERVICE_NAME=$2
NAME=$2
first=`echo $NAME|cut -c1|tr [a-z] [A-Z]`
second=`echo $NAME|cut -c2-`
PROPER_CASE_SERVICE_NAME=$first$second


npm install mongoose \
     mongodb


mkdir -p ./src/{entity,model,db}/connect

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
    container_name: ${APP_NAME}-services-db
    restart: unless-stopped
    volumes:
      - mongo-data:/data/db
      - mongo-configdb:/data/configdb
    ports:
      - \"27017:27017\"
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



# $SERVICE_NAME.model.ts
echo "import { Schema, model } from 'mongoose'

export interface $PROPER_CASE_SERVICE_NAMEDocument {
  _id: string;
  name: string;
}

const $PROPER_CASE_SERVICE_NAMESchema = new Schema({
  _id: { type: String, required: true, unique: true },
  name: { type: String, required: true }
});

const $PROPER_CASE_SERVICE_NAMEModel = model<$PROPER_CASE_SERVICE_NAMEDocument>('$PROPER_CASE_SERVICE_NAMEModel', $PROPER_CASE_SERVICE_NAMESchema);
export default $PROPER_CASE_SERVICE_NAMEModel;
">./"${APP_NAME}"/model/"${SERVICE_NAME}".model.ts



# service-schema.ts
echo "export const fetch$PROPER_CASE_SERVICE_NAME = {
  description: 'Fetch $SERVICE_NAME',
  tags: ['Fetch $SERVICE_NAME'],
  summary: 'Fetch $SERVICE_NAME list',
  response: {
    '200': {
      description: 'Successful response',
      type: 'array',
      item: {
        type: 'object',
        properties: {
          _id: { type: 'string' },
          name: { type: 'string' },
        },
      },
    },
    '404': {
      description: \"Can\'t find the $SERVICE_NAME\",
      type: 'object',
      properties: {
        message: { type: 'string' },
      },
    },
  },
  required: ['_id', 'name'],
  security: [
    {
      api_key: [],
    },
  ],
};

export const create$PROPER_CASE_SERVICE_NAME = {
  description: 'Create $SERVICE_NAME',
  tags: ['Create $SERVICE_NAME'],
  summary: 'Create a $SERVICE_NAME using this service',
  body: {
    type: 'object',
    properties: {
      _id: { type: 'string' },
      name: { type: 'string' },
    },
  },
  response: {
    '201': {
      description: 'Successful response',
      type: 'object',
      properties: {
        _id: { type: 'string' },
        name: { type: 'string' },
      },
    },
    '404': {
      description: \"Can\'t find the $SERVICE_NAME\",
      type: 'object',
      properties: {
        message: { type: 'string' },
      },
    },
  },
  required: ['_id', 'name'],
  security: [
    {
      api_key: [],
    },
  ],
};


export const fetchOne$PROPER_CASE_SERVICE_NAME = {
  description: 'Fetches a single $SERVICE_NAME',
  tags: ['Fetch single $SERVICE_NAME'],
  summary: 'Fetches a single a $SERVICE_NAME',
  params: {
    type: 'object',
    properties: {
      _id: {
        type: 'string',
        description: '$SERVICE_NAME id',
      },
    },
  },
  response: {
    '200': {
      description: 'Successful response',
      type: 'object',
      properties: {
        _id: { type: 'string' },
        name: { type: 'string' },
      },
    },
    '404': {
      description: \"Can\'t find the $SERVICE_NAME\",
      type: 'object',
      properties: {
        message: { type: 'string' },
      },
    },
  },
  required: ['_id', 'name'],
  security: [
    {
      api_key: [],
    },
  ],
};


export const updateOne$PROPER_CASE_SERVICE_NAME = {
  description: 'Updates a single $SERVICE_NAME',
  tags: ['Update single $SERVICE_NAME'],
  summary: 'Updates a single a $SERVICE_NAME',
  params: {
    type: 'object',
    properties: {
      _id: {
        type: 'string',
        description: '$SERVICE_NAME id',
      },
    },
  },
  body: {
    type: 'object',
    properties: {
      _id: { type: 'string' },
      name: { type: 'string' },
    },
  },
  response: {
    '200': {
      description: 'Successful response',
      type: 'object',
      properties: {
        _id: { type: 'string' },
        name: { type: 'string' },
      },
    },
    '404': {
      description: \"Can\'t find the $SERVICE_NAME\",
      type: 'object',
      properties: {
        message: { type: 'string' },
      },
    },
  },
  required: ['_id', 'name'],
  security: [
    {
      api_key: [],
    },
  ],
};


export const deleteOne$PROPER_CASE_SERVICE_NAME = {
  description: 'Delete a single $SERVICE_NAME',
  tags: ['Delete single $SERVICE_NAME'],
  summary: 'Delete a single a $SERVICE_NAME',
  params: {
    type: 'object',
    properties: {
      _id: {
        type: 'string',
        description: '$SERVICE_NAME id',
      },
    },
  },
  response: {
    '200': {
      description: 'Successful response',
      type: 'object',
      properties: {
        message: { type: 'string' },
      },
    },
    '404': {
      description: \"Can\'t find the $SERVICE_NAME\",
      type: 'object',
      properties: {
        message: { type: 'string' },
      },
    },
  },
  required: ['_id', 'name'],
  security: [
    {
      api_key: [],
    },
  ],
};">./"${APP_NAME}"/src/schema/"${SERVICE_NAME}".schema.ts


# data-store
echo "import { IRequestBody } from 'src/types';
import DataStore, { DatabaseInstance } from '../data-store';

export class $PROPER_CASE_SERVICE_NAMEService {
  private database: DatabaseInstance;

  constructor() {
    this.database = new DataStore();
  }

  public fetch$PROPER_CASE_SERVICE_NAMEs(): Promise<IRequestBody[] | void> {
    return this.database.fetch();
  }

  public fetch$PROPER_CASE_SERVICE_NAMEById(_id: string): Promise<IRequestBody | void> {
    return this.database.fetchById(_id);
  }

  public create$PROPER_CASE_SERVICE_NAME($SERVICE_NAME: IRequestBody): Promise<IRequestBody | void> {
    return this.database.add($SERVICE_NAME);
  }

  public update$PROPER_CASE_SERVICE_NAME(_id: string, $SERVICE_NAME: IRequestBody): Promise<IRequestBody | void> {
    return this.database.update(_id, $SERVICE_NAME);
  }

  public delete$PROPER_CASE_SERVICE_NAME(_id: string) {
    return this.database.delete(_id);
  }
}
">./"${APP_NAME}"/src/service/"${SERVICE_NAME}".service.ts


# service.ts
echo "import { IRequestBody as $PROPER_CASE_SERVICE_NAMEs } from 'src/types';
import { $PROPER_CASE_SERVICE_NAMEService } from './$SERVICE_NAME.service';

const $SERVICE_NAMEs: $PROPER_CASE_SERVICE_NAMEs[] = [
  { _id: '1', name: 'Judy Hopps' },
  { _id: '2', name: 'Nick Wilde' },
  { _id: '3', name: 'Cheif Bogo' },
  { _id: '4', name: 'Clawhauser' },
];

jest.mock('./$SERVICE_NAME.service');

function findElementByIndex(id: string) {
  if (!id) return -1;
  return $SERVICE_NAMEs.find(function(item) {
    return item._id === id;
  });
}

describe('$PROPER_CASE_SERVICE_NAME Service', () => {
  it('should return a list of $SERVICE_NAMEs', async () => {
    expect.assertions(2);
    const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();

    ($SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEs as jest.Mock).mockImplementation(() => $SERVICE_NAMEs);

    expect($SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEs()).toStrictEqual($SERVICE_NAMEs);
    expect($SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEs).toHaveBeenCalledTimes(1);
  });

  it('should return a single $SERVICE_NAME', () => {
    expect.assertions(2);

    const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
    ($SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEById as jest.Mock).mockImplementation((_id: string) => findElementByIndex(_id));
    expect($SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEById('4')).toStrictEqual({ _id: '4', name: 'Clawhauser' });
    expect($SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEById).toHaveBeenCalledTimes(1);
  });

  it('should create a single $SERVICE_NAME', () => {
    expect.assertions(2);
    const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
    const update = { _id: '5', name: 'Samantha' };

    ($SERVICE_NAME.create$PROPER_CASE_SERVICE_NAME as jest.Mock).mockImplementation((update: $PROPER_CASE_SERVICE_NAMEs) => {
      $SERVICE_NAMEs.splice($SERVICE_NAMEs.length, 0, update);
      $SERVICE_NAMEs.slice().splice($SERVICE_NAMEs.length, 0, update);
      return update;
    });

    expect($SERVICE_NAME.create$PROPER_CASE_SERVICE_NAME(update)).toStrictEqual(update);
    expect($SERVICE_NAME.create$PROPER_CASE_SERVICE_NAME).toHaveBeenCalledTimes(1);
  });

  it('should update a single $SERVICE_NAME', () => {
    expect.assertions(2);
    const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
    const update = { _id: '1', name: 'Samantha' };

    ($SERVICE_NAME.update$PROPER_CASE_SERVICE_NAME as jest.Mock).mockImplementation((_id: string, update: $PROPER_CASE_SERVICE_NAMEs) => {
      const index = parseInt(_id);
      const temp = $SERVICE_NAMEs.slice();
      temp[index - 1] = update;
      return update;
    });

    expect($SERVICE_NAME.update$PROPER_CASE_SERVICE_NAME('1', update)).toStrictEqual(update);
    expect($SERVICE_NAME.update$PROPER_CASE_SERVICE_NAME).toHaveBeenCalledTimes(1);
  });

  it('should delete a single $SERVICE_NAME', () => {
    expect.assertions(2);
    const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();

    ($SERVICE_NAME.delete$PROPER_CASE_SERVICE_NAME as jest.Mock).mockImplementation((_id: string) => {
      const index = parseInt(_id);
      const temp = $SERVICE_NAMEs.slice();
      temp.splice(index - 1, 1);
      return `$PROPER_CASE_SERVICE_NAME ${_id} deleted.`;
    });

    expect($SERVICE_NAME.delete$PROPER_CASE_SERVICE_NAME('1')).toEqual('$PROPER_CASE_SERVICE_NAME 1 deleted.');
    expect($SERVICE_NAME.delete$PROPER_CASE_SERVICE_NAME).toHaveBeenCalledTimes(1);
  });
});">./"${APP_NAME}"/src/service/"${SERVICE_NAME}".service.spec.ts


# service-modal
echo "import { model, Schema } from 'mongoose';

export interface ${PROPER_CASE_SERVICE_NAME}Document {
  _id: string;
  name: string;
}

const ${PROPER_CASE_SERVICE_NAME}Schema = new Schema<${PROPER_CASE_SERVICE_NAME}Document>({
  _id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
});

const ${PROPER_CASE_SERVICE_NAME}Model = model<${PROPER_CASE_SERVICE_NAME}Document>('${PROPER_CASE_SERVICE_NAME}', $PROPER_CASE_SERVICE_NAMESchema);
export default ${PROPER_CASE_SERVICE_NAME}Model;">./"${APP_NAME}"/src/model/"${PROPER_CASE_SERVICE_NAME}".entity.ts



# data-store

echo "import { IRequestBody } from '../types';
import {
  create$PROPER_CASE_SERVICE_NAME,
  find$PROPER_CASE_SERVICE_NAME,
  find$PROPER_CASE_SERVICE_NAMEById,
  modify$PROPER_CASE_SERVICE_NAME,
  delete$PROPER_CASE_SERVICE_NAME,
} from '../db/entity/$PROPER_CASE_SERVICE_NAME.entity';
import app from '../config/app';

export interface DatabaseInstance {
  fetch(): Promise<IRequestBody[] | void>;
  fetchById(_id: string): Promise<IRequestBody | void>;
  add(data: IRequestBody): Promise<IRequestBody | void>;
  update(_id: string, data: IRequestBody): Promise<IRequestBody | void>;
  delete(_id: string): Promise<void>;
}

export default class DataStore implements DatabaseInstance {
  public async fetch(): Promise<IRequestBody[] | void> {
    try {
      const $SERVICE_NAMEs = await find$PROPER_CASE_SERVICE_NAME();
      return $SERVICE_NAMEs;
    } catch (error) {
      app.log.error(error);
    }
  }

  public async fetchById(_id: string): Promise<IRequestBody | void> {
    try {
      const $SERVICE_NAME = await find$PROPER_CASE_SERVICE_NAMEById({ _id });
      if ($SERVICE_NAME) {
        return $SERVICE_NAME;
      }
    } catch (error) {
      app.log.error(error);
    }
  }

  public async add(data: IRequestBody): Promise<IRequestBody | void> {
    try {
      await create$PROPER_CASE_SERVICE_NAME(data);
      return data;
    } catch (error) {
      app.log.error(error);
    }
  }

  public async update(_id: string, data: IRequestBody): Promise<IRequestBody | void> {
    try {
      await modify$PROPER_CASE_SERVICE_NAME({ _id }, data);
      return data;
    } catch (error) {
      app.log.error(error);
    }
  }

  public async delete(_id: string): Promise<void> {
    try {
      await delete$PROPER_CASE_SERVICE_NAME({ _id });
    } catch (error) {
      app.log.error(error);
    }
  }
}
">./"${APP_NAME}"/src/data-store/index.ts


echo "import { FastifyInstance } from 'fastify';
import { $PROPER_CASE_SERVICE_NAMEService } from '../services/$SERVICE_NAME.service';
import { IRequestBody, IParams } from '../types';
import {
  create$PROPER_CASE_SERVICE_NAME as Create$PROPER_CASE_SERVICE_NAMESchema,
  fetch$PROPER_CASE_SERVICE_NAME as Fetch$PROPER_CASE_SERVICE_NAMESchema,
  fetchOne$PROPER_CASE_SERVICE_NAME as FetchOne$PROPER_CASE_SERVICE_NAMESchema,
  updateOne$PROPER_CASE_SERVICE_NAME as UpdateOne$PROPER_CASE_SERVICE_NAMESchema,
  deleteOne$PROPER_CASE_SERVICE_NAME as DeleteOne$PROPER_CASE_SERVICE_NAMESchema
} from '../schemas/$SERVICE_NAME-schema';

export async function $PROPER_CASE_SERVICE_NAMEController(fastify: FastifyInstance): Promise<void> {
  fastify.route<{ Body: IRequestBody }>({
    method: 'POST',
    url: '/$SERVICE_NAMEs/',
    schema: Create$PROPER_CASE_SERVICE_NAMESchema,
    handler: async function create$PROPER_CASE_SERVICE_NAMEController(request, reply) {
      const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
      return reply.code(201).send(await $SERVICE_NAME.create$PROPER_CASE_SERVICE_NAME(request.body));
    },
  });

  fastify.route({
    method: 'GET',
    url: '/$SERVICE_NAMEs/',
    schema: Fetch$PROPER_CASE_SERVICE_NAMESchema,
    handler: async function fetch$PROPER_CASE_SERVICE_NAMEController(_, reply) {
      const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
      return reply.send(await $SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEs());
    },
  });

  fastify.route<{ Params: IParams }>({
    method: 'GET',
    url: '/$SERVICE_NAMEs/:id/',
    schema: FetchOne$PROPER_CASE_SERVICE_NAMESchema,
    handler: async function fetch$PROPER_CASE_SERVICE_NAMEByIdController(request, reply) {
      const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
      return reply.send(await $SERVICE_NAME.fetch$PROPER_CASE_SERVICE_NAMEById(request.params._id));
    },
  });

  fastify.route<{ Params: IParams; Body: IRequestBody }>({
    method: 'PUT',
    url: '/$SERVICE_NAMEs/:id/',
    schema: UpdateOne$PROPER_CASE_SERVICE_NAMESchema,
    handler: async function update$PROPER_CASE_SERVICE_NAMEController(request, reply) {
      const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
      return reply.send(await $SERVICE_NAME.update$PROPER_CASE_SERVICE_NAME(request.params.id, request.body));
    },
  });

  fastify.route<{ Params: IParams }>({
    method: 'DELETE',
    url: '/$SERVICE_NAMEs/:id/',
    schema: DeleteOne$PROPER_CASE_SERVICE_NAMESchema,
    handler: async function delete$PROPER_CASE_SERVICE_NAMEController(request, reply) {
      const $SERVICE_NAME = new $PROPER_CASE_SERVICE_NAMEService();
      return reply.code(204).send(await $SERVICE_NAME.delete$PROPER_CASE_SERVICE_NAME(request.params._id));
    },
  });
}">./"${APP_NAME}"/src/controller/"${SERVICE_NAME}".controller.ts

