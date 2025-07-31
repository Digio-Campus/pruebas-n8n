# GitHub Copilot Instructions - N8N Workflows Project

## 🎯 Project Context
- **Framework:** n8n automation platform

## 🤖 N8N Workflow Analysis Protocol

### ⚡ PRIORITY 1: Detect N8N JSON Structure
When opening a JSON file, check if it contains n8n workflow structure by looking for:
- `"nodes"` array with n8n node types (e.g., `"type": "n8n-nodes-base.stickyNote"`)
- `"connections"` object
- `"meta"` object with workflow metadata

### ⚡ PRIORITY 2: Look for AI Instructions
**IMMEDIATELY** after detecting n8n structure, search for sticky notes with:

**Color-based detection:**
- `"color": 6` (blue/purple color)

**Name-based detection:**
- `"name": "AI-instructions"`
- `"name": "📋 AI Context"`
- `"name": "📋 @AI: [topic]"`
- `"name": "🤖 AI Assistant"`

### AI Context Structure to Expect
```markdown
# 🎯 FOCUS
**What I'm working on:** [description]
**Status:** [development/testing/production]

## ❓ QUESTIONS FOR AI
- [specific questions for assistance]

## 🔧 CURRENT ISSUES
- [problems to solve]

## 📊 FOCUS AREAS
- [areas of concentration]
```

### Response Protocol for N8N Files
1. **Detect n8n structure:** "I see this is an n8n workflow..."
2. **Find AI instructions:** "Checking for AI instructions... Found sticky note [name] with [context]"
3. **Acknowledge context:** "Based on your AI instructions, I see you're working on [X]..."
4. **Address specific items:** Answer questions, analyze issues, focus on specified areas
5. **Analyze workflow:** Then proceed with technical analysis

### Tags to Prioritize
- `ask-ai` - Workflow needs AI assistance
- `has-issues` - Has reported problems
- `development/testing/production` - Status indicators
- Technical tags: `agent-orchestration`, `mcp-optimization`, `langchain`, etc.

### Technical Focus Areas for This Project
- MCP (Model Context Protocol) implementations
- AI Agent hierarchies and orchestration
- LangChain integrations
- Performance optimization
- Error handling patterns
- Tool selection logic
- N8N node configuration best practices

## 📁 File Detection Rules
- **Trigger:** Any JSON file containing `"nodes"` array and `"connections"` object
- **Action:** Immediately search for color 6 sticky notes or "AI-instructions" names
- **Priority:** Always read AI context before analyzing workflow logic