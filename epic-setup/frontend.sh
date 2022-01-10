# openapi-typescript-codegen

openapi --input http://localhost:5000/documentation/json --output ./libs/openapi/src/domain --useUnionTypes --client axios



echo "name: Cypress Tests
on:
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout branch
        uses: actions/checkout@v2

  chrome:
    runs-on: ubuntu-latest
    name: E2E on Chrome
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Cypress run
        uses: cypress-io/github-action@v2
        with:
          command: make eTe URL=https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
          browser: chrome
          headless: true
          config-file: apps/k6i-ui-e2e/cypress.json
          tag: chrome
        env:
          BROWSER: chrome
          CI: true
          URL: https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
          CYPRESS_E2E_ENV: ${{ secrets.CYPRESS_E2E_ENV }}
          CYPRESS_E2E_API_SERVER: ${{ secrets.CYPRESS_E2E_API_SERVER }},
          CYPRESS_E2E_KEYCLOAK_SERVER: ${{ secrets.CYPRESS_E2E_KEYCLOAK_SERVER }}
          CYPRESS_E2E_GRANT_TYPE: ${{ secrets.CYPRESS_E2E_GRANT_TYPE }}
          CYPRESS_E2E_PASSWORD: ${{ secrets.CYPRESS_E2E_PASSWORD }}
          CYPRESS_E2E_USERNAME: ${{ secrets.CYPRESS_E2E_USERNAME }}
          CYPRESS_E2E_CLIENT_ID: ${{ secrets.CYPRESS_E2E_CLIENT_ID }}
          CYPRESS_E2E_CLIENT_SECRET: ${{ secrets.CYPRESS_E2E_CLIENT_SECRET }}
      - name: Upload artifacts on failure
        uses: actions/upload-artifact@v2
        if: failure()
        with:
          name: chrome-screenshots
          path: dist/cypress/apps/k6i-ui-e2e/screenshots
      - name: e2e Chrome Report
        run: |
          make report BROWSER=$BROWSER
      - name: Upload cucumber report
        if: success()
        uses: actions/upload-artifact@v2
        with:
          name: chrome-cucumber-report
          path: apps/k6i-ui-e2e/cucumber-report

  firefox:
    runs-on: ubuntu-latest
    name: E2E on Firefox
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Cypress run
        uses: cypress-io/github-action@v2
        with:
          command: make eTe URL=https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
          browser: firefox
          headless: true
          config-file: apps/k6i-ui-e2e/cypress.json
          tag: firefox
        env:
          BROWSER: firefox
          CI: true
          URL: https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
          CYPRESS_E2E_ENV: ${{ secrets.CYPRESS_E2E_ENV }}
          CYPRESS_E2E_API_SERVER: ${{ secrets.CYPRESS_E2E_API_SERVER }},
          CYPRESS_E2E_KEYCLOAK_SERVER: ${{ secrets.CYPRESS_E2E_KEYCLOAK_SERVER }}
          CYPRESS_E2E_GRANT_TYPE: ${{ secrets.CYPRESS_E2E_GRANT_TYPE }}
          CYPRESS_E2E_PASSWORD: ${{ secrets.CYPRESS_E2E_PASSWORD }}
          CYPRESS_E2E_USERNAME: ${{ secrets.CYPRESS_E2E_USERNAME }}
          CYPRESS_E2E_CLIENT_ID: ${{ secrets.CYPRESS_E2E_CLIENT_ID }}
          CYPRESS_E2E_CLIENT_SECRET: ${{ secrets.CYPRESS_E2E_CLIENT_SECRET }}
      - name: Upload artifacts on failure
        uses: actions/upload-artifact@v2
        if: failure()
        with:
          name: firefox-screenshots
          path: dist/cypress/apps/k6i-ui-e2e/screenshots
      - name: e2e Firefox Report
        run: |
          make report BROWSER=$BROWSER
      - name: Upload cucumber report
        if: success()
        uses: actions/upload-artifact@v2
        with:
          name: firefox-cucumber-report
          path: apps/k6i-ui-e2e/cucumber-report

  edge:
    name: E2E on Edge
    runs-on: windows-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Cypress run
        uses: cypress-io/github-action@v2
        with:
          command: make eTe URL=https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
          browser: edge
          headless: true
          config-file: apps/k6i-ui-e2e/cypress.json
          tag: edge
        env:
          BROWSER: edge
          CI: true
          URL: https://digitalai.k6i-ui-pr${{ github.event.number }}.tpl.digitalai.cloud
          CYPRESS_E2E_ENV: ${{ secrets.CYPRESS_E2E_ENV }}
          CYPRESS_E2E_API_SERVER: ${{ secrets.CYPRESS_E2E_API_SERVER }},
          CYPRESS_E2E_KEYCLOAK_SERVER: ${{ secrets.CYPRESS_E2E_KEYCLOAK_SERVER }}
          CYPRESS_E2E_GRANT_TYPE: ${{ secrets.CYPRESS_E2E_GRANT_TYPE }}
          CYPRESS_E2E_PASSWORD: ${{ secrets.CYPRESS_E2E_PASSWORD }}
          CYPRESS_E2E_USERNAME: ${{ secrets.CYPRESS_E2E_USERNAME }}
          CYPRESS_E2E_CLIENT_ID: ${{ secrets.CYPRESS_E2E_CLIENT_ID }}
          CYPRESS_E2E_CLIENT_SECRET: ${{ secrets.CYPRESS_E2E_CLIENT_SECRET }}
      - name: Upload artifacts on failure
        uses: actions/upload-artifact@v2
        if: failure()
        with:
          name: edge-screenshots
          path: dist/cypress/apps/k6i-ui-e2e/screenshots
      - name: e2e Firefox Report
        run: |
          make report BROWSER=$BROWSER
      - name: Upload cucumber report
        if: success()
        uses: actions/upload-artifact@v2
        with:
          name: edge-cucumber-report
          path: apps/k6i-ui-e2e/cucumber-report">.cypress-workflow.yml


echo "export interface Browser {
  name: string;
  family: string;
  channel: string;
  displayName: string;
  version: string;
  majorVersion: number;
  path: string;
  isHeaded: boolean;
  isHeadless: boolean;
}
"


echo "export interface DataTable {
  rawTable: string[][];
}

export function getNavigationItems(dataTable: DataTable) {
  const values = dataTable.rawTable.slice(1);

  const headings = dataTable.rawTable
    .slice(0, 1)[0]
    .reduce((acc: string[], title: string) => acc.concat(title), []);

  return values.map((current: [string, string], idx: number) => {
    return headings.reduce(
      (acc: { [key: string]: string }, heading: string, index: number) => {
        return (acc[heading] = values[idx][index]), acc;
      },
      {}
    );
  });
}"


echo "/* eslint-disable */
const report = require('multiple-cucumber-html-reporter');
const os = require('os');
const { resolve } = require('path');
const yargs = require('yargs/yargs');
const argv = yargs(process.argv).argv;

const reportPath = argv.DIR
  ? `./apps/k6i-ui-e2e/cucumber-report/${argv.DIR}`
  : './apps/k6i-ui-e2e/cucumber-report';

report.generate({
  jsonDir: resolve(__dirname, './cucumber-json'),
  reportPath: reportPath,
  pageTitle: 'k6ui-e2e',
  reportName: 'k6ui-e2e',
  displayDuration: true,
  displayReportTime: true,
  metadata: {
    browser: {
      name: argv.browser || 'local',
      version: 'latest',
    },
    device: os.hostname(),
    platform: {
      name: process.platform,
      version: process.release.lts,
    },
  },
  customData: {
    title: 'Run info',
    data: [
      { label: 'Project', value: 'Kalamari' },
      { label: 'Release', value: '1.2.3' },
      { label: 'Cycle', value: 'Sprint 16' },
      { label: 'Date', value: new Date() },
    ],
  },
});
"

echo "import cucumber from 'cypress-cucumber-preprocessor';
import * as fs from 'fs';
import { lighthouse, prepareAudit } from 'cypress-audit';
import type { Browser } from './plugin-types';

function urlParse(url: string): string {
  const localUrl = url.split('/').filter(Boolean);
  const match = /^[0-9-a-z( )]+$/g.test(localUrl[1]);
  if (match) {
    localUrl[1] = 'id';
  }
  return `${localUrl.join('-')}`;
}

export default (
  on: Cypress.PluginEvents,
  config: Cypress.PluginConfigOptions
): Cypress.PluginConfigOptions => {
  on(
    'file:preprocessor',
    cucumber({ typescript: require.resolve('typescript') })
  );
  on(
    'before:browser:launch',
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    (browser: Partial<Browser> = {}, launchOptions) => {
      prepareAudit(launchOptions);
    }
  );

  const dirPath = './audit-report';

  on('task', {
    lighthouse: lighthouse(
      (lighthouseReport: {
        lhr: { requestedUrl: string; fetchTime: string };
      }) => {
        const today = new Date();
        let h = today.getHours().toString();
        let m = today.getMinutes().toString();

        if (JSON.parse(h) < 10) h = '0' + h;
        if (JSON.parse(m) < 10) m = '0' + m;
        if (!fs.existsSync(dirPath)) {
          fs.mkdirSync(`${dirPath}/lighthouse`, { recursive: true });
        }

        const name = `${
          new URL(lighthouseReport.lhr.requestedUrl).pathname === '/'
            ? 'home'
            : new URL(lighthouseReport.lhr.requestedUrl).pathname.length >= 3
            ? urlParse(new URL(lighthouseReport.lhr.requestedUrl).pathname)
            : new URL(lighthouseReport.lhr.requestedUrl).pathname.slice(1)
        }-${lighthouseReport.lhr.fetchTime.split('T')[0]}_${h}:${m}`;
        fs.writeFileSync(
          `${dirPath}/lighthouse/${name}.json`,
          JSON.stringify(lighthouseReport.lhr, null, 2)
        );
      }
    ),
  });
  return config;
};"

echo "/* eslint-disable */
const report = require('multiple-cucumber-html-reporter');
const os = require('os');
const { resolve } = require('path');
const yargs = require('yargs/yargs');
const argv = yargs(process.argv).argv;

const reportPath = argv.DIR
  ? `./apps/k6i-ui-e2e/cucumber-report/${argv.DIR}`
  : './apps/k6i-ui-e2e/cucumber-report';

report.generate({
  jsonDir: resolve(__dirname, './cucumber-json'),
  reportPath: reportPath,
  pageTitle: 'k6ui-e2e',
  reportName: 'k6ui-e2e',
  displayDuration: true,
  displayReportTime: true,
  metadata: {
    browser: {
      name: argv.browser || 'local',
      version: 'latest',
    },
    device: os.hostname(),
    platform: {
      name: process.platform,
      version: process.release.lts,
    },
  },
  customData: {
    title: 'Run info',
    data: [
      { label: 'Project', value: 'Kalamari' },
      { label: 'Release', value: '1.2.3' },
      { label: 'Cycle', value: 'Sprint 16' },
      { label: 'Date', value: new Date() },
    ],
  },
});"



echo "ForkTsCheckerWebpackPlugin {
 options: {
   typescript: {
     enabled: true,
     configFile: '/Users/jlong/Development/k6i-ui/apps/k6i-ui/tsconfig.app.json',
     memoryLimit: 2018
   }
 }"


echo "const lighthouseConfig = {
  formFactor: 'desktop',
  screenEmulation: {
    disabled: true,
  },
};
const audits = {
  // seo: 60,
  // pwa: 5,
  performance: 0,
  // accessibility: 50,
  // interactive: 30000,
  // 'first-contentful-paint': 3000,
  'largest-contentful-paint': 40000,
};
    cy.lighthouse(audits, lighthouseConfig);

"


echo "{
  \"$schema\": \"https://on.cypress.io/cypress.schema.json\",
  \"baseUrl\": \"http://localhost:4200\",
  \"viewportWidth\": 1600,
  \"viewportHeight\": 900,
  \"fileServerFolder\": \".\",
  \"fixturesFolder\": \"cypress/fixtures\",
  \"modifyObstructiveCode\": false,
  \"screenshotOnRunFailure\": true,
  \"video\": true,
  \"videosFolder\": \"../../dist/cypress/apps/k6i-ui-e2e/videos\",
  \"screenshotsFolder\": \"../../dist/cypress/apps/k6i-ui-e2e/screenshots\",
  \"chromeWebSecurity\": false,
  \"testFiles\": \"**/*.{feature,features}\",
  \"defaultCommandTimeout\": 60000
}
">./cypress.json

echo "// Snowpack Configuration File
// See all supported options: https://www.snowpack.dev/reference/configuration

/** @type {import(\"snowpack\").SnowpackUserConfig } */
module.exports = {
  mount: {
    /* ... */
  },
  routes: [
    {
      match: 'routes',
      src: '.*',
      dest: '/index.html',
    },
  ],
  plugins: [
    /* ... */
  ],
  packageOptions: {
    external: [
      ...require('module').builtinModules,
      ...Object.keys(require('./package.json').devDependencies),
    ],
  },
  devOptions: {
    /* ... */
  },
  buildOptions: {
    /* ... */
  },
};
">./snowpack.config.js