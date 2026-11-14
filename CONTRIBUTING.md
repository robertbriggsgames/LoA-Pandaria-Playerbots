# Contributing (robertbriggsgames / LoA-Pandaria-Playerbots)

This fork runs the family MoP realm on `v02uawowmop01p`. It tracks the community playerbots LoA tree and keeps **server-local** changes separate from fixes we can send **upstream**.

Upstream LoA / playerbots do **not** ship a root `CONTRIBUTING.md` today. PR quality here is defined by:

1. This document
2. Existing upstream CI workflows we inherit (must stay green)
3. The pull request template

## Pipeline (required)

```
feature branch  →  PR into main  →  CI green  →  merge  →  fetch main on host  →  rebuild containers from main
```

- **Never** push straight to `main`.
- **Never** rebuild production from a dirty feature branch.
- `main` is branch-protected: required reviews/status checks; no force-push; no direct commits.

### Host loop

```bash
cd /opt/loa/LoA-Pandaria-Playerbots
git fetch origin
git checkout -b cursor/<short-name>-f1d3 origin/main   # or local/<…> / upstream/<…>
# …edit, build/test as needed…
git commit …
git push -u origin HEAD
# open PR → main, wait for CI, merge
git fetch origin && git checkout main && git reset --hard origin/main
cd /opt/loa && sudo docker build -t loa-pandaria:local -f docker/Dockerfile .
# Johnt countdown, then: sudo docker compose up -d --force-recreate --no-deps worldserver
```

## Remotes

| Remote | Repo | Purpose |
| --- | --- | --- |
| `origin` | `robertbriggsgames/LoA-Pandaria-Playerbots` | Our fork — feature branches + `main` |
| `upstream` | `1LineAtaTime/LoA-Pandaria-Playerbots` | Community playerbots LoA (sync / compare) |
| `loa-core` | `Legends-of-Azeroth/Legends-of-Azeroth-Pandaria-5.4.8` | Core without bots — optional pure-core upstream PRs |

Periodic sync (on a throwaway branch first):

```bash
git fetch upstream
git checkout -b sync/upstream-playerbot
git merge upstream/playerbot   # or rebase; resolve; PR into main
```

## Branch naming — isolate local vs upstream-bound work

| Prefix | Use | May PR to community upstream? |
| --- | --- | --- |
| `local/` or `cursor/` with **local** scope | Realm-only behaviour (soft level/Pandaria gate, custom LFG JP/pool, private NPCs, conf knobs) | **No** |
| `upstream/` | Fixes that belong in community LoA / playerbots (e.g. low-level OOC HP regen) | **Yes** — open against `upstream` / `loa-core` after CI on our fork |
| `sync/` | Merging community updates into `main` | N/A |

Tick **`local-mod`** or **`upstream-candidate`** in the PR template (CI enforces). Apply the matching GitHub label when those labels exist (created by the Ensure labels workflow after this pipeline lands on `main`).

### Local-mod examples (do not send upstream)

- Pandaria progress gate / Passage Keeper / XP freeze @85
- Custom Random BC Heroic LFG (checkbox pool, Wrath seal tied to gate, uncapped 5 JP)
- Private NPCs (Ling reagent bank), realm conf rates, grandfather SQL for our characters DB

### Upstream-candidate examples

- Broken low-level out-of-combat HP regen (SkyFire-style `Player::RegenerateHealth`)
- Generic Vehicle SPELLCLICK / temple draft correctness if framed without realm lore
- Crash fixes, wrong scriptnames, retail-accuracy bugs with no realm policy attached

When opening an upstream PR: branch from a clean sync tip, **only** the upstream-worthy commits, no `local/` SQL/conf, and target the correct upstream repo (`1LineAtaTime/…` for bots stack, `Legends-of-Azeroth/…` for core-only).

## CI that must pass (inherited from LoA playerbots)

Non-draft PRs that touch non-`sql/**` paths run:

| Workflow | Job name (status check) | Notes |
| --- | --- | --- |
| `.github/workflows/linux_clang.yml` | **Clang** | Ubuntu 24.04, clang-15, `-DTOOLS=1 -DELUNA=0` |
| `.github/workflows/linux_gcc.yml` | **GCC** | Ubuntu 24.04, g++-13; also used by beta packaging |
| `.github/workflows/macos-arm-build.yml` | macOS build | PR path-ignore `sql/**` |
| `.github/workflows/windows-build-release.yml` | Windows build | PR path-ignore `sql/**` |

Plus this fork’s **Contributing** workflow (PR template + local/upstream isolation).

`sql/**`-only PRs skip the compile matrices (upstream `paths-ignore`). Still require the Contributing gate and a human review.

Draft PRs skip the compile workflows until marked ready (upstream behaviour) — mark ready before merge.

## PR checklist

- [ ] Correct branch prefix / classification (`local-mod` **or** `upstream-candidate`)
- [ ] Description filled from the PR template
- [ ] No secrets, account dumps, or live `worldserver.conf` with passwords
- [ ] Local-mod PRs do not claim upstream readiness
- [ ] Upstream-candidate PRs do not include gate/LFG/private NPC/conf-only realm policy
- [ ] CI green on `main` before merge; production rebuild only from `origin/main`

## License

GPL-2.0 — see `COPYING.md` / `THANKS.md`.
