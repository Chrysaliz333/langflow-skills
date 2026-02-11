---
name: langflow-api-expert
description: Expert guide for using Langflow's REST API effectively. Use when creating flows, managing components, building workflows, deploying flows, executing flows, or using any Langflow API endpoint. Provides endpoint selection guidance, authentication patterns, and common usage examples.
---

# Langflow API Expert

Master guide for using the Langflow REST API to build AI applications.

---

## API Categories

Langflow's REST API is organized into these categories:

1. **Flow Management** → CRUD operations for flows
2. **Build Process** → Compiling and validating flows
3. **Flow Execution** → Running flows and managing sessions
4. **Component Discovery** → Finding and understanding components

---

## Quick Reference

### Most Common Endpoints

| Endpoint | Use When | Method |
|----------|----------|--------|
| `/api/v1/flows/` | Creating/listing flows | POST, GET |
| `/api/v1/flows/{id}` | Get/update/delete specific flow | GET, PUT, DELETE |
| `/api/v1/build/{flow_id}/flow` | Building a flow | POST |
| `/api/v1/build/{job_id}/events` | Monitoring build progress | GET |
| `/api/v1/run/{flow_id}` | Executing a flow | POST |

---

## Authentication

**All API requests require authentication using an API key.**

### Header Format
```bash
-H "x-api-key: $LANGFLOW_API_KEY"
```

### Obtaining API Key
1. Open Langflow UI
2. Go to Settings → API Keys
3. Create new API key
4. Store securely (shown only once)

---

## Endpoint Selection Guide

### Creating a New Flow

**Workflow**:
```
1. POST /api/v1/flows/ - Create flow with structure
2. POST /api/v1/build/{flow_id}/flow - Build the flow
3. GET /api/v1/build/{job_id}/events - Monitor build
4. POST /api/v1/run/{flow_id} - Execute flow
```

**Example**:
```bash
# Step 1: Create flow
curl -X POST "$LANGFLOW_URL/api/v1/flows/" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "name": "My Chat Flow",
    "description": "Simple chatbot",
    "data": {
      "nodes": [
        {
          "id": "ChatInput-abc123",
          "type": "genericNode",
          "data": {
            "type": "ChatInput",
            "node": {"template": {}}
          }
        }
      ],
      "edges": []
    }
  }'

# Response includes flow_id: "3fa85f64-5717-4562-b3fc-2c963f66afa6"

# Step 2: Build flow
curl -X POST "$LANGFLOW_URL/api/v1/build/3fa85f64-5717-4562-b3fc-2c963f66afa6/flow" \
  -H "x-api-key: $LANGFLOW_API_KEY"

# Response includes job_id: "build_job_123"

# Step 3: Monitor build
curl -X GET "$LANGFLOW_URL/api/v1/build/build_job_123/events" \
  -H "x-api-key: $LANGFLOW_API_KEY"
```

### Updating an Existing Flow

**Workflow**:
```
1. GET /api/v1/flows/{id} - Retrieve current flow
2. PUT /api/v1/flows/{id} - Update flow data
3. POST /api/v1/build/{flow_id}/flow - Rebuild
```

**Example**:
```bash
# Update flow
curl -X PUT "$LANGFLOW_URL/api/v1/flows/3fa85f64-5717-4562-b3fc-2c963f66afa6" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "description": "Updated chatbot with RAG",
    "tags": ["chat", "rag", "production"]
  }'
```

### Executing a Flow

**Workflow**:
```
1. Ensure flow is built
2. POST /api/v1/run/{flow_id} - Execute with inputs
3. (Optional) Use streaming for real-time responses
```

**Example (Non-streaming)**:
```bash
curl -X POST "$LANGFLOW_URL/api/v1/run/3fa85f64-5717-4562-b3fc-2c963f66afa6" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "input_request": {
      "input_value": "Hello, what can you help me with?",
      "session_id": "user_session_123"
    }
  }'
```

**Example (Streaming)**:
```bash
curl -X POST "$LANGFLOW_URL/api/v1/run/3fa85f64-5717-4562-b3fc-2c963f66afa6?stream=true" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "input_request": {
      "input_value": "Tell me a story",
      "session_id": "user_session_123"
    }
  }'
```

---

## Flow Data Structure

### Complete Flow Structure
```json
{
  "name": "Flow Name",
  "description": "Flow description",
  "data": {
    "nodes": [
      {
        "id": "ComponentType-unique-id",
        "type": "genericNode",
        "data": {
          "type": "ComponentType",
          "node": {
            "template": {
              "param_name": {
                "value": "param_value"
              }
            }
          }
        }
      }
    ],
    "edges": [
      {
        "source": "source-node-id",
        "target": "target-node-id",
        "sourceHandle": "output_name",
        "targetHandle": "input_name"
      }
    ]
  },
  "tags": ["tag1", "tag2"]
}
```

### Node Structure
```json
{
  "id": "OpenAIModel-abc123",
  "type": "genericNode",
  "data": {
    "type": "OpenAIModel",
    "node": {
      "template": {
        "model_name": {"value": "gpt-4"},
        "temperature": {"value": 0.7},
        "api_key": {"value": "OPENAI_API_KEY"}
      }
    }
  }
}
```

### Edge Structure (Connections)
```json
{
  "source": "ChatInput-abc123",
  "target": "OpenAIModel-def456",
  "sourceHandle": "message",
  "targetHandle": "input_value"
}
```

---

## Build Process

### Understanding the Build Process

Langflow flows must be built before execution. The build process:
1. Validates component configurations
2. Resolves dependencies
3. Initializes LangChain objects
4. Checks for errors

### Build Endpoint
```
POST /api/v1/build/{flow_id}/flow
```

### Build Events
```
GET /api/v1/build/{job_id}/events
```

Events include:
- `build_started` - Build initiated
- `component_validated` - Component validated
- `build_error` - Error occurred
- `build_complete` - Build finished successfully

### Build Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `stop_component_id` | string | Stop build at specific component |
| `start_component_id` | string | Start build from specific component |
| `log_builds` | boolean | Enable build logging (default: true) |
| `flow_name` | string | Override flow name |

---

## Common Patterns

### Pattern 1: Simple Chat Flow
```bash
# 1. Create flow
curl -X POST "$LANGFLOW_URL/api/v1/flows/" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "name": "Simple Chat",
    "data": {
      "nodes": [
        {
          "id": "ChatInput-1",
          "type": "genericNode",
          "data": {"type": "ChatInput", "node": {"template": {}}}
        },
        {
          "id": "OpenAIModel-1",
          "type": "genericNode",
          "data": {
            "type": "OpenAIModel",
            "node": {
              "template": {
                "model_name": {"value": "gpt-4"},
                "api_key": {"value": "OPENAI_API_KEY"}
              }
            }
          }
        },
        {
          "id": "ChatOutput-1",
          "type": "genericNode",
          "data": {"type": "ChatOutput", "node": {"template": {}}}
        }
      ],
      "edges": [
        {
          "source": "ChatInput-1",
          "target": "OpenAIModel-1",
          "sourceHandle": "message",
          "targetHandle": "input"
        },
        {
          "source": "OpenAIModel-1",
          "target": "ChatOutput-1",
          "sourceHandle": "output",
          "targetHandle": "message"
        }
      ]
    }
  }'

# 2. Build and execute (flow_id from step 1)
curl -X POST "$LANGFLOW_URL/api/v1/build/{flow_id}/flow" \
  -H "x-api-key: $LANGFLOW_API_KEY"

# 3. Run the flow
curl -X POST "$LANGFLOW_URL/api/v1/run/{flow_id}" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "input_request": {
      "input_value": "Hello!",
      "session_id": "chat_session_1"
    }
  }'
```

### Pattern 2: Update Flow with Tweaks
```bash
# Execute with parameter tweaks (without modifying flow)
curl -X POST "$LANGFLOW_URL/api/v1/run/{flow_id}" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "input_request": {
      "input_value": "What is AI?"
    },
    "tweaks": {
      "OpenAIModel-1": {
        "temperature": 0.9,
        "max_tokens": 500
      }
    }
  }'
```

### Pattern 3: Session Management
```bash
# Run 1: Start conversation
curl -X POST "$LANGFLOW_URL/api/v1/run/{flow_id}" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "input_request": {
      "input_value": "My name is Alice",
      "session_id": "user_123_session"
    }
  }'

# Run 2: Continue conversation (same session_id)
curl -X POST "$LANGFLOW_URL/api/v1/run/{flow_id}" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -d '{
    "input_request": {
      "input_value": "What is my name?",
      "session_id": "user_123_session"
    }
  }'
# Response should remember "Alice"
```

---

## Common Mistakes

### Mistake 1: Missing Authentication
**Problem**: 401 Unauthorized error

```bash
# WRONG - No API key
curl -X GET "$LANGFLOW_URL/api/v1/flows/"

# CORRECT
curl -X GET "$LANGFLOW_URL/api/v1/flows/" \
  -H "x-api-key: $LANGFLOW_API_KEY"
```

### Mistake 2: Running Without Building
**Problem**: Flow not initialized

```bash
# WRONG - Execute without building
curl -X POST "$LANGFLOW_URL/api/v1/run/{flow_id}" ...

# CORRECT - Build first
curl -X POST "$LANGFLOW_URL/api/v1/build/{flow_id}/flow" \
  -H "x-api-key: $LANGFLOW_API_KEY"
# Wait for build to complete, then run
curl -X POST "$LANGFLOW_URL/api/v1/run/{flow_id}" ...
```

### Mistake 3: Invalid Node Structure
**Problem**: Build fails with validation errors

```json
// WRONG - Missing required fields
{
  "id": "OpenAI-1",
  "data": {
    "type": "OpenAIModel"
  }
}

// CORRECT - Complete structure
{
  "id": "OpenAIModel-1",
  "type": "genericNode",
  "data": {
    "type": "OpenAIModel",
    "node": {
      "template": {
        "api_key": {"value": "OPENAI_API_KEY"},
        "model_name": {"value": "gpt-4"}
      }
    }
  }
}
```

### Mistake 4: Incorrect Edge Handles
**Problem**: Components not connected

```json
// WRONG - Invalid handle names
{
  "source": "ChatInput-1",
  "target": "OpenAIModel-1",
  "sourceHandle": "output",  // ChatInput uses "message"
  "targetHandle": "text"     // OpenAIModel uses "input"
}

// CORRECT - Use actual component handles
{
  "source": "ChatInput-1",
  "target": "OpenAIModel-1",
  "sourceHandle": "message",
  "targetHandle": "input"
}
```

---

## Response Formats

### Flow Creation Response
```json
{
  "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  "name": "My Flow",
  "description": "Flow description",
  "user_id": "user-uuid",
  "folder_id": "folder-uuid",
  "created_at": "2024-01-15T10:30:00Z",
  "updated_at": "2024-01-15T10:30:00Z"
}
```

### Build Response
```json
{
  "job_id": "build_job_123"
}
```

### Execution Response (Non-streaming)
```json
{
  "outputs": [
    {
      "inputs": {
        "chat": [
          {
            "role": "user",
            "content": "Hello"
          }
        ]
      },
      "outputs": {
        "text": "Hello! How can I help you today?"
      }
    }
  ],
  "session_id": "user_session_123"
}
```

---

## Error Handling

### Common HTTP Status Codes

| Code | Meaning | Common Cause |
|------|---------|--------------|
| 401 | Unauthorized | Missing/invalid API key |
| 404 | Not Found | Invalid flow_id or endpoint |
| 422 | Validation Error | Invalid request body |
| 500 | Internal Error | Build or execution failure |

### Example Error Response
```json
{
  "detail": "Flow not found",
  "status_code": 404
}
```

---

## Best Practices

### 1. Always Build Before Executing
```bash
# Build
POST /api/v1/build/{flow_id}/flow

# Check build events
GET /api/v1/build/{job_id}/events

# Once build is complete, execute
POST /api/v1/run/{flow_id}
```

### 2. Use Session IDs for Conversations
```bash
# Maintain conversation context with consistent session_id
{
  "input_request": {
    "session_id": "unique_session_identifier"
  }
}
```

### 3. Use Tweaks for Testing
```bash
# Test different parameters without modifying flow
{
  "tweaks": {
    "ComponentID": {
      "param_name": "test_value"
    }
  }
}
```

### 4. Handle Streaming Appropriately
```bash
# Use stream=true for real-time responses
POST /api/v1/run/{flow_id}?stream=true

# Use stream=false (default) for complete responses
POST /api/v1/run/{flow_id}
```

---

## Component Discovery

### Finding Component Types
- Check Langflow UI component list
- Refer to Langflow documentation
- Common components: ChatInput, ChatOutput, OpenAIModel, Agent, VectorStore

### Common Component Types
- **Inputs**: ChatInput, TextInput, FileInput
- **Models**: OpenAIModel, AnthropicModel, HuggingFaceModel
- **Outputs**: ChatOutput, TextOutput
- **Tools**: Agent, Chain, VectorStore
- **Memory**: ConversationBufferMemory, VectorStoreMemory

---

## Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| 401 Unauthorized | Check API key in headers |
| Build fails | Check component configurations in flow data |
| No response from run | Ensure flow was built successfully |
| Session not maintained | Use consistent session_id across requests |
| Streaming not working | Add `?stream=true` query parameter |

---

## Further Reading

- [Official Langflow API Docs](https://docs.langflow.org/api)
- [Langflow GitHub](https://github.com/langflow-ai/langflow)
- Use `langflow-component-config` skill for component details
- Use `langflow-build-expert` skill for build troubleshooting
