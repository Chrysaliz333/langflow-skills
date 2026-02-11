---
name: langflow-custom-components
description: Write custom Python components for Langflow. Use when creating custom components, extending functionality, Python development, building tools for agents, or implementing custom processing logic. Covers component class structure, build method implementation, and LangChain integration.
---

# Langflow Custom Components

Expert guide for creating custom Python components in Langflow.

---

## Component Structure

### Basic Component Template

```python
from lfx.custom import Component
from lfx.io import MessageTextInput, StrInput, Output
from lfx.schema import Data, Message

class MyCustomComponent(Component):
    display_name = "My Custom Component"
    description = "Description of what this component does"
    documentation = "https://docs.langflow.org/components/custom"
    icon = "icon-name"
    name = "MyCustomComponent"

    inputs = [
        MessageTextInput(
            name="input_text",
            display_name="Input Text",
            info="Enter text to process"
        )
    ]

    outputs = [
        Output(
            display_name="Result",
            name="output",
            method="build_output"
        )
    ]

    def build_output(self) -> Data:
        # Your component logic here
        text = self.input_text
        result = text.upper()  # Example processing

        return Data(value={"result": result})
```

---

## Component Attributes

### Required Attributes

```python
class MyComponent(Component):
    # REQUIRED
    display_name: str = "Component Name"  # Shown in UI
    description: str = "What it does"     # Help text

    # OPTIONAL
    documentation: str = "https://..."    # Documentation link
    icon: str = "icon-name"               # Icon identifier
    priority: int = 100                   # Sort priority
    name: str = "my_component"            # Internal identifier
```

---

## Input Definitions

### Input Types

```python
from lfx.io import (
    MessageTextInput,  # Chat/text input
    StrInput,          # String input
    IntInput,          # Integer input
    BoolInput,         # Boolean toggle
    DataInput,         # Data object input
    FileInput,         # File upload
    SecretStrInput     # API keys/secrets
)

inputs = [
    MessageTextInput(
        name="message",
        display_name="Message",
        info="Input message",
        value="Default text",
        tool_mode=True  # Usable as agent tool
    ),
    StrInput(
        name="param",
        display_name="Parameter",
        required=True
    ),
    IntInput(
        name="count",
        display_name="Count",
        value=5,
        advanced=True  # Shown in advanced settings
    )
]
```

---

## Output Definitions

### Output Types

```python
from lfx.io import Output

outputs = [
    Output(
        display_name="Text Output",
        name="text_output",
        method="build_text"  # Method to call
    ),
    Output(
        display_name="Data Output",
        name="data_output",
        method="build_data"
    )
]
```

---

## Build Method

### Return Types

The build method can return different types:

#### 1. Data Object
```python
from lfx.schema import Data

def build_output(self) -> Data:
    result = {"key": "value"}
    return Data(value=result)
```

#### 2. Message Object
```python
from lfx.schema import Message

def build_message(self) -> Message:
    return Message(
        text="Response text",
        data={"metadata": "value"}
    )
```

#### 3. String/Basic Types
```python
def build_text(self) -> str:
    return "Processed text"
```

#### 4. LangChain Objects
```python
from langchain_openai import ChatOpenAI

def build_model(self):
    return ChatOpenAI(
        model=self.model_name,
        api_key=self.api_key,
        temperature=self.temperature
    )
```

---

## Complete Examples

### Example 1: Text Analyzer

```python
from lfx.custom import Component
from lfx.io import MessageTextInput, Output
from lfx.schema import Data
import re

class TextAnalyzer(Component):
    display_name = "Text Analyzer"
    description = "Analyzes and transforms input text"
    icon = "chart-bar"
    name = "TextAnalyzer"

    inputs = [
        MessageTextInput(
            name="input_text",
            display_name="Input Text",
            info="Enter text to analyze",
            value="Hello, World!",
            tool_mode=True
        )
    ]

    outputs = [
        Output(
            display_name="Analysis Result",
            name="output",
            method="analyze_text"
        )
    ]

    def analyze_text(self) -> Data:
        text = self.input_text

        # Perform analysis
        word_count = len(text.split())
        char_count = len(text)
        sentence_count = len(re.findall(r'\w+[.!?]', text))

        # Transform text
        reversed_text = text[::-1]
        uppercase_text = text.upper()

        analysis_result = {
            "original_text": text,
            "word_count": word_count,
            "character_count": char_count,
            "sentence_count": sentence_count,
            "reversed_text": reversed_text,
            "uppercase_text": uppercase_text
        }

        data = Data(value=analysis_result)
        self.status = data  # Update component status
        return data
```

### Example 2: Sentiment Analyzer

```python
from lfx.custom import Component
from lfx.io import StrInput, Output
from lfx.schema import Message

class SentimentAnalyzer(Component):
    display_name = "Sentiment Analyzer"
    description = "Analyzes sentiment of input text"
    icon = "heart"

    inputs = [
        StrInput(
            name="text",
            display_name="Text",
            info="Text to analyze",
            required=True
        ),
        StrInput(
            name="threshold",
            display_name="Confidence Threshold",
            value="0.5",
            advanced=True
        )
    ]

    outputs = [
        Output(
            display_name="Sentiment",
            name="sentiment",
            method="build_sentiment"
        )
    ]

    def build_sentiment(self) -> Message:
        text = self.text
        threshold = float(self.threshold)

        # Simple sentiment analysis
        positive_words = ["good", "great", "excellent", "happy"]
        negative_words = ["bad", "terrible", "awful", "sad"]

        text_lower = text.lower()
        pos_count = sum(1 for w in positive_words if w in text_lower)
        neg_count = sum(1 for w in negative_words if w in text_lower)

        if pos_count > neg_count:
            sentiment = "positive"
            confidence = min(pos_count * 0.2, 1.0)
        elif neg_count > pos_count:
            sentiment = "negative"
            confidence = min(neg_count * 0.2, 1.0)
        else:
            sentiment = "neutral"
            confidence = 0.5

        self.status = f"Detected: {sentiment} ({confidence:.2f})"

        return Message(
            text=f"Sentiment: {sentiment}",
            data={
                "sentiment": sentiment,
                "confidence": confidence,
                "passes_threshold": confidence >= threshold
            }
        )
```

### Example 3: DataFrame Processor

```python
from lfx.custom import Component
from lfx.io import DataInput, StrInput, Output
from lfx.schema import Data
import pandas as pd

class DataFrameProcessor(Component):
    display_name = "DataFrame Processor"
    description = "Process pandas DataFrames with operations"
    documentation = "https://docs.langflow.org/components-dataframe"
    icon = "DataframeIcon"
    priority = 100
    name = "dataframe_processor"

    inputs = [
        DataInput(
            name="dataframe",
            display_name="DataFrame",
            info="Input DataFrame to process"
        ),
        StrInput(
            name="operation",
            display_name="Operation",
            info="Operation: sort, filter, aggregate"
        )
    ]

    outputs = [
        Output(
            display_name="Processed DataFrame",
            name="output",
            method="process_dataframe"
        )
    ]

    def process_dataframe(self) -> Data:
        df = self.dataframe
        operation = self.operation

        if operation == "sort":
            result = df.sort_values(by=df.columns[0])
        elif operation == "filter":
            result = df[df[df.columns[0]] > 0]
        elif operation == "aggregate":
            result = df.describe()
        else:
            result = df

        return Data(value=result.to_dict())
```

---

## LangChain Integration

### Creating LangChain Model Components

```python
from lfx.custom import Component
from lfx.io import (
    DropdownInput,
    SecretStrInput,
    SliderInput,
    IntInput
)
from langchain_openai import ChatOpenAI
from langflow.field_typing.range_spec import RangeSpec

class OpenAIComponent(Component):
    display_name = "OpenAI Model"
    description = "OpenAI language model"
    icon = "OpenAI"

    inputs = [
        DropdownInput(
            name="model_name",
            display_name="Model Name",
            options=["gpt-4", "gpt-3.5-turbo", "gpt-4-turbo"],
            value="gpt-4"
        ),
        SecretStrInput(
            name="api_key",
            display_name="API Key",
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
        )
    ]

    outputs = [
        Output(
            display_name="Model",
            name="model",
            method="build_model"
        )
    ]

    def build_model(self):
        return ChatOpenAI(
            model=self.model_name,
            api_key=self.api_key,
            temperature=self.temperature,
            max_tokens=self.max_tokens or None
        )
```

---

## Tool Mode Components

Components can be used as agent tools:

```python
from lfx.custom import Component
from lfx.io import MessageTextInput, IntInput, Output
from lfx.schema import Data

class CalculatorComponent(Component):
    display_name = "Calculator"
    description = "Performs mathematical calculations"
    icon = "calculator"

    inputs = [
        MessageTextInput(
            name="operation",
            display_name="Operation",
            info="Math operation to perform",
            tool_mode=True  # Enable as tool
        ),
        IntInput(
            name="num1",
            display_name="Number 1",
            value=0,
            tool_mode=True
        ),
        IntInput(
            name="num2",
            display_name="Number 2",
            value=0,
            tool_mode=True
        )
    ]

    outputs = [
        Output(
            display_name="Result",
            name="result",
            method="calculate"
        )
    ]

    def calculate(self) -> Data:
        op = self.operation.lower()
        num1 = self.num1
        num2 = self.num2

        if op in ["add", "+"]:
            result = num1 + num2
        elif op in ["subtract", "-"]:
            result = num1 - num2
        elif op in ["multiply", "*"]:
            result = num1 * num2
        elif op in ["divide", "/"]:
            result = num1 / num2 if num2 != 0 else "Error: Division by zero"
        else:
            result = "Unknown operation"

        return Data(value={"result": result})
```

---

## Component Status Updates

Update component status during execution:

```python
def build_output(self) -> Data:
    # Update status at start
    self.status = "Processing..."

    # Do work
    result = self.process_data()

    # Update status with result
    self.status = f"Processed {len(result)} items"

    return Data(value=result)
```

---

## Error Handling

```python
from lfx.custom import Component
from lfx.io import StrInput, Output
from lfx.schema import Message

class SafeComponent(Component):
    display_name = "Safe Component"
    description = "Component with error handling"

    inputs = [
        StrInput(name="input", display_name="Input")
    ]

    outputs = [
        Output(display_name="Output", name="output", method="build_safe")
    ]

    def build_safe(self) -> Message:
        try:
            result = self.process_input(self.input)
            self.status = "Success"
            return Message(text=result)

        except ValueError as e:
            self.status = f"Error: {str(e)}"
            return Message(
                text="",
                data={"error": str(e), "type": "ValueError"}
            )

        except Exception as e:
            self.status = f"Unexpected error: {str(e)}"
            return Message(
                text="",
                data={"error": str(e), "type": "Unknown"}
            )

    def process_input(self, text: str) -> str:
        if not text:
            raise ValueError("Input cannot be empty")
        return text.upper()
```

---

## Common Patterns

### Pattern 1: Chaining Components

```python
# Component 1: Input processor
class InputProcessor(Component):
    outputs = [Output(name="processed", method="build")]

    def build(self) -> str:
        return self.input_text.lower()

# Component 2: Output formatter
class OutputFormatter(Component):
    inputs = [StrInput(name="text", display_name="Text")]
    outputs = [Output(name="formatted", method="build")]

    def build(self) -> str:
        return f"Result: {self.text.upper()}"
```

### Pattern 2: Conditional Processing

```python
def build_output(self) -> Data:
    if self.use_advanced:
        result = self.advanced_processing()
    else:
        result = self.simple_processing()

    return Data(value=result)
```

### Pattern 3: List Processing

```python
from typing import List

def build_output(self) -> Data:
    items = self.input_list  # Assume list input

    results = []
    for item in items:
        processed = self.process_item(item)
        results.append(processed)

    return Data(value={"results": results, "count": len(results)})
```

---

## Common Mistakes

### Mistake 1: Not Using Standard Library Only

```python
# WRONG - External libraries not available at runtime
import requests  # ❌ Not available
import pandas as pd  # ❌ Not available
import numpy as np  # ❌ Not available

# CORRECT - Use standard library only
import json  # ✅ Available
import re    # ✅ Available
from datetime import datetime  # ✅ Available
```

### Mistake 2: Incorrect Method Signature

```python
# WRONG - Method signature doesn't match output
outputs = [Output(name="result", method="build_result")]

def build_result(self, extra_param):  # ❌ Extra parameter
    return "result"

# CORRECT - No extra parameters
def build_result(self):  # ✅ Correct
    return "result"
```

### Mistake 3: Wrong Return Type

```python
# WRONG - Method returns wrong type
def build_data(self) -> Data:
    return "string"  # ❌ Should return Data object

# CORRECT - Return correct type
def build_data(self) -> Data:
    return Data(value={"result": "string"})  # ✅ Correct
```

### Mistake 4: Missing Self Reference

```python
# WRONG - Not using self
def build_output(self):
    text = input_text  # ❌ NameError

# CORRECT - Use self
def build_output(self):
    text = self.input_text  # ✅ Correct
```

---

## Best Practices

### 1. Use Standard Library Only
```python
# ✅ Available: json, re, datetime, math, collections, itertools
import json
import re
from datetime import datetime
from collections import Counter
```

### 2. Provide Clear Documentation
```python
class MyComponent(Component):
    display_name = "Clear Name"
    description = "Detailed description of functionality"
    documentation = "https://docs.example.com/component"
```

### 3. Handle Errors Gracefully
```python
def build(self) -> Data:
    try:
        result = self.risky_operation()
        return Data(value=result)
    except Exception as e:
        self.status = f"Error: {str(e)}"
        return Data(value={"error": str(e)})
```

### 4. Update Status for User Feedback
```python
def build(self) -> Data:
    self.status = "Processing..."
    result = self.process()
    self.status = f"Complete: {len(result)} items"
    return Data(value=result)
```

---

## Standard Library Reference

Available modules (no pip install needed):

- **Text**: `re`, `string`, `textwrap`
- **Data**: `json`, `csv`, `collections`, `itertools`
- **Time**: `datetime`, `time`
- **Math**: `math`, `statistics`, `random`
- **Files**: `os`, `pathlib`, `io`
- **HTTP**: `urllib` (basic HTTP, no `requests`)
- **Other**: `hashlib`, `base64`, `uuid`

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Import error | Use standard library only |
| Method not called | Check `method` parameter in Output |
| Wrong type error | Match return type with type hint |
| Input not accessible | Use `self.input_name` |
| Component not showing | Check `display_name` and `description` |

---

## Further Reading

- [Langflow Custom Components](https://docs.langflow.org/components-custom-components)
- Use `langflow-component-config` for input types
- Use `langflow-agent-patterns` for tool components
