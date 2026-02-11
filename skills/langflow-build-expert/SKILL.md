---
name: langflow-build-expert
description: Interpret build errors and guide fixing in Langflow. Use when build fails, debugging flow errors, validation issues, component configuration errors, or understanding build events. Provides build workflow, error catalog, and fix patterns.
---

# Langflow Build Expert

Expert guide for understanding and fixing Langflow build errors.

---

## Build Process Overview

### Build Workflow

```
1. POST /api/v1/build/{flow_id}/flow
   ↓
2. Receive job_id
   ↓
3. GET /api/v1/build/{job_id}/events (poll or stream)
   ↓
4. Monitor events:
   - build_started
   - component_validated
   - build_error (if error)
   - build_complete (success)
   ↓
5. Ready to execute (POST /api/v1/run/{flow_id})
```

### Why Build is Required

The build process:
- Validates all component configurations
- Resolves component dependencies
- Initializes LangChain objects
- Checks for connection errors
- Prepares the flow for execution

**Without building, flows cannot execute.**

---

## Build Events

### Event Types

```json
// 1. Build Started
{
  "event": "build_started",
  "timestamp": "2024-01-15T10:00:00Z",
  "flow_id": "flow-uuid"
}

// 2. Component Validation
{
  "event": "component_validated",
  "component_id": "OpenAIModel-1",
  "status": "success"
}

// 3. Build Error
{
  "event": "build_error",
  "component_id": "VectorStore-1",
  "error": "Missing required field: index_name",
  "details": {...}
}

// 4. Build Complete
{
  "event": "build_complete",
  "timestamp": "2024-01-15T10:00:05Z",
  "status": "success",
  "duration": "5.2s"
}
```

### Streaming Build Events

```bash
# Stream build events in real-time
curl -X GET "$LANGFLOW_URL/api/v1/build/$JOB_ID/events" \
  -H "x-api-key: $LANGFLOW_API_KEY" \
  -N  # Enable streaming
```

---

## Common Build Errors

### Error 1: Missing Required Field

**Error Message:**
```
BuildError: Missing required field: 'api_key' in component OpenAIModel-1
```

**Cause:** Required component input not provided

**Fix:**
```json
// Add the missing field to component template
{
  "id": "OpenAIModel-1",
  "data": {
    "type": "OpenAIModel",
    "node": {
      "template": {
        "api_key": {"value": "OPENAI_API_KEY"},  // ✅ Added
        "model_name": {"value": "gpt-4"}
      }
    }
  }
}
```

---

### Error 2: Invalid Connection

**Error Message:**
```
BuildError: Cannot connect ChatInput.data to OpenAIModel.input - type mismatch
```

**Cause:** Incompatible input/output types

**Fix:**
```json
// WRONG - data output to message input
{
  "source": "ChatInput-1",
  "sourceHandle": "data",
  "target": "OpenAIModel-1",
  "targetHandle": "input"
}

// CORRECT - message output to input
{
  "source": "ChatInput-1",
  "sourceHandle": "message",  // ✅ Correct handle
  "target": "OpenAIModel-1",
  "targetHandle": "input"
}
```

---

### Error 3: Component Not Found

**Error Message:**
```
BuildError: Component type 'OpenAI' not found
```

**Cause:** Incorrect component type name

**Fix:**
```json
// WRONG - Abbreviated name
{
  "type": "OpenAI"  // ❌
}

// CORRECT - Full component name
{
  "type": "OpenAIModel"  // ✅
}
```

---

### Error 4: Missing Environment Variable

**Error Message:**
```
BuildError: Environment variable 'OPENAI_API_KEY' not found
```

**Cause:** Referenced env var doesn't exist

**Fix:**
```bash
# Set the environment variable
export OPENAI_API_KEY="sk-..."

# Or update .env file
echo "OPENAI_API_KEY=sk-..." >> .env
```

---

### Error 5: Invalid Parameter Value

**Error Message:**
```
BuildError: Invalid value for 'temperature': must be between 0 and 2
```

**Cause:** Parameter outside allowed range

**Fix:**
```json
// WRONG - Value out of range
{
  "temperature": {"value": 3.0}  // ❌
}

// CORRECT - Within valid range
{
  "temperature": {"value": 0.7}  // ✅
}
```

---

### Error 6: Circular Dependency

**Error Message:**
```
BuildError: Circular dependency detected: A → B → C → A
```

**Cause:** Components reference each other in a loop

**Fix:**
```json
// WRONG - Circular reference
edges: [
  {"source": "A", "target": "B"},
  {"source": "B", "target": "C"},
  {"source": "C", "target": "A"}  // ❌ Creates loop
]

// CORRECT - Linear or DAG structure
edges: [
  {"source": "A", "target": "B"},
  {"source": "B", "target": "C"},
  {"source": "C", "target": "D"}  // ✅ No loop
]
```

---

### Error 7: Missing Component Dependency

**Error Message:**
```
BuildError: Component 'VectorStore-1' requires 'Embeddings' connection
```

**Cause:** Required input not connected

**Fix:**
```json
// Add the missing connection
{
  "source": "Embeddings-1",
  "target": "VectorStore-1",
  "targetHandle": "embedding"  // ✅ Connect required input
}
```

---

### Error 8: Invalid JSON Structure

**Error Message:**
```
BuildError: Invalid flow data structure: missing 'nodes' field
```

**Cause:** Malformed flow JSON

**Fix:**
```json
// WRONG - Missing required fields
{
  "name": "My Flow"
  // ❌ Missing "data" field
}

// CORRECT - Complete structure
{
  "name": "My Flow",
  "data": {
    "nodes": [],
    "edges": []
  }
}
```

---

## Build Validation Strategies

### Strategy 1: Incremental Build

Build flow step-by-step:

```bash
# 1. Build with start component only
curl -X POST "$URL/api/v1/build/$FLOW_ID/flow" \
  -H "x-api-key: $KEY" \
  -d '{
    "data": {
      "start_component_id": "ChatInput-1",
      "stop_component_id": "ChatInput-1"
    }
  }'

# 2. Add next component and rebuild
# 3. Continue until full flow builds
```

### Strategy 2: Component Isolation

Test each component individually:

```bash
# Build single component
curl -X POST "$URL/api/v1/build/$FLOW_ID/vertices/ComponentID/post" \
  -H "x-api-key: $KEY"
```

### Strategy 3: Pre-flight Validation

Validate before building:

1. Check all required fields present
2. Verify environment variables exist
3. Confirm edge connections are valid
4. Test with minimal configuration first

---

## Build Parameters

### Control Build Process

```bash
curl -X POST "$URL/api/v1/build/$FLOW_ID/flow" \
  -H "x-api-key: $KEY" \
  -d '{
    "stop_component_id": "VectorStore-1",  # Stop at specific component
    "start_component_id": "ChatInput-1",   # Start from specific component
    "log_builds": true,                     # Enable build logging
    "flow_name": "Test Build"               # Override flow name
  }'
```

---

## Debugging Workflow

### Step 1: Identify Error Component

```bash
# Get build events
curl -X GET "$URL/api/v1/build/$JOB_ID/events" \
  -H "x-api-key: $KEY"

# Look for error event:
{
  "event": "build_error",
  "component_id": "OpenAIModel-1",  # ← Problem component
  "error": "Missing api_key"
}
```

### Step 2: Check Component Configuration

```bash
# Get flow details
curl -X GET "$URL/api/v1/flows/$FLOW_ID" \
  -H "x-api-key: $KEY"

# Verify component template has all required fields
```

### Step 3: Fix Configuration

```bash
# Update flow with fix
curl -X PUT "$URL/api/v1/flows/$FLOW_ID" \
  -H "Content-Type: application/json" \
  -H "x-api-key: $KEY" \
  -d '{
    "data": {
      "nodes": [...],  # Fixed configuration
      "edges": [...]
    }
  }'
```

### Step 4: Rebuild

```bash
# Trigger new build
curl -X POST "$URL/api/v1/build/$FLOW_ID/flow" \
  -H "x-api-key: $KEY"
```

---

## Error Patterns by Component Type

### OpenAI Model Errors
- Missing `api_key`
- Invalid `model_name`
- `temperature` out of range (0-2)
- `max_tokens` exceeds limit

### Vector Store Errors
- Missing `index_name`
- Missing `embedding` connection
- Invalid `search_type`
- Connection timeout

### Agent Errors
- No tools connected
- Missing LLM connection
- Invalid tool configuration

### Chat Components
- Missing `message` input
- Invalid session_id format

---

## Build Performance

### Typical Build Times

| Flow Complexity | Build Time |
|-----------------|------------|
| Simple (3 components) | 1-2 seconds |
| Medium (5-10 components) | 3-5 seconds |
| Complex (10+ components) | 5-10 seconds |
| With external APIs | 10-20 seconds |

### Optimization Tips

1. **Cache vector stores**: Enable caching in config
2. **Use minimal builds**: Only build changed components
3. **Parallel processing**: Build independent branches concurrently
4. **Pre-validate**: Check config before building

---

## Common Fixes

### Fix 1: Add Missing API Key

```json
{
  "template": {
    "api_key": {"value": "OPENAI_API_KEY"}
  }
}
```

### Fix 2: Correct Edge Connection

```json
{
  "source": "ChatInput-1",
  "sourceHandle": "message",  // Use correct handle
  "target": "OpenAIModel-1",
  "targetHandle": "input"
}
```

### Fix 3: Set Environment Variable

```bash
export LANGFLOW_ENV_VAR="value"
# or add to .env file
```

### Fix 4: Fix Component Type

```json
{
  "type": "OpenAIModel"  // Full, correct name
}
```

### Fix 5: Add Required Connection

```json
{
  "edges": [
    {
      "source": "Embeddings-1",
      "target": "VectorStore-1",
      "targetHandle": "embedding"
    }
  ]
}
```

---

## Best Practices

### 1. Build After Every Change
```bash
# Update flow
PUT /api/v1/flows/{id}

# Rebuild immediately
POST /api/v1/build/{flow_id}/flow
```

### 2. Monitor Build Events
```bash
# Don't just wait - watch events
GET /api/v1/build/{job_id}/events
```

### 3. Use Incremental Builds
```bash
# Build one component at a time
POST /api/v1/build/{flow_id}/vertices/{vertex_id}
```

### 4. Log Build Details
```json
{
  "log_builds": true  // Enable detailed logging
}
```

---

## Troubleshooting Checklist

- [ ] All required fields provided?
- [ ] Environment variables set?
- [ ] Edge connections use correct handles?
- [ ] Component types spelled correctly?
- [ ] No circular dependencies?
- [ ] Parameters within valid ranges?
- [ ] Required components connected?
- [ ] JSON structure valid?

---

## Further Reading

- Use `langflow-api-expert` for build endpoints
- Use `langflow-component-config` for field requirements
- Use `langflow-flow-patterns` for correct architectures
- [Langflow Build API](https://docs.langflow.org/api-reference-api-examples)
