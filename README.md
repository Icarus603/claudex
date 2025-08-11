<div align="center">

# **Claudex** 

**Intelligent Multi-Agent Development System**

*Transform Claude Code into your personal AI development team*

---

[![GitHub](https://img.shields.io/badge/GitHub-Icarus603-blue?logo=github)](https://github.com/Icarus603)
[![Claude Code](https://img.shields.io/badge/Claude-Code-orange)](https://claude.ai/code)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

**Claudex** is a sophisticated development orchestration framework that transforms Claude Code into an intelligent development partner. It coordinates 12 specialized AI agents to handle the complete software development lifecycle through adaptive workflows, continuous quality integration, and persistent learning.

> **🎯 Core Mission**: Make software development iterative, intelligent, and effortless by embracing the messy reality of real-world development with AI-powered workflow orchestration.

## 🎯 Core Philosophy

Real software development isn't linear - it's iterative, messy, and full of feedback loops. Claudex embraces this reality by providing:

- **Specialized AI agents** acting as domain experts (PM, Architect, Engineers, QA, etc.)
- **Intelligent workflow orchestration** that handles feedback loops and iterations
- **Continuous quality integration** throughout the development lifecycle
- **Context persistence and learning** across development phases
- **Adaptive cycle management** that prevents infinite loops and optimizes efficiency

## 🛠️ Installation & Setup

### Method 1: Git Clone Installation (Recommended)

```bash
# 1. Clone the Claudex repository
git clone https://github.com/Icarus603/claudex.git

# 2. Install in your Claude Code directory
# CRITICAL: Rename 'claudex' to '.claude' in your home directory
mv claudex ~/.claude

# 3. Navigate to your Claude Code configuration
cd ~/.claude

# 4. Create your personal configuration from template
cp CLAUDE.md.template CLAUDE.md

# 5. Edit CLAUDE.md with your personal information
# - Replace [Your Name] with your actual name
# - Replace [Your GitHub Username] with your GitHub username  
# - Replace [your.email@domain.com] with your email
# - Replace [he/him/she/her/they/them] with your pronouns

# 6. Make hook scripts executable
chmod +x hooks/*.sh

# 7. Verify installation
ls -la  # Should show agents/, commands/, hooks/, CLAUDE.md, etc.
```

### Method 2: Manual Setup (If you already have the files)

**1. Copy Personal Configuration Template**
```bash
# Create your personal configuration from template
cp CLAUDE.md.template CLAUDE.md

# Edit with your information (same as above)
```

**2. Verify .gitignore Protection**
The `.gitignore` file is configured to protect your personal information:
- `CLAUDE.md` - Your personal configuration (contains your name, email, etc.)
- `projects/` - Your project history and conversations
- `claudex-data/` - Agent learning data with your development patterns
- `.git/config` - Git configuration with your personal details

**3. Initialize Git Repository (Optional)**
```bash
# If you want to version control your Claudex configuration
git add .
git commit -m "Initial Claudex configuration"

# Your personal data remains protected by .gitignore
```

### Verification

**Test Your Setup:**
```bash
# Verify Claudex is working
/discover "test project setup"

# Check workflow orchestration
/workflow status
```

**Expected Output:**
- Claudex intelligence hooks should activate
- Agent coordination should be available
- Workflow state management should initialize

### 🔒 Security & Privacy

**Personal Data Protection:**
- **CRITICAL**: Never commit `CLAUDE.md` - it contains your personal information
- Project history in `projects/` contains your conversations and code
- Agent learning in `claudex-data/` contains your development patterns
- Git configuration may contain your name and email

**Before Sharing:**
```bash
# Verify your personal data is protected
git status

# Should NOT show:
# - CLAUDE.md
# - projects/
# - claudex-data/
# - .git/config

# If any personal files appear, add them to .gitignore immediately
```

**✅ Core Functional Files (100% Clean & Shareable):**
- **`agents/`** - All 12 AI agent configurations (no personal info)
- **`commands/`** - All 10 workflow command definitions (no personal info)
- **`hooks/`** - All 11 intelligence hook scripts (no personal info)
- **`README.md`** and documentation (no personal info)
- **`CLAUDE.md.template`** - Template only (no personal info)

> **🌟 Repository Status**: The entire Claudex system is designed for public sharing. All core functionality is completely generic and contains no personal information. Only user-specific configuration and runtime data is protected.

**❌ Personal Data Files (Protected by .gitignore):**
- **`CLAUDE.md`** - Your personal configuration 
- **`projects/`** - Your project history and conversations
- **`claudex-data/`** - Your agent learning patterns
- **`.git/config`** - Your git configuration

### 🔧 Troubleshooting

**Setup Issues:**
```bash
# If Claudex commands don't work:
# 1. Ensure CLAUDE.md exists (not just the template)
cp CLAUDE.md.template CLAUDE.md

# 2. Check file permissions
chmod +x hooks/*.sh

# 3. Verify you're in a Claude Code environment
# (Claudex only works in Claude Code CLI, not web interface)
```

**Personal Data Leaked:**
```bash
# If you accidentally committed personal data:
# 1. Add to .gitignore immediately
echo "filename" >> .gitignore

# 2. Remove from git history (if needed)
git rm --cached filename
git commit -m "Remove personal data from tracking"

# 3. For sensitive data, consider repo history cleanup
```

## 🚀 Quick Start

```bash
# Start a new project
/discover "Build a real-time analytics dashboard"

# Let the system guide you through the workflow
/workflow auto

# Or execute specific phases
/design
/build
/deploy
/maintain
```

## 📊 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Workflow Orchestration                   │
├─────────────────────────────────────────────────────────────┤
│  /workflow → /cycle-manager → /context-manager → /state     │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                  Development Phase Commands                 │
├─────────────────────────────────────────────────────────────┤
│  /discover → /design → /build → /deploy → /maintain         │
│      ↑          ↑        ↑        ↑          ↑              │
│      └──────────┴────────┴────────┴──────────┘              │
│            Intelligent Feedback Loops                       │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                    Specialized AI Agents                    │
├─────────────────────────────────────────────────────────────┤
│  PM | Architect | Engineers | QA | DevOps | Performance     │
└─────────────────────────────────────────────────────────────┘
```

## 🤖 Specialized AI Agents

### Product & Strategy
- **🔴 `product-manager`** - Requirements analysis, user stories, market research, success metrics
- **🔵 `technical-investigator`** - Feasibility assessment, technology evaluation, risk analysis

### Architecture & Design  
- **🔵 `software-architect`** - System design with implementation phases, component architecture
- **🔵 `design-reviewer`** - Architecture validation, scalability analysis, security review

### Engineering Implementation
- **🟣 `frontend-engineer`** - Advanced UI/UX implementation, animations, state management
- **🟠 `backend-engineer`** - Distributed systems, microservices, high-performance servers
- **🩵 `ai-ml-engineer`** - LLM integration, RAG pipelines, vector databases, AI orchestration
- **🩵 `data-scientist`** - Analytics, ML models, A/B testing, data transformation

### Quality & Operations
- **🟡 `qa-engineer`** - Proactive quality assurance, continuous testing, quality gates
- **🩷 `devops-engineer`** - Infrastructure, CI/CD, deployment, monitoring
- **🟢 `performance-analyzer`** - Bottleneck identification, optimization strategies
- **🟢 `code-simplifier`** - Refactoring, technical debt reduction, maintainability

## 📝 Development Phase Commands

### `/discover` - Requirements Discovery
**Purpose:** Discover and document product requirements through parallel PM and technical analysis

**Execution:**
```bash
/discover "AI-powered code review tool"
```

**Generates:** `PRD.md` with:
- User stories and acceptance criteria
- Technical constraints and feasibility
- Success metrics and priorities
- Market analysis and differentiation

**Agents Used:**
- `product-manager` + `technical-investigator` (parallel execution)

---

### `/design` - Technical Architecture
**Purpose:** Create comprehensive technical specifications with architecture review and quality validation

**Execution:**
```bash
/design                    # Design entire system
/design "authentication"   # Focus on specific area
```

**Generates:** `SPECS.md` with:
- System architecture with implementation phases
- Component specifications and dependencies
- Interface contracts and integration patterns
- Build order and engineer assignments

**Agents Used:**
1. `software-architect` (creates architecture)
2. Parallel: `design-reviewer` + `qa-engineer` + `ai-ml-engineer` (if needed)

---

### `/build` - Intelligent Implementation
**Purpose:** Build components with Claude as primary developer and specialists as consultants

**Execution:**
```bash
/build              # Build next logical component
/build "api"        # Build specific component
```

**Coordination Patterns:**
- **Pattern A:** Claude Direct (90% of cases)
- **Pattern B:** Sequential Specialist Chain (with QA gates)
- **Pattern C:** Parallel Specialist Coordination  
- **Pattern D:** Layered Implementation (with layer validation)

**Agents Used:** Dynamic based on requirements
- Primary: Claude implements directly
- Specialists: Called only for complex domain-specific needs

---

### `/deploy` - Production Deployment
**Purpose:** Deploy to target environment with comprehensive infrastructure and quality gates

**Execution:**
```bash
/deploy staging
/deploy production
```

**Generates:** `DEPLOYMENT.md` with:
- Infrastructure configuration
- CI/CD pipeline with quality gates
- Monitoring and alerting setup
- Rollback procedures

**Agents Used:**
- `devops-engineer` + `qa-engineer` (parallel preparation)

---

### `/maintain` - Maintenance & Optimization
**Purpose:** Handle bugs, performance issues, refactoring, and security with dynamic specialist routing

**Execution:**
```bash
/maintain "bug: payment processing fails"
/maintain "performance: slow dashboard loading"
/maintain "refactor: simplify authentication logic"
```

**Updates:** `MAINTENANCE_LOG.md` with:
- Root cause analysis
- Solutions implemented
- Quality metrics (before/after)
- Preventive measures

**Agents Used:** Dynamic routing based on issue type
- Bugs: `qa-engineer`
- Performance: `performance-analyzer` + `qa-engineer`
- Refactoring: `code-simplifier` + `qa-engineer`
- Security: `qa-engineer` + `devops-engineer` + `backend-engineer`

## 🔄 Workflow Orchestration Commands

### `/workflow` - Master Orchestrator
**Purpose:** Manage command interdependencies and feedback loops intelligently

**Execution:**
```bash
/workflow auto              # Analyze and execute optimal next action
/workflow status           # Check current workflow state
/workflow back design      # Manually trigger regression to design phase
```

**Features:**
- Automatic feedback loop detection and resolution
- Smart phase progression and regression
- Context preservation across phase transitions
- Error recovery with graceful degradation

---

### `/cycle-manager` - Iteration Optimizer
**Purpose:** Manage and optimize repetitive development cycles

**Execution:**
```bash
/cycle-manager analyze      # Analyze current cycle patterns
/cycle-manager optimize     # Apply optimization strategies
```

**Intervention Strategies:**
- Scope reduction for excessive cycles
- Technology simplification for technical loops
- Stakeholder escalation for process deadlocks
- Automatic breaking of infinite loops

---

### `/context-manager` - Memory System
**Purpose:** Preserve and transfer context between commands and sessions

**Execution:**
```bash
/context-manager save       # Save current context
/context-manager load       # Load relevant context
/context-manager analyze    # Analyze context patterns
```

**Manages:**
- Agent performance history and learning
- Technical decisions and rationale
- Requirements evolution
- Process optimizations

---

### `/workflow-state` - Save/Resume System
**Purpose:** Enable seamless workflow interruption and resumption

**Execution:**
```bash
/workflow-state save        # Create checkpoint
/workflow-state resume      # Resume from last checkpoint
/workflow-state checkpoint "pre-deployment"  # Named checkpoint
```

**Features:**
- Automatic checkpointing at critical moments
- Intelligent resumption based on interruption duration
- State reconstruction from project artifacts
- Multi-branch workflow support

## 🎯 Real-World Development Scenarios

### Scenario 1: Building a SaaS Application (Complete Journey)
```bash
# Day 1: Project Initiation
/discover "Multi-tenant project management SaaS with team collaboration, file sharing, and time tracking"
# → Creates PRD.md with user stories, technical requirements, and success metrics

/workflow auto
# → Automatically progresses to /design

# → ai-ml-engineer suggests recommendation engine for project insights
# → software-architect creates microservices architecture 
# → qa-engineer defines testing strategies
# → Creates SPECS.md with implementation phases

/workflow auto
# → Automatically progresses to /build

# Day 2-10: Implementation
/build "user authentication service"
# → Claude implements OAuth2 + JWT with refresh tokens

/build "project management API" 
# → backend-engineer designs complex database relationships
# → Claude implements CRUD operations with validation

/build "real-time collaboration"
# → Claude implements WebSocket connections with Redis

/build "frontend dashboard"
# → frontend-engineer creates responsive React components
# → Claude integrates with APIs

# Day 11: Deployment
/deploy staging
# → devops-engineer creates Docker + Kubernetes config
# → qa-engineer sets up automated testing pipeline
# → Creates DEPLOYMENT.md with monitoring and scaling

/deploy production
# → Live SaaS application with monitoring and alerting

# Ongoing: Maintenance
/maintain "performance: slow dashboard loading"
# → performance-analyzer identifies N+1 query problem
# → qa-engineer creates regression tests
# → Updates code and deploys optimization
```

### Scenario 2: AI-Powered Developer Tool (Iterative Development)
```bash
# Start with minimal concept
/discover "CLI tool that analyzes code quality and suggests improvements"

/workflow auto
# → Creates simple architecture, begins implementation

/build "core CLI framework"
# → Claude creates argument parsing and file processing

/build "code analysis engine"  
# → ai-ml-engineer integrates LLM API for code analysis
# → Discovers need for more sophisticated analysis

# Feedback loop detected - enhance requirements
/discover "Add support for multiple languages, generate reports, integrate with CI/CD"
# → Updates PRD.md with expanded scope

/design
# → software-architect redesigns for plugin architecture
# → ai-ml-engineer plans multi-model analysis approach

/build "enhanced analysis system"
# → Sequential implementation with specialists
# → ai-ml-engineer: LLM integration with prompt templates
# → backend-engineer: Plugin system and report generation
# → Claude: Final integration and CLI enhancements

/deploy
# → Creates distributable binaries for multiple platforms
# → Sets up CI/CD for automatic releases

# Result: Professional developer tool with AI capabilities
```

### Scenario 3: Debugging Production Issues (Maintenance Workflow)
```bash
# Production issue reported
/maintain "bug: users can't login after password reset"

# → qa-engineer performs root cause analysis
# → Identifies authentication token expiry issue
# → Creates reproduction steps and regression tests

# Issue requires architecture change
/workflow detects feedback loop need

/design "authentication system redesign"
# → software-architect redesigns token refresh mechanism  
# → security review by multiple agents

/build "updated authentication"
# → Claude implements new token system
# → qa-engineer validates security and functionality

/deploy staging
# → Comprehensive testing in staging environment

/deploy production  
# → Gradual rollout with monitoring

# → Updates MAINTENANCE_LOG.md with solution and preventive measures
# → Sets up additional monitoring to prevent similar issues
```

### Scenario 4: Stuck in Development Cycle (Auto-Recovery)
```bash
# Developer gets stuck in design-build loop
Design → Build → Design → Build → Design → Build (4th iteration)

/cycle-manager detects excessive iteration
# → Analysis: "Architecture complexity exceeding MVP scope"
# → Recommendation: "Reduce to core features, defer advanced integrations"

/cycle-manager optimize
# → Automatically creates simplified architecture
# → Extracts core user stories to new PRD.md
# → Defers complex features to future phases

/build  
# → Implementation proceeds with simplified scope
# → Delivers working MVP quickly
# → Documents deferred features for next iteration

# Result: Breaks cycle, delivers value, maintains development momentum
```

### Scenario 5: Team Collaboration (Context Preservation)
```bash
# Developer A starts project
/discover "Mobile app for food delivery with restaurant management"
/design
/build "user authentication and restaurant onboarding"

# End of day - save progress
/workflow-state checkpoint "auth-complete"
/context-manager save

# Developer B continues next day  
/workflow-state resume
# → Automatically loads context, agent history, and progress
# → Understands what was built and why

/build "order management system"
# → Continues seamlessly with full project context
# → QA integration validates compatibility with existing code

# Developer A returns
/context-manager load
# → Instantly understands all changes and decisions made
# → Can continue development without missing context

# Result: Seamless team handoffs with zero context loss
```

## 💡 Best Practices

### 1. Let the Workflow Guide You
```bash
# Start with discovery
/discover "your project idea"

# Then let workflow orchestrate
/workflow auto
```

### 2. Trust the Specialists
- Claude handles 90% of implementation directly
- Specialists are called only when their expertise is truly needed
- QA is integrated continuously, not just at the end

### 3. Embrace Feedback Loops
- Going backwards is normal and handled automatically
- Context is preserved across all transitions
- Each iteration adds to system learning

### 4. Use Checkpoints for Long Projects
```bash
# Before major changes
/workflow-state checkpoint "pre-refactor"

# Natural pause points
/workflow-state save
```

## 🔧 Configuration

### Agent Models
Agents use specialized models optimized for their roles. Color coding helps identify agent responses:
- 🔴 Red: Product/Business focus
- 🔵 Blue: Architecture/Technical investigation
- 🟣 Purple: Frontend specialization
- 🟠 Orange: Backend specialization
- 🩵 Cyan: AI/ML and Data Science
- 🟡 Yellow: Quality Assurance
- 🩷 Pink: DevOps/Infrastructure
- 🟢 Green: Performance/Optimization

### Error Recovery
All commands include comprehensive error recovery:
- Agent failures trigger Claude fallbacks
- Partial responses are completed with basic patterns
- Quality degradation is documented
- Learning from failures improves future execution

## 📈 System Intelligence

### Proactive Quality Integration
- QA validates testability during design
- Continuous quality gates during build
- Pre/post-deployment validation
- Proactive monitoring in maintenance

### Learning and Adaptation
- Agents learn from performance patterns
- Workflow optimizes based on project history
- Context accumulates across project lifecycle
- Cross-project patterns improve future projects

### Predictive Capabilities
- Cycle pattern prediction and prevention
- Resource optimization recommendations
- Risk identification and mitigation
- Success probability modeling

## 🚦 Getting Started

### Quick Start - Any Project
```bash
# Start any project with intelligent discovery
/discover "your project idea here"

# Let workflow orchestration guide you
/workflow auto

# That's it! Claudex handles the complexity
```

### Practical Examples

**🌐 Full-Stack Web Application**
```bash
# 1. Discover requirements
/discover "E-commerce platform with user authentication, product catalog, shopping cart, and payment processing"

# 2. Let workflow guide implementation
/workflow auto

# Result: Complete web app with database, APIs, frontend, and deployment
```

**🤖 AI-Powered Terminal Tool**
```bash
# 1. Requirements discovery
/discover "CLI tool for code analysis using LLMs with file processing and report generation"

# 2. Design with AI integration
/design

# 3. Build with AI specialist coordination
/build

# Result: Production-ready CLI with LLM integration
```

**📊 Data Dashboard with Analytics**
```bash
# 1. Business requirements
/discover "Real-time analytics dashboard for user behavior with A/B testing capabilities"

# 2. Automatic workflow progression
/workflow auto

# Result: Dashboard with database, APIs, real-time updates, and analytics
```

### Manual Workflow Control
```bash
# Specific phase execution
/design "authentication system"          # Focus design on specific area
/build "api"                            # Build specific component  
/deploy production                       # Deploy to specific environment
/maintain "bug: payment processing"      # Handle specific maintenance issue

# Orchestration commands
/workflow status                         # Check current workflow state
/cycle-manager analyze                   # Detect and optimize iteration cycles
/context-manager save                    # Preserve project context
/workflow-state checkpoint "pre-deploy"  # Create checkpoint
```

## 📚 Advanced Usage

### Custom Workflow Paths
```bash
# Skip to specific phase with context
/workflow next build

# Force regression with specific focus
/workflow back design "review caching strategy"
```

### Parallel Development
```bash
# Work on multiple components simultaneously
/build "frontend" & /build "api"
```

### Context-Aware Execution
```bash
# Load specific context before execution
/context-manager load agent-performance
/build
```

## 🎓 System Philosophy

Claudex is built on the principle that **software development is inherently iterative and messy**. Instead of fighting this reality, we embrace it with:

1. **Intelligent Orchestration** - Manages the complex dance between phases
2. **Specialist Collaboration** - Right expertise at the right time
3. **Continuous Quality** - Quality built-in, not bolted-on
4. **Persistent Learning** - Every project makes the system smarter
5. **Adaptive Workflows** - Adjusts to project reality, not rigid processes

## 🤝 Contributing

Claudex is designed to be extensible:
- Add new specialized agents for domain expertise
- Create custom commands for specific workflows
- Enhance error recovery strategies
- Contribute workflow optimization patterns

## 📄 License

This system is designed for use with Claude and follows Anthropic's usage guidelines.

---

**Remember:** Claudex isn't just a collection of commands - it's an intelligent development partner that learns, adapts, and improves with every project. Trust the workflow, embrace the iterations, and let the system handle the complexity while you focus on building great software.