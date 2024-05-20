#! /bin/dash

# this test will check if the pigs-status works correctly

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
pigs-status: error: pigs repository directory .pig not found
Initialized empty pigs repository in .pig
Committed as commit 0
a - file changed, changes staged for commit
b - same as repo
c - file changed, changes not staged for commit
EOF

{
    pigs-status
    touch a b c
    pigs-init
    pigs-add a b c
    pigs-commit -m 'first commit'
    echo 2 >a
    echo 4 >c
    pigs-add a b
    pigs-status
} >"$actual_output" 2>&1

if ! diff "$expected_output" "$actual_output"; then
    echo "failed"
    exit 1
else
    echo "pass"
    exit 0
fi