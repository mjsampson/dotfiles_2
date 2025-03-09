PATH=~/.console-ninja/.bin:$HOME/.docker/bin:$PATH
alias env_dbt='source ~/code/graywolf/asena-monorepo/python/dbt-env/bin/activate'

ln -s /opt/homebrew/bin/python3 /opt/homebrew/bin/python
. "$HOME/.cargo/env"

. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
