---
allowed-tools: Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob
argument-hint: [maintenance type: bug/performance/refactor/security] [description]
description: Maintain and optimize applications with dynamic specialist routing
---

$THINKING_LEVEL about maintenance requirements and approach.

Enter plan mode and present your maintenance strategy before proceeding.

## Maintenance Workflow

Maintenance request: $ARGUMENTS

**Steps to execute:**

1. **Maintenance Type Classification**
   - Analyze the maintenance request type and complexity
   - Set appropriate thinking level:
     - Simple bug fixes: "Think" (4K tokens)
     - Performance issues/complex bugs: "Think hard" (10K tokens)
     - Major refactoring/architecture changes: "Think harder" (32K tokens)
   - Identify scope and potential impact

2. **Dynamic Specialist Routing with Proactive QA**
   - **Bug Fixes & Debugging**:
     - Call qa-engineer subagent for:
       - **Proactive quality assessment:** Identify related components at risk
       - Root cause analysis and reproduction with system-wide impact evaluation
       - Comprehensive debugging approach with monitoring integration
       - Fix validation and comprehensive regression testing
       - **Prevention strategies:** Long-term quality improvement recommendations
       - **Quality monitoring:** Setup alerts for similar issues in the future
   
   - **Performance Optimization**:
     - **SIMULTANEOUSLY** call relevant agents:
       - **performance-analyzer** for:
         - Bottleneck identification and comprehensive profiling
         - Optimization strategy and implementation approach
         - Performance testing and validation methodology
       - **qa-engineer** for:
         - **Performance monitoring:** Baseline establishment and regression detection
         - **Load testing validation:** Comprehensive performance testing under various conditions
         - **Monitoring integration:** Real-time performance alerting and tracking
         - **Quality assurance:** Ensure optimizations don't introduce bugs or regressions
   
   - **Code Quality & Refactoring**:
     - **SIMULTANEOUSLY** call relevant agents:
       - **code-simplifier** for:
         - Code complexity analysis and refactoring strategy
         - Implementation approach for maintainability improvements
         - Technical debt reduction planning
       - **qa-engineer** for:
         - **Quality impact assessment:** Evaluate risks of refactoring changes
         - **Testing strategy:** Comprehensive test coverage for refactored components
         - **Quality validation:** Ensure refactoring maintains or improves system quality
         - **Regression prevention:** Setup monitoring for quality degradation post-refactor
   
   - **Security Issues**:
     - **SIMULTANEOUSLY** call relevant agents:
       - **qa-engineer** for:
         - **Proactive security monitoring:** Continuous vulnerability scanning and threat detection
         - **Security testing:** Comprehensive penetration testing and vulnerability assessment
         - **Compliance validation:** Ensure security fixes meet regulatory requirements
         - **Security regression prevention:** Setup monitoring for future security vulnerabilities
       - **devops-engineer** for: Infrastructure security, access controls, network protection
       - **backend-engineer** for: Application security, input validation, authentication fixes

3. **Data-Driven Analysis (When Applicable) with Error Recovery**
   - Call data-scientist subagent for:
     - Performance metrics analysis
     - User behavior impact assessment
     - A/B testing for optimization changes
     - Business impact measurement
   
   **Data Analysis Error Recovery:**
   - If data-scientist fails: Claude provides basic metrics analysis
   - If data unavailable: Use application logs and basic performance monitoring
   - If analysis incomplete: Proceed with available insights and document limitations

4. **Implementation & Validation with Error Recovery**
   - Execute maintenance changes in code
   - **Error Recovery During Implementation:**
     - If specialist recommendations fail: Implement simpler alternative solutions
     - If testing fails: Create hotfix with minimal risk changes
     - If performance degrades: Implement rollback and try alternative approach
     - If integration breaks: Create temporary compatibility layers
   
   - Run comprehensive testing suite (or basic validation if testing fails)
   - Validate improvements (or document partial success)
   - Ensure no regressions (or document acceptable trade-offs)

5. **Maintenance Feedback Loop Detection**

   **Systemic Issues Requiring Upstream Changes:**
   - **Architectural Limitations Discovered:**
     - Performance issues that cannot be resolved without architectural changes
     - Scalability bottlenecks requiring fundamental design modifications
     - Security vulnerabilities stemming from architectural decisions
     - **Feedback Action:** Flag need to return to `/design` for architectural re-evaluation
   
   - **Requirements Evolution and Gaps:**
     - User needs have changed significantly since original requirements
     - Business requirements conflict with current implementation approach
     - New feature requests require major structural changes
     - **Feedback Action:** Flag need to return to `/discover` for requirements re-evaluation
   
   - **Technical Debt Requiring Rebuild:**
     - Code complexity has reached unmaintainable levels
     - Technology stack is obsolete and blocking progress
     - Integration patterns are causing systematic failures
     - **Feedback Action:** Flag need for `/design` → `/build` modernization cycle

   **Pattern Recognition for Process Improvement:**
   - Recurring maintenance issues indicating systematic problems
   - Performance degradation patterns suggesting architectural issues
   - Security incidents revealing design gaps
   - User experience issues stemming from requirement misunderstandings

6. **Documentation Update with Quality Tracking and Feedback Analysis**
   - UPDATE (append to) EXACTLY ONE file: `MAINTENANCE_LOG.md`
   - Add comprehensive entries with:
     - Timestamp and issue description
     - Root cause analysis and system impact
     - Solution implemented and validation performed
     - **Quality metrics:** Before/after performance, reliability, security measurements
     - **Preventive measures:** Monitoring, alerts, and process improvements implemented
     - **Quality assurance actions:** Testing performed and ongoing quality monitoring setup
     - **Feedback analysis:** Patterns indicating need for upstream phase revisitation
     - **Process improvement recommendations:** Lessons learned for future development cycles