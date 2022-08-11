# shellcheck shell=bash

bash_json.util_is_primitive() {
	local value="$1"

	if [[ "${value::1}" = $'\x01' || "${value::1}" = $'\x02' ]]; then
		return 0
	else
		return 1
	fi
}

bash_json.util_is_within_bounds() {
	local idx="$1"
	local message="$2"

	if ((idx >= ${#TOKENS[@]} )); then
		core.print_die "$message"
	fi
}

bash_json_get_idx_values() {
	unset -v REPLY{1,2,3}; REPLY1= REPLY2= REPLY3=
	local i="$1"

	REPLY1=${TOKENS[$i]##*:}
	REPLY2=${TOKENS[$i]%%:*}
	REPLY3=${TOKENS[$i]#*:}; REPLY3=${REPLY3%%:*}
}

bash_json.util_die() {
	local msg="$1"

	core.print_die "$msg (row $idx_row, column: $idx_col)"
}
