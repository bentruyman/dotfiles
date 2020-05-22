import { ExecaChildProcess } from "execa"

import Api from "."

const BREW_BIN = "brew"
const NEWLINE = "\n"

export default class BrewApi extends Api {
  cleanup(): ExecaChildProcess {
    return this.exec(BREW_BIN, ["cleanup"])
  }

  install(formula: string | string[]): ExecaChildProcess {
    return this.exec(BREW_BIN, ["install", ...toArray(formula)])
  }

  async list(): Promise<string[]> {
    const { stdout } = await this.exec(BREW_BIN, ["list"])

    return stdout.split(NEWLINE)
  }

  update(): ExecaChildProcess {
    return this.exec(BREW_BIN, ["update"])
  }

  upgrade(formulas: string[] = []): ExecaChildProcess {
    return this.exec(BREW_BIN, ["upgrade", ...formulas])
  }

  uninstall(formula: string | string[]): ExecaChildProcess {
    return this.exec(BREW_BIN, ["uninstall", ...toArray(formula)])
  }
}

function toArray<T>(items: T | T[]): T[] {
  return Array.isArray(items) ? items : [items]
}
