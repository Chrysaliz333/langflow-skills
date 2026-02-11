# n8n to Langflow Skills Migration Analysis

## Architecture Comparison

### n8n
- **Type**: Workflow automation platform
- **Focus**: General automation, 800+ integration nodes
- **Interface**: MCP server (n8n-mcp) for programmatic access
- **Language**: JavaScript/Python code nodes
- **Data Access**: `{{ }}` expression syntax (`$json`, `$node`, `$input`)
- **Execution**: Direct workflow execution
- **Templates**: 2,653+ workflows

### Langflow
- **Type**: Visual AI application builder
- **Focus**: AI agents, LLM workflows, RAG applications
- **Interface**: REST API for programmatic access
- **Language**: Python-based components
- **Data Access**: Python native (component inputs/outputs)
- **Execution**: Build step → Execute
- **Components**: ChatInput, OpenAIModel, etc.

## Terminology Mapping

| n8n | Langflow |
|-----|----------|
| Node | Component |
| Workflow | Flow |
| Expression `{{ }}` | Python code |
| n8n-mcp server | REST API |
| Template | Flow template |
| Node type | Component type |
| Connection | Edge |
| $json, $node | Component inputs |
| Code node | Custom component |

## Skills Adaptation Strategy

### 1. n8n Expression Syntax → **SKIP**
**Reason**: Langflow doesn't use expression syntax. Data is passed via Python component inputs/outputs.
**Alternative**: Merge into component configuration guidance.

### 2. n8n MCP Tools Expert → **Langflow API Expert**
**Changes**:
- Replace MCP tool calls with REST API endpoints
- Document API authentication (x-api-key)
- Cover: `/api/v1/flows/`, `/api/v1/build/`, `/run`
- Tool selection → Endpoint selection
- `search_nodes` → Component type discovery
- `validate_node` → Build validation

### 3. n8n Workflow Patterns → **Langflow Flow Patterns**
**Changes**:
- Webhook processing → Chat input flows
- HTTP API → API integration components
- Database → Vector store patterns
- **AI Agent** patterns (central to Langflow)
- Scheduled tasks → Flow triggers

### 4. n8n Validation Expert → **Langflow Build Expert**
**Changes**:
- Focus on build process validation
- `/v1/build/{flow_id}/flow` endpoint
- Build events streaming
- Common build errors
- Component configuration validation

### 5. n8n Node Configuration → **Langflow Component Configuration**
**Changes**:
- Component inputs/outputs
- Python field types (StrInput, IntInput, SecretStrInput, etc.)
- Component templates
- Input validation
- Real-time refresh fields

### 6. n8n Code JavaScript → **SKIP**
**Reason**: Langflow is Python-based.
**Alternative**: Merge into custom component patterns.

### 7. n8n Code Python → **Langflow Custom Components**
**Changes**:
- Focus on creating custom components
- Component class structure
- Input/output definitions
- `build()` method patterns
- Integration with LangChain/LangGraph
- Standard library usage (same constraints apply)

## New Skills Required

### 1. Langflow Component Development
- Creating custom components
- Component class structure
- Field types and inputs
- Build method implementation
- LangChain integration patterns

### 2. Langflow Agent Patterns
- Multi-agent workflows
- Tool-calling patterns
- Memory management
- Human-in-the-loop
- RAG implementation

### 3. Langflow API Integration
- REST API endpoints
- Authentication patterns
- Flow CRUD operations
- Build and execution
- Session management

## Implementation Order

1. ✅ **Langflow API Expert** (Foundation - replaces MCP tools)
2. ✅ **Langflow Component Configuration** (Core skill)
3. ✅ **Langflow Custom Components** (Python development)
4. ✅ **Langflow Flow Patterns** (Architecture patterns)
5. ✅ **Langflow Build Expert** (Validation and debugging)
6. ✅ **Langflow Agent Patterns** (AI-specific patterns)

## Key Differences to Address

### 1. No Expression Syntax
n8n's `{{ $json.body }}` → Langflow's Python: `self.input_value`

### 2. Component-Based Architecture
- Components inherit from base classes
- Inputs are defined declaratively
- Build method returns constructed objects

### 3. Build Process
- Flows must be built before execution
- Build can fail with validation errors
- Build events can be streamed

### 4. AI-Centric
- LangChain integration is core
- Agent patterns are primary use case
- Vector stores, embeddings, LLMs are first-class

### 5. Python-Native
- No JavaScript alternative
- Standard library only (no pip packages in runtime)
- Type hints and Pydantic models

## Testing Strategy

Each adapted skill needs evaluations for:
1. API endpoint usage
2. Component configuration
3. Build process validation
4. Common error scenarios
5. Pattern implementation

## Files to Modify

```
langflow-skills/
├── README.md                    # Update for Langflow
├── CLAUDE.md                    # Update project context
├── MIGRATION_ANALYSIS.md        # This file
├── skills/
│   ├── langflow-api-expert/           # NEW
│   ├── langflow-component-config/     # ADAPTED
│   ├── langflow-custom-components/    # ADAPTED
│   ├── langflow-flow-patterns/        # ADAPTED
│   ├── langflow-build-expert/         # ADAPTED
│   └── langflow-agent-patterns/       # NEW
└── evaluations/
    ├── langflow-api-expert/
    ├── langflow-component-config/
    ├── langflow-custom-components/
    ├── langflow-flow-patterns/
    ├── langflow-build-expert/
    └── langflow-agent-patterns/
```

## Next Steps

1. Create Langflow API Expert skill (foundation)
2. Adapt component configuration guidance
3. Create custom component development skill
4. Adapt flow patterns for AI use cases
5. Create build/validation expert skill
6. Add agent-specific patterns skill
7. Update all documentation and examples
8. Create comprehensive evaluations
9. Test against real Langflow instance
