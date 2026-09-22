
# Base (base)

A general-purpose devcontainer template using this repo's own base image (fish, vim, uv, starship, prek, opencode)

## What it brings

This template uses this repo's own published base image (`ghcr.io/mmartinortiz/devcontainer-images/base`), which already includes:

- [Fish shell](https://fishshell.com/), set as the default shell
- [vim](https://www.vim.org/), with line numbers, wrapped text, and a blinking bar cursor in insert mode
- [uv / uvx](https://docs.astral.sh/uv/), with fish completions
- [Starship](https://starship.rs/) prompt
- [prek](https://github.com/j178/prek), with fish completions
- [opencode](https://opencode.ai)

It ships with an empty `features` block in `.devcontainer/devcontainer.json`, ready for you to add whatever language or runtime [Features](https://containers.dev/features) your project needs.

## Using this template for a new project

Create a directory for your project.

```bash
mkdir myproject && cd myproject
```

Apply the template using the devcontainer-cli. This will download this template and save it locally, you will need to have installed the [devcontainer-cli](https://github.com/devcontainers/cli). If you do not have it or do not want to install it, just download the `.devcontainer` folder and its content into your project's root folder.

```bash
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/base
```

Use an IDE with Devcontainers support like VS Code. VS Code will ask you to reopen the project in the container, click on the button and the devcontainer will be built. This template is a starting point, from here, modify the `.devcontainer/devcontainer.json` file to fit your project's needs (add Features, customizations, etc).

```bash
code .
```

## Using this template on an existing project

If you have an existing project, you can use this template to add the devcontainer to it. Just copy the `.devcontainer` folder and its content into your project's root folder or use the `devcontainer` cli.

```bash
devcontainer templates apply --template-id ghcr.io/mmartinortiz/devcontainer-templates/base
```


---

_Note: This file was auto-generated from the [devcontainer-template.json](https://github.com/mmartinortiz/devcontainer-templates/blob/main/src/base/devcontainer-template.json).  Add additional notes to a `NOTES.md`._
