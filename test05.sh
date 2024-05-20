#! /bin/dash

# this test will check if the pigs-commit -a option works correctly

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
Committed as commit 0
a
b
c
d
e
EOF

{
    pigs-init
    touch a b c d e
    pigs-add a b c
    pigs-commit -a -m 'first commit'
    ls
} >"$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "failed"
    exit 1
else
    echo "pass"
    exit 0
fi