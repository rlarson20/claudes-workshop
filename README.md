# claudes-workshop

A repo I use for tools I want Claude to build. Each tool/project lives in its
own self-contained directory under `projects/`, built test-first.

## How it works

Tell Claude what you want:

> "Build me a tool that does X, Y, and Z. Here's how I want it. Go."

Claude scaffolds a new project, writes a spec, drives it with TDD, and leaves
you a completed, tested, runnable artifact in `projects/<name>/`.

See [CLAUDE.md](./CLAUDE.md) for the full workflow.

## Start a new project

```bash
./scripts/new-project.sh <project-name>   # e.g. csv-diff  (defaults to python)
./scripts/new-project.sh -h               # options + available templates
```

## Layout

```
claudes-workshop/
├── CLAUDE.md          # the build workflow Claude follows
├── scripts/           # new-project.sh scaffolder
├── templates/         # per-language project templates
└── projects/          # each built tool, self-contained
```
