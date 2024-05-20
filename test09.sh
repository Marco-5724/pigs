#! /bin/dash

# this test will check if the pigs-branch and pigs-checkout work correctly

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
pigs-branch: error: pigs repository directory .pig not found
pigs-checkout: error: pigs repository directory .pig not found
Initialized empty pigs repository in .pig
pigs-branch: error: this command can not be run until after the first commit
Committed as commit 0
Switched to branch 'b1'
0 first commit
EOF

{
    pigs-branch
    pigs-checkout
    touch a b c
    pigs-init
    pigs-add a b c
    pigs-branch b1
    pigs-commit -m 'first commit'
    pigs-branch b1
    pigs-checkout b1
    pigs-log
} >"$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "failed"
    exit 1
else
    echo "pass"
    exit 0
fi
