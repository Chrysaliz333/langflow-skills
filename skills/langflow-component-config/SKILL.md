---
name: langflow-component-config
description: Component-aware configuration guidance for Langflow. Use when configuring components, understanding input dependencies, setting up AI workflows, working with component templates, or connecting components. Provides input field type reference and common configuration patterns.
---

# Langflow Component Configuration

Expert guide for configuring Langflow components and their inputs.

---

## Input Field Types

Langflow components use typed input fields from `lfx.io`:

### Text Inputs

#### StrInput - Single-line Text
```python
from lfx.io import StrInput

StrInput(
    name="title",
    display_name="Title",
    value="Default value",
    info="Help text shown to user",
    required=True
)
```

#### MultilineInput - Multi-line Text
```python
from lfx.io import MultilineInput

MultilineInput(
    name="prompt",
    display_name="Prompt Template",
    value="Default template",
    info="Enter your prompt template"
)
```

#### SecretStrInput - Password/API Key
```python
from lfx.io import SecretStrInput

SecretStrInput(
    name="api_key",
    display_name="API Key",
    value="OPENAI_API_KEY",  # Environment variable name
    required=True,
    info="Your OpenAI API key"
)
```

### Numeric Inputs

#### IntInput - Integer
```python
from lfx.io import IntInput

IntInput(
    name="max_tokens",
    display_name="Max Tokens",
    value=256,
    info="Maximum tokens to generate"
)
```

#### SliderInput - Numeric Slider
```python
from lfx.io import SliderInput
from langflow.field_typing.range_spec import RangeSpec

SliderInput(
    name="temperature",
    display_name="Temperature",
    value=0.7,
    range_spec=RangeSpec(min=0, max=2, step=0.1)
)
```

### Boolean Inputs

#### BoolInput - Toggle
```python
from lfx.io import BoolInput

BoolInput(
    name="enabled",
    display_name="Enabled",
    value=True,
    info="Enable this feature"
)
```

### Selection Inputs

#### DropdownInput - Dropdown Menu
```python
from lfx.io import DropdownInput

DropdownInput(
    name="model_name",
    display_name="Model Name",
    options=["gpt-4", "gpt-3.5-turbo", "gpt-4-turbo"],
    value="gpt-4",
    info="Select the model to use",
    combobox=True  # Allow custom values
)
```

### Advanced Inputs

#### FileInput - File Upload
```python
from lfx.io import FileInput

FileInput(
    name="file",
    display_name="Upload File",
    file_types=["txt", "pdf", "md"],
    info="Upload a document"
)
```

#### CodeInput - Code Editor
```python
from lfx.io import CodeInput

CodeInput(
    name="code",
    display_name="Python Code",
    value="# Enter your code here",
    language="python"
)
```

#### DataInput - Structured Data
```python
from lfx.io import DataInput

DataInput(
    name="data",
    display_name="Input Data",
    info="Connect a data source"
)
```

#### MessageTextInput - Chat Message
```python
from lfx.io import MessageTextInput

MessageTextInput(
    name="message",
    display_name="Message",
    info="Input message for chat"
)
```

---

## Dynamic Fields

### Real-time Refresh
Fields can trigger component refresh when changed:

```python
from lfx.io import DropdownInput, StrInput

DropdownInput(
    name="operator",
    display_name="Operator",
    options=["equals", "contains", "regex"],
    value="equals",
    real_time_refresh=True  # Triggers component update
)
```

### Conditional Visibility
Show/hide fields based on other field values:

```python
from lfx.custom import Component
from lfx.io import DropdownInput, StrInput

class RegexRouter(Component):
    inputs = [
        DropdownInput(
            name="operator",
            display_name="Operator",
            options=["equals", "contains", "regex"],
            real_time_refresh=True
        ),
        StrInput(
            name="regex_pattern",
            display_name="Regex Pattern",
            dynamic=True,  # Can be shown/hidden
            show=False     # Initially hidden
        )
    ]

    def update_build_config(self, build_config, field_value, field_name):
        if field_name == "operator":
            # Show regex_pattern only when operator is "regex"
            build_config["regex_pattern"]["show"] = (field_value == "regex")
        return build_config
```

---

## Common Component Configurations

### OpenAI Model Component

```python
from lfx.io import (
    DropdownInput,
    SecretStrInput,
    SliderInput,
    IntInput,
    BoolInput
)

inputs = [
    DropdownInput(
        name="model_name",
        display_name="Model Name",
        options=["gpt-4", "gpt-3.5-turbo", "gpt-4-turbo"],
        value="gpt-4",
        combobox=True
    ),
    SecretStrInput(
        name="api_key",
        display_name="OpenAI API Key",
        value="OPENAI_API_KEY",
        required=True
    ),
    SliderInput(
        name="temperature",
        display_name="Temperature",
        value=0.7,
        range_spec=RangeSpec(min=0, max=2, step=0.01)
    ),
    IntInput(
        name="max_tokens",
        display_name="Max Tokens",
        value=256
    ),
    BoolInput(
        name="stream",
        display_name="Stream",
        value=False
    )
]
```

### Vector Store Component

```python
from lfx.io import (
    StrInput,
    DataInput,
    IntInput,
    BoolInput,
    DropdownInput
)

inputs = [
    StrInput(
        name="index_name",
        display_name="Index Name",
        value="langflow",
        info="Vector store index name"
    ),
    DataInput(
        name="ingest_data",
        display_name="Ingest Data",
        info="Data to be ingested"
    ),
    StrInput(
        name="search_input",
        display_name="Search Query",
        info="Enter search query"
    ),
    DropdownInput(
        name="search_type",
        display_name="Search Type",
        options=["similarity", "mmr", "similarity_score_threshold"],
        value="similarity"
    ),
    IntInput(
        name="number_of_results",
        display_name="Number of Results",
        value=4
    ),
    BoolInput(
        name="cache_vector_store",
        display_name="Cache Vector Store",
        value=True
    )
]
```

---

## Component Template Structure

When creating flows via API, components are configured through templates:

```json
{
  "id": "OpenAIModel-abc123",
  "type": "genericNode",
  "data": {
    "type": "OpenAIModel",
    "node": {
      "template": {
        "model_name": {
          "value": "gpt-4"
        },
        "api_key": {
          "value": "OPENAI_API_KEY"
        },
        "temperature": {
          "value": 0.7
        },
        "max_tokens": {
          "value": 256
        }
      }
    }
  }
}
```

---

## Input Dependencies

### Property Dependencies

Some inputs depend on others:

```python
# Example: HTTP Request component
inputs = [
    DropdownInput(
        name="method",
        options=["GET", "POST", "PUT", "DELETE"],
        real_time_refresh=True
    ),
    BoolInput(
        name="send_body",
        display_name="Send Body",
        value=False,
        show=False  # Only shown for POST/PUT
    ),
    DropdownInput(
        name="content_type",
        options=["application/json", "application/x-www-form-urlencoded"],
        show=False  # Only shown when send_body=True
    )
]
```

### Update Logic

```python
def update_build_config(self, build_config, field_value, field_name):
    if field_name == "method":
        # Show send_body for POST/PUT
        show_body = field_value in ["POST", "PUT"]
        build_config["send_body"]["show"] = show_body

    if field_name == "send_body":
        # Show content_type when send_body is True
        build_config["content_type"]["show"] = field_value

    return build_config
```

---

## Common Patterns

### Pattern 1: Environment Variables for Secrets

```python
# Store API keys as environment variables
SecretStrInput(
    name="api_key",
    value="OPENAI_API_KEY",  # Points to env var
    required=True
)

# Access in component
def build(self):
    api_key = self.api_key  # Automatically resolved from env
    # Use api_key...
```

### Pattern 2: Dropdown with Custom Values

```python
# Allow users to select OR type custom value
DropdownInput(
    name="model_name",
    options=["gpt-4", "gpt-3.5-turbo"],
    value="gpt-4",
    combobox=True  # Enables custom input
)
```

### Pattern 3: Conditional Required Fields

```python
from lfx.custom import Component

class CustomComponent(Component):
    inputs = [
        BoolInput(name="use_custom", value=False),
        StrInput(
            name="custom_value",
            show=False,
            required=False  # Initially not required
        )
    ]

    def update_build_config(self, build_config, field_value, field_name):
        if field_name == "use_custom":
            build_config["custom_value"]["show"] = field_value
            build_config["custom_value"]["required"] = field_value
        return build_config
```

### Pattern 4: Range-Constrained Inputs

```python
from langflow.field_typing.range_spec import RangeSpec

IntInput(
    name="max_tokens",
    range_spec=RangeSpec(min=1, max=128000),
    value=256
)

SliderInput(
    name="temperature",
    range_spec=RangeSpec(min=0.0, max=2.0, step=0.01),
    value=0.7
)
```

---

## Common Mistakes

### Mistake 1: Missing Required Fields

```python
# WRONG - No required API key
SecretStrInput(
    name="api_key",
    display_name="API Key"
)

# CORRECT - Mark as required
SecretStrInput(
    name="api_key",
    display_name="API Key",
    required=True
)
```

### Mistake 2: Incorrect Field Access

```python
# WRONG - Accessing template directly
def build(self):
    model = self.template["model_name"]

# CORRECT - Access via self
def build(self):
    model = self.model_name
```

### Mistake 3: Wrong Input Type

```python
# WRONG - Using StrInput for numeric value
StrInput(name="temperature", value="0.7")

# CORRECT - Use SliderInput or IntInput
SliderInput(
    name="temperature",
    value=0.7,
    range_spec=RangeSpec(min=0, max=2, step=0.01)
)
```

### Mistake 4: Missing Environment Variable

```json
// WRONG - Hardcoded API key in template
{
  "template": {
    "api_key": {"value": "sk-abc123xyz"}
  }
}

// CORRECT - Reference environment variable
{
  "template": {
    "api_key": {"value": "OPENAI_API_KEY"}
  }
}
```

---

## Best Practices

### 1. Use Appropriate Input Types
```python
# Use SliderInput for bounded numeric values
SliderInput(name="temperature", value=0.7, range_spec=RangeSpec(min=0, max=2))

# Use IntInput for unbounded integers
IntInput(name="max_tokens", value=256)

# Use SecretStrInput for sensitive data
SecretStrInput(name="api_key", value="OPENAI_API_KEY")
```

### 2. Provide Clear Help Text
```python
StrInput(
    name="prompt",
    display_name="Prompt Template",
    info="Enter your prompt. Use {input} for variable substitution."
)
```

### 3. Set Sensible Defaults
```python
# Good defaults improve user experience
SliderInput(name="temperature", value=0.7)  # Common default
IntInput(name="max_tokens", value=256)      # Reasonable default
BoolInput(name="stream", value=False)       # Safe default
```

### 4. Use Real-time Refresh Sparingly
```python
# Only use for fields that affect other fields
DropdownInput(
    name="operator",
    real_time_refresh=True  # Affects regex_pattern visibility
)

# Don't use for independent fields
StrInput(
    name="title",
    real_time_refresh=False  # Not needed
)
```

---

## Component Connection Patterns

### Output Types

Components output specific types that must match input types:

```python
# Text output
Output(name="output", display_name="Output", method="build_output")

# Message output
Output(name="message", display_name="Message", method="build_message")

# Data output
Output(name="data", display_name="Data", method="build_data")
```

### Connection Compatibility

| Output Type | Compatible Input Types |
|-------------|------------------------|
| Text | StrInput, MultilineInput, MessageTextInput |
| Message | MessageTextInput, DataInput |
| Data | DataInput |
| Model | ModelInput |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Field not showing | Check `show` parameter and `update_build_config` |
| Value not saving | Ensure `name` parameter is unique |
| Dropdown not working | Verify `options` is a list of strings |
| API key not found | Check environment variable exists |
| Type mismatch on connection | Ensure output and input types match |

---

## Further Reading

- [Langflow Component Docs](https://docs.langflow.org/components-custom-components)
- Use `langflow-custom-components` skill for building components
- Use `langflow-api-expert` skill for API integration
