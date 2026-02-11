# Installation Guide - Langflow Skills

## Prerequisites

1. **Langflow** installed and running ([Installation Guide](https://docs.langflow.org))
2. **Claude Code**, Claude.ai, or Claude API access
3. Langflow API key configured

---

## Claude Code Installation

### Method 1: Manual Installation (Recommended)

```bash
# 1. Clone this repository
git clone https://github.com/Chrysaliz333/langflow-skills.git

# 2. Copy skills to your Claude Code skills directory
cp -r langflow-skills/skills/* ~/.claude/skills/

# 3. Reload Claude Code
# Skills will activate automatically
```

### Method 2: From Zip File

```bash
# 1. Download the latest release zip
# 2. Extract to ~/.claude/skills/
unzip langflow-skills-v1.0.0.zip -d ~/.claude/skills/

# 3. Reload Claude Code
```

---

## Claude.ai Installation

1. Download individual skill folders from `skills/`
2. Zip each skill folder individually
3. Upload via Settings → Capabilities → Skills

### Individual Skills

- **langflow-api-expert** - API usage patterns (install first)
- **langflow-component-config** - Component configuration
- **langflow-custom-components** - Custom Python components
- **langflow-flow-patterns** - Architectural patterns
- **langflow-build-expert** - Build validation
- **langflow-agent-patterns** - Agent architectures

---

## Verification

After installation, test with:

```
"How do I create a flow using the Langflow API?"
```

This should activate the **langflow-api-expert** skill.

---

## Troubleshooting

### Skills Not Activating

1. Check skills are in `~/.claude/skills/`
2. Verify SKILL.md files exist
3. Reload Claude Code
4. Try a more specific query

### Skills Not Found

```bash
# Verify installation
ls ~/.claude/skills/
# Should show: langflow-api-expert, langflow-component-config, etc.
```

---

## Updating

```bash
# Pull latest changes
cd langflow-skills
git pull

# Re-copy skills
cp -r skills/* ~/.claude/skills/

# Reload Claude Code
```

---

## Uninstallation

```bash
# Remove all Langflow skills
rm -rf ~/.claude/skills/langflow-*
```

---

## Credits

Adapted from [n8n-skills](https://github.com/czlonkowski/n8n-skills) by Romuald Członkowski ([www.aiadvisors.pl/en](https://www.aiadvisors.pl/en))
