import process from 'node:process'

let notificationId = 0

export function notifyOSC777(title: string, body: string): void {
  process.stdout.write(`\x1B]777;notify;${title};${body}\x07`)
}

/**
 * Send a notification via Kitty's OSC 99 sequence.
 * Uses incrementing IDs and d=1 (done) so notifications stack instead of replacing.
 * Two-part sequence: title with d=0 (in-progress), body with d=1 (done, triggers display).
 */
export function notifyOSC99(title: string, body: string): void {
  notificationId++
  const id = notificationId
  process.stdout.write(`\x1B]99;i=${id}:d=0;${title}\x1B\\`)
  process.stdout.write(`\x1B]99;i=${id}:d=1:p=body;${body}\x1B\\`)
}

export function notify(title: string, body: string): void {
  if (process.env.KITTY_WINDOW_ID) {
    notifyOSC99(title, body)
  }
  else {
    notifyOSC777(title, body)
  }
}
