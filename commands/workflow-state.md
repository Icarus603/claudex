---
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob
argument-hint: [action: save/load/resume/checkpoint/reset] [state-id: optional checkpoint identifier]
description: Comprehensive workflow state tracking and intelligent resumption management
---

Think harder about workflow state management and seamless resumption capabilities.

## Workflow State Tracking and Resumption

Action: $ARGUMENTS (default: save)

**Steps to execute:**

1. **Comprehensive State Capture and Analysis**
   - Read existing state files: `WORKFLOW_STATE.md`, `STATE_CHECKPOINTS.md`, `RESUMPTION_CONTEXT.md`
   - **Multi-Dimensional State Tracking:**
     - **Phase State:** Current development phase and sub-phase progress
     - **Agent State:** Agent execution history, success/failure patterns, context requirements
     - **Artifact State:** File completion status, dependency tracking, quality validation status
     - **Cycle State:** Current iteration counts, cycle efficiency metrics, intervention triggers
     - **Context State:** Accumulated knowledge, decision history, learning insights
     - **Quality State:** Testing progress, performance baselines, security validation status
   
   - **State Consistency Validation:**
     - Verify state consistency across all tracking dimensions
     - Detect state corruption or incomplete state information
     - Identify state conflicts requiring resolution

2. **Intelligent State Checkpoint Management**

   **Automatic Checkpoint Creation:**
   ```
   CHECKPOINT TRIGGERS:
   - Before each major command execution (discover, design, build, deploy, maintain)
   - After successful command completion
   - Before feedback loop initiation (phase regression)
   - After cycle intervention or optimization
   - Before critical decision points or escalations
   - At natural workflow pause points (end of day, waiting for external input)
   ```

   **Checkpoint State Structure:**
   ```
   STATE_CHECKPOINTS.md:
   
   ## Checkpoint: [TIMESTAMP-PHASE-ID]
   ### Execution Context
   - Current Phase: [discover/design/build/deploy/maintain]  
   - Phase Progress: [percentage complete, specific milestones reached]
   - Next Planned Action: [specific command or decision point]
   
   ### Agent Context Snapshot
   - Active Agents: [which agents were in use, their state]
   - Agent Performance: [recent success/failure patterns]
   - Agent Context Requirements: [what context agents need for resumption]
   
   ### Artifact State
   - Completed Files: [PRD.md, SPECS.md, etc. with completion status]
   - Partial Work: [in-progress components, temporary files, draft content]
   - Dependencies: [what depends on what, blocking relationships]
   
   ### Cycle and Optimization State
   - Current Cycle: [active feedback loops, iteration counts]
   - Optimization Actions: [recent interventions, their effectiveness]
   - Process Adaptations: [workflow customizations in effect]
   
   ### Quality and Validation State
   - Quality Gates: [passed/failed/pending quality checkpoints]
   - Testing Progress: [test coverage, performance baselines, security validation]
   - Known Issues: [technical debt, blockers, quality concerns]
   ```

3. **Intelligent Resumption Strategy**

   **Context-Aware Resumption:**
   - **State Analysis for Resumption:**
     - Analyze how much time has elapsed since last checkpoint
     - Assess if external context may have changed (requirements, technology, team)
     - Identify state components that may need refresh or validation
   
   - **Smart Resumption Decision Making:**
     - **Recent Interruption (< 1 hour):** Direct resumption with full context
     - **Same Day Resumption (< 1 day):** Brief context refresh, validate assumptions
     - **Multi-Day Resumption (< 1 week):** Context validation, stakeholder check-in
     - **Long-Term Resumption (> 1 week):** Full context review, requirements validation
   
   - **Resumption Context Preparation:**
     - Load relevant agent context for immediate execution
     - Prepare technical context (architecture decisions, constraints)
     - Refresh stakeholder context (requirements changes, priority shifts)
     - Update resource context (timeline, budget, team availability)

4. **Advanced Workflow State Management**

   **Parallel State Tracking:**
   - **Multiple Workflow Branches:**
     - Track experimental branches (proof-of-concept, alternative approaches)
     - Manage feature branch workflows with different states
     - Handle simultaneous work on different project components
   
   - **State Merging and Conflict Resolution:**
     - Intelligently merge state from parallel workflow branches
     - Detect and resolve conflicts between different workflow paths
     - Preserve valuable context from unsuccessful branches
   
   - **Collaborative State Management:**
     - Handle multiple team members working on different workflow aspects
     - Synchronize state across distributed development environments
     - Manage handoffs between different workflow phases and team members

5. **Failure Recovery and State Reconstruction**

   **Robust Recovery Mechanisms:**
   - **State File Corruption Recovery:**
     - Reconstruct state from git history and project artifacts
     - Infer state from existing files (PRD.md existence = discovery complete)
     - Use partial state information to rebuild complete state picture
   
   - **Context Loss Recovery:**
     - Rebuild agent context from command execution history
     - Reconstruct decision context from artifact analysis
     - Infer process context from project timeline and artifact patterns
   
   - **Incomplete State Resolution:**
     - Identify missing state components and their importance
     - Provide fallback strategies when state cannot be fully reconstructed
     - Create new baseline state from current project analysis

6. **Predictive State Management**

   **State-Based Optimization:**
   - **Predictive Workflow Planning:**
     - Use state patterns to predict optimal next actions
     - Identify likely state transitions and prepare for them
     - Anticipate resource needs based on state trajectory
   
   - **Risk-Based State Monitoring:**
     - Monitor state patterns that historically lead to problems
     - Set up early warning systems based on state analysis
     - Automatically trigger interventions based on state risk assessment
   
   - **Efficiency Optimization:**
     - Optimize checkpoint frequency based on workflow stability
     - Adjust state tracking granularity based on project complexity
     - Streamline state information based on resumption patterns

7. **State-Driven Process Intelligence**

   **Workflow Adaptation Based on State:**
   - **Dynamic Process Customization:**
     - Adapt command execution based on current state analysis
     - Customize agent selection based on state-driven success prediction
     - Optimize resource allocation based on state trajectory analysis
   
   - **State-Informed Decision Making:**
     - Use state history to inform current decision points
     - Apply state-based learning to similar future situations
     - Create state-driven recommendations for process improvements
   
   - **Cross-Project State Learning:**
     - Extract state patterns that predict project success
     - Build organizational knowledge from successful state transitions
     - Create state templates for different project types and contexts

## Advanced State Features

### Multi-Resolution State Tracking
```
High-Resolution: Real-time command execution state (for active development)
Medium-Resolution: Daily workflow progress state (for regular resumption)
Low-Resolution: Weekly project milestone state (for long-term tracking)
```

### State-Based Analytics
- Workflow efficiency analysis based on state transition patterns
- Bottleneck identification through state duration analysis
- Success prediction based on state progression patterns
- Resource optimization recommendations from state utilization analysis

### Intelligent State Compression
- Compress old state information while preserving key insights
- Archive detailed state for completed phases while maintaining summary context
- Optimize state storage for long-running projects
- Balance state detail with performance and storage considerations

## State Management Integration Examples

### Command Integration
```
Before Command Execution:
1. Create state checkpoint
2. Load relevant context from state history  
3. Prepare agents with state-driven context
4. Execute command with state monitoring

After Command Execution:
1. Capture execution results in state
2. Update artifact and quality state
3. Analyze state for feedback loop triggers
4. Create completion checkpoint
```

### Resumption Integration  
```
Resumption Process:
1. Analyze last checkpoint and elapsed time
2. Validate state consistency and currency
3. Refresh context based on resumption duration
4. Prepare workflow for optimal continuation
5. Execute with enhanced monitoring for resumption stability
```

### Recovery Integration
```
Recovery Process:
1. Assess state damage/loss extent
2. Reconstruct state from available information
3. Identify state gaps and create fallback strategies
4. Resume workflow with appropriate risk mitigation
5. Enhance state tracking to prevent similar issues
```

## Success Criteria

- **Seamless Resumption:** Projects can be resumed at any point without context loss
- **State Integrity:** Workflow state remains accurate and consistent throughout project lifecycle
- **Recovery Robustness:** System can recover gracefully from state loss or corruption
- **Performance Efficiency:** State management doesn't significantly impact workflow performance
- **Predictive Value:** State analysis provides actionable insights for workflow optimization
- **Collaborative Support:** Multiple team members can work with shared workflow state
- **Long-term Sustainability:** State management scales to long-running, complex projects
- **Cross-Project Learning:** State patterns contribute to organizational development intelligence