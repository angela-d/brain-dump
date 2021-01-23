# Cloning a Pull Request
Test a pull request without merging it over your master repo.

1. Clone a fresh copy
```bash
git clone https://REPO_URL_HERE.git
```

2. Change into the directory
```bash
cd REPO_DIRECTORY_HERE
```

3. Clone the pull-request number (replace **5** with the # of the PR from the particular repo)
```bash
git pull origin pull/5/head
```

4. Test the pull request!
