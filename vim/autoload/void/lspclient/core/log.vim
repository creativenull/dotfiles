vim9script

# Logger to handle messages from the LSP server/client to the user. Logs to
# :messages and a log file.

const echoPrefix = '[VOID_LSPCLIENT]'
const logFilepath = expand('~/.cache/vim/void/lspclient.log')
const level = {
  ERROR: 'ERROR',
  DEBUG: 'DEBUG',
  INFO: 'INFO',
}

# Get the current timestamp format for logfiles
def GetTime(): string
  return strftime('%Y-%m-%d %T')
enddef

# Ensure logfile is created to be written into
def EnsureLogFile(): void
  const dirpath = fnamemodify(logFilepath, ':h')

  if !filereadable(logFilepath)
    execute printf('!mkdir -p %s', dirpath)
    execute printf('!touch %s', logFilepath)
  endif
enddef

# Write infomation to the logfile
def WriteLogFile(msg: string): void
  writefile([msg], logFilepath, 'a')
enddef

# Generic format for messages to be logged as
def Render(levelType: string, msg: string): string
  return printf('%s: %s', levelType, msg)
enddef

# Logs to be printed to :messages
def Print(levelType: string, msg: string): void
  echom printf('%s %s', echoPrefix, Render(levelType, msg))
enddef

# Log to be writted to logfiles
def Log(levelType: string, msg: string): void
  EnsureLogFile()
  WriteLogFile(printf('[%s] %s', GetTime(), Render(levelType, msg)))
enddef

# Debug Functions
# ---
export const Debug = (msg: string): string => Render(level.DEBUG, msg)
export const PrintDebug = (msg: string): void => {
  Print(level.DEBUG, msg)
}
export const LogDebug = (msg: string): void => {
  Log(level.DEBUG, msg)
}

# Info Functions
# ---
export const Info = (msg: string): string => Render(level.INFO, msg)
export const PrintInfo = (msg: string): void => {
  Print(level.INFO, msg)
}
export const LogInfo = (msg: string): void => {
  Log(level.INFO, msg)
}

# Error Functions
# ---
export const Error = (msg: string): string => Render(level.ERROR, msg)
export const PrintError = (msg: string): void => {
  Print(level.ERROR, msg)
}
export const LogError = (msg: string): void => {
  Log(level.ERROR, msg)
}
