# Vale Accept Term Automation

## Overview

This automation allows PR reviewers and contributors to quickly add technical terms to the Vale accept list by simply replying to Vale error comments with `vale-accept-term`.

## How It Works

### User Flow

```mermaid
sequenceDiagram
    participant User
    participant Vale
    participant GitHub
    participant Workflow
    participant Repository

    Vale->>GitHub: Post PR review comment about unknown term
    User->>GitHub: Reply to comment with "vale-accept-term"
    GitHub->>Workflow: Trigger vale-accept-term workflow
    Workflow->>Workflow: Parse previous comment for term
    Workflow->>Repository: Add term to accept.txt
    Workflow->>Repository: Commit and push
    Workflow->>GitHub: Add 👍 reaction to command comment
    Workflow->>GitHub: Update Vale comment as resolved
    Workflow->>GitHub: Post confirmation comment
    GitHub->>User: Term added! ✅
```

### Workflow Steps

1. **Trigger**: Listens for `issue_comment` events on PRs
2. **Command Detection**: Checks if comment is exactly `vale-accept-term`
3. **Context Analysis**: Looks at the previous comment (the Vale error)
4. **Term Extraction**: Parses the Vale error to extract the flagged term
5. **File Update**: Adds term to `.github/styles/config/vocabularies/Calculinux/accept.txt`
6. **Commit & Push**: Commits the change to the PR branch
7. **Confirmation**: Posts a success message
8. **Reaction**: Adds a green checkmark (👍) reaction to the command comment
9. **Resolution**: Updates the Vale review comment to mark it as resolved

## Command

Reply to any Vale error comment with:
- `vale-accept-term` ✅

Command is case-insensitive but must be the exact text (no other words).

## Term Extraction Patterns

The workflow looks for terms in these formats:
- `'term'` - Single quotes
- `"term"` - Double quotes
- `**term**` - Bold markdown
- `` `term` `` - Code backticks
- `Unknown word: term`
- `Did you really mean 'term'?`

## Files Modified

- `.github/workflows/vale-accept-term.yml` - Main workflow
- `.github/styles/config/vocabularies/Calculinux/accept.txt` - Accept list
- `.github/pull_request_template.md` - PR template with instructions
- `.github/styles/config/vocabularies/README.md` - Documentation
- `README.md` - Updated contributing section

## Security Considerations

- Only works on PR comments (not standalone issues)
- Requires `contents: write` permission to commit
- Uses `github-actions[bot]` as committer
- Includes co-author attribution to the commenting user
- Validates that the previous comment is from Vale

## Testing

To test this feature:

1. Create a PR with a file containing an unknown term
2. Wait for Vale to flag it in a review comment
3. Reply to that comment with `add`
4. Verify the workflow runs and commits the term

## Limitations

- Only extracts terms from the immediate previous comment
- Cannot add terms retroactively (must reply to the original error)
- Single term per command (for multiple terms, reply to each error separately)
- Requires the term to be extractable via regex patterns

## Future Enhancements

Possible improvements:
- Support for adding terms with specific case patterns (e.g., `(?i)term`)
- Ability to add to other vocabularies (Yocto, OpenSource)
- Support for phrase extraction (multi-word terms)
- Interactive confirmation before committing
- Batch add multiple terms from a single command

## Related Files

- Workflow: [vale-accept-term.yml](vale-accept-term.yml)
- Accept list: [vocabularies/Calculinux/accept.txt](../styles/config/vocabularies/Calculinux/accept.txt)
- Vale config: [.vale.ini](../../.vale.ini)
- Main PR checks: [markdown-check.yml](markdown-check.yml)
