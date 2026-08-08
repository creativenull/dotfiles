import type { ExtensionAPI } from '@earendil-works/pi-coding-agent'
import type { Diagnostic } from 'vscode-languageserver-protocol'
import type { LspManager } from './lsp-manager.js'
import type { DiagnosticsError, DiagnosticsResult } from './types.js'
import { basename, resolve } from 'node:path'
import { Type } from 'typebox'
import { DiagnosticSeverity } from 'vscode-languageserver-protocol'

function formatDiagnostics(result: DiagnosticsResult): string {
  const { server, filePath, diagnostics } = result
  const fileName = basename(filePath)

  if (diagnostics.length === 0) {
    return `No diagnostics for ${fileName} (${server}) ✓`
  }

  const lines: string[] = []
  lines.push(`Diagnostics for ${fileName} (${server}):`)
  lines.push('')

  const sorted = [...diagnostics].sort((a, b) => {
    const sevA = a.severity ?? 4
    const sevB = b.severity ?? 4
    if (sevA !== sevB)
      return sevA - sevB
    return a.range.start.line - b.range.start.line
  })

  for (const diag of sorted) {
    const icon = severityIcon(diag.severity)
    const label = severityLabel(diag.severity)
    const line = diag.range.start.line + 1
    const col = diag.range.start.character + 1
    const code = formatCode(diag)
    lines.push(`  ${icon} ${label} (${line}:${col}): ${diag.message}${code}`)
  }

  lines.push('')

  const errors = diagnostics.filter(d => d.severity === DiagnosticSeverity.Error).length
  const warnings = diagnostics.filter(d => d.severity === DiagnosticSeverity.Warning).length
  const infos = diagnostics.filter(d => d.severity === DiagnosticSeverity.Information).length
  const hints = diagnostics.filter(d => d.severity === DiagnosticSeverity.Hint || !d.severity).length

  const parts: string[] = []
  if (errors > 0)
    parts.push(`${errors} error${errors !== 1 ? 's' : ''}`)
  if (warnings > 0)
    parts.push(`${warnings} warning${warnings !== 1 ? 's' : ''}`)
  if (infos > 0)
    parts.push(`${infos} info`)
  if (hints > 0)
    parts.push(`${hints} hint${hints !== 1 ? 's' : ''}`)

  lines.push(`${diagnostics.length} diagnostic${diagnostics.length !== 1 ? 's' : ''}: ${parts.join(', ')}`)

  return lines.join('\n')
}

function severityIcon(severity?: DiagnosticSeverity): string {
  switch (severity) {
    case DiagnosticSeverity.Error: return '✗'
    case DiagnosticSeverity.Warning: return '⚠'
    case DiagnosticSeverity.Information: return 'ℹ'
    default: return '💡'
  }
}

function severityLabel(severity?: DiagnosticSeverity): string {
  switch (severity) {
    case DiagnosticSeverity.Error: return 'Error'
    case DiagnosticSeverity.Warning: return 'Warning'
    case DiagnosticSeverity.Information: return 'Info'
    default: return 'Hint'
  }
}

function formatCode(diag: Diagnostic): string {
  if (diag.code === undefined || diag.code === null)
    return ''
  if (diag.source)
    return ` [${diag.source}(${diag.code})]`
  return ` [${diag.code}]`
}

export function registerLspTools(pi: ExtensionAPI, manager: LspManager): void {
  pi.registerTool({
    name: 'lsp_diagnostics',
    label: 'LSP Diagnostics',
    description: 'Get compiler/linter diagnostics (errors, warnings, hints) for a file from configured LSP servers. Use after editing files to verify changes did not introduce problems.',
    promptSnippet: 'Get LSP diagnostics (errors, warnings) for a file',
    promptGuidelines: [
      'Use lsp_diagnostics after editing or writing a file to check for compiler errors, type errors, or lint warnings.',
      'Run lsp_diagnostics to verify that code changes did not introduce new problems before declaring a task complete.',
    ],
    parameters: Type.Object({
      filePath: Type.String({
        description: 'Path to the file to check (absolute or relative to working directory)',
      }),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate, ctx) {
      const absolutePath = resolve(ctx.cwd, params.filePath)
      const result = await manager.getDiagnosticsForFile(absolutePath)

      if ('error' in result) {
        return {
          content: [{ type: 'text', text: (result as DiagnosticsError).error }],
          details: {},
          isError: true,
        }
      }

      const diagResult = result as DiagnosticsResult
      const text = formatDiagnostics(diagResult)

      return {
        content: [{ type: 'text', text }],
        details: {
          server: diagResult.server,
          filePath: diagResult.filePath,
          diagnosticCount: diagResult.diagnostics.length,
        },
      }
    },
  })
}
