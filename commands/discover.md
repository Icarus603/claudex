---
allowed-tools: Task, Read, Write
argument-hint: [feature/project description]
description: Discover and document product requirements through PM analysis and technical investigation
---

Think hard about discovering product requirements.

## Requirements Discovery Workflow

Analyze the request: $ARGUMENTS

**Steps to execute:**

1. **Parallel Analysis Phase with Error Handling**
   - **SIMULTANEOUSLY** call both agents with fallback strategy:
     
     **product-manager** analyzes:
     - Target users and their specific needs
     - Core features with clear priorities (MVP vs nice-to-have)
     - Market analysis and competitive differentiation
     - Success metrics and acceptance criteria
     - User stories in proper format
     
     **technical-investigator** analyzes:
     - Technical feasibility and implementation complexity
     - Existing system constraints and integration requirements
     - Technology stack recommendations
     - Potential risks and mitigation strategies
     - Resource and timeline estimates

2. **Error Recovery & Validation**
   - **If product-manager fails/incomplete:**
     - Claude extracts basic user needs from $ARGUMENTS
     - Creates fundamental user stories and basic requirements
     - Marks areas needing future PM review
   
   - **If technical-investigator fails/incomplete:**
     - Claude provides basic technical feasibility assessment
     - Uses standard technology recommendations based on project type
     - Flags areas requiring technical deep-dive
   
   - **If both agents fail:**
     - Claude creates minimal viable PRD from $ARGUMENTS
     - Documents all assumptions and limitations
     - Creates action items for manual review
   
   - **Response validation:**
     - Check for required sections (users, features, constraints)
     - Request specific missing information if gaps detected
     - Proceed with available data if agents are unresponsive

3. **Discovery Feedback Loop Detection**

   **Existing Implementation Conflict Analysis:**
   - **Requirements conflict with current codebase:**
     - New requirements incompatible with existing architecture
     - Business needs require major system restructuring  
     - User expectations conflict with current technical capabilities
     - **Feedback Action:** Flag need for `/design` impact assessment and migration planning
   
   - **Stakeholder Alignment Issues:**
     - Conflicting requirements from different stakeholders
     - Business objectives unclear or contradictory
     - Technical feasibility conflicts with business timelines
     - **Feedback Action:** Escalate to stakeholder alignment process before proceeding
   
   - **Scope and Feasibility Concerns:**
     - Requirements scope exceeds available resources significantly
     - Technical complexity higher than initial assessment
     - Dependencies on external systems not previously identified
     - **Feedback Action:** Flag need for iterative discovery and scope refinement

4. **Robust Documentation Generation with Feedback Tracking**
   - Synthesize all available findings (from agents and/or Claude fallbacks)
   - Generate EXACTLY ONE file: `PRD.md` containing:
     - Complete requirements, user stories, acceptance criteria, and technical constraints
     - **Error Recovery Documentation:**
       - Flag any sections with limited analysis due to agent failures
       - Document assumptions made during fallback processing
       - Include action items for future verification
       - Mark confidence levels for different requirement areas