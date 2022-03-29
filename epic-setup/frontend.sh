#!/usr/bin/env bash

##########################################
#  Create a directories for the server app
###########################################
APP_NAME="$1"
# NODE_VERSION="$2"
# MAJOR_VERSION=${NODE_VERSION%%.*}
# GITHUB_URL="$3"

mkdir -p "${APP_NAME}"/{public,src/{assets,common,providers,config,routing,pages,services,mocks,utils}}


echo "

<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>${APP_NAME}</title>
</head>
<body>
    <h1>${APP_NAME}</h1>
    <div id=\"root\"></div>
    <script type=\"module\" src=\"./dist/index.js\"></script>
</body>
</html>

">./"${APP_NAME}"/public/index.html


echo "import React from 'react';
import ReactDOM from 'react-dom';

function App(): React.ReactElement {
  return <div>Typescript enabled</div>;
}

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root'),
);

if (import.meta.hot) {
  import.meta.hot.accept();
}">./"${APP_NAME}"/src/index.tsx


echo "describe('Test', () => {
  it('should execute code', () => {
    expect(1).toBe(1);
  });
});

export {};">./"${APP_NAME}"/src/app.spec.tsx


echo "node_modules">./"${APP_NAME}"/.gitignore

echo "{
  \"\$schema\": \"https://json.schemastore.org/tsconfig\",
  \"compilerOptions\": {
    \"jsx\": \"react\",
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
    \"module\": \"esnext\",
    \"moduleResolution\": \"node\",
    \"noEmit\": true,
    \"noImplicitAny\": true,
    \"noImplicitThis\": true,
    \"noUnusedLocals\": true,
    \"noUnusedParameters\": true,
    \"paths\": {
      \"@assets\": [\"./src/assets\"],
      \"@common\": [\"./src/common\"],
      \"@pages\": [\"./src/pages\"],
      \"@providers\": [\"./src/providers\"],
      \"@routing\": [\"./src/routing\"],
      \"@services\": [\"./src/services\"],
      \"@styles\": [\"./src/styles\"],
      \"@utils\": [\"./src/utils\"],
      \"*\": [\".snowpack/types/*\"]
    },
    \"resolveJsonModule\": true,
    \"skipLibCheck\": true,
    \"sourceMap\": true,
    \"strict\": true,
    \"strictBindCallApply\": true,
    \"strictFunctionTypes\": true,
    \"strictNullChecks\": true,
    \"strictPropertyInitialization\": true,
    \"target\": \"esnext\",
    \"target\": \"esnext\",
    \"types\": [\"snowpack-env\", \"@testing-library/jest-dom\"]
  },
  \"exclude\": [\"./dist\", \"**/node_modules\", \"**/.(spec|test)*/\"],
  \"include\": [\"src\", \"types\"]
}">./"${APP_NAME}"/tsconfig.json


echo "/** @type {import(\"snowpack\").SnowpackUserConfig } */
export default {
  mount: {
    public: '/',
    src: '/dist',
  },
  alias: {
    '@assets': './src/assets',
    '@common': './src/common',
    '@pages': './src/pages',
    '@providers': './src/providers',
    '@routing': './src/routing',
    '@services': './src/services',
    '@styles': './src/styles',
    '@utils': './src/utils',
  },
  plugins: [
    '@snowpack/plugin-react-refresh',
    '@snowpack/plugin-typescript'
  ],
  routes: [{ match: 'routes', src: '.*', dest: '/index.html' }],
  optimize: {
    bundle: true,
    sourcemap: 'inline',
    splitting: true,
    treeshake: true,
    manifest: true,
    minify: true
  },
  packageOptions: {
    /* ... */
  },
  devOptions: {},
  buildOptions: {
    /* ... */
  },
};">./"${APP_NAME}"/snowpack.config.mjs


echo "{
  \"rootDir\": \".\",
  \"verbose\": true,
  \"transform\": {
    \"^.+\\\\.tsx?$\": \"ts-jest\"
  },
  \"testEnvironment\": \"jsdom\",
  \"testMatch\": [\"<rootDir>/src/**/?(*.)+(spec|test).[jt]s?(x)\"],
  \"setupFilesAfterEnv\": [\"@testing-library/jest-dom\"],
  \"moduleFileExtensions\": [\"ts\", \"tsx\", \"js\", \"jsx\"],
  \"coverageDirectory\": \"<rootDir>/coverage\",
  \"moduleDirectories\": [\"node_modules\"],
  \"moduleNameMapper\": {
    \"\\\\.css$\": \"<rootDir>/src/mocks/styleMock.ts\",
    \"\\\\.ico$\": \"<rootDir>/src/mocks/styleMock.ts\",
    \"@components/(.*)$\": \"<rootDir>/src/components/$1\",
    \"@assets/(.*)$\": \"<rootDir>/src/assets/$1\"
  },
  \"coverageThreshold\": {
    \"global\": {
      \"branches\": 80,
      \"functions\": 80,
      \"lines\": 80,
      \"statements\": -10
    }
  },
  \"coveragePathIgnorePatterns\": [\"<rootDir>/coverage\", \"<rootDir>/src/mocks\", \"<rootDir>/src/index.tsx?\"],
  \"globals\": {
    \"test-jest\": {
      \"diagnostics\": false
    }
  }
}">./"${APP_NAME}"/jest.config.json


echo "{
  \"arrowParens\": \"avoid\",
  \"bracketSpacing\": true,
  \"endOfLine\": \"lf\",
  \"htmlWhitespaceSensitivity\": \"css\",
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
}">./"${APP_NAME}"/.prettierrc.json


echo "export {};">./"${APP_NAME}/mocks/styleMock.ts"


echo "root = true


[*]
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
indent_style = space
indent_size = 2

[*.txt]
indent_style = tab
indent_size = 4

[*.{diff,md}]
trim_trailing_whitespace = false
">./"${APP_NAME}"/.editorconfig


echo "# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.vscode
.history/

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


# TypeScript v1 declaration files
typings/

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

# Next.js build output
.next

.parcel-cache

# Next.js build output
.next
out

# Nuxt.js build / generate output
.nuxt

dist/
# Gatsby files
.cache/
# Comment in the public line in if your project uses Gatsby and *not* Next.js
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
.pnp.*

# stryker temp files
.stryker-tmp">./"${APP_NAME}"/.gitignore


#######################################
# NPM package installation for SERVER 
#######################################
cd ./"${APP_NAME}" &&

git init > /dev/null 2>&1 &&

npm init -y > /dev/null 2>&1


npm i -D @snowpack/plugin-react-refresh \
    @snowpack/plugin-typescript \
    @snowpack/plugin-webpack \
    @types/jest \
    @types/react \
    @types/react-dom \
    @types/snowpack-env \
    @testing-library/jest-dom \
    jest \
    ts-jest \
    snowpack \


npm i -S react \
    react-dom \


npm set-script start "snowpack dev"
npm set-script build "snowpack build"    
npm set-script test "NODE_ENV=test jest --detectOpenHandles --forceExit --config jest.config.json"
npm set-script test:coverage "NODE_ENV=test jest --config jest.config.json --coverage"

# openapi --input http://localhost:5000/documentation/json --output ./libs/openapi/src/domain --useUnionTypes --client fetch

# echo "name: Cypress Tests
# on:
#   pull_request:

# jobs:
#   build:
#     runs-on: ubuntu-latest
#     steps:
#       - name: Checkout branch
#         uses: actions/checkout@v2

#   chrome:
#     runs-on: ubuntu-latest
#     name: E2E on Chrome
#     steps:
#       - name: Checkout
#         uses: actions/checkout@v2
#       - name: Cypress run
#         uses: cypress-io/github-action@v2
#         with:
#           command: make eTe URL=https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
#           browser: chrome
#           headless: true
#           config-file: apps/k6i-ui-e2e/cypress.json
#           tag: chrome
#         env:
#           BROWSER: chrome
#           CI: true
#           URL: https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
#           CYPRESS_E2E_ENV: ${{ secrets.CYPRESS_E2E_ENV }}
#           CYPRESS_E2E_API_SERVER: ${{ secrets.CYPRESS_E2E_API_SERVER }},
#           CYPRESS_E2E_KEYCLOAK_SERVER: ${{ secrets.CYPRESS_E2E_KEYCLOAK_SERVER }}
#           CYPRESS_E2E_GRANT_TYPE: ${{ secrets.CYPRESS_E2E_GRANT_TYPE }}
#           CYPRESS_E2E_PASSWORD: ${{ secrets.CYPRESS_E2E_PASSWORD }}
#           CYPRESS_E2E_USERNAME: ${{ secrets.CYPRESS_E2E_USERNAME }}
#           CYPRESS_E2E_CLIENT_ID: ${{ secrets.CYPRESS_E2E_CLIENT_ID }}
#           CYPRESS_E2E_CLIENT_SECRET: ${{ secrets.CYPRESS_E2E_CLIENT_SECRET }}
#       - name: Upload artifacts on failure
#         uses: actions/upload-artifact@v2
#         if: failure()
#         with:
#           name: chrome-screenshots
#           path: dist/cypress/apps/k6i-ui-e2e/screenshots
#       - name: e2e Chrome Report
#         run: |
#           make report BROWSER=$BROWSER
#       - name: Upload cucumber report
#         if: success()
#         uses: actions/upload-artifact@v2
#         with:
#           name: chrome-cucumber-report
#           path: apps/k6i-ui-e2e/cucumber-report

#   firefox:
#     runs-on: ubuntu-latest
#     name: E2E on Firefox
#     steps:
#       - name: Checkout
#         uses: actions/checkout@v2
#       - name: Cypress run
#         uses: cypress-io/github-action@v2
#         with:
#           command: make eTe URL=https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
#           browser: firefox
#           headless: true
#           config-file: apps/k6i-ui-e2e/cypress.json
#           tag: firefox
#         env:
#           BROWSER: firefox
#           CI: true
#           URL: https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
#           CYPRESS_E2E_ENV: ${{ secrets.CYPRESS_E2E_ENV }}
#           CYPRESS_E2E_API_SERVER: ${{ secrets.CYPRESS_E2E_API_SERVER }},
#           CYPRESS_E2E_KEYCLOAK_SERVER: ${{ secrets.CYPRESS_E2E_KEYCLOAK_SERVER }}
#           CYPRESS_E2E_GRANT_TYPE: ${{ secrets.CYPRESS_E2E_GRANT_TYPE }}
#           CYPRESS_E2E_PASSWORD: ${{ secrets.CYPRESS_E2E_PASSWORD }}
#           CYPRESS_E2E_USERNAME: ${{ secrets.CYPRESS_E2E_USERNAME }}
#           CYPRESS_E2E_CLIENT_ID: ${{ secrets.CYPRESS_E2E_CLIENT_ID }}
#           CYPRESS_E2E_CLIENT_SECRET: ${{ secrets.CYPRESS_E2E_CLIENT_SECRET }}
#       - name: Upload artifacts on failure
#         uses: actions/upload-artifact@v2
#         if: failure()
#         with:
#           name: firefox-screenshots
#           path: dist/cypress/apps/k6i-ui-e2e/screenshots
#       - name: e2e Firefox Report
#         run: |
#           make report BROWSER=$BROWSER
#       - name: Upload cucumber report
#         if: success()
#         uses: actions/upload-artifact@v2
#         with:
#           name: firefox-cucumber-report
#           path: apps/k6i-ui-e2e/cucumber-report

#   edge:
#     name: E2E on Edge
#     runs-on: windows-latest
#     steps:
#       - name: Checkout
#         uses: actions/checkout@v2
#       - name: Cypress run
#         uses: cypress-io/github-action@v2
#         with:
#           command: make eTe URL=https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
#           browser: edge
#           headless: true
#           config-file: apps/k6i-ui-e2e/cypress.json
#           tag: edge
#         env:
#           BROWSER: edge
#           CI: true
#           URL: https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
#           CYPRESS_E2E_ENV: ${{ secrets.CYPRESS_E2E_ENV }}
#           CYPRESS_E2E_API_SERVER: ${{ secrets.CYPRESS_E2E_API_SERVER }},
#           CYPRESS_E2E_KEYCLOAK_SERVER: ${{ secrets.CYPRESS_E2E_KEYCLOAK_SERVER }}
#           CYPRESS_E2E_GRANT_TYPE: ${{ secrets.CYPRESS_E2E_GRANT_TYPE }}
#           CYPRESS_E2E_PASSWORD: ${{ secrets.CYPRESS_E2E_PASSWORD }}
#           CYPRESS_E2E_USERNAME: ${{ secrets.CYPRESS_E2E_USERNAME }}
#           CYPRESS_E2E_CLIENT_ID: ${{ secrets.CYPRESS_E2E_CLIENT_ID }}
#           CYPRESS_E2E_CLIENT_SECRET: ${{ secrets.CYPRESS_E2E_CLIENT_SECRET }}
#       - name: Upload artifacts on failure
#         uses: actions/upload-artifact@v2
#         if: failure()
#         with:
#           name: edge-screenshots
#           path: dist/cypress/apps/k6i-ui-e2e/screenshots
#       - name: e2e Firefox Report
#         run: |
#           make report BROWSER=$BROWSER
#       - name: Upload cucumber report
#         if: success()
#         uses: actions/upload-artifact@v2
#         with:
#           name: edge-cucumber-report
#           path: apps/k6i-ui-e2e/cucumber-report">.cypress-workflow.yml


# echo "export interface Browser {
#   name: string;
#   family: string;
#   channel: string;
#   displayName: string;
#   version: string;
#   majorVersion: number;
#   path: string;
#   isHeaded: boolean;
#   isHeadless: boolean;
# }
# "


# echo "export interface DataTable {
#   rawTable: string[][];
# }

# export function getNavigationItems(dataTable: DataTable) {
#   const values = dataTable.rawTable.slice(1);

#   const headings = dataTable.rawTable
#     .slice(0, 1)[0]
#     .reduce((acc: string[], title: string) => acc.concat(title), []);

#   return values.map((current: [string, string], idx: number) => {
#     return headings.reduce(
#       (acc: { [key: string]: string }, heading: string, index: number) => {
#         return (acc[heading] = values[idx][index]), acc;
#       },
#       {}
#     );
#   });
# }"


# echo "/* eslint-disable */
# const report = require('multiple-cucumber-html-reporter');
# const os = require('os');
# const { resolve } = require('path');
# const yargs = require('yargs/yargs');
# const argv = yargs(process.argv).argv;

# const reportPath = argv.DIR
#   ? `./apps/k6i-ui-e2e/cucumber-report/${argv.DIR}`
#   : './apps/k6i-ui-e2e/cucumber-report';

# report.generate({
#   jsonDir: resolve(__dirname, './cucumber-json'),
#   reportPath: reportPath,
#   pageTitle: 'k6ui-e2e',
#   reportName: 'k6ui-e2e',
#   displayDuration: true,
#   displayReportTime: true,
#   metadata: {
#     browser: {
#       name: argv.browser || 'local',
#       version: 'latest',
#     },
#     device: os.hostname(),
#     platform: {
#       name: process.platform,
#       version: process.release.lts,
#     },
#   },
#   customData: {
#     title: 'Run info',
#     data: [
#       { label: 'Project', value: 'Kalamari' },
#       { label: 'Release', value: '1.2.3' },
#       { label: 'Cycle', value: 'Sprint 16' },
#       { label: 'Date', value: new Date() },
#     ],
#   },
# });
# "

# echo "import cucumber from 'cypress-cucumber-preprocessor';
# import * as fs from 'fs';
# import { lighthouse, prepareAudit } from 'cypress-audit';
# import type { Browser } from './plugin-types';

# function urlParse(url: string): string {
#   const localUrl = url.split('/').filter(Boolean);
#   const match = /^[0-9-a-z( )]+$/g.test(localUrl[1]);
#   if (match) {
#     localUrl[1] = 'id';
#   }
#   return `${localUrl.join('-')}`;
# }

# export default (
#   on: Cypress.PluginEvents,
#   config: Cypress.PluginConfigOptions
# ): Cypress.PluginConfigOptions => {
#   on(
#     'file:preprocessor',
#     cucumber({ typescript: require.resolve('typescript') })
#   );
#   on(
#     'before:browser:launch',
#     // eslint-disable-next-line @typescript-eslint/no-unused-vars
#     (browser: Partial<Browser> = {}, launchOptions) => {
#       prepareAudit(launchOptions);
#     }
#   );

#   const dirPath = './audit-report';

#   on('task', {
#     lighthouse: lighthouse(
#       (lighthouseReport: {
#         lhr: { requestedUrl: string; fetchTime: string };
#       }) => {
#         const today = new Date();
#         let h = today.getHours().toString();
#         let m = today.getMinutes().toString();

#         if (JSON.parse(h) < 10) h = '0' + h;
#         if (JSON.parse(m) < 10) m = '0' + m;
#         if (!fs.existsSync(dirPath)) {
#           fs.mkdirSync(`${dirPath}/lighthouse`, { recursive: true });
#         }

#         const name = `${
#           new URL(lighthouseReport.lhr.requestedUrl).pathname === '/'
#             ? 'home'
#             : new URL(lighthouseReport.lhr.requestedUrl).pathname.length >= 3
#             ? urlParse(new URL(lighthouseReport.lhr.requestedUrl).pathname)
#             : new URL(lighthouseReport.lhr.requestedUrl).pathname.slice(1)
#         }-${lighthouseReport.lhr.fetchTime.split('T')[0]}_${h}:${m}`;
#         fs.writeFileSync(
#           `${dirPath}/lighthouse/${name}.json`,
#           JSON.stringify(lighthouseReport.lhr, null, 2)
#         );
#       }
#     ),
#   });
#   return config;
# };"

# echo "/* eslint-disable */
# const report = require('multiple-cucumber-html-reporter');
# const os = require('os');
# const { resolve } = require('path');
# const yargs = require('yargs/yargs');
# const argv = yargs(process.argv).argv;

# const reportPath = argv.DIR
#   ? `./apps/k6i-ui-e2e/cucumber-report/${argv.DIR}`
#   : './apps/k6i-ui-e2e/cucumber-report';

# report.generate({
#   jsonDir: resolve(__dirname, './cucumber-json'),
#   reportPath: reportPath,
#   pageTitle: 'k6ui-e2e',
#   reportName: 'k6ui-e2e',
#   displayDuration: true,
#   displayReportTime: true,
#   metadata: {
#     browser: {
#       name: argv.browser || 'local',
#       version: 'latest',
#     },
#     device: os.hostname(),
#     platform: {
#       name: process.platform,
#       version: process.release.lts,
#     },
#   },
#   customData: {
#     title: 'Run info',
#     data: [
#       { label: 'Project', value: 'Kalamari' },
#       { label: 'Release', value: '1.2.3' },
#       { label: 'Cycle', value: 'Sprint 16' },
#       { label: 'Date', value: new Date() },
#     ],
#   },
# });"



# echo "ForkTsCheckerWebpackPlugin {
#  options: {
#    typescript: {
#      enabled: true,
#      configFile: '/Users/jlong/Development/k6i-ui/apps/k6i-ui/tsconfig.app.json',
#      memoryLimit: 2018
#    }
#  }"


# echo "const lighthouseConfig = {
#   formFactor: 'desktop',
#   screenEmulation: {
#     disabled: true,
#   },
# };
# const audits = {
#   // seo: 60,
#   // pwa: 5,
#   performance: 0,
#   // accessibility: 50,
#   // interactive: 30000,
#   // 'first-contentful-paint': 3000,
#   'largest-contentful-paint': 40000,
# };
#     cy.lighthouse(audits, lighthouseConfig);

# "


# echo "{
#   \"$schema\": \"https://on.cypress.io/cypress.schema.json\",
#   \"baseUrl\": \"http://localhost:4200\",
#   \"viewportWidth\": 1600,
#   \"viewportHeight\": 900,
#   \"fileServerFolder\": \".\",
#   \"fixturesFolder\": \"cypress/fixtures\",
#   \"modifyObstructiveCode\": false,
#   \"screenshotOnRunFailure\": true,
#   \"video\": true,
#   \"videosFolder\": \"../../dist/cypress/apps/k6i-ui-e2e/videos\",
#   \"screenshotsFolder\": \"../../dist/cypress/apps/k6i-ui-e2e/screenshots\",
#   \"chromeWebSecurity\": false,
#   \"testFiles\": \"**/*.{feature,features}\",
#   \"defaultCommandTimeout\": 60000
# }
# ">./cypress.json

# echo "// Snowpack Configuration File
# // See all supported options: https://www.snowpack.dev/reference/configuration

# /** @type {import(\"snowpack\").SnowpackUserConfig } */
# module.exports = {
#   mount: {
#     /* ... */
#   },
#   routes: [
#     {
#       match: 'routes',
#       src: '.*',
#       dest: '/index.html',
#     },
#   ],
#   plugins: [
#     /* ... */
#   ],
#   packageOptions: {
#     external: [
#       ...require('module').builtinModules,
#       ...Object.keys(require('./package.json').devDependencies),
#     ],
#   },
#   devOptions: {
#     /* ... */
#   },
#   buildOptions: {
#     /* ... */
#   },
# };
# ">./snowpack.config.js
