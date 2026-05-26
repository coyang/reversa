#!/usr/bin/env node

import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import chalk from 'chalk';
import { clearTerminalForLogo, renderReversaLogo } from '../lib/utils/banner.js';

const __dirname = dirname(fileURLToPath(import.meta.url));
const pkg = JSON.parse(readFileSync(join(__dirname, '../package.json'), 'utf8'));

const [,, command, ...args] = process.argv;

const commands = {
  install:            () => import('../lib/commands/install.js'),
  update:             () => import('../lib/commands/update.js'),
  status:             () => import('../lib/commands/status.js'),
  uninstall:          () => import('../lib/commands/uninstall.js'),
  'add-agent':        () => import('../lib/commands/add-agent.js'),
  'add-engine':       () => import('../lib/commands/add-engine.js'),
  'export-diagrams':  () => import('../lib/commands/export-diagrams.js'),
};

if (!command || command === '--help' || command === '-h') {
  clearTerminalForLogo();
  console.log(renderReversaLogo(chalk) + `

  reversa v${pkg.version}

  Usage: npx reversa <command>

  Commands:
    install            在当前项目中安装 Reversa
    update             更新 agent 到最新版本
    status             查看当前分析状态
    uninstall          从项目中移除 Reversa
    add-agent          添加 agent 到项目
    add-engine         添加引擎支持
    export-diagrams    导出 Mermaid 图为 SVG/PNG
                       选项: --format=svg|png  --output=<文件夹>
                       需要安装: npm install -g @mermaid-js/mermaid-cli

  Documentation: https://github.com/sandeco/reversa
  `);
  process.exit(0);
}

if (command === '--version' || command === '-v') {
  console.log(pkg.version);
  process.exit(0);
}

if (!commands[command]) {
  console.error(`\n  未知命令: "${command}"`);
  console.error('  运行 "npx reversa --help" 查看可用命令。\n');
  process.exit(1);
}

const mod = await commands[command]();
await mod.default(args);
