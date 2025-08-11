---
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob
argument-hint: [analyze/optimize/reset] [cycle-type: discovery-design/design-build/build-deploy/maintain-design]
description: Intelligent iterative development cycle management and optimization
---

Think harder about development cycle patterns and optimization strategies.

Enter plan mode and present your cycle management approach before proceeding.

## Iterative Development Cycle Management

Action: $ARGUMENTS (default: analyze)

**Steps to execute:**

1. **Cycle Pattern Analysis with Historical Context**
   - Read `WORKFLOW_STATE.md` to understand current cycle history
   - Read `CYCLE_ANALYTICS.md` for historical cycle performance data
   - **Pattern Recognition:**
     - Identify recurring cycle types (Discovery↔Design, Design↔Build, etc.)
     - Analyze cycle duration and efficiency trends
     - Detect infinite loop patterns and bottlenecks
     - Track success/failure rates for different cycle approaches
   - **Performance Metrics:**
     - Average cycle completion time
     - Resource utilization per cycle type
     - Quality outcomes after cycle completion
     - Team productivity impact of different cycle patterns

2. **Intelligent Cycle Optimization**

   **Cycle Efficiency Assessment:**
   ```
   DISCOVERY ↔ DESIGN CYCLES:
   - Efficient: 1-2 iterations (requirements clarification)
   - Warning: 3 iterations (stakeholder alignment issues)
   - Critical: 4+ iterations (fundamental scope problems)
   - Optimization: Stakeholder workshop, scope reduction, phased approach
   
   DESIGN ↔ BUILD CYCLES:
   - Efficient: 1-3 iterations (technical refinement)
   - Warning: 4-5 iterations (architecture complexity issues)
   - Critical: 6+ iterations (fundamental technical mismatch)
   - Optimization: Technology change, architecture simplification, MVP scope
   
   BUILD ↔ DEPLOY CYCLES:
   - Efficient: 1-2 iterations (environment configuration)
   - Warning: 3 iterations (infrastructure complexity)
   - Critical: 4+ iterations (fundamental deployment architecture issues)
   - Optimization: Containerization, cloud-native approach, infrastructure simplification
   
   MAINTAIN → DESIGN/BUILD CYCLES:
   - Efficient: Occasional cycles (planned technical debt resolution)
   - Warning: Monthly cycles (systemic design issues)
   - Critical: Weekly cycles (fundamental architecture problems)
   - Optimization: Major refactoring, technology migration, system redesign
   ```

3. **Cycle Intervention Strategies**

   **Proactive Cycle Prevention:**
   - **Early Complexity Detection:**
     - Analyze requirements for inherent complexity indicators
     - Predict likely cycle patterns based on project characteristics
     - Set realistic iteration budgets for different project types
     - Pre-allocate time for expected refinement cycles
   
   **Cycle Breaking Strategies:**
   - **Scope Reduction:** When cycles exceed efficiency thresholds
     - Identify core functionality vs nice-to-have features
     - Create phased delivery approach with MVP first
     - Defer complex integrations to later phases
   
   - **Technology Simplification:** When technical cycles are excessive
     - Switch to simpler, proven technology stacks
     - Eliminate complex integrations in favor of simpler approaches
     - Use managed services instead of custom implementations
   
   - **Process Intervention:** When team/stakeholder cycles occur
     - Escalate to stakeholder alignment workshops
     - Implement time-boxed decision making
     - Create architectural decision records (ADRs) to prevent re-litigation

4. **Adaptive Cycle Management**

   **Learning from Cycle Patterns:**
   - **Successful Cycle Analysis:**
     - What conditions led to efficient cycle completion?
     - Which approaches minimized back-and-forth iterations?
     - How did team composition affect cycle efficiency?
   
   - **Failed Cycle Analysis:**
     - What warning signs preceded cycle inefficiency?
     - Which intervention strategies were most effective?
     - How can similar cycles be prevented in future projects?
   
   **Predictive Cycle Management:**
   - **Risk-Based Cycle Planning:**
     - Assign cycle budgets based on project complexity analysis
     - Pre-identify likely iteration points and plan for them
     - Set automatic intervention triggers based on cycle metrics
   
   - **Adaptive Thresholds:**
     - Adjust cycle efficiency thresholds based on project context
     - Account for team experience and technology familiarity
     - Factor in timeline pressure and quality requirements

5. **Cycle Performance Optimization**

   **Context-Aware Cycle Strategies:**
   - **Startup/MVP Projects:** Favor speed over perfection, higher iteration tolerance
   - **Enterprise Projects:** Emphasize stability, lower iteration tolerance
   - **Research Projects:** Accept high iteration counts, focus on learning
   - **Maintenance Projects:** Minimize cycles, emphasize stability
   
   **Resource-Aware Cycle Management:**
   - **High Resource Availability:** Allow more iterations for quality
   - **Resource Constraints:** Aggressive cycle breaking and scope reduction
   - **Time Pressure:** Implement parallel cycle approaches where possible
   - **Quality Requirements:** Budget additional cycles for refinement

6. **Cycle Documentation and Learning**

   **Real-Time Cycle Tracking:**
   - UPDATE `CYCLE_ANALYTICS.md` with:
     - Current cycle performance metrics
     - Intervention strategies employed and their effectiveness
     - Pattern recognition insights and recommendations
     - Resource utilization and team productivity impacts
   
   **Cross-Project Learning:**
   - Maintain organizational cycle pattern database
   - Share successful intervention strategies across projects
   - Build predictive models for cycle efficiency
   - Create best practice recommendations based on historical data

## Cycle Optimization Strategies

### Parallel Cycle Execution
```
Traditional: DISCOVER → DESIGN → BUILD (linear, high cycle risk)
Optimized: DISCOVER ↔ DESIGN (while) BUILD preparation (parallel risk reduction)
```

### Risk-Based Cycle Budgeting
```
Low Risk Projects: 1-2 iterations per phase
Medium Risk Projects: 2-4 iterations per phase  
High Risk Projects: 3-6 iterations per phase (with intervention triggers)
```

### Intervention Escalation
```
Iteration Count → Warning Threshold → Intervention Strategy → Escalation
1-2: Normal → Continue → Monitor
3-4: Warning → Optimization Analysis → Process Improvement
5-6: Critical → Scope/Tech Review → Management Escalation
7+: Emergency → Project Restructure → Stakeholder Alignment
```

## Advanced Cycle Management

### Predictive Cycle Analytics
- Use historical data to predict cycle likelihood
- Machine learning models for cycle pattern recognition
- Early warning systems for cycle efficiency problems
- Automated intervention recommendations

### Dynamic Scope Management
- Real-time scope adjustment based on cycle efficiency
- Automated MVP extraction when cycles exceed thresholds
- Feature prioritization optimization during cycle stress
- Stakeholder communication automation for scope changes

### Quality-Cycle Balance
- Quality gate flexibility during high-cycle periods
- Technical debt management during cycle stress
- Post-cycle quality recovery strategies
- Long-term quality impact analysis of cycle decisions

## Success Criteria

- **Cycle Efficiency:** Minimize time spent in iterations while maintaining quality
- **Pattern Recognition:** Early identification of problematic cycle patterns
- **Intervention Effectiveness:** Successful cycle breaking when efficiency thresholds exceeded
- **Learning Integration:** Continuous improvement of cycle management based on historical data
- **Quality Preservation:** Maintain software quality despite cycle optimization pressure
- **Team Productivity:** Optimize cycle patterns for developer and stakeholder productivity
- **Predictive Accuracy:** Improve ability to forecast and prevent cycle inefficiency