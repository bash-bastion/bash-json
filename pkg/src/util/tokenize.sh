# shellcheck shell=bash

bash_json.tokenize_begin_value() {
	local char="$1"

	if bash_json.tokenize_util_is_space "$char"; then
		return
	fi

	case $char in
		'{')

			;;
	esac
}

bash_json.tokenize_util_is_space() {
	local char="$1"

	if [ "$char" == ' ' ]; then
		:
	fi
}
# bash_json.tokenize_string() {
# 	i=$((i+1))

# 	local char="${content:$i:1}"

# 	case $char in
# 	$'\x10'|$'\x11'|$'\x12'|$'\x13'|$'\x14')
# 		core.print_die 'Unexpected whitespace in string'
# 		;;
# 	'"'|'')
# 		return 1
# 		;;
# 	*)
# 		str+=$char
# 		;;
# 	esac

# 	until bash_json.tokenize_string; do
# 		return 1
# 	done
# }

# bash_json.tokenize_number() {
# 	case $char in
# 	$'\x09'|$'\x0B'|$'\x0C')
# 		core.print_die 'Unexpected whitespace in number'
# 		;;
# 	','|']')
# 		i=$((i-1))
# 		return 1
# 		;;
# 	$'\x0A'|'')
# 		i=$((i-1))
# 		return 1
# 		;;
# 	*)
# 		str+=$char
# 		;;
# 	esac

# 	i=$((i+1))
# 	local char="${content:$i:1}"

# 	until bash_json.tokenize_number; do
# 		return 1
# 	done
# }
