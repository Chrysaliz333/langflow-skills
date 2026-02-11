---
name: langflow-agent-patterns
description: Advanced AI agent implementation patterns for Langflow. Use when building multi-agent systems, implementing RAG, tool-calling patterns, memory management, human-in-the-loop workflows, or agent collaboration. Provides agent architecture patterns and best practices.
---

# Langflow Agent Patterns

Expert guide for building advanced AI agent systems in Langflow.

---

## Agent Architecture Patterns

### 1. **Single Agent with Tools** - Tool-calling agent
### 2. **Sequential Multi-Agent** - Agent chain
### 3. **Parallel Multi-Agent** - Concurrent agents
### 4. **Hierarchical Multi-Agent** - Supervisor + workers
### 5. **RAG Agent** - Retrieval-augmented agent

---

## Pattern 1: Single Agent with Tools

### When to Use
- Tool-calling workflows
- Calculator, web search, API calls
- Single-purpose specialized agent

### Component Structure

```python
from langflow.base.agents.agent import LCToolsAgentComponent
from langflow.inputs import HandleInput, MessageTextInput, DataInput

class ToolCallingAgent(LCToolsAgentComponent):
    display_name = "Tool Calling Agent"
    description = "Agent that uses tools"
    name = "ToolCallingAgent"

    inputs = [
        HandleInput(
            name="llm",
            display_name="Language Model",
            input_types=["LanguageModel"],
            required=True
        ),
        MessageTextInput(
            name="system_prompt",
            display_name="System Prompt",
            value="You are a helpful assistant that can use tools"
        ),
        HandleInput(
            name="tools",
            display_name="Tools",
            input_types=["Tool"],
            is_list=True
        ),
        DataInput(
            name="chat_history",
            display_name="Chat Memory",
            is_list=True,
            advanced=True
        )
    ]

    def create_agent_runnable(self):
        from langchain.agents import create_tool_calling_agent
        from langchain_core.prompts import ChatPromptTemplate

        messages = [
            ("system", "{system_prompt}"),
            ("placeholder", "{chat_history}"),
            ("human", "{input}"),
            ("placeholder", "{agent_scratchpad}")
        ]
        prompt = ChatPromptTemplate.from_messages(messages)

        return create_tool_calling_agent(
            self.llm,
            self.tools or [],
            prompt
        )
```

### Flow Structure

```json
{
  "name": "Tool-Using Agent",
  "data": {
    "nodes": [
      {"id": "ChatInput-1", "type": "genericNode", "data": {"type": "ChatInput"}},
      {"id": "OpenAIModel-1", "type": "genericNode", "data": {"type": "OpenAIModel"}},
      {"id": "Calculator-1", "type": "genericNode", "data": {
        "type": "Calculator",
        "node": {"template": {"tool_mode": {"value": true}}}
      }},
      {"id": "WebSearch-1", "type": "genericNode", "data": {
        "type": "SerpAPI",
        "node": {"template": {"tool_mode": {"value": true}}}
      }},
      {"id": "Agent-1", "type": "genericNode", "data": {"type": "ToolCallingAgent"}},
      {"id": "ChatOutput-1", "type": "genericNode", "data": {"type": "ChatOutput"}}
    ],
    "edges": [
      {"source": "ChatInput-1", "target": "Agent-1", "targetHandle": "input"},
      {"source": "OpenAIModel-1", "target": "Agent-1", "targetHandle": "llm"},
      {"source": "Calculator-1", "target": "Agent-1", "targetHandle": "tools"},
      {"source": "WebSearch-1", "target": "Agent-1", "targetHandle": "tools"},
      {"source": "Agent-1", "target": "ChatOutput-1"}
    ]
  }
}
```

---

## Pattern 2: Sequential Multi-Agent

### When to Use
- Multi-step workflows
- Research → Analysis → Report
- Each agent specializes in one task

### Agent Chain Structure

```
User Input
   ↓
Research Agent (web search)
   ↓
Analysis Agent (process data)
   ↓
Writer Agent (generate report)
   ↓
Output
```

### Implementation

```json
{
  "nodes": [
    {"id": "ChatInput-1", "data": {"type": "ChatInput"}},
    {"id": "ResearchAgent-1", "data": {
      "type": "ToolCallingAgent",
      "node": {
        "template": {
          "system_prompt": {"value": "You are a research agent. Search the web and gather relevant information."},
          "tools": {"value": ["WebSearch", "URLFetch"]}
        }
      }
    }},
    {"id": "AnalysisAgent-1", "data": {
      "type": "ToolCallingAgent",
      "node": {
        "template": {
          "system_prompt": {"value": "You are an analysis agent. Process and analyze the research data."},
          "tools": {"value": ["Calculator", "DataProcessor"]}
        }
      }
    }},
    {"id": "WriterAgent-1", "data": {
      "type": "ToolCallingAgent",
      "node": {
        "template": {
          "system_prompt": {"value": "You are a writer agent. Create a comprehensive report."}
        }
      }
    }},
    {"id": "ChatOutput-1", "data": {"type": "ChatOutput"}}
  ],
  "edges": [
    {"source": "ChatInput-1", "target": "ResearchAgent-1"},
    {"source": "ResearchAgent-1", "target": "AnalysisAgent-1"},
    {"source": "AnalysisAgent-1", "target": "WriterAgent-1"},
    {"source": "WriterAgent-1", "target": "ChatOutput-1"}
  ]
}
```

---

## Pattern 3: Parallel Multi-Agent

### When to Use
- Concurrent processing
- Multiple perspectives needed
- Faster results through parallelization

### Parallel Structure

```
         User Input
         /    |    \
        /     |     \
Agent A   Agent B   Agent C
  (web)   (docs)   (calc)
        \     |     /
         \    |    /
       Aggregator
           ↓
         Output
```

### Implementation

```json
{
  "edges": [
    {"source": "ChatInput-1", "target": "WebAgent-1"},
    {"source": "ChatInput-1", "target": "DocsAgent-1"},
    {"source": "ChatInput-1", "target": "CalcAgent-1"},
    {"source": "WebAgent-1", "target": "Aggregator-1"},
    {"source": "DocsAgent-1", "target": "Aggregator-1"},
    {"source": "CalcAgent-1", "target": "Aggregator-1"},
    {"source": "Aggregator-1", "target": "ChatOutput-1"}
  ]
}
```

---

## Pattern 4: Hierarchical Multi-Agent

### When to Use
- Complex task decomposition
- Supervisor delegates to specialists
- Dynamic task routing

### Hierarchical Structure

```
         Supervisor Agent
              ↓
        (decides which agent)
         /    |    \
        /     |     \
  Specialist Specialist Specialist
     Agent A   Agent B   Agent C
```

### Supervisor Logic

```python
class SupervisorAgent(Component):
    def build(self):
        # Analyze task
        task_type = self.classify_task(self.input_value)

        # Route to appropriate specialist
        if task_type == "research":
            return self.research_agent.invoke(self.input_value)
        elif task_type == "calculation":
            return self.calc_agent.invoke(self.input_value)
        elif task_type == "writing":
            return self.writer_agent.invoke(self.input_value)
```

---

## Pattern 5: RAG Agent

### When to Use
- Document-based Q&A with actions
- Knowledge base + tool calling
- Context-aware agent responses

### RAG Agent Structure

```
User Query
   ↓
Vector Store Search
   ↓
[Retrieved Documents]
   ↓
Agent (with tools + context)
   ↓
Response
```

### Implementation

```json
{
  "nodes": [
    {"id": "ChatInput-1", "data": {"type": "ChatInput"}},
    {"id": "Embeddings-1", "data": {"type": "OpenAIEmbeddings"}},
    {"id": "VectorStore-1", "data": {
      "type": "Pinecone",
      "node": {
        "template": {
          "index_name": {"value": "knowledge-base"},
          "number_of_results": {"value": 5}
        }
      }
    }},
    {"id": "Agent-1", "data": {
      "type": "ToolCallingAgent",
      "node": {
        "template": {
          "system_prompt": {"value": "Answer based on the provided context. Use tools when needed."},
          "tools": {"value": ["Calculator", "WebSearch"]}
        }
      }
    }},
    {"id": "ChatOutput-1", "data": {"type": "ChatOutput"}}
  ],
  "edges": [
    {"source": "ChatInput-1", "target": "VectorStore-1", "targetHandle": "search_query"},
    {"source": "Embeddings-1", "target": "VectorStore-1"},
    {"source": "VectorStore-1", "target": "Agent-1", "targetHandle": "context"},
    {"source": "ChatInput-1", "target": "Agent-1", "targetHandle": "input"},
    {"source": "Agent-1", "target": "ChatOutput-1"}
  ]
}
```

---

## Tool Modes

### Enabling Tool Mode

Components can be used as agent tools:

```python
from lfx.io import MessageTextInput

MessageTextInput(
    name="input_text",
    display_name="Input",
    tool_mode=True  # ✅ Enables use as tool
)
```

### Custom Tool Component

```python
from lfx.custom import Component
from lfx.io import MessageTextInput, IntInput, Output
from lfx.schema import Data

class CalculatorTool(Component):
    display_name = "Calculator Tool"
    description = "Performs mathematical calculations"

    inputs = [
        MessageTextInput(
            name="operation",
            display_name="Operation",
            tool_mode=True
        ),
        IntInput(name="num1", tool_mode=True),
        IntInput(name="num2", tool_mode=True)
    ]

    outputs = [Output(name="result", method="calculate")]

    def calculate(self) -> Data:
        op = self.operation.lower()
        if op == "add":
            result = self.num1 + self.num2
        elif op == "multiply":
            result = self.num1 * self.num2
        # ...

        return Data(value={"result": result})
```

### Agent as Tool

Use one agent as a tool for another:

```json
{
  "id": "SpecialistAgent-1",
  "data": {
    "type": "ToolCallingAgent",
    "node": {
      "template": {
        "tool_mode": {"value": true},  // ✅ Agent as tool
        "agent_description": {"value": "Use GPT-4 for complex tasks"}
      }
    }
  }
}
```

---

## Memory Management

### Conversation Memory

```python
DataInput(
    name="chat_history",
    display_name="Chat Memory",
    is_list=True,
    info="Stores conversation history"
)

def get_chat_history_data(self):
    return self.chat_history
```

### Vector Memory (Long-term)

```json
{
  "id": "VectorMemory-1",
  "data": {
    "type": "VectorStoreMemory",
    "node": {
      "template": {
        "index_name": {"value": "agent-memory"},
        "memory_key": {"value": "chat_history"}
      }
    }
  }
}
```

### Session-Based Memory

```bash
# Use session_id for user-specific memory
curl -X POST "$URL/api/v1/run/$FLOW_ID" \
  -d '{
    "input_value": "Remember my name is Alice",
    "session_id": "user_123"
  }'

# Later in same session
curl -X POST "$URL/api/v1/run/$FLOW_ID" \
  -d '{
    "input_value": "What is my name?",
    "session_id": "user_123"  # Same session
  }'
# Response: "Your name is Alice"
```

---

## Human-in-the-Loop Patterns

### Pattern 1: Approval Workflow

```
Agent generates action
   ↓
Request human approval
   ↓
If approved → Execute
If rejected → Retry
```

### Pattern 2: Clarification

```
Agent encounters ambiguity
   ↓
Ask human for clarification
   ↓
Continue with clarified information
```

### Implementation

```python
class ApprovalComponent(Component):
    def build(self):
        action = self.agent_proposed_action

        # Request approval (via custom UI/API)
        approved = self.request_approval(action)

        if approved:
            return self.execute_action(action)
        else:
            return Data(value={"status": "rejected"})
```

---

## Tool-Calling Best Practices

### 1. Clear Tool Descriptions

```python
class WebSearchTool(Component):
    description = "Search the web for current information. Use when the query requires recent data or facts not in your training."
```

### 2. Validate Tool Inputs

```python
def build(self):
    if not self.query or len(self.query) < 3:
        return Data(value={"error": "Query too short"})

    result = self.search(self.query)
    return Data(value=result)
```

### 3. Handle Tool Errors

```python
def build(self):
    try:
        result = self.api_call()
        return Data(value=result)
    except Exception as e:
        return Data(value={
            "error": str(e),
            "fallback": "Using cached data"
        })
```

---

## Agent System Prompts

### Research Agent

```
You are a research agent. Your job is to:
1. Search the web for relevant information
2. Extract key facts and data
3. Summarize findings
4. Pass results to the next agent

Available tools: WebSearch, URLFetch
```

### Analysis Agent

```
You are an analysis agent. Your job is to:
1. Receive research data
2. Identify patterns and insights
3. Calculate metrics
4. Prepare structured analysis

Available tools: Calculator, DataProcessor
```

### Coordinator Agent

```
You are a coordinator agent. Your job is to:
1. Understand the user's request
2. Decompose into subtasks
3. Delegate to specialist agents
4. Combine results into final response

Available agents: ResearchAgent, AnalysisAgent, WriterAgent
```

---

## Common Patterns

### Pattern: Research + Analysis + Report

```
1. Research Agent → Web search + document retrieval
2. Analysis Agent → Process data, find insights
3. Writer Agent → Generate comprehensive report
```

### Pattern: Parallel Experts + Consensus

```
1. Expert A (finance) → Financial analysis
2. Expert B (tech) → Technical analysis
3. Expert C (market) → Market analysis
4. Consensus Agent → Combine perspectives
```

### Pattern: Iterative Refinement

```
1. Initial Agent → Generate draft
2. Critic Agent → Provide feedback
3. Refiner Agent → Improve based on feedback
4. Repeat until quality threshold met
```

---

## Optimization Strategies

### 1. Tool Selection

Only provide relevant tools to each agent:

```python
# GOOD - Focused toolset
research_agent.tools = [WebSearch, URLFetch]
calc_agent.tools = [Calculator, DataProcessor]

# BAD - Too many tools
agent.tools = [WebSearch, Calculator, Database, Email, ...]  # Confusing
```

### 2. Prompt Optimization

```python
# GOOD - Clear, specific
"You are a research agent. Search for {topic} and return top 3 sources."

# BAD - Vague
"You are an agent. Do something."
```

### 3. Error Recovery

```python
def build(self):
    max_retries = 3
    for attempt in range(max_retries):
        try:
            return self.agent.invoke(self.input)
        except Exception as e:
            if attempt == max_retries - 1:
                return Data(value={"error": str(e)})
            continue
```

---

## Common Mistakes

### Mistake 1: Too Many Tools

```python
# WRONG - Agent overloaded with 20+ tools
agent.tools = [Tool1, Tool2, ..., Tool20]

# CORRECT - Focused toolset
agent.tools = [WebSearch, Calculator, Database]  # 3-5 tools max
```

### Mistake 2: Missing Tool Mode

```python
# WRONG - Component not usable as tool
inputs = [StrInput(name="query")]

# CORRECT - Enable tool mode
inputs = [StrInput(name="query", tool_mode=True)]
```

### Mistake 3: No Error Handling

```python
# WRONG - Crashes on errors
def build(self):
    return self.api_call()

# CORRECT - Handle errors
def build(self):
    try:
        return self.api_call()
    except Exception as e:
        return Data(value={"error": str(e)})
```

---

## Best Practices

### 1. Single Responsibility
Each agent should have one clear purpose.

### 2. Clear Communication
Agents should output structured data for next agent.

### 3. Error Recovery
Implement fallbacks and retry logic.

### 4. Memory Management
Use appropriate memory for use case (short-term vs long-term).

### 5. Tool Validation
Validate tool inputs before execution.

---

## Further Reading

- Use `langflow-component-config` for tool input types
- Use `langflow-custom-components` for custom tools
- Use `langflow-flow-patterns` for agent architectures
- [Langflow Agents](https://docs.langflow.org/components-agents)
- [Tool Calling](https://docs.langflow.org/agents-tools)
