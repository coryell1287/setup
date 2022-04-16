#!/usr/bin/env bash

##########################################
#  Create a directories for the server app
###########################################
APP_NAME="$1"
# NODE_VERSION="$2"
# MAJOR_VERSION=${NODE_VERSION%%.*}
# GITHUB_URL="$3"

mkdir -p "${APP_NAME}"/{public,src/{assets,common/{nav-list,nav,types},providers,config,routing,pages,services,mocks,utils}}


###########################
#  Create index.html file
###########################

echo "<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <link rel=\"stylesheet\" href=\"./reset.css\">
    <link rel=\"stylesheet\" href=\"./main.css\">
    <title>${APP_NAME}</title>
</head>
<body>
    <h1>${APP_NAME}</h1>
    <div id=\"root\"></div>
    <script type=\"module\" src=\"./dist/index.js\"></script>
</body>
</html>

">./"${APP_NAME}"/public/index.html



echo "html, body, div, span, applet, object, iframe,
h1, h2, h3, h4, h5, h6, p, blockquote, pre,
a, abbr, acronym, address, big, cite, code,
del, dfn, em, img, ins, kbd, q, s, samp,
small, strike, strong, sub, sup, tt, var,
b, u, i, center,
dl, dt, dd, ol, ul, li,
fieldset, form, label, legend,
table, caption, tbody, tfoot, thead, tr, th, td,
article, aside, canvas, details, embed, 
figure, figcaption, footer, header, hgroup, 
menu, nav, output, ruby, section, summary,
time, mark, audio, video {
	margin: 0;
	padding: 0;
	border: 0;
	font-size: 100%;
	font: inherit;
	vertical-align: baseline;
}
/* HTML5 display-role reset for older browsers */
article, aside, details, figcaption, figure, 
footer, header, hgroup, menu, nav, section {
	display: block;
}
body {
	line-height: 1;
}
ol, ul {
	list-style: none;
}
blockquote, q {
	quotes: none;
}
blockquote:before, blockquote:after,
q:before, q:after {
	content: '';
	content: none;
}
table {
	border-collapse: collapse;
	border-spacing: 0;
}">./"${APP_NAME}"/public/reset.css



echo "h1 {
  font-size: 24px;
  padding: 15px 5px;
}">./"${APP_NAME}"/public/main.css

###########################
#  Create app entry file
###########################

echo "import React, { ReactElement } from 'react';
import ReactDOM from 'react-dom/client';
import { Nav } from './common/nav/Nav';

const root = ReactDOM.createRoot(document.getElementById('root') as HTMLDivElement);

function App(): ReactElement {
  return <Nav />;
}

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
);

if (import.meta.hot) {
  import.meta.hot.accept();
}">./"${APP_NAME}"/src/index.tsx



###########################
#  Create tsconfig file
###########################
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
    \"declarationDir\": \"./types\",
    \"declarationMap\": true,
    \"downlevelIteration\": true,
    \"emitDecoratorMetadata\": true,
    \"esModuleInterop\": true,
    \"experimentalDecorators\": true,
    \"forceConsistentCasingInFileNames\": true,
    \"importHelpers\": true,
    \"isolatedModules\": true,
     \"lib\": [
      \"es5\",
      \"es6\",
      \"dom\",
      \"es2015.core\",
      \"es2015.collection\",
      \"es2015.generator\",
      \"es2015.iterable\",
      \"es2015.promise\",
      \"es2015.proxy\",
      \"es2015.reflect\",
      \"es2015.symbol\",
      \"es2015.symbol.wellknown\",
      \"esnext.asynciterable\",
      \"es2019\",
      \"ESNext\"
    ],
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
    \"types\": [\"snowpack-env\", \"@testing-library/jest-dom\"]
  },
  \"exclude\": [\"./dist\", \"**/node_modules\", \"**/.(spec|test)*/\"],
  \"include\": [\"src\", \"types\"]
}">./"${APP_NAME}"/tsconfig.json


################################
#  Create snowpack config file
################################

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


###########################
#  Create jest config file
###########################

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

##############################
#  Create prettier config file
##############################

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


echo "export {};">./"${APP_NAME}/src/mocks/styleMock.ts"


##############################
#  Create .eslint file
##############################


echo "{
  \"root\": true,
  \"parser\": \"@typescript-eslint/parser\",
   \"env\": {
        \"browser\": true,
        \"es2021\": true
    },
  \"extends\": [
    \"plugin:jest/all\",
    \"plugin:@typescript-eslint/recommended\",
    \"plugin:jsx-a11y/recommended\",
    \"plugin:react-hooks/recommended\",
    \"plugin:import/errors\",
    \"plugin:import/warnings\"
  ],
  \"plugins\": [\"testing-library\", \"import\", \"@typescript-eslint\", \"react\", \"prettier\"],
  \"parserOptions\": {
    \"ecmaVersion\": \"latest\",
    \"sourceType\": \"module\"
  },
  \"rules\": {
    \"no-unused-expressions\": \"off\",
    \"@typescript-eslint/explicit-function-return-type\": \"off\",
    \"@typescript-eslint/no-explicit-any\": \"error\",
    \"jest/prefer-expect-assertions\": \"error\",
    \"jest/no-hooks\": \"off\",
    \"jest/no-disabled-tests\": \"off\",
    \"jest/prefer-called-with\": \"off\",
    \"@typescript-eslint/no-inferrable-types\": [
      \"warn\",
      {
        \"ignoreParameters\": true
      }
    ],
    \"@typescript-eslint/no-unused-vars\": \"warn\",
    \"prettier/prettier\": \"error\",
    \"import/order\": [
      \"error\",
      {
        \"groups\": [\"builtin\", \"external\", \"internal\", \"parent\", \"sibling\", \"index\", \"unknown\"],
        \"newlines-between\": \"always\"
      }
    ]
  },
  \"overrides\": [
    {
      \"files\": [\"**/*.spec.js\"],
      \"env\": {
        \"jest\": true
      }
    }
  ],
  \"settings\": {
    \"import/resolver\": {
      \"alias\": {
        \"map\": [
          [\"@assets\", \"./src/assets\"],
          [\"@components\", \"./src/components\"],
          [\"@types/*\", \"./src/types/*\"],
          [\"@styles\", \"./src/styles\"]
        ],
        \"extensions\": [\".js\", \".ts\", \".tsx\", \".json\", \".ico\"]
      }
    }
  }
}">./"${APP_NAME}"/.eslintrc.json

##############################
#  Create .editorconfig file
##############################

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



##############################
#  Create .gitignore  file
##############################
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
# Create Nav directories and files 
#######################################


echo "export { Nav } from './Nav';">./"${APP_NAME}"/src/common/nav/index.ts

echo "import React, { ReactElement } from 'react';
import { NavList } from '../nav-list';
import { List } from '../types';
import './nav.css';

const list: List[] = [
  { label: 'About', href: '/about' },
  { label: 'Products', href: '/products' },
  { label: 'Our team', href: '/team' },
  { label: 'Contact', href: '/contact' },
];

export const Nav = (): ReactElement => {
  return (
    <nav data-testid=\"main-nav\">
      <ul className=\"main-nav\">
        <NavList menuitems={list} />
      </ul>
    </nav>
  );
};">./"${APP_NAME}"/src/common/nav/Nav.tsx



echo ".main-nav {
  display: flex;
  width: 500px;
  float: right;
}

.main-nav li:last-child {
  margin-left: auto;
}

.main-nav li {
  height: 45px;
  width: 100px;
}">./"${APP_NAME}"/src/common/nav/nav.css


echo "import React from 'react';
import { render, screen } from '@testing-library/react';
import { Nav } from './Nav';

describe('<Nav/>', () => {
  it('should load the <Nav/> component', () => {
    render(<Nav />);
    expect(screen.getByTestId('main-nav')).toBeInTheDocument();
  });
});
">./"${APP_NAME}"/src/common/nav/nav.spec.tsx

#######################################
# Create NavList directories and files 
#######################################


echo "export { NavList } from './NavList';">./"${APP_NAME}"/src/common/nav-list/index.ts


echo "import { render, screen } from '@testing-library/react';
import React from 'react';
import type { List } from '../types/index';
import { NavList } from './NavList';

describe('<NavList/>', () => {
  it('should render list items inside of the NavList', () => {
    const list: List[] = [
      { label: 'About', href: '/about' },
      { label: 'Products', href: '/products' },
      { label: 'Our team', href: '/team' },
      { label: 'Contact', href: '/contact' },
    ];

    render(<NavList menuitems={list} />);
    const menuitems = screen.getAllByTestId('menu-item').map(item => item.textContent);
    const labels = list.map(a => a.label);

    expect(menuitems).toEqual(labels);
  });

  it('should render nav links inside of the NavList', () => {
    const list: List[] = [
      { label: 'About', href: '/about' },
      { label: 'Products', href: '/products' },
      { label: 'Our team', href: '/team' },
      { label: 'Contact', href: '/contact' },
    ];

    render(<NavList menuitems={list} />);
    const navLinks = Array.from(screen.getAllByTestId('nav-link')).map(item => item.getAttribute('href'));
    const href = list.map(item => item.href);
    expect(navLinks).toEqual(href);
  });
});">./"${APP_NAME}"/src/common/nav-list/NavList.spec.tsx



echo "import React, { ReactElement } from 'react';
import { List } from '../types/index';

interface NavListProps {
  menuitems: List[];
}

export const NavList = ({ menuitems }: NavListProps): ReactElement => {
  return (
    <>
      {menuitems.map(({ label, href }, index) => {
        return (
          <li key={index + label} data-testid=\"menu-item\">
            <a data-testid=\"nav-link\" href={href}>{label}</a>
          </li>
        );
      })}
    </>
  );
};">./"${APP_NAME}"/src/common/nav-list/NavList.tsx


echo "export interface List {
  label: string;
  href: string;
}">./"${APP_NAME}"/src/common/types/index.ts

#######################################
# Initialize github repo for SERVER 
#######################################
cd ./"${APP_NAME}" &&
git init > /dev/null 2>&1 &&
# git remote add origin "${GITHUB_URL}" > /dev/null 2>&1

#######################################
# NPM package installation for SERVER 
#######################################
npm init -y > /dev/null 2>&1

npm i -D jest \
    ts-jest \
    snowpack \
    @types/jest \
    @types/react \
    @types/react-dom \
    @typescript-eslint/parser \
    eslint \
    eslint-config-prettier \
    eslint-import-resolver-alias \
    eslint-plugin-import \
    eslint-plugin-jest \
    eslint-plugin-jsx-a11y \
    eslint-plugin-prettier \
    eslint-plugin-react \
    eslint-plugin-react-hooks \
    eslint-plugin-testing-library \
    prettier \
    @testing-library/jest-dom \
    @testing-library/user-event \
    @testing-library/react \
    @testing-library/react-hooks \
    @snowpack/plugin-react-refresh \
    @snowpack/plugin-typescript \
    @snowpack/plugin-webpack \
    @types/snowpack-env \
    typescript \

npm i -S react@17 \
    react-dom@17 \


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
