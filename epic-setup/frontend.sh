# openapi-typescript-codegen

openapi --input http://localhost:5000/documentation/json --output ./libs/openapi/src/domain --useUnionTypes --client axios



echo "name: Cypress Tests
# on:
#   pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout branch
        uses: actions/checkout@v2

      - name: Install and build UI
        uses: cypress-io/github-action@v2
        with:
          runTests: false
          build: npm run build
          config-file: apps/k6i-ui-e2e/cypress.json

  chrome:
    runs-on: ubuntu-latest
    name: E2E on Chrome

    steps:
      - uses: actions/checkout@v2
      - uses: cypress-io/github-action@v2
        with:
          start: npm start
          command: npm run cy:headless
          browser: chrome
          headless: true
          config-file: apps/k6i-ui-e2e/cypress.json
        env:
          BROWSER: chrome
      - name: e2e Chrome Report
        run: |
          node ./apps/k6i-ui-e2e/cypress/cucumber-report.js --browser $BROWSER --DIR $BROWSER

  firefox:
    runs-on: ubuntu-latest
    name: E2E on Firefox

    steps:
      - uses: actions/checkout@v2
      - uses: cypress-io/github-action@v2
        with:
          start: npm start
          command: npm run cy:headless
          browser: firefox
          headless: true
          config-file: apps/k6i-ui-e2e/cypress.json
        env:
          BROWSER: firefox
      - name: e2e Firefox Report
        run: |
          node ./apps/k6i-ui-e2e/cypress/cucumber-report.js --browser $BROWSER --DIR $BROWSER

  edge:
    name: E2E on Edge
    runs-on: windows-latest

    steps:
      - uses: actions/checkout@v2
      - uses: cypress-io/github-action@v2
        with:
          start: npm start
          command: npm run cy:headless
          browser: edge
          headless: true
          config-file: apps/k6i-ui-e2e/cypress.json
        env:
          BROWSER: edge
      - name: e2e Edge Report
        run: |
          node ./apps/k6i-ui-e2e/cypress/cucumber-report.js --browser $BROWSER --DIR $BROWSER
"



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