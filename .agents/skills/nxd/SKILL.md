---
name: nxd
description: >-
  Runs Node.js and npm via the `nxd;` PowerShell function (fnm env, then pin
  Node v22.12). Use when running npm, node, npx, or npm scripts in the agent
  terminal, or when node is not found in PATH.
---

# Node (fnm via nxd)

`nxd;` = PowerShell function: `fnm env --use-on-cd --shell powershell`, then `fnm use v22.12`.
Use: `nxd; npm [script]` / `nxd; npx …`

If `nxd` is not defined in the shell, dot-source it and then call it:

```powershell
. "$env:USERPROFILE\Documents\LINKS\@my-config\shell\nxd.ps1"
nxd
```
