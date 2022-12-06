### Contains shared CI tasks synced across repositories.

#### Steps for adding in a new repository:

1. Clone and get into the repository: 
```
gh repo clone GaloyMoney/concourse-shared
cd concourse-shared
```
2. Edit `ci/values.yml` and under `src_repos`, add the new repository. The key name for the repository must be the name of the repository as on GitHub under GaloyMoney organization.
This file contains many feature flags according to which the Pull Request will be created with shared tasks.
3. Push the change on the CI.
```
ci/repipe
```
4. Make sure that `galoybot` has permissions to the target repository and it also has `galoybot` as a possible label in the PR.

This would, in turn create a new job under the concourse-shared pipeline and when it runs, it would automatically create the pull request for you on the specified target repository.

#### Shared Folder Details

1. `actions` folder - Get synced to `.github/workflows/` folder
2. `ci` folder - Get synced to `ci/` folder

#### Feature Flags

Feature Flags `nodejs`, `rust`, `chart` and `docker` are supported right now.
Files whose names don't start with them are treated as common and synced to all.
These are keywords such that files whose names start with these are included in that specific repository.
