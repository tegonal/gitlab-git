# Tegonal gitlab-git

Docker image which helps to carry out git specific tasks.
It is tailored for [GitLab](https://gitlab.com) but can be used in other contexts as well.

# Basic Setup

It expects two ENV variables to be set:
- GITBOT_SSH_PRIVATE_KEY : the private ssh key which allows to push back to the repository
- CI_REPOSITORY_URL : (provided by GitLab) the URL of the repository including a username e.g. `https://git:[MASKED]@scm.example.com/group/repo`

You can optionally overwrite:
- GITBOT_USERNAME : used for `git --config user.name`
- GITBOT_EMAIL : used for `git --config user.email`


The GITBOT_SSH_PRIVATE_KEY needs to be available to job via `Variable` (Settings -> CI / CD -> Variables).  
The public key belonging to GITBOT_SSH_PRIVATE_KEY needs be configured as `Deploy Key` in your repository (Settings -> Repository -> Deploy Keys)

Following a small sample how you use it in your .gitlab-ci.yml 
```yml
rebase: 
  image: tegonal/gitbot
  script:
    - git ...
```

In case you use already another image, then you can resort to download the shell scripts instead (note the `. ` before `./...` which is necessary so that the script runs in the same bash).

```yml
rebase: 
  image: your/image
  script:
    - wget https://raw.githubusercontent.com/tegonal/gitlab-git/master/scripts/setup-ssh.sh
    - wget https://raw.githubusercontent.com/tegonal/gitlab-git/master/scripts/clone-current.sh
    - chmod +x setup-ssh.sh clone-current.sh
    - . ./setup-ssh.sh
    - . ./clone-current.sh
    - git ...
```


# Additional Scripts

## clone-current.sh

Clones the current branch with `--depth 1` and `cd`s into the project folder, ready to do additional stuff.


Call it as follows (note the `. ` before `/scripts/...` which is necessary so that the script runs in the same bash and thus has access to the ssh-key which was setup).

```yml
rebase: 
  image: tegonal/gitbot
  script:
    - . /scripts/clone-current.sh
    - git ...

```


# License
gitlab-git is licensed under [Apache 2.0](http://opensource.org/licenses/Apache2.0).