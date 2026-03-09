# Subagent: git-history-analyzer

## Purpose
Analyze git history since a given date to produce a structured summary of commits, changed files, and diff statistics that downstream subagents (autogen-detector, manifest-change-analyzer) can consume.

## Used By
- manifest-update (Flow A — Git-based, Step A1-A2)
- rules-update (Flow A — Git-based, Step 1)

## Tools Available
- Bash (git commands only)
- Read

## Input
From orchestrator:
- `project_root` (string) — absolute path to project root
- `since_date` (string) — ISO 8601 date from manifest's `last_updated` field (e.g., `"2024-11-15"`)

## Output
Return to orchestrator:
- `period` (object) — `{ from, to, days }`
- `commit_count` (number) — total commits in the period
- `commits` (array) — list of commit summaries
- `file_changes` (object) — categorized file lists
- `diff_stats` (object) — insertions, deletions, files changed
- `warnings` (array) — edge cases surfaced upstream

Each `commits[]` item:
```json
{
  "hash": "a1b2c3d",
  "date": "2024-11-20",
  "message": "feat: add payment module",
  "files_touched": 5
}
```

`file_changes` structure:
```json
{
  "added": ["src/features/payments/index.ts", "src/features/payments/service.ts"],
  "modified": ["src/routes/api.ts", "package.json"],
  "deleted": ["src/utils/deprecated-helper.ts"],
  "renamed": [
    { "from": "src/old-name.ts", "to": "src/new-name.ts" }
  ]
}
```

## Instructions
You are the git history specialist. Extract a clean, deduplicated change summary from git. Focus on structural changes (new files, deleted files, renamed files) over line-by-line diffs. Keep output compact for downstream consumption.

### 1) Validation
- Verify `.git` directory exists at `project_root`. If not, return an empty result with a warning: `"No .git directory found"`.
- Verify `since_date` is a valid date. If the date is in the future, warn and use 30 days ago as fallback.

### 2) Git Commands to Execute

**Find baseline commit:**
```bash
git rev-list -n1 --before="<since_date>" HEAD
```
- If no commit exists before that date (brand-new repo), use the initial commit as baseline.
- Store as `$BASE_COMMIT`.

**Get commit count:**
```bash
git rev-list --count $BASE_COMMIT..HEAD
```

**Get commit list (compact):**
```bash
git log --oneline --format="%h %ad %s" --date=short $BASE_COMMIT..HEAD
```
- Parse each line into `{ hash, date, message }`.
- Cap at 200 commits. If more, add a warning with total count and note that only the latest 200 are listed.

**Get file change summary:**
```bash
git diff --name-status $BASE_COMMIT..HEAD
```
- Parse output: `A` → added, `M` → modified, `D` → deleted, `R###` → renamed (with similarity percentage).
- Use `--no-renames` only if rename detection causes issues.

**Get diff statistics:**
```bash
git diff --stat $BASE_COMMIT..HEAD | tail -1
```
- Parse: `X files changed, Y insertions(+), Z deletions(-)`.

**Get files touched per commit (for commit details):**
```bash
git log --oneline --stat $BASE_COMMIT..HEAD
```
- Extract `files_touched` count per commit. Keep lightweight — don't capture per-file details here.

### 3) Deduplication
- A file that was added and then modified multiple times should appear ONLY in `added` (not also in `modified`).
- A file that was added and then deleted should appear in NEITHER list (net zero change).
- A file that was modified and then deleted should appear ONLY in `deleted`.
- A renamed file should appear in `renamed`, NOT in both `added` and `deleted`.

### 4) Path Normalization
- All paths should be relative to `project_root`.
- Remove leading `./` if present.
- Use forward slashes consistently.

### 5) Edge Cases
- **Merge commits:** Include them in count but don't double-count file changes (the `$BASE_COMMIT..HEAD` diff handles this automatically).
- **Empty period:** If `commit_count` is 0, return empty file changes and a note: `"No commits found since <since_date>"`.
- **Binary files:** Include in file lists but note in warnings if large binaries were added (> 1MB).
- **Submodules:** Flag submodule changes in warnings, don't recurse into them.

### 6) Output Size Limits
- `commits` array: max 200 entries.
- `file_changes` arrays: no limit (downstream filtering handles this).
- `warnings`: max 10 entries.

## Example Output
```json
{
  "period": {
    "from": "2024-11-15",
    "to": "2024-11-25",
    "days": 10
  },
  "commit_count": 15,
  "commits": [
    {
      "hash": "f3a9c21",
      "date": "2024-11-25",
      "message": "feat: add notification service",
      "files_touched": 4
    },
    {
      "hash": "b8d4e17",
      "date": "2024-11-23",
      "message": "feat: implement payment flow",
      "files_touched": 7
    },
    {
      "hash": "c2a1d09",
      "date": "2024-11-18",
      "message": "fix: auth token refresh",
      "files_touched": 2
    }
  ],
  "file_changes": {
    "added": [
      "src/features/payments/PaymentForm.tsx",
      "src/features/payments/paymentService.ts",
      "src/services/notifications.ts"
    ],
    "modified": [
      "src/routes/api.ts",
      "src/services/auth.ts",
      "package.json"
    ],
    "deleted": [
      "src/utils/deprecated-helper.ts"
    ],
    "renamed": [
      { "from": "src/config/old-config.ts", "to": "src/config/app-config.ts" }
    ]
  },
  "diff_stats": {
    "files_changed": 12,
    "insertions": 847,
    "deletions": 123
  },
  "warnings": [
    "Monorepo detected: commits span apps/web and apps/api."
  ]
}
```
