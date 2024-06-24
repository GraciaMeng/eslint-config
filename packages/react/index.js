module.exports = {
  root: true,
  env: { browser: true, es2020: true },
  extends: [
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    '@mengjx/eslint-config-ts',
  ],
  settings: {
    react: {
      version: '17.0',
    },
  },
  plugins: ['react-refresh'],
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
}
