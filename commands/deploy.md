---
allowed-tools: Task, Read, Write, Bash, Grep, Glob
argument-hint: [target environment: staging/production]
description: Deploy application to target environment with comprehensive infrastructure setup
---

Think about deployment strategy and infrastructure requirements.

## Deployment Workflow

Target environment: $ARGUMENTS (default: production)

**Steps to execute:**

1. **Deployment Environment Detection**
   - Analyze codebase to identify deployment target
   - Detect framework type (Next.js, Express, React SPA, etc.)
   - Identify infrastructure requirements (databases, services, etc.)
   - Determine appropriate deployment platform (Vercel, AWS, Docker, etc.)

2. **Parallel Deployment Preparation with Error Recovery**
   - **SIMULTANEOUSLY** call both agents with fallback strategies:
     
     **devops-engineer** designs infrastructure:
     - Deployment strategy and rollout approach
     - CI/CD pipeline configuration
     - Infrastructure requirements and scaling considerations
     - Monitoring and alerting setup
     - Backup and disaster recovery procedures
     - Environment variable and secrets management
     
     **qa-engineer** creates comprehensive validation framework:
     - **Pre-deployment QA gate:** Complete testing checklist and automation
     - **Post-deployment QA gate:** Smoke test suite and production verification
     - Performance baseline establishment and monitoring validation
     - Security validation in production environment and access control verification
     - **Continuous monitoring:** Real-time quality metrics and alerting
     - **Rollback validation:** Automated testing of disaster recovery procedures
   
   **Error Recovery Strategies:**
   - **DevOps failure**: Claude creates basic deployment config based on project type
   - **QA failure**: Claude creates essential validation checklist
   - **Both fail**: Use standard deployment patterns with basic monitoring
   - **Partial responses**: Fill gaps with industry best practices
   - **Conflicting recommendations**: Prioritize security and reliability over complexity

3. **Integrated Deployment Execution with QA Gates**
   - Synthesize infrastructure design with validation requirements
   - Generate deployment configuration files with testing integration
   - **QA Gate 1:** Pre-deployment validation
     - Run complete test suite in staging environment
     - Validate deployment scripts and configurations
     - Verify environment variables and secrets
     - Check rollback procedures functionality
   - Create CI/CD pipeline scripts with integrated quality gates
   - Setup monitoring and alerting configurations
   - **QA Gate 2:** Post-deployment validation
     - Execute smoke tests in production environment
     - Validate performance baselines and monitoring
     - Verify security configurations and access controls
     - Confirm rollback procedures are accessible
   - Configure environment variables and secrets with validation
   - Implement rollback procedures with automated validation checks

4. **Deployment Feedback Loop Detection**

   **Infrastructure Requirements Discovery:**
   - **Deployment complexity exceeds design specifications:**
     - Infrastructure requirements not anticipated in architecture
     - Scalability needs requiring architectural changes
     - Security requirements conflicting with current design
     - **Feedback Action:** Flag need to return to `/design` for infrastructure architecture updates
   
   - **Production Environment Issues:**
   - **Performance baselines cannot be met:**
     - Application performance insufficient for production load
     - Database queries requiring optimization or redesign
     - API response times exceeding acceptable limits
     - **Feedback Action:** Flag need to return to `/build` for performance optimization or `/design` for architecture review
   
   - **Security and Compliance Gaps:**
     - Security requirements discovered during production setup
     - Compliance issues requiring application changes
     - Access control complexity requiring architectural updates
     - **Feedback Action:** Flag need for `/design` security architecture review or `/build` security implementation

5. **Resilient Documentation Generation with Feedback Tracking**
   - Generate EXACTLY ONE file: `DEPLOYMENT.md` containing:
     - Integrated deployment scripts, monitoring setup, quality gates, and rollback procedures
     - **Error Recovery Documentation:**
       - Fallback deployment procedures if automation fails
       - Manual verification steps when automated validation is unavailable
       - Emergency rollback procedures and contact information
       - Known limitations due to agent failures during planning
       - Post-deployment validation checklist
       - Incident response procedures for deployment failures