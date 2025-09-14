# @mengjx/eslint-config

[![npm](https://img.shields.io/npm/v/@mengjx/eslint-config.svg)](https://npmjs.com/package/@mengjx/eslint-config)

**Now supports ESLint v9.0+ with Flat Config!**

- Single quotes, no semi
- Auto fix for formatting (aimed to be used standalone without Prettier)
- Designed to work with TypeScript, Vue, React out-of-box
- Lint also for json, yaml, markdown
- Sorted imports, dangling commas for cleaner commit diff
- Reasonable defaults, best practices, only one-line of config
- **Now using ESLint 9's new Flat Config format**

## Requirements

- **ESLint 9.0+** (uses new Flat Config format)
- Node.js 18+

## Usage

### Install

```bash
pnpm add -D eslint @mengjx/eslint-config
```

### Config `eslint.config.js` (ESLint 9 Flat Config)

```javascript
// eslint.config.js
import config from '@mengjx/eslint-config'

export default config
```

Or for CommonJS:

```javascript
// eslint.config.js
const config = require('@mengjx/eslint-config')

module.exports = config
```

### Legacy `.eslintrc` format (Not recommended)

If you must use legacy format, you'll need ESLint 8.x:

```json
{
  "extends": "@mengjx"
}
```

> You don't need `.eslintignore` as ignore patterns are included in the config.

### Customization

Since this config returns an array (Flat Config format), you can easily extend it:

```javascript
// eslint.config.js
import mengjxConfig from '@mengjx/eslint-config'

export default [
  ...mengjxConfig,
  // your custom config
  {
    rules: {
      // override rules here
    }
  }
]
```

### Add script for package.json

For example:

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix"
  }
}
```

### Config VS Code auto fix

Create `.vscode/settings.json`

```json
{
  "prettier.enable": false,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

## Available Configs

### `@mengjx/eslint-config` (All-in-one)
Includes configs for Vue and React

### `@mengjx/eslint-config-basic`
Basic ESLint rules, JavaScript support

### `@mengjx/eslint-config-ts`
Basic + TypeScript support

### `@mengjx/eslint-config-vue`
TypeScript + Vue 3 support

### `@mengjx/eslint-config-react`
TypeScript + React support

## Migration from v0.x (ESLint 8)

1. Update ESLint to v9:
   ```bash
   pnpm update eslint@^9.0.0
   ```

2. Replace `.eslintrc.*` with `eslint.config.js`:
   ```javascript
   // eslint.config.js
   import config from '@mengjx/eslint-config'
   
   export default config
   ```

3. Update your npm scripts (remove config flags):
   ```json
   {
     "scripts": {
       "lint": "eslint .",
       "lint:fix": "eslint . --fix"
     }
   }
   ```
