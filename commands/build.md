---
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob
argument-hint: [optional: specific component name or "next" for automatic]
description: Intelligent implementation with Claude as primary engineer and specialists as expert consultants
---

$THINKING_LEVEL about implementation approach.

## Intelligent Implementation Workflow

Target: $ARGUMENTS (or next logical component if not specified)

**Steps to execute:**

1. **Context Analysis & Planning with Error Recovery**
   - Read `SPECS.md` to understand what needs to be built
   - **SPECS.md Error Handling:**
     - If `SPECS.md` is missing: Create basic implementation plan from `PRD.md`
     - If incomplete: Use available sections and flag missing areas
     - If corrupted: Request regeneration via `/design` command
   - Analyze existing codebase for patterns and structure
   - Determine target component and its requirements
   - Set appropriate thinking level based on complexity
   - **Fallback Planning:**
     - If no clear next component: Implement foundation layers first
     - If dependencies unclear: Build independent components in parallel

2. **Capability Assessment**
   - Analyze what the component requires
   - Determine what Claude can build directly vs. what needs specialists

3. **Agent Selection Strategy**

   **Claude Handles Directly (90% of cases):**
   ```
   ✅ CLI tools and command-line applications
   ✅ REST APIs and CRUD services
   ✅ Next.js/SvelteKit/Remix full-stack apps
   ✅ Database operations and schema design
   ✅ File operations and data processing
   ✅ Authentication and authorization (standard patterns)
   ✅ Basic web UI with standard interactions
   ✅ Configuration management and logging
   ✅ Testing and error handling
   ✅ Standard business logic and workflows
   ```

   **Call Specialists Only When Needed:**
   
   **🔵 ai-ml-engineer** - For AI-specific implementations:
   ```
   • LLM API integration (OpenAI, Anthropic, local models)
   • Vector database implementation (Pinecone, Chroma, Weaviate)
   • Agent orchestration and tool calling systems
   • RAG pipeline implementation
   • Prompt engineering and template systems
   • Model fine-tuning or training code
   ```
   
   **🟣 frontend-engineer** - For advanced UI implementations:
   ```
   • Complex animations and micro-interactions
   • Advanced state management (Redux sagas, complex contexts)
   • Performance optimization for large SPAs
   • Complex design systems and component libraries
   • Mobile-specific optimizations
   • Advanced accessibility implementations
   ```
   
   **🟠 backend-engineer** - For complex server architectures:
   ```
   • Distributed systems and microservices
   • High-performance queue systems (Redis, RabbitMQ)
   • Database sharding and replication strategies
   • Real-time systems at scale
   • Complex caching strategies
   • Advanced DevOps and infrastructure
   ```
   
   **🩵 data-scientist** - For data analysis and ML:
   ```
   • Statistical analysis and A/B testing
   • Custom ML model training (not API usage)
   • Complex ETL and data transformation
   • Business intelligence dashboards
   • Advanced analytics and reporting
   ```

4. **Implementation Planning**
   - Enter plan mode and present your technical implementation strategy based on the above analysis:
     - Specific components to build and their implementation order
     - Technical approach and patterns to use
     - Dependencies and integration points
     - Testing strategy and validation approach
     - Potential challenges and mitigation strategies

5. **Implementation Execution with Coordination Patterns**

   **Pattern A: Claude Direct (90% of cases)**
   - Claude builds complete component
   - Updates `SPECS.md` with completion

   **Pattern B: Sequential Specialist Chain**
   - Used when specialists have dependencies
   - Example: CLI Agent Tool
     1. ai-ml-engineer implements AI core → returns interfaces
     2. **qa-engineer validates** AI integration patterns and error handling
     3. backend-engineer integrates AI with CLI → uses interfaces  
     4. **qa-engineer validates** distributed system reliability and performance
     5. Claude integrates final implementation
     6. **qa-engineer performs** end-to-end validation

   **Pattern C: Parallel Specialist Coordination**
   - Used when specialists work independently
   - Example: Web App with AI Features
     1. **SIMULTANEOUSLY:**
        - frontend-engineer builds UI components
        - ai-ml-engineer builds AI backend services
        - **qa-engineer validates** interface contracts and integration compatibility
     2. Claude integrates all components using validated interfaces
     3. **qa-engineer performs** final integration testing

   **Pattern D: Layered Implementation**
   - Used for complex systems with clear layers
   - Example: Data Pipeline with ML
     1. Layer 1: backend-engineer (data ingestion)
     2. **qa-engineer validates** layer functionality and interface contracts
     3. Layer 2: data-scientist (transformation logic) 
     4. **qa-engineer validates** data quality and processing accuracy
     5. Layer 3: ai-ml-engineer (ML processing)
     6. **qa-engineer validates** ML model integration and performance
     7. Claude integrates layers sequentially with validated foundations

6. **Feedback Loop Detection During Implementation**

   **Architecture Insufficiency Detection:**
   - **Component complexity exceeds specifications:**
     - Implementation reveals missing architectural details
     - Interface contracts are incomplete or contradictory
     - Performance requirements cannot be met with current design
     - **Feedback Action:** Flag need to return to `/design` with specific architectural gaps
   
   - **Requirements Ambiguity During Implementation:**
     - Business logic unclear from requirements
     - User stories insufficient for implementation decisions
     - Acceptance criteria missing or contradictory
     - **Feedback Action:** Flag need to return to `/discover` with specific requirement clarifications
   
   - **Technology Stack Issues:**
     - Chosen technologies insufficient for requirements
     - Integration complexity higher than anticipated
     - Performance characteristics don't match needs
     - **Feedback Action:** Flag need for `/design` technology re-evaluation
   
   **Implementation Feedback Triggers:**
   - Agent failure patterns indicating missing context
   - Repeated implementation attempts failing on same components
   - Test failures revealing fundamental design issues
   - Integration problems between components

7. **Error Recovery & Fallback Strategies**
   
   **Specialist Agent Failures:**
   - **Single specialist fails**: Claude implements with basic patterns + documents limitations
   - **Multiple specialists fail**: Escalate to Claude direct implementation
   - **Partial responses**: Request specific missing sections or proceed with available code
   
   **Implementation Failures:**
   - **Code doesn't integrate**: Analyze interface mismatches and create adapters
   - **Performance issues**: Fall back to simpler implementations
   - **Dependency conflicts**: Use version pinning or alternative libraries
   
   **Quality Assurance Failures:**
   - **QA agent fails**: Claude performs basic testing validation
   - **Tests fail**: Implement fixes or document known issues for future resolution
   - **Integration issues**: Create temporary workarounds with TODO items
   
   **Progressive Degradation:**
   - **High complexity**: Try "think harder" → "think hard" → "think" → direct implementation
   - **Resource constraints**: Simplify scope to core functionality
   - **Time pressure**: Implement MVP version with enhancement TODOs

## Decision Logic Examples

### CLI Agentic Tool (like Claude Code):
**Claude builds:** Command parsing, file operations, configuration, project management, basic UI
**ai-ml-engineer adds:** LLM streaming, agent orchestration, prompt management
**Result:** Claude integrates AI features into CLI framework

### E-commerce Web App:
**Claude builds:** User auth, product catalog, shopping cart, checkout flow, payment integration
**data-scientist adds:** Recommendation engine, A/B testing analytics
**Result:** Claude integrates recommendations into product pages

### Data Dashboard:
**Claude builds:** Web interface, user management, basic charts
**data-scientist builds:** Complex analytics, statistical models, advanced visualizations
**Result:** Claude creates dashboard that displays data-scientist's analysis

### Mobile App:
**Claude builds:** Navigation, basic screens, API integration, data management
**frontend-engineer adds:** Complex animations, performance optimizations
**Result:** Claude creates app with enhanced UI interactions

## Continuous Quality Assurance Strategy

**QA Integration During Implementation:**

**Pattern A: Claude Direct** → QA validation after implementation for:
- Critical system components
- User-facing features  
- Security-sensitive implementations
- Components with external dependencies

**Pattern B: Sequential Specialist Chain** → QA validation between each specialist:
- After ai-ml-engineer: Validate AI integration patterns and error handling
- After backend-engineer: Validate distributed system reliability and performance
- After final integration: End-to-end QA validation

**Pattern C: Parallel Specialist Coordination** → QA coordination during parallel work:
- **SIMULTANEOUSLY** call qa-engineer with specialists to:
  - Validate interface contracts as they're implemented
  - Ensure integration compatibility between parallel components
  - Test component interactions in real-time

**Pattern D: Layered Implementation** → QA gates between layers:
- After each layer: Validate layer functionality and interface contracts
- Before next layer: Ensure stable foundation for dependent components
- Final integration: Complete system validation

**Claude handles QA directly for:**
- Standard CRUD operations
- Simple CLI tools without external integrations
- Basic web interfaces with standard patterns
- Standard business logic without complex dependencies

## Integration Patterns

### Pattern 1: Direct Build (Most Common)
```
Claude analyzes → Claude implements → Update SPECS.md
```

### Pattern 2: Expert Consultation
```
Claude analyzes → Claude builds foundation → 
Specialist adds expertise → Claude integrates → QA if needed
```

### Pattern 3: Specialist-Led (Rare)
```
Claude analyzes → Route to specialist → 
Specialist implements → QA validates → Update SPECS.md
```

## Success Criteria
- Component works as specified and integrates seamlessly (or documents limitations)
- Code follows project conventions and patterns (or establishes new patterns)
- Implementation is maintainable and well-tested (or includes validation TODOs)
- Specialist expertise is used where available, Claude handles fallbacks
- `SPECS.md` accurately reflects completion status and any error recovery actions taken
- Error recovery actions are documented for future reference and improvement