import main from "../src"

describe("main", () => {
  it("works", () => {
    expect.assertions(1)

    expect(main()).toBe(true)
  })
})
