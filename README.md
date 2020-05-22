# dotfiles

[![CircleCI](https://circleci.com/gh/bentruyman/dotfiles/tree/node-rewrite.svg?style=svg)](https://circleci.com/gh/bentruyman/dotfiles/tree/node-rewrite)

```console
$ npx @bentruyman/dotfiles install <plugin|preset>
```

## API

### Plugin

```typescript
interface IConfig {
  shell: string;
}

export function firstTime(api: PluginApi<IConfig>) {
  const shell = await api.prompt({
    type: "list",
    message: "Which shell would you like to use?",
    choices: ["bash", "fish", "zsh"]
  });

  api.config.set("shell", shell);
}
export function install(api: PluginApi) {}
export function update(api: PluginApi) {}
```

```typescript
const shell = await api.prompt({
  type: "list",
  message: "Which shell would you like to use?",
  choices: ["bash", "fish", "zsh"]
});

await api.brew.update();
await api.brew.upgrade();
await api.brew.install(shell);
await api.brew.uninstall(["python", "svn"]);
await api.brew.cleanup();

await api.config("shell", shell);
await api.config("shell");

api.env.isMacOs();
api.env.isUbuntu();

await api.defaults.write("NSGlobalDomain", "AppleKeyboardUIMode", 2);
await api.defaults.write("NSGlobalDomain", "AppleFontSmoothing", 2);
await api.defaults.write("NSGlobalDomain", "NSUserDictionaryReplacementItems", [
  {
    on: 1,
    replace: "omw",
    with: "On my way!"
  },
  {
    on: 1,
    replace: "omw",
    with: "On my way"
  }
]);

const { stdout, stderr } = await api.shell("echo 'Hello World!'");
```

### Preset

```typescript
export const plugins = {
  "@bentruyman/dotfiles-plugin": "^1.0.0",
  "dotfiles-plugin-zsh": "^1.0.0"
};
```
