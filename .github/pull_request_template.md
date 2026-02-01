## Description
<!-- Please describe the changes made in this pull request -->

## Type of Change
- [ ] New content
- [ ] Restructuring/reorganization
- [ ] Minor edit

## Changes Made
<!-- List the specific files changed and what was updated -->

## Related Issues
<!-- Link any related issues: Closes #123, Fixes #456 -->

## Notes for Reviewers

<!-- Add any additional context or notes for reviewers -->

## Automated Checks

This PR will run the following automated checks:

### 📝 Grammar & Syntax Check
The workflow will check for:
- **Markdown Syntax Issues** (markdownlint) - formatting and structure
- **Grammar & Prose Issues** (Vale) - writing quality and consistency
- **Spelling Issues** (cspell) - spelling errors against a project dictionary

### 💬 Feedback Handling
When the workflow finds issues, it will post comments on this PR with:

1. **Review the Issues**: Check the PR comment for details on what was found
2. **Choose an Action**:
   - **Fix the Issues**: Update your markdown files and push changes
   - **Disagree with Feedback**: Reply to the comment explaining why, then close the conversation
   - **Acknowledge & Close**: If you're addressing the feedback in a separate issue, close the conversation

### 📚 Adding Terms to Vale Accept List

**Quick Add via Comment** ⚡

If Vale flags a legitimate term (technical word, brand name, acronym), you can add it automatically:

1. Reply to the Vale error comment with: `vale-accept-term`
2. The bot will automatically:
   - Extract the term from the error
   - Add it to `.github/styles/config/vocabularies/Calculinux/accept.txt`
   - Commit the change to your PR
   - Confirm with a comment

**Manual Add**

You can also manually edit `.github/styles/config/vocabularies/Calculinux/accept.txt` and add terms:
- One term per line
- Case-sensitive (unless you use regex patterns like `(?i)term`)
- Push the change and the workflow will re-run

**Examples of terms to add:**
- Product names (PicoCalc, Luckfox, Rockchip)
- Brand names (ClockworkPi, Yocto)
- Technical acronyms (GPIO, UART, SoC)
- Project-specific terminology
- Tool names (bitbake, mkdocs)

### ✅ Merge Requirements

Before this PR can be merged:
- [ ] All workflow checks must pass (or have feedback resolved)
- [ ] All conversations must be closed (addressed or dismissed)
- [ ] Code review approval (if required by branch protection rules)

---

**Questions?** Check the [Contributing Guide](CONTRIBUTING.md) or [Documentation Framework](DOCUMENTATION_FRAMEWORK.md) for more details.
