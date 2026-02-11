# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **langflow-skills** repository - a collection of Claude Code skills designed to teach AI assistants how to build Langflow AI applications using the Langflow REST API.

**Repository**: https://github.com/Chrysaliz333/langflow-skills

**Adapted From**: [n8n-skills](https://github.com/czlonkowski/n8n-skills) - Originally Conceived by Romuald Członkowski ([www.aiadvisors.pl/en](https://www.aiadvisors.pl/en))

**Purpose**: 6 complementary skills that provide expert guidance on building Langflow flows programmatically via REST API.

**Architecture**:
- **Langflow REST API**: Provides programmatic access to flows, components, builds, and execution
- **Claude Skills**: Provides expert guidance on HOW to use the API effectively
- **Together**: Expert Langflow application builder with progressive disclosure

## Repository Structure

```
langflow-skills/
├── README.md                         # Project overview
├── LICENSE                           # MIT License
├── MIGRATION_ANALYSIS.md             # n8n → Langflow adaptation analysis
├── CLAUDE.md                         # This file
├── skills/                           # Individual skill implementations
│   ├── langflow-api-expert/          # API usage patterns (HIGHEST PRIORITY)
│   ├── langflow-component-config/    # Component configuration
│   ├── langflow-custom-components/   # Custom Python components
│   ├── langflow-flow-patterns/       # Architectural patterns
│   ├── langflow-build-expert/        # Build validation
│   └── langflow-agent-patterns/      # AI agent patterns
├── evaluations/                      # Test scenarios for each skill
├── docs/                             # Documentation
└── dist/                             # Distribution packages
```

## The 6 Skills

### 1. Langflow API Expert (HIGHEST PRIORITY)
- Teaches how to use Langflow REST API effectively
- Covers endpoints: `/api/v1/flows/`, `/api/v1/build/`, `/run`
- Authentication with x-api-key
- Flow CRUD operations
- Build process management

### 2. Langflow Component Configuration
- Component input/output configuration
- Field types: StrInput, IntInput, SecretStrInput, BoolInput, etc.
- Component templates and parameters
- LangChain integration

### 3. Langflow Custom Components
- Creating custom Python components
- Component class structure
- Build method implementation
- Standard library only (no pip packages)

### 4. Langflow Flow Patterns
- Proven AI architectural patterns
- 5 patterns: Chat, RAG, Agent, API Integration, Multi-Agent
- Component connection best practices

### 5. Langflow Build Expert
- Build process validation
- Error interpretation and fixing
- Build event streaming
- Common failure patterns

### 6. Langflow Agent Patterns
- Multi-agent architectures
- Tool-calling patterns
- Memory management
- RAG implementation

## Key API Endpoints

The Langflow REST API provides these core endpoints:

### Flow Management
- `POST /api/v1/flows/` - Create new flows
- `GET /api/v1/flows/` - List flows
- `GET /api/v1/flows/{id}` - Get flow details
- `PATCH /api/v1/flows/{id}` - Update flow
- `DELETE /api/v1/flows/{id}` - Delete flow

### Build Process
- `POST /v1/build/{flow_id}/flow` - Start build
- `GET /v1/build/{job_id}/events` - Stream build events
- `POST /v1/build/{job_id}/cancel` - Cancel build

### Execution
- `POST /run` - Execute flow with inputs/tweaks
- Supports session management
- Returns outputs, artifacts, logs

### Components
- Component types discovered through API or docs
- Components configured via flow data structure
- Python-based with LangChain integration

## Important Patterns

### Common API Pattern
```
1. Create flow (POST /api/v1/flows/)
2. Build flow (POST /v1/build/{flow_id}/flow)
3. Monitor build (GET /v1/build/{job_id}/events)
4. Execute flow (POST /run)
```

### Component Structure
```python
class CustomComponent(Component):
    display_name = "Component Name"
    description = "Component description"

    inputs = [
        StrInput(name="input_name", display_name="Input Label"),
        # ... more inputs
    ]

    def build(self):
        # Build logic
        return result
```

### Flow Data Structure
```json
{
  "name": "Flow Name",
  "data": {
    "nodes": [
      {
        "id": "ComponentType-uuid",
        "type": "genericNode",
        "data": {
          "type": "ComponentType",
          "node": {
            "template": {
              "param_name": {"value": "param_value"}
            }
          }
        }
      }
    ],
    "edges": [
      {
        "source": "source-id",
        "target": "target-id",
        "sourceHandle": "output_name",
        "targetHandle": "input_name"
      }
    ]
  }
}
```

## Working with This Repository

### When Adding New Skills
1. Create skill directory under `skills/`
2. Write SKILL.md with frontmatter
3. Add reference files as needed
4. Create 3+ evaluations in `evaluations/`
5. Test against real Langflow instance

### Skill Activation
Skills activate automatically when queries match their description triggers:
- "How do I use the Langflow API?" → Langflow API Expert
- "Configure OpenAI component" → Langflow Component Configuration
- "Build a RAG app" → Langflow Flow Patterns + Langflow Agent Patterns
- "Build failed" → Langflow Build Expert
- "Create custom component" → Langflow Custom Components

### Cross-Skill Integration
Skills are designed to work together:
- Use Langflow API Expert to understand endpoints
- Use Langflow Flow Patterns to identify architecture
- Use Langflow Component Configuration for setup
- Use Langflow Custom Components for extensions
- Use Langflow Build Expert to validate
- Use Langflow Agent Patterns for AI-specific patterns

## Requirements

- Langflow installed and running
- API key configured
- Claude Code, Claude.ai, or Claude API access
- Understanding of Python and LLM concepts

## Distribution

Available as:
1. **GitHub Repository**: Full source code and documentation
2. **Manual Installation**: Copy to ~/.claude/skills/

## Credits

**Adapted by**: Liz (Chrysaliz333)
**Originally Conceived by**: Romuald Członkowski - [www.aiadvisors.pl/en](https://www.aiadvisors.pl/en)
**Original Project**: [n8n-skills](https://github.com/czlonkowski/n8n-skills)

## Writing Style

### Anti-AI-Voice Rules

**NEVER use these words in any documentation, commit messages, or skill content:**
- "production-ready", "robust", "scalable", "streamline", "leverage"
- "cutting-edge", "best-in-class", "enterprise-grade", "world-class"
- "innovative", "empower", "synergy", "holistic"
- "comprehensive solution", "game-changing"

**NEVER use these phrases:**
- "It's important to note", "It's worth mentioning"
- "Great question!", "Absolutely!", "Fantastic"
- "depending on your specific use case"

**DO instead:**
- Write plainly and directly
- State facts without marketing language
- Use specific nouns over abstract ones
- Keep it conversational but professional

## License

MIT License - See LICENSE file for details.

## Development Notes

### Key Differences from n8n-skills
1. **REST API** instead of MCP server
2. **Python-centric** (no JavaScript alternative)
3. **Build process** is critical
4. **AI-focused** patterns (agents, RAG, etc.)
5. **Component-based** instead of node-based

### Testing Against Langflow
- Requires running Langflow instance
- API key for authentication
- Test flows should be simple and self-contained
- Clean up test flows after evaluations

### Documentation Sources
- https://docs.langflow.org - Official Langflow docs
- https://github.com/langflow-ai/langflow - Source code
- Context7 documentation (use when developing)
