# CLAUDE.md — Claude's Workshop

This repository is a **workshop**: a home for many small, independent tools and
projects that Claude builds on request. The workflow is meant to be simple for
the human:

> "Hey Claude, build me a tool that does X, Y, and Z. Here's how I want it. Go."

...and you come back to a **completed, tested, runnable artifact** living in its
own directory.

Your job is to turn a loose request into a self-contained project by following
the TDD workflow below. Do not cut corners on tests — the tests *are* the
deliverable's proof of correctness.

---

## The one rule

**Every project is fully self-contained inside `projects/<project-name>/`.**

- No project imports from, or depends on, another project.
- All of a project's dependencies, tests, docs, and config live in its own directory.
- The root of the repo holds only shared scaffolding (this file, `scripts/`,
  `templates/`), never project code.

This keeps each tool independently testable, movable, and deletable — like
separate experiments in a research repo.

---

## Repository layout

```
claudes-workshop/
├── CLAUDE.md              # you are here — the build workflow
├── README.md
├── scripts/
│   └── new-project.sh     # scaffolds a new project from a template
├── templates/
│   └── python/            # project template(s) — copied per new project
└── projects/
    ├── some-tool/         # each built tool/project lives in its own dir
    └── another-tool/
```

---

## Starting a new project

From the repo root, run the scaffolding script. It copies a template into
`projects/<name>/` and fills in the name:

```bash
./scripts/new-project.sh <project-name> [template]
# template defaults to "python"; run with -h to list available templates
```

Example:

```bash
./scripts/new-project.sh url-shortener
```

This creates `projects/url-shortener/` with a `SPEC.md`, a `CLAUDE.md`, a test
suite, and source layout ready for TDD. **Then `cd` into that directory and do
all further work there** — the project's own `CLAUDE.md` drives the build.

If no template fits the request (e.g. a different language), create the
directory by hand under `projects/<name>/` following the same shape: `SPEC.md`,
`CLAUDE.md`, source, tests, dependency manifest, `README.md`. Consider adding a
reusable template under `templates/` if you'll want it again.

---

## The build workflow (test-driven)

Follow these phases **in order** for every project. Do not write implementation
code before there is a failing test that demands it.

1. **Spec.** Write the request into the project's `SPEC.md`: what the tool does,
   its inputs/outputs, the CLI/API surface, and concrete examples. If the
   request is ambiguous on something that changes the design, ask the human
   before building; otherwise pick a sensible default and record it in the spec.

2. **Red — write failing tests first.** Translate the spec's examples and edge
   cases into tests. Run them; they must fail (or error) for the right reason.
   Cover the happy path, boundaries, and error handling.

3. **Green — implement minimally.** Write the least code needed to make the
   tests pass. Run the suite until it's green.

4. **Refactor.** Clean up names, structure, and duplication with the tests still
   green. Re-run after each change.

5. **Verify end-to-end.** Actually run the tool the way the user will (CLI
   invocation, function call, etc.), not just the unit tests. Confirm it behaves
   as the spec describes.

6. **Document.** Fill in the project `README.md`: what it is, how to install,
   how to run, and a real usage example. Anyone should be able to use it from
   the README alone.

### Definition of done

A project is done only when **all** of these hold:

- [ ] `SPEC.md` describes the tool and every design decision made.
- [ ] The full test suite passes locally.
- [ ] Tests meaningfully cover the happy path, edge cases, and errors.
- [ ] The tool runs end-to-end as specified.
- [ ] `README.md` lets a fresh reader install, run, and use it.
- [ ] Everything lives under `projects/<name>/` with no cross-project coupling.

---

## Conventions

- **Naming:** project directories are `kebab-case` (`csv-diff`, `pdf-merger`).
  Python packages derived from them use `snake_case`.
- **Python default:** `pyproject.toml` + `pytest`. Prefer `uv` when available
  (`uv run pytest`), fall back to a virtualenv + `pip install -e .`.
- **Small commits:** commit at meaningful checkpoints (spec, red, green,
  refactor, docs) with clear messages, rather than one giant commit.
- **Tests are non-negotiable.** If you find yourself wanting to skip a test to
  "save time," write the test.

## Don'ts

- Don't put project code at the repo root.
- Don't share dependencies or imports across projects.
- Don't implement before there's a failing test.
- Don't declare a project done with failing, skipped, or missing tests.
