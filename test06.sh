#! /bin/dash

# this test will check if the pigs-rm works correctly

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
pigs-rm: error: pigs repository directory .pig not found
Initialized empty pigs repository in .pig
usage: pigs-rm [--force] [--cached] <filenames>
Committed as commit 0
pigs-rm: error: 'c' is not in the pigs repository
b
EOF

{
    touch a b
    pigs-rm a
    pigs-init
    pigs-rm
    pigs-add a b
    pigs-commit -a -m 'first commit'
    pigs-rm a
    pigs-rm c
    ls
} >"$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "failed"
    exit 1
else
    echo "pass"
    exit 0
fi