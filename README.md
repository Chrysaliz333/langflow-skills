# langflow-skills

**Expert Claude Code skills for building Langflow AI applications**

[![GitHub stars](https://img.shields.io/github/stars/Chrysaliz333/langflow-skills?style=social)](https://github.com/Chrysaliz333/langflow-skills)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Langflow](https://img.shields.io/badge/Langflow-compatible-blue.svg)](https://github.com/langflow-ai/langflow)

---

## 🎯 What is this?

This repository contains **6 complementary Claude Code skills** that teach AI assistants how to build Langflow AI applications using the Langflow REST API.

**Adapted from**: [n8n-skills by Romuald Członkowski](https://github.com/czlonkowski/n8n-skills) - Conceived by Romuald Członkowski ([www.aiadvisors.pl/en](https://www.aiadvisors.pl/en))

### Why These Skills Exist

Building Langflow applications programmatically can be challenging. Common issues include:
- Using REST API endpoints incorrectly or inefficiently
- Getting stuck in build validation error loops
- Not knowing which AI agent patterns to use
- Misconfiguring components and their dependencies
- Understanding Python component development

These skills solve these problems by teaching Claude:
- ✅ How to use Langflow's REST API effectively
- ✅ Component configuration and input/output management
- ✅ Custom Python component development patterns
- ✅ Proven AI agent and RAG workflow patterns
- ✅ Build process validation and error fixing

---

## 📚 The 6 Skills

### 1. **Langflow API Expert** (HIGHEST PRIORITY)
Expert guide for using Langflow's REST API effectively.

**Activates when**: Creating flows, managing components, building workflows, deploying flows, executing flows.

**Key Features**:
- API endpoint selection guide
- Authentication patterns (x-api-key)
- Flow CRUD operations
- Build process management
- Execution and session handling
- Common API patterns

### 2. **Langflow Component Configuration**
Component-aware configuration guidance.

**Activates when**: Configuring components, understanding input dependencies, setting up AI workflows.

**Key Features**:
- Input field types (StrInput, IntInput, SecretStrInput, BoolInput, etc.)
- Component templates and parameters
- Input/output connections
- Real-time refresh fields
- Common configuration patterns
- LangChain integration

### 3. **Langflow Custom Components**
Write custom Python components for Langflow.

**Activates when**: Creating custom components, extending functionality, Python development.

**Key Features**:
- Component class structure
- Input/output definitions
- Build method implementation
- LangChain/LangGraph integration
- Standard library usage (no external packages)
- Error handling patterns
- **Critical limitation**: No pip packages at runtime (standard library only)

### 4. **Langflow Flow Patterns**
Build flows using proven AI architectural patterns.

**Activates when**: Creating flows, designing AI applications, implementing agents.

**Key Features**:
- 5 proven patterns (Chat, RAG, Agent, API Integration, Multi-Agent)
- Flow creation checklist
- Component connection patterns
- Pattern selection guide
- Real-world examples

### 5. **Langflow Build Expert**
Interpret build errors and guide fixing.

**Activates when**: Build fails, debugging flow errors, validation issues.

**Key Features**:
- Build process workflow
- Real error catalog
- Build event streaming
- Common build failures
- Validation strategies
- Fix patterns

### 6. **Langflow Agent Patterns**
Advanced AI agent implementation patterns.

**Activates when**: Building multi-agent systems, implementing RAG, tool-calling patterns.

**Key Features**:
- Multi-agent architectures
- Tool-calling patterns
- Memory management (conversation, vector)
- Human-in-the-loop workflows
- RAG implementation strategies
- Agent collaboration patterns

---

## 🚀 Installation

### Prerequisites

1. **Langflow** installed and running ([Installation Guide](https://docs.langflow.org))
2. **Claude Code**, Claude.ai, or Claude API access
3. Langflow API key configured

### Claude Code

**Method 1: Manual Installation**
```bash
# 1. Clone this repository
git clone https://github.com/Chrysaliz333/langflow-skills.git

# 2. Copy skills to your Claude Code skills directory
cp -r langflow-skills/skills/* ~/.claude/skills/

# 3. Reload Claude Code
# Skills will activate automatically
```

### Claude.ai

1. Download individual skill folders from `skills/`
2. Zip each skill folder
3. Upload via Settings → Capabilities → Skills

### API / SDK

See [docs/INSTALLATION.md](docs/INSTALLATION.md) for detailed instructions.

---

## 💡 Usage

Skills activate **automatically** when relevant queries are detected:

```
"How do I create a flow using the API?"
→ Activates: Langflow API Expert

"How do I configure the OpenAI component?"
→ Activates: Langflow Component Configuration

"Build a RAG application"
→ Activates: Langflow Flow Patterns + Langflow Agent Patterns

"Why is my build failing?"
→ Activates: Langflow Build Expert

"How do I create a custom component?"
→ Activates: Langflow Custom Components

"Implement a multi-agent system"
→ Activates: Langflow Agent Patterns
```

### Skills Work Together

When you ask: **"Build and deploy a chatbot with RAG"**

1. **Langflow Flow Patterns** identifies RAG pattern architecture
2. **Langflow API Expert** guides API usage for flow creation
3. **Langflow Component Configuration** helps configure ChatInput, OpenAI, Vector Store components
4. **Langflow Custom Components** helps if custom retrieval logic is needed
5. **Langflow Build Expert** validates and fixes build errors
6. **Langflow Agent Patterns** optimizes agent and tool-calling patterns

All skills compose seamlessly!

---

## 📖 Documentation

- [Migration Analysis](MIGRATION_ANALYSIS.md) - How we adapted from n8n to Langflow
- [Installation Guide](docs/INSTALLATION.md) - Detailed installation for all platforms
- [Usage Guide](docs/USAGE.md) - How to use skills effectively
- [Development Guide](docs/DEVELOPMENT.md) - Contributing and testing

---

## 🧪 Testing

Each skill includes 3+ evaluations for quality assurance:

```bash
# Run evaluations (if testing framework available)
npm test

# Or manually test with Claude
claude-code --skill langflow-api-expert "Create a simple chat flow"
```

---

## 🤝 Contributing

Contributions welcome! Please see [DEVELOPMENT.md](docs/DEVELOPMENT.md) for guidelines.

### Development Approach

1. **Evaluation-First**: Write test scenarios before implementation
2. **API-Informed**: Test endpoints, document real responses
3. **Iterative**: Test against evaluations, iterate until 100% pass
4. **Concise**: Keep SKILL.md under 500 lines
5. **Real Examples**: All examples from real Langflow components

---

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Credits

**Adapted by Liz (Chrysaliz333)**
- From: [n8n-skills](https://github.com/czlonkowski/n8n-skills)
- **Originally Conceived by Romuald Członkowski** - [www.aiadvisors.pl/en](https://www.aiadvisors.pl/en)

This work builds upon the excellent foundation of the n8n-skills project.

---

## 🔗 Related Projects

- [Langflow](https://github.com/langflow-ai/langflow) - Visual AI application builder
- [n8n-skills](https://github.com/czlonkowski/n8n-skills) - Original n8n skills (by Romuald Członkowski)
- [LangChain](https://github.com/langchain-ai/langchain) - LLM application framework

---

## 📊 What's Included

- **6** complementary skills that work together
- **Python-native** component development guidance
- **AI-focused** patterns (RAG, agents, multi-agent systems)
- **Comprehensive** build error catalogs and troubleshooting guides
- **REST API** integration patterns

---

## Key Differences from n8n-skills

- **Focus**: AI/LLM applications instead of general automation
- **Interface**: REST API instead of MCP server
- **Language**: Python-based components instead of JavaScript/Python code nodes
- **Execution**: Build process before execution
- **Patterns**: Agent-centric instead of webhook/integration-centric

---

**Ready to build powerful Langflow AI applications? Get started now!** 🚀
