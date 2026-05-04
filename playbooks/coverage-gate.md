# Playbook — Coverage gate

Used by phase 05 (QA). Verifies that **added/changed code** is covered by unit tests at the project's configured threshold (default ≥ 80%). Whole-codebase coverage is **not** the metric — diff coverage is.

## Configuration (read first)

Before doing anything else, read the project's `.ai-sdlc.yaml` (at the project root, alongside `.ai-sdlc/`). Honor its `gates.coverage` section:

- `enabled: true` (default) → run the gate as a hard exit-criterion.
- `enabled: false` → skip entirely. Record `skipped (disabled by .ai-sdlc.yaml)` in `05-qa.md` and continue.
- `enabled: manual` → do **not** auto-run. The agent runs it only when the user explicitly asks ("run the coverage gate"). When skipped, record `skipped (manual mode; not invoked this run)`.
- `threshold: <N>` → use `<N>` instead of 80.

If `.ai-sdlc.yaml` doesn't exist, defaults apply (enabled, threshold 80).

## Step 1 — Detect the project language and existing tooling

**Do this before suggesting any tool.** The wrong default — running a Python tool in a Go repo — is worse than no gate.

1. Detect the primary language by looking at the project root:
   - `go.mod` → Go
   - `package.json` → JS/TS (also check for `vitest.config.*`, `jest.config.*`)
   - `pyproject.toml` / `setup.py` / `requirements*.txt` → Python
   - `Cargo.toml` → Rust
   - `pom.xml` / `build.gradle*` → JVM (Java/Kotlin/Scala)
   - `Gemfile` → Ruby
   - mixed/none → ask the user before proceeding

2. Look for existing coverage tooling: scan CI configs, `Makefile`, `package.json` scripts, `pyproject.toml` `[tool.coverage]` sections, etc. **If something is already configured, use that.** Don't add a parallel toolchain.

## Step 2 — Pick a coverage tool (language-first)

Prefer the language's native coverage tooling. Only reach for `diff-cover` when Python is already present in the project — `diff-cover` is a Python tool and pulling Python into a non-Python repo is friction the gate doesn't justify.

| Language | Native coverage | Native diff-coverage option | Fallback (only if Python is already a project dep) |
|---|---|---|---|
| Python | `coverage` / `pytest-cov` | `diff-cover` (already Python) | — |
| JS / TS | `c8`, `nyc`, Vitest/Jest `--coverage` | [`monocart`](https://github.com/cenfun/monocart-coverage-reports) v2+ supports diff-coverage; or compute against `git diff` from lcov manually | `diff-cover` over lcov |
| Go | `go test -cover -coverprofile` | Compute diff coverage from the coverprofile + `git diff --unified=0`. A small awk/jq script suffices; do **not** install Python for this. | `gocover-cobertura` + `diff-cover` (only if project already uses Python tooling, e.g. ML/data tooling alongside Go) |
| Rust | `cargo-llvm-cov` (`--lcov`) or `cargo-tarpaulin` | Compute from lcov + `git diff` | `diff-cover` over lcov (only if Python is already present) |
| Java / Kotlin | JaCoCo | [`diff-line-coverage` Gradle plugin](https://plugins.gradle.org/) or compute from JaCoCo XML | `diff-cover` over JaCoCo XML (only if Python is already present) |
| Ruby | `simplecov` | `simplecov-cobertura` + small ruby script over `git diff` | `diff-cover` (only if Python is already present) |

**Rule of thumb:** if the repo's lockfile / dependency manifest doesn't already include Python, do **not** install Python or `diff-cover`. Compute diff coverage natively or ask the user how to proceed.

## Step 3 — Run

1. Run unit tests with coverage enabled, emit a machine-readable report (cobertura XML or lcov).
2. Compute diff coverage on lines added/changed since the merge base of the work branch (`git merge-base HEAD origin/main` — or whatever base branch the project uses).
3. If a chunk genuinely shouldn't be unit-tested (UI glue, IO at boundary covered by integration tests only), exclude it via the tool's exclusion config and document why in `05-qa.md`.

## Step 4 — Decide

- **≥ threshold** → record results, advance.
- **< threshold** → identify uncovered added lines, add tests for the meaningful uncovered branches, re-run. Don't game the metric (assertion-less tests, broad excludes, threshold lowering).

## Step 5 — Record

In `05-qa.md`, record:

- Detected language and tool selected
- Whether the gate ran, was disabled, or was in manual-mode-not-invoked
- Threshold used and diff coverage percentage achieved
- Total added/changed lines, total covered lines
- Any explicit exclusions and rationale

## Exit criteria

- Diff coverage ≥ threshold (when `enabled: true`), or
- Gate skipped per `.ai-sdlc.yaml` (`enabled: false` or `manual` and not invoked) with reason recorded.

## Anti-patterns

- Pulling Python into a non-Python repo just to run `diff-cover`. Use language-native tooling.
- Reporting whole-codebase coverage instead of diff coverage.
- Tests that achieve coverage without making assertions.
- Lowering the threshold for "this one PR." If the threshold is wrong for the project, raise it at retrospective; don't bypass mid-session.
- Excluding files just to clear the bar. Excludes need a stated reason.
