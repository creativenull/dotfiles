import antfu from '@antfu/eslint-config'

export default antfu({
  type: 'module',
  typescript: true,
  formatters: {
    // Use eslint-plugin-format for formatting
    // This avoids needing prettier as a separate tool
  },
  ignores: [
    'node_modules/**',
  ],
})
