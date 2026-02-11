---
name: langflow-flow-patterns
description: Build flows using proven AI architectural patterns. Use when creating flows, designing AI applications, implementing agents, building chat systems, RAG applications, or multi-agent workflows. Provides pattern selection guidance and component connection best practices.
---

# Langflow Flow Patterns

Expert guide for building Langflow flows using proven AI architectural patterns.

---

## The 5 Core Patterns

### 1. **Chat Application** - Simple Conversational AI
### 2. **RAG (Retrieval Augmented Generation)** - Knowledge-Enhanced Chat
### 3. **Agent Workflow** - Tool-Using AI
### 4. **API Integration** - External Service Integration
### 5. **Multi-Agent System** - Collaborative AI Agents

---

## Pattern 1: Chat Application

### When to Use
- Simple Q&A chatbot
- Customer support
- General conversation
- No external knowledge required

### Components Needed
- `ChatInput` - User message input
- `OpenAIModel` or `AnthropicModel` - LLM
- `ChatOutput` - Display response

### Basic Structure

```json
{
  "name": "Simple Chat",
  "data": {
    "nodes": [
      {
        "id": "ChatInput-1",
        "type": "genericNode",
        "data": {
          "type": "ChatInput",
          "node": {"template": {}}
        }
      },
      {
        "id": "OpenAIModel-1",
        "type": "genericNode",
        "data": {
          "type": "OpenAIModel",
          "node": {
            "template": {
              "model_name": {"value": "gpt-4"},
              "api_key": {"value": "OPENAI_API_KEY"},
              "temperature": {"value": 0.7}
            }
          }
        }
      },
      {
        "id": "ChatOutput-1",
        "type": "genericNode",
        "data": {
          "type": "ChatOutput",
          "node": {"template": {}}
        }
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
}
```

### With Memory

Add `ConversationBufferMemory` for conversation history:

```json
{
  "nodes": [
    {"id": "ChatInput-1", "type": "genericNode", "data": {"type": "ChatInput"}},
    {"id": "Memory-1", "type": "genericNode", "data": {"type": "ConversationBufferMemory"}},
    {"id": "OpenAIModel-1", "type": "genericNode", "data": {"type": "OpenAIModel"}},
    {"id": "ChatOutput-1", "type": "genericNode", "data": {"type": "ChatOutput"}}
  ],
  "edges": [
    {"source": "ChatInput-1", "target": "OpenAIModel-1"},
    {"source": "Memory-1", "target": "OpenAIModel-1"},
    {"source": "OpenAIModel-1", "target": "ChatOutput-1"}
  ]
}
```

---

## Pattern 2: RAG (Retrieval Augmented Generation)

### When to Use
- Document-based Q&A
- Knowledge base search
- Context-aware responses
- Technical documentation assistant

### Components Needed
- `ChatInput` - User query
- `VectorStore` (Pinecone, Chroma, etc.) - Document storage
- `Embeddings` - Text embedding model
- `OpenAIModel` - LLM for generation
- `ChatOutput` - Display response

### Basic RAG Structure

```json
{
  "name": "RAG Application",
  "data": {
    "nodes": [
      {
        "id": "ChatInput-1",
        "type": "genericNode",
        "data": {"type": "ChatInput"}
      },
      {
        "id": "Embeddings-1",
        "type": "genericNode",
        "data": {
          "type": "OpenAIEmbeddings",
          "node": {
            "template": {
              "api_key": {"value": "OPENAI_API_KEY"}
            }
          }
        }
      },
      {
        "id": "VectorStore-1",
        "type": "genericNode",
        "data": {
          "type": "Pinecone",
          "node": {
            "template": {
              "index_name": {"value": "my-knowledge-base"},
              "search_query": {"value": ""},
              "number_of_results": {"value": 5}
            }
          }
        }
      },
      {
        "id": "OpenAIModel-1",
        "type": "genericNode",
        "data": {
          "type": "OpenAIModel",
          "node": {
            "template": {
              "model_name": {"value": "gpt-4"}
            }
          }
        }
      },
      {
        "id": "ChatOutput-1",
        "type": "genericNode",
        "data": {"type": "ChatOutput"}
      }
    ],
    "edges": [
      {
        "source": "ChatInput-1",
        "target": "VectorStore-1",
        "sourceHandle": "message",
        "targetHandle": "search_query"
      },
      {
        "source": "Embeddings-1",
        "target": "VectorStore-1"
      },
      {
        "source": "VectorStore-1",
        "target": "OpenAIModel-1",
        "sourceHandle": "search_results",
        "targetHandle": "context"
      },
      {
        "source": "ChatInput-1",
        "target": "OpenAIModel-1",
        "sourceHandle": "message",
        "targetHandle": "input"
      },
      {
        "source": "OpenAIModel-1",
        "target": "ChatOutput-1"
      }
    ]
  }
}
```

### RAG Best Practices

1. **Chunk Size**: Use 500-1000 tokens per chunk
2. **Overlap**: 10-20% overlap between chunks
3. **Number of Results**: 3-5 documents typically optimal
4. **Prompt Engineering**: Include "Answer based on the following context..."

---

## Pattern 3: Agent Workflow

### When to Use
- Tool-calling AI
- Multi-step tasks
- Web search + answer
- Database query + analysis

### Components Needed
- `ChatInput` - User request
- `Agent` - Tool orchestrator
- Custom tools (Calculator, WebSearch, Database, etc.)
- `ChatOutput` - Display result

### Agent Structure

```json
{
  "name": "Tool-Using Agent",
  "data": {
    "nodes": [
      {
        "id": "ChatInput-1",
        "type": "genericNode",
        "data": {"type": "ChatInput"}
      },
      {
        "id": "Calculator-1",
        "type": "genericNode",
        "data": {
          "type": "Calculator",
          "node": {
            "template": {
              "tool_mode": {"value": true}
            }
          }
        }
      },
      {
        "id": "WebSearch-1",
        "type": "genericNode",
        "data": {
          "type": "SerpAPI",
          "node": {
            "template": {
              "api_key": {"value": "SERP_API_KEY"},
              "tool_mode": {"value": true}
            }
          }
        }
      },
      {
        "id": "Agent-1",
        "type": "genericNode",
        "data": {
          "type": "Agent",
          "node": {
            "template": {
              "llm": {"value": ""},
              "tools": {"value": []}
            }
          }
        }
      },
      {
        "id": "OpenAIModel-1",
        "type": "genericNode",
        "data": {
          "type": "OpenAIModel",
          "node": {
            "template": {
              "model_name": {"value": "gpt-4"}
            }
          }
        }
      },
      {
        "id": "ChatOutput-1",
        "type": "genericNode",
        "data": {"type": "ChatOutput"}
      }
    ],
    "edges": [
      {"source": "ChatInput-1", "target": "Agent-1"},
      {"source": "OpenAIModel-1", "target": "Agent-1", "targetHandle": "llm"},
      {"source": "Calculator-1", "target": "Agent-1", "targetHandle": "tools"},
      {"source": "WebSearch-1", "target": "Agent-1", "targetHandle": "tools"},
      {"source": "Agent-1", "target": "ChatOutput-1"}
    ]
  }
}
```

---

## Pattern 4: API Integration

### When to Use
- Third-party service calls
- Data transformation pipelines
- External API enrichment

### Components Needed
- `ChatInput` or `TextInput` - Request input
- `HTTPRequest` or custom API component - API call
- `CustomComponent` - Data processing
- `ChatOutput` or `TextOutput` - Response

### API Integration Structure

```json
{
  "name": "API Integration",
  "data": {
    "nodes": [
      {
        "id": "TextInput-1",
        "type": "genericNode",
        "data": {"type": "TextInput"}
      },
      {
        "id": "HTTPRequest-1",
        "type": "genericNode",
        "data": {
          "type": "HTTPRequest",
          "node": {
            "template": {
              "method": {"value": "GET"},
              "url": {"value": "https://api.example.com/data"},
              "headers": {"value": {"Authorization": "Bearer TOKEN"}}
            }
          }
        }
      },
      {
        "id": "DataProcessor-1",
        "type": "genericNode",
        "data": {"type": "CustomComponent"}
      },
      {
        "id": "TextOutput-1",
        "type": "genericNode",
        "data": {"type": "TextOutput"}
      }
    ],
    "edges": [
      {"source": "TextInput-1", "target": "HTTPRequest-1"},
      {"source": "HTTPRequest-1", "target": "DataProcessor-1"},
      {"source": "DataProcessor-1", "target": "TextOutput-1"}
    ]
  }
}
```

---

## Pattern 5: Multi-Agent System

### When to Use
- Complex task decomposition
- Specialized agent roles
- Collaborative problem-solving

### Components Needed
- `ChatInput` - User request
- Multiple `Agent` components - Specialized agents
- `Coordinator` - Agent orchestration
- `ChatOutput` - Final result

### Multi-Agent Structure

```json
{
  "name": "Multi-Agent System",
  "data": {
    "nodes": [
      {
        "id": "ChatInput-1",
        "type": "genericNode",
        "data": {"type": "ChatInput"}
      },
      {
        "id": "ResearchAgent-1",
        "type": "genericNode",
        "data": {
          "type": "Agent",
          "node": {
            "template": {
              "agent_description": {"value": "Researches information"}
            }
          }
        }
      },
      {
        "id": "AnalysisAgent-1",
        "type": "genericNode",
        "data": {
          "type": "Agent",
          "node": {
            "template": {
              "agent_description": {"value": "Analyzes data"}
            }
          }
        }
      },
      {
        "id": "WriterAgent-1",
        "type": "genericNode",
        "data": {
          "type": "Agent",
          "node": {
            "template": {
              "agent_description": {"value": "Writes reports"}
            }
          }
        }
      },
      {
        "id": "Coordinator-1",
        "type": "genericNode",
        "data": {"type": "CustomComponent"}
      },
      {
        "id": "ChatOutput-1",
        "type": "genericNode",
        "data": {"type": "ChatOutput"}
      }
    ],
    "edges": [
      {"source": "ChatInput-1", "target": "Coordinator-1"},
      {"source": "Coordinator-1", "target": "ResearchAgent-1"},
      {"source": "ResearchAgent-1", "target": "AnalysisAgent-1"},
      {"source": "AnalysisAgent-1", "target": "WriterAgent-1"},
      {"source": "WriterAgent-1", "target": "ChatOutput-1"}
    ]
  }
}
```

---

## Flow Creation Checklist

### Planning Phase
- [ ] Identify use case and pattern
- [ ] List required components
- [ ] Design data flow
- [ ] Plan error handling

### Implementation Phase
- [ ] Create flow via API or UI
- [ ] Configure all components
- [ ] Connect components (edges)
- [ ] Set environment variables for secrets

### Testing Phase
- [ ] Build flow
- [ ] Test with sample inputs
- [ ] Validate outputs
- [ ] Check error handling

### Production Phase
- [ ] Enable session management
- [ ] Monitor performance
- [ ] Log interactions
- [ ] Plan for scaling

---

## Connection Best Practices

### 1. Component Compatibility

Match output and input types:

```json
// CORRECT - Compatible types
{
  "source": "ChatInput-1",
  "sourceHandle": "message",     // Outputs: Message
  "target": "OpenAIModel-1",
  "targetHandle": "input"         // Expects: Message/Text
}

// WRONG - Incompatible types
{
  "source": "DataProcessor-1",
  "sourceHandle": "data",         // Outputs: Data
  "target": "ChatOutput-1",
  "targetHandle": "message"       // Expects: Message
}
```

### 2. Sequential vs Parallel

```json
// Sequential processing
[
  {"source": "A", "target": "B"},
  {"source": "B", "target": "C"},
  {"source": "C", "target": "D"}
]

// Parallel processing
[
  {"source": "A", "target": "B"},
  {"source": "A", "target": "C"},
  {"source": "A", "target": "D"}
]
```

### 3. Multiple Inputs

```json
// Component with multiple inputs
[
  {
    "source": "ChatInput-1",
    "target": "OpenAIModel-1",
    "targetHandle": "input"
  },
  {
    "source": "Memory-1",
    "target": "OpenAIModel-1",
    "targetHandle": "chat_history"
  },
  {
    "source": "VectorStore-1",
    "target": "OpenAIModel-1",
    "targetHandle": "context"
  }
]
```

---

## Pattern Selection Guide

| Use Case | Pattern | Key Components |
|----------|---------|----------------|
| Customer support chat | Chat Application | ChatInput, LLM, ChatOutput |
| Document Q&A | RAG | VectorStore, Embeddings, LLM |
| Web search + answer | Agent Workflow | Agent, WebSearch tool, LLM |
| Data pipeline | API Integration | HTTPRequest, Processors |
| Research report | Multi-Agent | Multiple Agents, Coordinator |
| Content moderation | API Integration | LLM, Custom rules |
| Translation service | Chat Application | ChatInput, LLM, ChatOutput |
| Code assistant | RAG + Agent | VectorStore, Code tools, LLM |

---

## Common Mistakes

### Mistake 1: Wrong Pattern for Use Case

```
// WRONG - Using simple chat for knowledge-based Q&A
ChatInput → OpenAIModel → ChatOutput

// CORRECT - Use RAG pattern
ChatInput → VectorStore → OpenAIModel → ChatOutput
               ↑
         Embeddings
```

### Mistake 2: Missing Session Management

```json
// WRONG - No session tracking
{
  "input_value": "What did I ask before?"
}

// CORRECT - Use session_id
{
  "input_value": "What did I ask before?",
  "session_id": "user_123_session"
}
```

### Mistake 3: Incorrect Edge Handles

```json
// WRONG - Invalid handle names
{
  "source": "ChatInput-1",
  "sourceHandle": "output",  // ChatInput uses "message"
  "target": "OpenAIModel-1"
}

// CORRECT
{
  "source": "ChatInput-1",
  "sourceHandle": "message",
  "target": "OpenAIModel-1",
  "targetHandle": "input"
}
```

---

## Best Practices

### 1. Start Simple, Then Enhance
```
1. Build basic flow
2. Test core functionality
3. Add memory/context
4. Add error handling
5. Optimize performance
```

### 2. Use Environment Variables
```json
{
  "template": {
    "api_key": {"value": "OPENAI_API_KEY"},  // Not hardcoded
    "pinecone_key": {"value": "PINECONE_KEY"}
  }
}
```

### 3. Enable Streaming for Chat
```bash
# Stream responses for better UX
curl -X POST "$URL/api/v1/run/$FLOW_ID?stream=true" \
  -H "x-api-key: $KEY" \
  -d '{"input_value": "Tell me a story"}'
```

### 4. Plan for Scaling
- Use caching for vector stores
- Implement rate limiting
- Monitor token usage
- Log failures for debugging

---

## Real-World Examples

### Example 1: Technical Documentation Assistant (RAG)

```
ChatInput → [
  → VectorStore (docs) →
  → Retrieval →
  → Context
] → OpenAIModel → ChatOutput
```

### Example 2: Customer Support Bot (Agent)

```
ChatInput → Agent → [
  → FAQ Tool
  → Ticket Creation Tool
  → Knowledge Base Search
] → Response → ChatOutput
```

### Example 3: Content Generation Pipeline (Multi-Agent)

```
ChatInput → [
  → Research Agent (web search)
  → Writer Agent (draft)
  → Editor Agent (refine)
] → Final Content → ChatOutput
```

---

## Further Reading

- Use `langflow-api-expert` for flow creation via API
- Use `langflow-agent-patterns` for advanced agent architectures
- Use `langflow-component-config` for component setup
- [Langflow Templates](https://docs.langflow.org/templates)
