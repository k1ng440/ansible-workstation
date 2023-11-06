# Workstation Ansible Playbook

## Variable
| Var               | Default        | Description                                                           |
| ------            | ---------      | ---------------                                                       |
| dist_override     | ``             | Override distro codename                                              |
| nvim_version      | `09.2`         | Neovim version to install                                             |
| nvim_install_dest | `/usr/local`   | Neovim installation destination path                                  |
| git_user_email    | `john@doe.com` | Email address for git                                                 |
| git_user_name     | `John Doe`     | Name for git                                                          |
| dunst_version     | `1.9.2`        | Version of [dunst](https://github.com/dunst-project/dunst) release    |
| gvm_version       | `1.0.22`       | Version of [gvm (Go Version Manager)](https://github.com/moovweb/gvm) |
| golang_version    | `1.21.3`       | Version of [golang](https://go.dev)                                   |
| fzf_version       | `0.43.0`       | Version of [fzf](https://github.com/junegunn/fzf)                     |
| slack_version     | `4.34.121`     | Version of [Slack](https://slack.com/downloads) .dep package          |
| i3_version        | `4.23`         | Version of [i3](https://github.com/i3/i3)                             |

# TODO
* Vagrant with Virtual box
* [ddgr](https://github.com/jarun/ddgr)
* rofi
    * [rofi-blocks](https://github.com/OmarCastro/rofi-blocks)
* WezTerm
