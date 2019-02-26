#!/usr/bin/env bash

echo -e "\n\n\t\e[1;35mBeginning graphql setup.\n\n\e[0m"

npm i apollo-server-express
npm i graphql
npm i @babel/node
npm i express
npm i cors
npm i http-server
npm i nodemon
npm i helmet
npm i bcrypt
npm i morgan
npm i body-parser
npm i compression
npm i dotenv
npm i apollo-boost
npm i react-apollo
npm i graphql-tag


echo -e "module.exports = {
  apps: [{
    name: 'ai-dashboard',
    script: 'build/index.js',
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

echo -e "import path from 'path';
import express from 'express';
import cors from 'cors';
import http from 'http';
import bodyParser from 'body-parser';
import helmet from 'helmet';
import compression from 'compression';
import { ApolloServer }  from 'apollo-server-express';
import { config } from 'dotenv';

config();
import apollo from './schema'

const port = process.env.PORT || 5000;
const app = express();
const publicPath = path.join(__dirname, '../dist');
const server = http.createServer(app);

apollo.applyMiddleware({ app });
app.use(cors());
app.use(helmet());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(require('morgan')('dev'));
app.use(compression());
app.use(express.static(publicPath));

apollo.installSubscriptionHandlers(server);

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
  console.log(\`🚀 Server has started and is listening on \${port}\`);
  console.info('Graphql is listing on has started and is listening on', apollo.graphqlPath);
})();"> ./server/index.js

echo -e "import dse from 'dse-driver';

const client = new dse.Client({
  contactPoints: ['127.0.0.1'],
  keyspace: 'chatter'
});

export default client;
">./server/config/db.js


echo -e "import { ApolloServer, gql, PubSub } from 'apollo-server-express';
import resolvers from './resolvers';
import UserType from './user/user.type'
import client from '../config/db';
import RootQuery from './root-query/root-query.type'
import RootMutation from './root-mutation/root-mutation.type';
import Subscriptions from './subscriptions/subscription.type';

const pubSub = new PubSub();

const SchemaDefinition = gql\`
  schema {
    query: RootQuery,
    mutation: RootMutation,
    subscription: Subscription
  }\`;

const apollo = new ApolloServer({
  typeDefs: [SchemaDefinition, RootQuery, RootMutation, Subscriptions, UserType],
  context(request) {
    return { client, pubSub, request }
  },
  resolvers
  introspection: false,
  playground: false,
});

export default apollo;
">./sever/schema/index.js


echo -e "import RootQuery from './root-query/root-query.resolvers';
import RootMutation from './root-mutation/root-mutation.resolvers';
import Subscription from './subscriptions/subscription.resolvers';

export default {
  RootQuery,
  RootMutation,
  Subscription
}
">./server/schema/resolvers.js

echo -e "import { gql } from 'apollo-server-express';

const userProfileDef = gql\`
  type UserProfile {
   user(email: String!): User
  }

  type User {
    firstname: String!
    surname: String!
    email: String!
    password: String!
    hash: String!
    tokens: Tokens
    authorization: Auth!
  }

  type Auth {
    read: Boolean!
    write: Boolean!
  }

  type Tokens {
     access: String
     token: String
  }
\`;

export default userProfileDef; ">./server/user/user.type.js

echo -e "const subscriptionResolvers = {
  activeUsers: {
    subscribe(parent, args, { pubSub }, info) {
      console.log(pubSub);
      let count = 0;

      setInterval(() => {
        count++;
        pubSub.publish('ONLINE_NOTIFICATION', {
          activeUsers: {
            data: count,
            mutation: 'NEW_USER_SIGNED_IN'
          }
        })
      }, 1000);

      return pubSub.asyncIterator('ONLINE_NOTIFICATION')
    }
  }

};

export default subscriptionResolvers;">./server/schema/subscriptions/subscription.resolvers.js

echo -e "const subscriptionResolvers = {
  activeUsers: {
    subscribe(parent, args, { pubSub }, info) {
      console.log(pubSub);
      let count = 0;

      setInterval(() => {
        count++;
        pubSub.publish('ONLINE_NOTIFICATION', {
          activeUsers: {
            data: count,
            mutation: 'NEW_USER_SIGNED_IN'
          }
        })
      }, 1000);

      return pubSub.asyncIterator('ONLINE_NOTIFICATION')
    }
  }

};

export default subscriptionResolvers;">./server/schema/subscriptions/subscription.resolvers.js

echo -e "import { gql } from 'apollo-server-express';

const RootSubscription = gql\`
  type Subscription {
   activeUsers: Info!
  }

  type Info {
   data: Int!
   mutation: MutationType!
  }

  enum MutationType {
    NEW_USER_SIGNED_IN
  }
\`;

export default RootSubscription;">./server/schema/subscriptions/subscription.type.js


echo -e "const rootQueryResolvers = {
  async user(parent, args, { client }, info) {
    const query = 'SELECT * FROM chatter.userprofile WHERE email = ?';
    const params = [args.email];
    try {
      const results = await client.execute(query, params);
      return results.rows[0];
    } catch (error) {
      console.log(error);
    }
  },
};

export default rootQueryResolvers;">./server/schema/root-query/root-query.resolvers.js

echo -e "import { gql } from 'apollo-server-express';

const queryEntryPoints = gql\`
  type RootQuery {
   user(email: String!): User
  }
\`;

export default queryEntryPoints;">./server/schema/root-query/root-query.type.js


echo -e "const rootMutationResolver = {

  async createUser(parent, args, { client }, info) {
    const authorization = { read: true, write: false };
    const insert = 'INSERT INTO userprofile(email, firstname, surname, password, authorization, tokens) VALUES(?, ?, ?, ?, ?, ?) IF NOT EXISTS';
    const params = [args.email, args.firstname, args.surname, args.password, authorization];

    try {
      const results = await client.execute(insert, params, { prepare: true });
      return results.rows[0];
    } catch (error) {
      console.log(error);
      return error;
    }
  }
};


export default rootMutationResolver;">./server/schema/root-mutation/root-mutation.resolvers.js

echo -e "import { gql } from 'apollo-server-express';

const RootMutation = gql\`
  type RootMutation {
    createUser(
      firstname: String!,
      surname: String!,
      email: String!
      password: String!
    ): User
  }
\`;

export default RootMutation;">./server/schema/root-mutation/root-mutation.type.js


sed -i '/"test":/i \\t"server": "nodemon server\/index.js --exec babel-node",' package.json
sed -i '/"server":/a \\t"start": "pm2-runtime start ecosystem.config.js --env production",' package.json
