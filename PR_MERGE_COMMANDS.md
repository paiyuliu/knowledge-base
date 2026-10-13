# Pull Request Merge Command Notes

Generic examples for working with a pull request on a Gitea-compatible server. Replace the sample values before running the commands.

## Configuration

Set these values for your repository and pull request:

```powershell
$GitHost = 'https://git.example.com'
$Repository = '<OWNER>/<REPOSITORY>'
$PrNumber = '<PR_NUMBER>'
$BaseBranch = '<BASE_BRANCH>'
$HeadBranch = '<HEAD_BRANCH>'
$FollowUpBranch = '<FOLLOW_UP_BRANCH>'
```

Use a personal access token with the permissions required for the API operations. Do not commit, publish, or otherwise store a real token in this file or in scripts.

## Useful Commands

Check the current branch and worktree:

```powershell
git status --short --branch
```

Check the configured remotes:

```powershell
git remote -v
```

Check whether the base branch exists on the remote:

```powershell
git ls-remote --heads origin $BaseBranch
```

Fetch the base and pull request branches:

```powershell
git fetch origin `
    "+refs/heads/${BaseBranch}:refs/remotes/origin/${BaseBranch}" `
    "+refs/heads/${HeadBranch}:refs/remotes/origin/${HeadBranch}"
```

Query pull requests:

```powershell
$headers = @{ Authorization = 'token <GITEA_TOKEN>' }
$prs = Invoke-RestMethod `
    -Headers $headers `
    -Uri "${GitHost}/api/v1/repos/${Repository}/pulls?state=all" `
    -TimeoutSec 20

$prs |
    Select-Object number,title,state,mergeable,
        @{n='base';e={$_.base.ref}},
        @{n='head';e={$_.head.ref}},
        @{n='user';e={$_.user.login}} |
    ConvertTo-Json -Depth 6
```

Merge a pull request into its base branch:

```powershell
$headers = @{ Authorization = 'token <GITEA_TOKEN>' }
$body = @{ Do = 'merge' } | ConvertTo-Json

Invoke-RestMethod `
    -Method Post `
    -Headers $headers `
    -ContentType 'application/json' `
    -Body $body `
    -Uri "${GitHost}/api/v1/repos/${Repository}/pulls/${PrNumber}/merge" `
    -TimeoutSec 30
```

Verify the pull request merge status:

```powershell
$headers = @{ Authorization = 'token <GITEA_TOKEN>' }

Invoke-RestMethod `
    -Headers $headers `
    -Uri "${GitHost}/api/v1/repos/${Repository}/pulls/${PrNumber}" `
    -TimeoutSec 20 |
    Select-Object number,title,state,merged,merged_at,merge_commit_sha,
        @{n='base';e={$_.base.ref}},
        @{n='head';e={$_.head.ref}} |
    ConvertTo-Json -Depth 6
```

Fetch the updated base branch after the merge:

```powershell
git fetch origin "+refs/heads/${BaseBranch}:refs/remotes/origin/${BaseBranch}"
```

Create a follow-up branch locally from the updated base branch:

```powershell
git branch $FollowUpBranch "origin/$BaseBranch"
```

Push the follow-up branch:

```powershell
git push -u origin $FollowUpBranch
```

Fetch the follow-up branch from the remote:

```powershell
git fetch origin `
    "+refs/heads/${FollowUpBranch}:refs/remotes/origin/${FollowUpBranch}"
```

Optionally configure local branch tracking manually:

```powershell
git config "branch.${FollowUpBranch}.remote" origin
git config "branch.${FollowUpBranch}.merge" "refs/heads/${FollowUpBranch}"
```

Switch to the follow-up branch:

```powershell
git switch $FollowUpBranch
```
