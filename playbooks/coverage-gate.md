# Playbook — Coverage gate

Used by phase 05 (QA). Verifies that **added/changed code** is covered by unit tests at ≥ 80%. Whole-codebase coverage is **not** the metric — diff coverage is. A passing build that drops a 20-line uncovered helper into the codebase still fails this gate.

## Threshold

- **≥ 80% line coverage on added/changed lines** in this session's diff.
- Tested-elsewhere code (e.g., type definitions, constants, generated files) may be excluded with explicit notes in `05-qa.md`.

## Tool selection (free / open source)

Pick the one that matches the project. Install if needed and record the choice in `05-qa.md`.

| Language / runtime | Coverage tool | Diff coverage tool |
|---|---|---|
| Python | `coverage` / `pytest-cov` | [`diff-cover`](https://pypi.org/project/diff-cover/) |
| JavaScript / TypeScript | `c8` or `nyc` (Istanbul); Vitest/Jest `--coverage` | `diff-cover` (works on cobertura/lcov output) |
| Go | `go test -cover -coverprofile=cover.out` | `diff-cover` on cobertura-converted output, or `gocover-cobertura` + `diff-cover` |
| Rust | `cargo-llvm-cov` (or `cargo-tarpaulin`) | `diff-cover` on lcov output |
| Java / Kotlin | JaCoCo | `diff-cover` on JaCoCo XML |
| Ruby | `simplecov` | `simplecov-cobertura` + `diff-cover` |

`diff-cover` is the common denominator: it consumes a coverage report (cobertura XML, lcov, or JaCoCo) plus a git diff, and outputs the percentage covered on changed lines.

## Steps

1. **Identify the project's existing coverage tooling** (config files, CI scripts). If something is already configured, use it. Don't add a parallel toolchain.

2. **If no coverage tooling exists**, install the appropriate one above and add minimal config:
   - Generate machine-readable output (cobertura XML or lcov is most portable).
   - Output path: `.coverage.xml` or `coverage/lcov.info` (don't commit; add to `.gitignore` if not already).
   - Ask the user before adding new dev dependencies.

3. **Run the unit test suite with coverage enabled.** Capture the report.

4. **Compute diff coverage** against the merge base of the work branch:

   ```sh
   diff-cover .coverage.xml --compare-branch=origin/main --fail-under=80
   ```

   (Adjust paths and base branch to match the project. Use `git merge-base` if `origin/main` isn't right.)

5. **If < 80%:**
   - Identify uncovered added lines (the report lists them).
   - Add unit tests for the meaningful uncovered branches.
   - Re-run.
   - **Do not** game the metric by adding tests that exercise without asserting. The threshold is a floor, not a finish line.

6. **If a chunk genuinely shouldn't be unit-tested** (UI glue, framework boilerplate, IO at trust boundary covered only by integration tests), document why in `05-qa.md` and exclude it explicitly via the tool's exclusion config — not by lowering the threshold.

7. **Record results** in `05-qa.md`:
   - Tool used
   - Diff coverage percentage
   - Total added/changed lines, total covered lines
   - Any explicit exclusions and rationale

## Exit criteria

- Diff coverage ≥ 80% (or all gaps explicitly justified and approved).
- Coverage report path noted in `05-qa.md`.

## Anti-patterns

- Reporting whole-codebase coverage instead of diff coverage. Easy to game; misses the point.
- Adding tests that achieve coverage without making assertions.
- Excluding files just to clear the threshold. Excludes need a stated reason.
- Lowering the threshold for "this one PR." If 80% isn't right for the project, raise the issue at retrospective; don't bypass mid-session.
