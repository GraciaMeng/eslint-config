const { defineConfig } = require('eslint-define-config')
const vue = require('@mengjx/eslint-config-vue')
const react = require('@mengjx/eslint-config-react')

module.exports = defineConfig([
  // 继承 Vue 和 React 配置
  ...vue,
  ...react,
])
