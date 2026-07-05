# CLAUDE.md — {{PROJECT_NAME}}

Self-contained project in Claude's Workshop. `SPEC.md` is the source of truth
for behavior. Build it test-first.

## Setup

Prefer `uv` if available; otherwise use a virtualenv.

```bash
# with uv
uv sync --extra dev        # or: uv pip install -e ".[dev]"
uv run pytest

# without uv
python -m venv .venv && source .venv/bin/activate
pip install -e ".[dev]"
pytest
```

## TDD loop (do this, in order)

1. **Spec:** complete `SPEC.md` from the request. Ask about anything ambiguous
   that changes the design; otherwise choose a default and record it under
   "Decisions".
2. **Red:** turn spec examples and edge cases into tests in `tests/`. Delete the
   placeholder `test_replace_me`. Run `pytest` — tests should fail for the right
   reason.
3. **Green:** implement the minimum in `src/{{PACKAGE_NAME}}/` to pass.
4. **Refactor:** clean up while keeping tests green.
5. **Verify:** run the tool end-to-end the way a user would, not just unit tests.
6. **Document:** fill in `README.md` (install, run, usage example).

## Done when

- [ ] `SPEC.md` complete, decisions recorded
- [ ] `pytest` passes; tests cover happy path, edges, and errors
- [ ] Tool runs end-to-end per the spec
- [ ] `README.md` lets a fresh reader install and use it

## Layout

```
{{PROJECT_NAME}}/
├── SPEC.md                    # what it does (source of truth)
├── README.md                  # how to use it
├── pyproject.toml             # deps + pytest config
├── src/{{PACKAGE_NAME}}/      # implementation
└── tests/                     # test suite
```
