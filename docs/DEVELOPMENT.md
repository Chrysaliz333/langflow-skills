# Development Guide - Langflow Skills

## Project Structure

```
langflow-skills/
├── README.md                    # Project overview
├── CLAUDE.md                    # Claude Code context
├── MIGRATION_ANALYSIS.md        # n8n → Langflow adaptation analysis
├── LICENSE                      # MIT License
├── build.sh                     # Build distribution packages
├── .claude-plugin/              # Claude Code plugin config
│   ├── plugin.json
│   └── marketplace.json
├── skills/                      # Skill implementations
│   ├── langflow-api-expert/
│   ├── langflow-component-config/
│   ├── langflow-custom-components/
│   ├── langflow-flow-patterns/
│   ├── langflow-build-expert/
│   └── langflow-agent-patterns/
├── evaluations/                 # Test scenarios
│   ├── langflow-api-expert/
│   ├── langflow-component-config/
│   └── ...
└── docs/                        # Documentation
    ├── INSTALLATION.md
    ├── USAGE.md
    └── DEVELOPMENT.md (this file)
```

---

## Creating a New Skill

### 1. Create Skill Directory

```bash
mkdir -p skills/my-new-skill
```

### 2. Create SKILL.md with Frontmatter

```markdown
---
name: my-new-skill
description: Brief description that triggers skill activation. Use when [specific scenarios].
---

# My New Skill

Detailed skill content here...
```

### 3. Add Reference Files (Optional)

```bash
skills/my-new-skill/
├── SKILL.md              # Required
├── REFERENCE.md          # Optional reference material
└── EXAMPLES.md           # Optional examples
```

### 4. Create Evaluations

```bash
mkdir -p evaluations/my-new-skill
```

Create test scenarios:

```json
{
  "scenario": "Test scenario description",
  "user_query": "User's question",
  "expected_activation": "my-new-skill",
  "expected_guidance": "What the skill should provide"
}
```

---

## Skill Best Practices

### 1. Clear Activation Triggers

```markdown
---
description: Use when creating flows, managing components, building workflows, deploying flows, executing flows, or using any Langflow API endpoint.
---
```

### 2. Progressive Disclosure

Start with quick reference, then provide details:

```markdown
## Quick Reference
- Endpoint overview
- Common patterns

## Detailed Sections
- In-depth explanations
- Advanced patterns
```

### 3. Real Examples

```bash
# Always include working examples
curl -X POST "$URL/api/v1/flows/" \
  -H "x-api-key: $KEY" \
  -d '{"name": "My Flow"}'
```

### 4. Common Mistakes Section

```markdown
## Common Mistakes

### Mistake 1: Issue Description
**Problem**: Error message
**Fix**: Corrected code
```

### 5. Keep Under 500 Lines

Focus on essential information. Link to external docs for details.

---

## Testing Skills

### Manual Testing

```bash
# 1. Install skill
cp -r skills/my-new-skill ~/.claude/skills/

# 2. Test activation
# Ask Claude a query that should trigger the skill

# 3. Verify correct guidance provided
```

### Evaluation Testing

Create test scenarios:

```json
{
  "test_id": "001",
  "scenario": "User wants to create a flow",
  "query": "How do I create a flow using the API?",
  "should_activate": "langflow-api-expert",
  "should_include": [
    "POST /api/v1/flows/",
    "x-api-key header",
    "Example curl command"
  ]
}
```

---

## Building Distributions

### Build All Packages

```bash
./build.sh
```

This creates:
- Individual skill zips (for Claude.ai)
- Complete bundle (for Claude Code)

### Manual Build

```bash
# Individual skill
zip -r langflow-api-expert-v1.0.0.zip skills/langflow-api-expert/

# Complete bundle
zip -r langflow-skills-v1.0.0.zip \
  .claude-plugin/ \
  README.md \
  LICENSE \
  skills/
```

---

## Contributing

### Before Submitting

1. Test skill activation
2. Verify examples work
3. Check for typos
4. Update CHANGELOG (if exists)
5. Run build.sh

### Pull Request Guidelines

- Clear description of changes
- Test results included
- Updated documentation
- Follows existing patterns

---

## Adaptation from n8n-skills

This project was adapted from [n8n-skills](https://github.com/czlonkowski/n8n-skills) by Romuald Członkowski.

### Key Changes

1. **API Interface**: MCP server → REST API
2. **Language**: JavaScript/Python → Python-only
3. **Focus**: General automation → AI/LLM applications
4. **Patterns**: Webhooks/integrations → RAG/Agents
5. **Build Process**: Direct execution → Build before execute

See [MIGRATION_ANALYSIS.md](../MIGRATION_ANALYSIS.md) for full details.

---

## Credits

**Adapted by**: Liz (Chrysaliz333)
**Originally Conceived by**: Romuald Członkowski - [www.aiadvisors.pl/en](https://www.aiadvisors.pl/en)

---

## License

MIT License - see [LICENSE](../LICENSE) file
