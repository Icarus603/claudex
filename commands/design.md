---
allowed-tools: Task, Read, Write
argument-hint: [optional: specific design focus]
description: Create comprehensive technical specifications through architectural design and review
---

Think harder about system design and architecture.

Enter plan mode and present your plan for technical design before proceeding.

## System Design Workflow

Analyze any specific focus: $ARGUMENTS

**Steps to execute:**

1. **Read Requirements**
   - Read and analyze `PRD.md` thoroughly
   - Extract all technical requirements and constraints
   - Identify system complexity and architectural patterns needed

2. **Architectural Design Phase with Error Recovery**
   - Call the software-architect subagent to create comprehensive design:
     - Overall system architecture with clear component boundaries
     - Detailed implementation phases with specific components
     - Component dependencies and build order
     - Interface definitions between components
     - Technology stack for each component
     - Engineer assignments (which specialist builds what)
   
   - **Architect Failure Recovery:**
     - If architect fails: Claude creates basic system design from `PRD.md`
     - If incomplete: Request specific missing sections (phases, dependencies, tech stack)
     - If unresponsive: Use standard architectural patterns based on project requirements

3. **Parallel Review, AI Integration & Quality Analysis Phase**
   - **SIMULTANEOUSLY** call relevant agents:
     
     **design-reviewer** validates architecture:
     - Scalability bottlenecks and performance issues
     - Security vulnerabilities and threat vectors
     - Architecture complexity and maintainability
     - Integration risks and failure points
     - Resource utilization and cost implications
     
     **qa-engineer** reviews for testability & quality:
     - Component testability and mock-ability
     - Integration testing complexity and strategies
     - Performance testing requirements and approach
     - Security testing needs and vulnerability assessment
     - Test data requirements and management strategies
     - Quality gates definition for each component
     
     **ai-ml-engineer** (IF AI features detected) designs:
     - LLM integration patterns and prompt strategies
     - Vector database architecture and RAG design
     - Model deployment and inference optimization
     - AI ethics and safety considerations

4. **Integration & Conflict Resolution with Error Handling**
   - **Review Phase Error Recovery:**
     - If design-reviewer fails: Claude performs basic architecture validation
     - If ai-ml-engineer fails (when needed): Claude provides standard AI integration patterns
     - If conflicting responses: Claude arbitrates based on project priorities from `PRD.md`
   
   - **Conflict Resolution Strategy:**
     - Prioritize security and scalability concerns from reviewer
     - Balance AI requirements with practical implementation constraints
     - Document trade-offs and decisions made during conflict resolution
   
   - **Fallback Integration:**
     - If multiple agents fail: Claude creates architecture based on `PRD.md` requirements
     - Use industry standard patterns for unknown areas
     - Mark high-risk architectural decisions for future review

5. **Feedback Loop Detection and Resolution**
   - **Requirements Gap Detection:**
     - If architecture reveals missing or unclear requirements
     - If technical constraints conflict with business requirements  
     - If user stories are insufficient for technical implementation
     - **Feedback Action:** Flag need to return to `/discover` with specific requirement gaps
   
   - **Technical Feasibility Issues:**
     - If proposed architecture exceeds technical capabilities
     - If timeline estimates conflict with architectural complexity
     - If resource constraints make architecture unviable
     - **Feedback Action:** Document alternative approaches or scope reduction needs
   
   - **Integration Complexity Discovery:**
     - If component integration is more complex than initially understood
     - If third-party dependencies have technical limitations
     - If performance requirements conflict with architectural approach
     - **Feedback Action:** Flag need for iterative design refinement or requirement adjustment

6. **Resilient Documentation Generation with Feedback Tracking**
   - Synthesize all available findings (architecture + review + AI integration)
   - Generate EXACTLY ONE file: `SPECS.md` containing:
     - System architecture overview (validated and AI-enhanced where available)
     - Implementation phases with checkboxes
     - Component specifications with:
       - Purpose and functionality
       - Assigned engineer(s) [Claude/specialist] with fallback assignments
       - Dependencies on other components
       - Interface contracts (inputs/outputs)
       - Integration points and coordination patterns
       - **Risk indicators** for components with limited analysis
     - Build order and coordination strategy (parallel/sequential)
     - Testing requirements per component
     - **Error Recovery Documentation:**
       - Areas requiring additional architectural review
       - Assumptions made due to agent failures
       - Recommended validation steps during implementation
       - Confidence levels for different architectural decisions