#!/usr/bin/env bash

sed -i '/"clean":/a \\t"start": "nodemon lib\/server.js --exec babel-node --presets es2015,stage-2",' package.json
sed -i '/"start":/a \\t"build": "babel lib -d dist --presets es2015,stage-2",' package.json
sed -i '/"build":/a \\t"serve": "node dist\/server.js"' package.json
