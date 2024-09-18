In the newly created repository to explain the process of branching, committing, and raising pull requests (PRs) from a basic level. This guide will help interns or contributors understand the Git workflow and how to contribute to the project effectively.

CONTRIBUTING.md
Welcome to the project! Follow these steps to contribute to this repository.

Step 1: Fork the Repository
Before making any changes, you should first create your own copy of the repository.

Go to the repository page on GitHub.
Click the Fork button at the top right of the page. This will create a copy of the repository under your GitHub account.
Step 2: Clone the Forked Repository
Now that you've forked the repository, you can clone it to your local machine to start working.

In your forked repository, click on the Code button and copy the URL.
Open your terminal or Git Bash and run the following command:

git clone https://github.com/your-username/your-repo-name.git
Replace your-username and your-repo-name with your GitHub username and the repository name.
Navigate into the project directory:

cd your-repo-name
Step 3: Create a New Branch
Now that you have the repository locally, create a new branch for your changes. Always work on a new branch, never make changes directly on the main branch.

Create a new branch:

git checkout -b your-branch-name
Replace your-branch-name with a descriptive name related to the changes you are going to make (e.g., add-feature-x or fix-bug-y).
Step 4: Make Changes to the Project
Now that you're on your new branch, make the necessary changes to the codebase. This can include updating files, adding features, or fixing bugs.

Step 5: Stage and Commit Your Changes
Once you've made your changes, it's time to stage and commit them.

Stage the changes:

git add .
This stages all the changes you made. You can also stage specific files:


git add path/to/your/file
Commit the changes: Write a clear and descriptive commit message about the changes you made:

git commit -m "Brief description of your changes"
Step 6: Push Your Branch to GitHub
Now that your changes are committed, it's time to push your branch to GitHub.

Push the branch to your forked repository:

git push origin your-branch-name
Step 7: Create a Pull Request (PR)
After pushing your branch to GitHub, it's time to create a Pull Request (PR) to propose your changes to be merged into the main repository.

Go to your repository on GitHub.
You should see a message saying, "Compare & pull request". Click on that button.
If not, go to the Pull Requests tab and click New pull request.
Select your branch from the "compare" dropdown and ensure the base branch is main.
Add a title and description for your PR, explaining what changes you made and why.
Submit the pull request by clicking Create pull request.
Step 8: Respond to Feedback
Once you submit your pull request, the repository maintainers may review your code and provide feedback. Be sure to respond to their comments and make any necessary updates to your code.

If changes are requested, make them on your local machine, commit them, and push them to the same branch:


git add .
git commit -m "Addressed feedback on [describe changes]"
git push origin your-branch-name
Your pull request will automatically update with the new changes.
Step 9: Merge the PR (If Approved)
Once your PR is reviewed and approved, it can be merged into the main branch. This will usually be done by the repository maintainers.

Important Guidelines
Branch Naming: Use meaningful names for branches (e.g., feature/add-login, bugfix/fix-header).
Commit Messages: Write clear and concise commit messages that describe the changes made.
Pull Request Description: Provide a detailed description of the changes in your pull request, and explain why these changes were necessary.
Additional Notes
Syncing your fork: If the original repository is updated, you might need to sync your fork before creating new branches. You can do this by adding the original repository as a remote:

git remote add upstream https://github.com/original-owner/original-repo.git
git fetch upstream
git checkout main
git merge upstream/main
Resolve Conflicts: If your branch has conflicts with the main branch, resolve them locally, commit, and push the changes.
By following this process, you can contribute effectively to this project! If you have any questions, feel free to ask.

