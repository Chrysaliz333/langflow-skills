# Usage Guide - Langflow Skills

## How Skills Activate

Skills activate **automatically** when your query matches their description:

```
"How do I use the Langflow API?"
→ Activates: langflow-api-expert

"Configure the OpenAI component"
→ Activates: langflow-component-config

"Create a custom component"
→ Activates: langflow-custom-components

"Build a RAG application"
→ Activates: langflow-flow-patterns

"Why is my build failing?"
→ Activates: langflow-build-expert

"Implement a multi-agent system"
→ Activates: langflow-agent-patterns
```

---

## Skill Descriptions

### 1. Langflow API Expert (HIGHEST PRIORITY)

**Use when**: Creating flows, managing components, building workflows, executing flows

**Example queries**:
- "How do I create a flow via API?"
- "What's the build endpoint?"
- "How do I execute a flow with streaming?"
- "Show me authentication patterns"

---

### 2. Langflow Component Configuration

**Use when**: Configuring components, understanding inputs, setting up workflows

**Example queries**:
- "What input types are available?"
- "How do I configure an OpenAI component?"
- "What's SecretStrInput for?"
- "How do I make a field required?"

---

### 3. Langflow Custom Components

**Use when**: Creating custom components, extending functionality, Python development

**Example queries**:
- "How do I create a custom component?"
- "What's the build method signature?"
- "Can I use external libraries?"
- "How do I return Data objects?"

---

### 4. Langflow Flow Patterns

**Use when**: Designing flows, choosing architectures, implementing patterns

**Example queries**:
- "What's the RAG pattern?"
- "How do I build a chat application?"
- "Show me multi-agent architecture"
- "What pattern for document Q&A?"

---

### 5. Langflow Build Expert

**Use when**: Build failures, validation errors, debugging

**Example queries**:
- "Why is my build failing?"
- "How do I fix missing required field error?"
- "What are build events?"
- "How do I monitor build progress?"

---

### 6. Langflow Agent Patterns

**Use when**: Building agents, tool-calling, multi-agent systems

**Example queries**:
- "How do I create a tool-calling agent?"
- "What's the supervisor pattern?"
- "How do I manage agent memory?"
- "Show me RAG agent architecture"

---

## Skills Work Together

Complex queries may activate multiple skills:

**Example**: "Build and deploy a chatbot with RAG"

1. **langflow-flow-patterns** - Identifies RAG pattern
2. **langflow-api-expert** - Guides API flow creation
3. **langflow-component-config** - Configures components
4. **langflow-custom-components** - Creates custom retrieval logic (if needed)
5. **langflow-build-expert** - Validates and fixes build errors
6. **langflow-agent-patterns** - Optimizes agent architecture

---

## Best Practices

### 1. Start with API Expert

Learn the API fundamentals first:
```
"How do I authenticate with Langflow API?"
"Show me basic flow creation"
```

### 2. Understand Components

Before building, understand component configuration:
```
"What are the main input types?"
"How do I configure a vector store?"
```

### 3. Choose the Right Pattern

Identify your use case pattern:
```
"Which pattern for document Q&A?" → RAG
"Which pattern for tool-using AI?" → Agent
```

### 4. Build Incrementally

Start simple, then enhance:
```
1. "Create a simple chat flow"
2. "Add memory to chat flow"
3. "Add RAG to chat flow"
```

### 5. Handle Errors Properly

Use build expert for troubleshooting:
```
"Build failing with missing field error"
"How do I debug component connections?"
```

---

## Common Workflows

### Workflow 1: Create Chat Application

```
1. "How do I create a chat flow via API?"
   → langflow-api-expert shows API patterns

2. "Configure OpenAI and ChatInput components"
   → langflow-component-config shows setup

3. "Build the flow"
   → langflow-build-expert shows build process

4. "Execute the flow"
   → langflow-api-expert shows execution
```

### Workflow 2: Build RAG System

```
1. "What's the RAG pattern?"
   → langflow-flow-patterns explains architecture

2. "Configure vector store component"
   → langflow-component-config shows inputs

3. "Create custom retrieval component"
   → langflow-custom-components shows Python code

4. "Build and fix errors"
   → langflow-build-expert handles validation
```

### Workflow 3: Multi-Agent System

```
1. "Show me multi-agent patterns"
   → langflow-agent-patterns explains architectures

2. "Create tool-calling agents"
   → langflow-custom-components shows tool development

3. "Connect agents in flow"
   → langflow-flow-patterns shows structure

4. "Manage agent memory"
   → langflow-agent-patterns shows memory patterns
```

---

## Tips

### Specific Queries Get Better Results

```
❌ "Help with Langflow"
✅ "How do I create a flow using the API?"

❌ "Components"
✅ "What input types are available for components?"

❌ "Errors"
✅ "Build failing with missing required field error"
```

### Reference Skills by Name

```
"Use langflow-api-expert to show me authentication"
"Ask langflow-agent-patterns about tool-calling"
```

### Combine Skills

```
"Use langflow-flow-patterns to identify the pattern, then langflow-api-expert to implement it"
```

---

## Getting Help

If skills aren't activating:

1. Check installation: `ls ~/.claude/skills/`
2. Use more specific queries
3. Reference skill by name
4. Reload Claude Code

---

## Further Reading

- [Installation Guide](INSTALLATION.md)
- [Development Guide](DEVELOPMENT.md)
- [Langflow Documentation](https://docs.langflow.org)
