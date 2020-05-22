import BrewApi from "../../src/api/brew"

describe("brew API", () => {
  describe("cleanup", () => {
    it("executes", async () => {
      expect.assertions(1)
      const brew = new BrewApi()
      const spy = jest.spyOn(brew, "exec").mockImplementation()

      await brew.cleanup()

      expect(spy).toHaveBeenCalledWith("brew", ["cleanup"])
    })
  })

  describe("list", () => {
    it("returns a list of installed packages", async () => {
      expect.assertions(2)
      const brew = new BrewApi()
      const spy = jest.spyOn(brew, "exec")

      spy.mockResolvedValue({
        command: "brew list",
        exitCode: 0,
        failed: false,
        isCanceled: false,
        killed: false,
        timedOut: false,
        stdout: "bash\nfish\nzsh",
        stderr: "",
      })

      const formulas = await brew.list()

      expect(spy).toHaveBeenCalledWith("brew", ["list"])
      expect(formulas).toStrictEqual(["bash", "fish", "zsh"])
    })
  })

  describe("install", () => {
    it("executes", async () => {
      expect.assertions(2)
      const brew = new BrewApi()
      const spy = jest.spyOn(brew, "exec").mockImplementation()

      await brew.install("zsh")
      await brew.install(["bash", "svn"])

      expect(spy).toHaveBeenCalledWith("brew", ["install", "zsh"])
      expect(spy).toHaveBeenCalledWith("brew", ["install", "bash", "svn"])
    })
  })

  describe("uninstall", () => {
    it("executes", async () => {
      expect.assertions(2)
      const brew = new BrewApi()
      const spy = jest.spyOn(brew, "exec").mockImplementation()

      await brew.uninstall("zsh")
      await brew.uninstall(["bash", "svn"])

      expect(spy).toHaveBeenCalledWith("brew", ["uninstall", "zsh"])
      expect(spy).toHaveBeenCalledWith("brew", ["uninstall", "bash", "svn"])
    })
  })

  describe("update", () => {
    it("executes", async () => {
      expect.assertions(1)
      const brew = new BrewApi()
      const spy = jest.spyOn(brew, "exec").mockImplementation()

      await brew.update()

      expect(spy).toHaveBeenCalledWith("brew", ["update"])
    })
  })

  describe("upgrade", () => {
    it("executes without formula", async () => {
      expect.assertions(1)
      const brew = new BrewApi()
      const spy = jest.spyOn(brew, "exec").mockImplementation()

      await brew.upgrade()

      expect(spy).toHaveBeenCalledWith("brew", ["upgrade"])
    })

    it("executes with formula", async () => {
      expect.assertions(1)
      const brew = new BrewApi()
      const spy = jest.spyOn(brew, "exec").mockImplementation()

      await brew.upgrade(["bash", "zsh"])

      expect(spy).toHaveBeenCalledWith("brew", ["upgrade", "bash", "zsh"])
    })
  })
})
