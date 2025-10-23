#!/usr/bin/env bash

# used to match output from `tmux list-keys`
KEY_BINDING_REGEX="bind-key[[:space:]]\+\(-r[[:space:]]\+\)\?\(-T prefix[[:space:]]\+\)\?"

TMUX_BIN=$(echo "$TMUX" | awk -F'[/-]' '{print $3}')

# returns prefix key, e.g. 'C-a'
prefix() {
	$TMUX_BIN show-option -gv prefix
}

# if prefix is 'C-a', this function returns 'a'
prefix_without_ctrl() {
	local prefix="$(prefix)"
	echo "$prefix" | cut -d '-' -f2
}

option_value_not_changed() {
	local option="$1" default_value="$2" option_value
	option_value=$($TMUX_BIN show-option -gv "$option")
	[ "$option_value" == "$default_value" ]
}

server_option_value_not_changed() {
	local option="$1" default_value="$2" option_value
	option_value=$($TMUX_BIN show-option -sv "$option")
	[ "$option_value" == "$default_value" ]
}

key_binding_not_set() {
	local key="${1//\\/\\\\}"
	if $TMUX_BIN list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]"; then
		return 1
	else
		return 0
	fi
}

key_binding_not_changed() {
	local key="$1"
	local default_value="$2"
	if $TMUX_BIN list-keys | grep -q "${KEY_BINDING_REGEX}${key}[[:space:]]\+${default_value}"; then
		# key still has the default binding
		return 0
	else
		return 1
	fi
}

get_tmux_config() {
	local tmux_config_xdg="${XDG_CONFIG_HOME:-$HOME/.config}/tmux/tmux.conf"
	local tmux_config="$HOME/.tmux.conf"

	if [ -f "${tmux_config_xdg}" ]; then
		echo "${tmux_config_xdg}"
	else
		echo "${tmux_config}"
	fi
}

main() {
	# OPTIONS

	# address vim mode switching delay (http://superuser.com/a/252717/65504)
	if server_option_value_not_changed "escape-time" "500"; then
		$TMUX_BIN set-option -s escape-time 0
	fi

	# increase scrollback buffer size
	if option_value_not_changed "history-limit" "2000"; then
		$TMUX_BIN set-option -g history-limit 50000
	fi

	# $TMUX_BIN messages are displayed for 4 seconds
	if option_value_not_changed "display-time" "750"; then
		$TMUX_BIN set-option -g display-time 4000
	fi

	# refresh 'status-left' and 'status-right' more often
	if option_value_not_changed "status-interval" "15"; then
		$TMUX_BIN set-option -g status-interval 5
	fi

	# upgrade $TERM, tmux 1.9
	if option_value_not_changed "default-terminal" "screen"; then
		$TMUX_BIN set-option -g default-terminal "screen-256color"
	fi
	# upgrade $TERM, tmux 2.0+
	if server_option_value_not_changed "default-terminal" "screen"; then
		$TMUX_BIN set-option -s default-terminal "screen-256color"
	fi

	# emacs key bindings in tmux command prompt (prefix + :) are better than
	# vi keys, even for vim users
	$TMUX_BIN set-option -g status-keys emacs

	# focus events enabled for terminals that support them
	$TMUX_BIN set-option -g focus-events on

	# DEFAULT KEY BINDINGS

	local prefix="$(prefix)"
	local prefix_without_ctrl="$(prefix_without_ctrl)"

	# if C-b is not prefix
	if [ "$prefix" != "C-b" ]; then
		# unbind obsolete default binding
		if key_binding_not_changed "C-b" "send-prefix"; then
			$TMUX_BIN unbind-key C-b
		fi

		# pressing `prefix + prefix` sends <prefix> to the shell
		if key_binding_not_set "$prefix"; then
			$TMUX_BIN bind-key "$prefix" send-prefix
		fi
	fi

	# If Ctrl-a is prefix then `Ctrl-a + a` switches between alternate windows.
	# Works for any prefix character.
	if key_binding_not_set "$prefix_without_ctrl"; then
		$TMUX_BIN bind-key "$prefix_without_ctrl" last-window
	fi

	# easier switching between next/prev window
	if key_binding_not_set "C-p"; then
		$TMUX_BIN bind-key C-p previous-window
	fi
	if key_binding_not_set "C-n"; then
		$TMUX_BIN bind-key C-n next-window
	fi

	# source `.tmux.conf` file - as suggested in `man tmux`
	if key_binding_not_set "R"; then
		local tmux_config
		tmux_config=$(get_tmux_config)

		$TMUX_BIN bind-key R run-shell " \
      $TMUX_BIN source-file ${tmux_config} > /dev/null; \
      $TMUX_BIN display-message 'Sourced ${tmux_config}!'"
	fi
}
main
