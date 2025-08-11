---
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob
argument-hint: [action: save/load/merge/analyze] [context-type: agent/cycle/decision/learning]
description: Cross-command context persistence and intelligent context management
---

Think harder about context preservation and knowledge transfer across development phases.

Enter plan mode and present your context management strategy before proceeding.

## Cross-Command Context Persistence

Action: $ARGUMENTS (default: save)

**Steps to execute:**

1. **Context State Analysis and Classification**
   - Read existing context files: `PROJECT_CONTEXT.md`, `AGENT_MEMORY.md`, `DECISION_LOG.md`
   - **Context Categories:**
     - **Agent Context:** What agents learned, failed at, succeeded with
     - **Technical Context:** Architecture decisions, technology choices, integration patterns
     - **Requirements Context:** User needs, business constraints, stakeholder preferences
     - **Quality Context:** Testing strategies, performance baselines, security requirements
     - **Process Context:** What workflow patterns work, cycle efficiency, team dynamics
   
   - **Context Freshness Assessment:**
     - Identify stale context that may no longer be relevant
     - Detect conflicting context between different development phases
     - Prioritize recent context while preserving valuable historical insights

2. **Intelligent Context Persistence Strategy**

   **Agent Memory Management:**
   ```
   AGENT_MEMORY.md Structure:
   
   ## Agent Performance History
   - Agent success/failure patterns by project phase
   - Context requirements for optimal agent performance
   - Agent collaboration patterns that worked well
   - Agent fallback strategies that were effective
   
   ## Agent Learning Insights
   - What information agents needed but didn't have
   - Common agent failure modes and prevention strategies
   - Successful agent coordination patterns
   - Agent-specific context requirements for future executions
   ```

   **Decision Context Preservation:**
   ```
   DECISION_LOG.md Structure:
   
   ## Architectural Decisions
   - Technology choices and rationale
   - Design pattern selections and trade-offs
   - Integration approach decisions
   - Performance optimization choices
   
   ## Process Decisions
   - Workflow adaptations and their effectiveness
   - Cycle management decisions and outcomes
   - Quality gate adjustments and rationale
   - Resource allocation decisions
   ```

   **Project Learning Accumulation:**
   ```
   PROJECT_CONTEXT.md Structure:
   
   ## Requirements Evolution
   - How requirements changed over project lifecycle
   - Stakeholder alignment challenges and solutions
   - User need discoveries during implementation
   
   ## Technical Evolution  
   - Architecture changes and their drivers
   - Technology stack adaptations
   - Performance optimization journey
   - Security requirement evolution
   
   ## Process Evolution
   - Workflow optimization discoveries
   - Team productivity patterns
   - Quality assurance effectiveness patterns
   ```

3. **Context-Aware Command Enhancement**

   **Pre-Command Context Loading:**
   - **Agent Context Preparation:**
     - Load relevant agent performance history
     - Prepare agents with context about previous failures/successes
     - Set agent expectations based on project-specific learning
   
   - **Technical Context Integration:**
     - Load architectural decisions and constraints
     - Prepare technology stack context and limitations
     - Set performance and quality expectations from previous phases
   
   - **Process Context Application:**
     - Apply learned workflow optimizations
     - Set cycle management thresholds based on project history
     - Configure quality gates based on project-specific requirements

   **Post-Command Context Capture:**
   - **Agent Performance Documentation:**
     - Record what worked well and what didn't for each agent
     - Document context gaps that led to agent failures
     - Capture successful agent collaboration patterns
   
   - **Decision Documentation:**
     - Record significant technical and process decisions
     - Document rationale and trade-offs considered
     - Capture context that influenced decisions
   
   - **Learning Extraction:**
     - Identify patterns that could improve future command executions
     - Extract reusable strategies and approaches
     - Document anti-patterns to avoid in future

4. **Context Transfer Between Commands**

   **Seamless Context Flow:**
   - **Discovery → Design Context Transfer:**
     - Requirements complexity indicators
     - Stakeholder preference patterns
     - Technical constraint discoveries
   
   - **Design → Build Context Transfer:**
     - Architecture complexity assessments
     - Technology choice rationale
     - Integration pattern specifications
   
   - **Build → Deploy Context Transfer:**
     - Implementation complexity outcomes
     - Performance characteristic discoveries
     - Integration challenge solutions
   
   - **Deploy → Maintain Context Transfer:**
     - Production behavior patterns
     - Performance baseline reality
     - Operational complexity insights
   
   - **Maintain → [Previous Phases] Context Transfer:**
     - System behavior insights requiring architectural changes
     - User feedback requiring requirement updates
     - Technical debt patterns requiring design revisits

5. **Intelligent Context Synthesis**

   **Cross-Phase Context Analysis:**
   - **Pattern Recognition:**
     - Identify recurring challenges across project phases
     - Recognize successful solution patterns that can be reused
     - Detect early warning signs of problems based on historical context
   
   - **Context Conflict Resolution:**
     - When different phases have conflicting context, prioritize based on:
       - Recency (newer context generally more accurate)
       - Specificity (specific context overrides general patterns)
       - Success rate (context from successful outcomes prioritized)
   
   - **Context Gap Identification:**
     - Identify missing context that led to command failures
     - Predict future context needs based on project trajectory
     - Prepare context collection strategies for anticipated needs

6. **Context-Driven Process Optimization**

   **Adaptive Process Intelligence:**
   - **Workflow Customization:**
     - Adapt command execution based on project-specific context
     - Customize agent selection based on performance history
     - Optimize coordination patterns based on past success
   
   - **Predictive Context Application:**
     - Use historical context to predict likely challenges
     - Pre-configure solutions based on similar past situations
     - Adjust resource allocation based on context-driven predictions
   
   - **Continuous Context Learning:**
     - Refine context categories based on their predictive value
     - Optimize context persistence strategies based on usage patterns
     - Improve context transfer mechanisms based on effectiveness

7. **Context Quality and Maintenance**

   **Context Hygiene Management:**
   - **Context Validation:**
     - Verify context accuracy and relevance
     - Remove outdated or conflicting context
     - Merge related context entries for clarity
   
   - **Context Optimization:**
     - Compress verbose context while preserving key insights
     - Categorize context for efficient retrieval
     - Index context for rapid lookup during command execution
   
   - **Context Recovery:**
     - Rebuild context from project artifacts when files are lost
     - Infer missing context from successful project outcomes
     - Create fallback context strategies for new project types

## Advanced Context Features

### Context-Aware Agent Orchestration
- Select agents based on context-driven success prediction
- Prepare agents with relevant historical context
- Optimize agent coordination based on past collaboration success

### Predictive Context Modeling  
- Use machine learning to predict context needs
- Automatically prepare context for anticipated command sequences
- Identify context patterns that predict project success/failure

### Cross-Project Context Transfer
- Share successful context patterns across similar projects
- Build organizational knowledge base from project contexts
- Create context templates for common project types

## Context Integration Examples

### Agent Context Usage
```
Context: "ai-ml-engineer previously failed on this project when given incomplete interface specifications"
Action: Ensure complete interface specs before calling ai-ml-engineer
```

### Technical Context Application
```
Context: "Previous performance testing revealed database bottlenecks with this architecture"
Action: Pre-configure database optimization during deployment planning
```

### Process Context Learning
```
Context: "Design-build cycles averaged 4 iterations due to unclear requirements"
Action: Invest additional time in requirements clarification during discovery
```

## Success Criteria

- **Context Continuity:** No loss of important context between command executions
- **Context Relevance:** Context application improves command success rates
- **Context Learning:** System gets smarter about project patterns over time
- **Context Efficiency:** Context management doesn't slow down development workflow
- **Context Quality:** Context remains accurate and useful throughout project lifecycle
- **Cross-Command Intelligence:** Commands benefit from learnings of previous phases
- **Predictive Value:** Context enables proactive problem prevention and optimization