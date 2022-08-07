# shellcheck shell=bash

eval "$(basalt-package-init)" || exit
basalt.package-init || exit
basalt.package-load

# Test thing
# declare -Ag TEST_THING=()
# declare -ag test_array=('a' 'b' 'c' 'd')
# bobject set-array --ref 'TEST_THING' '.arr' 'test_array'
# bobject get-array --value 'TEST_THING' '.arr'
# echo "${REPLY[@]}"

export VERIFY_BASH_OBJECT=

# Start Program
c="$(<"./file.json")"
bash_json.parse 'root_value' "$c"

# Print values
case $root_value_type in
object)
	printf '%s\n' "Object found ($root_value_type)"
	bobject.print 'root_value'
	;;
array)
	printf '%s\n' "Array found ($root_value_type)"
	bobject.print "$root_value"
	;;
string)
	printf '%s\n' "String found ($root_value_type): $root_value"
	;;
number)
	printf '%s\n' "Number found ($root_value_type): $root_value"
	;;
*)
	core.print_die "Value type did not match: $root_value_type"
	;;
esac
