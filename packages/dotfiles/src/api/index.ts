import execa, { ExecaChildProcess } from "execa"

export default class Api {
  exec(file: string, arguments_: readonly string[]): ExecaChildProcess<string> {
    return execa(file, arguments_, { encoding: "utf8", stdio: "inherit" })
  }
}
