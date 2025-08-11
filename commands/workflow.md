---
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob
argument-hint: [action: auto/status/next/back/reset] [target-phase: discover/design/build/deploy/maintain]
description: Intelligent workflow orchestration managing interdependencies and iterative development cycles
---

Think harder about the complete development workflow state and optimal next actions.

Enter plan mode and present your workflow orchestration strategy before proceeding.

## Workflow Orchestration

Action: $ARGUMENTS (default: auto)

**Steps to execute:**

1. **Project State Analysis with Context Persistence**
   - Read `WORKFLOW_STATE.md` to understand current project phase and history
   - **State File Missing Recovery:**
     - If `WORKFLOW_STATE.md` missing: Initialize from existing project files
     - Scan for `PRD.md`, `SPECS.md`, `DEPLOYMENT.md`, `MAINTENANCE_LOG.md`
     - Infer current phase from available artifacts and codebase maturity
     - Create initial workflow state with discovered context
   - Analyze git history and commit patterns to understand development progression
   - Identify completed phases, current phase, and pending work
   - Detect potential issues requiring phase regressions or iterations

2. **Intelligent Phase Orchestration**

   **Auto Mode (Default):** Analyze project state and execute optimal next action
   
   **Phase Dependency Analysis:**
   ```
   DISCOVERY → DESIGN → BUILD → DEPLOY → MAINTAIN
        ↑         ↑       ↑        ↑         ↑
        └─────────┴───────┴────────┴─────────┘
         Feedback loops when issues discovered
   ```
   
   **Forward Progression Logic:**
   - **Discovery Complete** (`PRD.md` exists, requirements clear) → Proceed to Design
   - **Design Complete** (`SPECS.md` exists, architecture validated) → Proceed to Build  
   - **Build Complete** (components implemented, tests passing) → Proceed to Deploy
   - **Deploy Complete** (production running, monitoring active) → Proceed to Maintain
   - **Maintenance Ongoing** (system operational, continuous improvement)

   **Regression Detection and Feedback Loops:**
   - **Design Issues Found During Build:**
     - Architecture insufficient for requirements
     - Missing component specifications 
     - Interface contracts unclear or incomplete
     - **Action:** Execute `/design` with specific focus areas, then resume `/build`
   
   - **Requirements Issues Found During Design/Build:**
     - Unclear business requirements
     - Missing user stories or acceptance criteria
     - Conflicting stakeholder requirements
     - **Action:** Execute `/discover` with specific gaps, then resume current phase
   
   - **Technical Debt in Maintenance:**
     - Performance issues requiring architecture changes
     - Security vulnerabilities needing design updates
     - Scalability problems requiring component redesign
     - **Action:** Execute `/design` → `/build` cycle, then return to maintenance

3. **Context-Aware Command Execution with State Management**

   **Phase Execution with Feedback Detection:**
   - Execute target command (discover/design/build/deploy/maintain)
   - **Monitor for feedback triggers:**
     - Agent failures indicating missing context
     - Implementation blockers requiring upstream changes
     - Quality issues requiring architectural revisions
     - Performance problems requiring design changes
   
   **Automatic Regression Handling:**
   - **During `/design`:** If architecture gaps found → auto-execute `/discover` with specific focus
   - **During `/build`:** If component complexity exceeds specs → auto-execute `/design` update
   - **During `/deploy`:** If infrastructure requirements unclear → auto-execute `/design` infrastructure review
   - **During `/maintain`:** If systematic issues found → auto-execute relevant upstream phases

4. **Iterative Development Cycle Management**

   **Cycle Detection and Optimization:**
   - Track how many times each phase has been executed
   - Identify recurring feedback patterns and optimize for them
   - Detect infinite loops and provide alternative approaches
   - Balance perfectionism vs progress with intelligent thresholds

   **Smart Iteration Limits:**
   - **Discovery-Design cycles:** Max 3 iterations before escalating to stakeholder alignment
   - **Design-Build cycles:** Max 4 iterations before MVP scope reduction
   - **Build-Deploy cycles:** Max 3 iterations before infrastructure simplification
   - **Any phase regression:** Log pattern analysis for process improvement

   **Progress Tracking:**
   - Maintain completion percentages for each phase
   - Track velocity and cycle efficiency metrics
   - Identify process bottlenecks and improvement opportunities

5. **Workflow State Persistence and Recovery**

   **State Management:**
   - UPDATE `WORKFLOW_STATE.md` with:
     - Current phase and completion status
     - Phase execution history and feedback loops
     - Context learned from previous cycles
     - Outstanding issues and dependencies
     - Next recommended actions and reasoning
     - Performance metrics and cycle analysis
   
   **Recovery and Resumption:**
   - **Session interruption:** Resume from last known state
   - **Context restoration:** Restore agent context from previous executions
   - **Progress preservation:** Maintain progress even through regressions
   - **Learning integration:** Apply lessons learned from previous cycles

## Workflow State Transitions

### Normal Progression
```
INIT → DISCOVER → DESIGN → BUILD → DEPLOY → MAINTAIN → [ONGOING]
```

### With Feedback Loops
```
DISCOVER ←→ DESIGN ←→ BUILD ←→ DEPLOY → MAINTAIN
    ↑         ↑         ↑         ↑         ↑
    └─────────┼─────────┼─────────┼─────────┘
              └─────────┼─────────┼─────────┘
                        └─────────┼─────────┘
                                  └─────────┘
```

### Iterative Refinement
```
MAINTAIN → [Issue Detected] → DESIGN → BUILD → DEPLOY → MAINTAIN
                        ↑              ↑         ↑
                        └──────────────┴─────────┘
                         Additional refinements
```

## Intelligent Decision Making

**When to Progress Forward:**
- Current phase deliverables are complete and validated
- No blocking issues or unresolved dependencies
- Quality gates are satisfied
- Next phase prerequisites are met

**When to Regress Backward:**
- Fundamental issues discovered that require upstream changes
- Agent failures indicating insufficient context or requirements
- Quality issues that cannot be resolved in current phase
- Implementation blockers requiring architectural or requirement changes

**When to Iterate Current Phase:**
- Issues found that can be resolved within current phase scope
- Quality improvements needed but foundation is solid
- Minor refinements and optimizations required
- Incremental progress toward phase completion

## Error Recovery with Learning

**Workflow-Level Error Recovery:**
- **Command execution failures:** Retry with simplified scope or fallback approaches
- **Infinite loop detection:** Break cycles with alternative approaches or scope reduction
- **Context loss:** Reconstruct context from available artifacts and project history
- **Agent coordination failures:** Fall back to Claude-only execution with documented limitations

**Learning and Adaptation:**
- Analyze successful and failed workflow patterns
- Optimize phase transitions based on project type and complexity
- Improve regression detection based on historical patterns
- Recommend process improvements based on cycle analysis

## Success Criteria

- **Optimal workflow orchestration:** Right phase at the right time based on project state
- **Efficient feedback loops:** Quick detection and resolution of phase dependencies
- **Context preservation:** No loss of progress or learning through iterations
- **Intelligent automation:** Minimal manual workflow management required
- **Continuous improvement:** Workflow efficiency increases over project lifecycle
- **Quality integration:** Quality maintained through all iterations and regressions
- **State persistence:** Robust recovery and resumption capabilities