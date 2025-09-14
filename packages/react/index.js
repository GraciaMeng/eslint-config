const { defineConfig } = require('eslint-define-config')
const typescript = require('@mengjx/eslint-config-ts')
const react = require('eslint-plugin-react')
const reactHooks = require('eslint-plugin-react-hooks')
const reactRefresh = require('eslint-plugin-react-refresh')
const typescriptParser = require('@typescript-eslint/parser')

module.exports = defineConfig([
  // 继承 TypeScript 配置
  ...typescript,
  // React 配置
  {
    files: ['**/*.jsx', '**/*.tsx'],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    plugins: {
      react,
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
    },
    settings: {
      react: {
        version: '17.0',
      },
    },
    rules: {
      'jsx-quotes': [
        'error',
        'prefer-double',
      ],
      'react/react-in-jsx-scope': 'off',
      'react-refresh/only-export-components': [
        'warn',
        { allowConstantExport: true },
      ],
      'react/display-name': 'off',
      'react/prop-types': 'off',
    },
  },
])
