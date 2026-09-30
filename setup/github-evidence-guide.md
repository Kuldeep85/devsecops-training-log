# GitHub evidence guide: what, when and how to push

Recruiters can open your GitHub in a minute. The goal is honest, tidy, verifiable evidence of real work.

## What to save (and where)
| What | Where | Public? |
|---|---|---|
| Daily practice notes | day file's **My notes** section | Yes |
| Scripts, Dockerfiles, YAML, Terraform you wrote | `labs/day-NN/` | Yes |
| Weekly summaries | `notes/week-NN-summary.md` | Yes |
| Interview answers | `interview/` | Yes (or keep private) |
| Main project | separate repo `devsecops-pipeline-lab` | Yes |
| Screenshots of your **own** lab pipelines | `evidence/` or `labs/day-NN/` | Yes, after checking |
| Your CV | keep locally, do not commit to a public repo | No |

## What must NEVER go to GitHub
- Anything from **client projects**: pipeline YAML, repository names, project names, URLs, server addresses, database contents, screenshots of Azure DevOps or OpenShift showing client data. Your own Azure DevOps organisation screenshot with client projects visible must not be published.
- Tokens, passwords, keys, `oc login` commands, `.env` files, kubeconfig files, Terraform state files.
- Your employer's internal documents or code.
- Real personal data (phone numbers, ID numbers).

`tools/finish-day.sh` runs gitleaks before every commit, but scanners cannot recognise client confidentiality. That part is your judgement.

## Screenshot checklist (before saving any screenshot)
1. Are any client names, project names or URLs visible? Crop or don't use it.
2. Is any token, subscription ID or email visible? Crop or blur.
3. Is it clearly from **your own** personal lab? If unsure, don't publish it.

## When to commit and push
| When | What |
|---|---|
| **Every practice day** | one commit: `Day NN: short description`, then push (use `tools/finish-day.sh`) |
| **Every Saturday** | write `notes/week-NN-summary.md` (5–8 lines: learned, struggled, next week), commit, push |
| **After each project phase** (Week 6) | commit per fix with a clear message; open a pull request for the fixes |
| **End of Week 8** | polish READMEs, pin repos, write the project story |
| **End of Week 11** | final polish; add the GitHub link to CV and LinkedIn |

Push at least once a week even if you miss days. Small, regular commits look far better than one huge upload.

## How to commit and push (daily routine)
```bash
cd ~/repos/devsecops-training-log
tools/finish-day.sh 07 "bash conditionals and loops"
```
The script scans for secrets (once gitleaks is installed on Day 12), stages everything, commits with the message `Day 07: bash conditionals and loops`, and pushes.

The manual version, so you understand it:
```bash
git status
git add -A
git commit -m "Day 07: bash conditionals and loops"
git push
```

## Weekly tag (a neat marker for recruiters)
```bash
git tag -a week-03-complete -m "Week 3 complete: Git deep-dive and Docker basics"
git push origin week-03-complete
```

## Good commit messages
Start with a verb, say what and why in one line: `Add health-check script with exit codes`, `Fix SQL injection by using a parameterised query`, `Remove .env from tracking`. Avoid `update`, `stuff`, `final`.

## Integrity rules
- **Never backdate or fake commits or timestamps.** The real dates are part of your evidence. If you miss a week, that is fine.
- Write notes in your own words. If a section is copied from documentation, say so.
- Claim only what you did. In interviews say: "I built this lab to learn; it is not production."

## Making the profile work for you
1. Pin `devsecops-pipeline-lab`, `devsecops-training-log` and one more repo.
2. Write a two-line bio: `Application Developer | CI/CD and Azure DevOps | Building DevSecOps skills (labs on GitHub)`.
3. In each README put the one-sentence description first and a status line saying it is a learning project.
4. Add the GitHub link to your CV and LinkedIn once the project is complete (Week 8).
5. Keep repos public only when they are clean. You can keep a repo private and make it public later.
