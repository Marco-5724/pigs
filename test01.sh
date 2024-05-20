#! /bin/dash

# this test will check if the pigs-add works correctly

PATH="$PATH:$(pwd)"

# create a temporary directory for the test.
test_dir=$(mktemp -d)
cd "$test_dir" || exit 1

# create some files to hold output.
expected_output=$(mktemp)
actual_output=$(mktemp)



# remove the temporary directory when the test is done.

trap 'rm "$expected_output" "$actual_output" -rf "$test_dir"' INT HUP QUIT TERM EXIT

# create pigs repository
cat >"$expected_output" <<EOF
Initialized empty pigs repository in .pig
pigs-add: error: can not open 'c'
EOF

{
    touch a b
    pigs-init
    pigs-add a
    pigs-add b
    pigs-add c
} >"$actual_output" 2>&1    

if ! diff "$expected_output" "$actual_output"; then
    echo "failed"
    exit 1
else
    echo "pass"
    exit 0
fi