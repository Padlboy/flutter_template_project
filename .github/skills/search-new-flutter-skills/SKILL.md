---
name: search-new-flutter-skills
description: "Search the internet for new, useful Flutter/Dart skills and productivity patterns. Discovers emerging best practices, tools, and techniques that can enhance development workflows. When skills are found, helps create them in the local environment and integrates them with the flutter-coding-agent."
---

# Search for New Flutter Skills

This skill enables the agent to discover and integrate new Flutter/Dart development skills from the internet, keeping the development toolkit current with emerging practices and tools.

---

## ⚡ Quick Start: Using the Skills NPM Package

**⚠️ IMPORTANT: Load these skills before starting any search:**
1. **[find-skills](vercel-labs/skills)** - Official skill discovery tool (from vercel-labs/skills package)
2. **[use-skills-npm-package](../use-skills-npm-package/SKILL.md)** - Complete reference for skills CLI commands

The `skills` npm CLI is the primary tool for discovering, searching, and managing agent skills from community repositories and official sources. The official **find-skills** skill from Vercel Labs provides AI-assisted skill discovery and evaluation.

### Quick Commands

```bash
# Search for Flutter skills
npx skills find flutter

# Search for specific integrations (e.g., Supabase)
npx skills find supabase

# List available skills without installing
npx skills add owner/repo --list

# Install selected skills
npx skills add owner/repo --skill "skill-name"
```

**Always check:** https://www.npmjs.com/package/skills for the latest documentation and commands.

---

## Phase 1: Internet Research using Skills CLI

### Primary Tools: Official find-skills + Skills NPM Package

The agent MUST load and use these in order:

1. **FIRST: Load the [find-skills](https://github.com/vercel-labs/skills/tree/main/skills/find-skills) skill** - Official AI-powered skill discovery (from vercel-labs/skills package)
   - Provides advanced skill search capabilities
   - Helps evaluate and recommend skills
   - Integrated with the skills ecosystem

2. **THEN: Reference [use-skills-npm-package](../use-skills-npm-package/SKILL.md) skill** - Complete CLI documentation

3. **USE CLI commands to find skills:**
   ```bash
   # Interactive search
   npx skills find
   
   # Keyword search for Flutter/Dart topics
   npx skills find flutter
   npx skills find testing
   npx skills find "state management"
   ```
3. **List available skills from repositories:**
   ```bash
   npx skills add vercel-labs/agent-skills --list
   npx skills add flutter-community/skills --list
   ```
4. **Preview SKILL.md files** from found repositories directly on GitHub

### Secondary: Internet Search

After checking the Skills CLI, supplement with web search for:
- Emerging patterns not yet packaged as skills
- Recent blog posts and articles about Flutter/Dart
- GitHub discussions and community patterns
- Stack Overflow solutions and patterns

The Search Categories

### Search Categories

**Development Practices:**
- Code architecture patterns (MVVM, BLoC, Riverpod patterns)
- Testing strategies (widget testing, integration testing, golden tests)
- Performance optimization techniques
- Accessibility best practices
- Internationalization (i18n) patterns

**Tools & Integrations:**
- VS Code extensions or configurations
- Development environment optimization
- CI/CD pipeline setups
- Code analysis and linting strategies
- Build and deployment automation

**Platform-Specific:**
- Platform channels (native code integration)
- Platform-specific UI patterns
- Cross-platform compatibility
- Deep linking and app shortcuts

**Emerging Features:**
- Latest Flutter/Dart language features
- New packages and libraries
- Framework-specific patterns (Material 3, Cupertino)
- State management solutions

**Developer Experience:**
- Debugging techniques
- Profiling and monitoring
- Developer tools usage
- Productivity shortcuts

---

## Phase 2: Evaluate and Curate

When searching for skills, the agent will evaluate based on:

### Quality Criteria

✅ **Practical & Actionable**
- Clear, step-by-step instructions
- Real-world applicable examples
- Measurable outcomes

✅ **Currently Relevant**
- Uses modern Flutter/Dart versions (3.0+)
- Aligns with current best practices
- Not superseded by newer approaches

✅ **Well-Documented**
- Clear descriptions and use cases
- Code examples or patterns
- When to use / when NOT to use

✅ **Fills a Gap**
- Doesn't duplicate existing agent skills
- Addresses common development challenges
- Provides unique value

### Evaluation Process

1. **Search for skills** using web search
   - Query examples:
     - "Flutter best practices 2024 2025"
     - "Dart testing patterns skill guide"
     - "Flutter performance optimization guide"
     - "Flutter accessibility guide"
     - "Flutter state management patterns"

2. **Evaluate candidates**
   - Check relevance to Flutter/Dart ecosystem
   - Verify quality and completeness
   - Assess if it fills a gap vs. existing skills

3. **Identify complementary skills**
   - Skills that work well together
   - Skills that enhance current agent capabilities
   - Related patterns and techniques

---

## Phase 3: Present Findings to Developer

When promising skills are found, present them clearly:

### Format Example

**📚 Skill Found: "Flutter Performance Profiling"**

**Source:** [Link to Origin/Documentation]

**Purpose:** "Guide developers through using DevTools profiler to identify and fix performance bottlenecks, including frame rate analysis, memory profiling, and CPU usage tracking."

**Key Benefits:**
- Systematically identify slow widgets and rendering issues
- Optimize memory usage patterns
- Reduce jank and stuttering in apps
- Measurable performance improvements

**When to Use:**
- App is experiencing frame rate drops
- Memory usage is unexpectedly high
- Build process seems slow
- Need to optimize for lower-end devices

**Complements These Existing Skills:**
- `load-flutter-instructions` - General best practices reference
- `flutter-control-and-screenshot` - Testing and verification

**Estimated Complexity:** Intermediate (requires DevTools familiarity)

---

## Phase 4: Create Skill in Local Environment

Once developer approves, help them create the skill:

### Step-by-Step Creation

1. **Prepare Skill Structure**
   ```
   .github/skills/skill-name/SKILL.md
   ```

2. **Skill Format Template**
   ```markdown
   ---
   name: skill-name
   description: "Clear, actionable description of what the skill does and when to use it."
   ---
   
   # Skill Title
   
   Introduction and context...
   
   ## Phase 1: [First Step]
   ## Phase 2: [Second Step]
   ## Phase 3: [Implementation]
   
   ## Best Practices
   
   ## Troubleshooting
   
   ## Resources
   ```

3. **Populate Skill Content**
   - Copy/adapt content from internet source
   - Ensure clarity and actionability
   - Add code examples where helpful
   - Include real-world use cases

4. **Format & Validate**
   - Use clear markdown formatting
   - Include code blocks with language syntax highlighting
   - Add emojis for visual clarity (sparingly)
   - Ensure all links are valid

5. **Verify Completeness**
   - ✓ Has clear description
   - ✓ Has "when to use" guidance
   - ✓ Has practical examples
   - ✓ Has troubleshooting section
   - ✓ Has resource links

---

## Phase 5: Integrate with Flutter Coding Agent

After creating the skill locally, update the flutter-coding-agent.md:

### Update Agent Configuration

1. **Add to skills list:**
   ```yaml
   skills:
     - load-flutter-instructions
     - flutter-setup-guide-skill
     - search-new-flutter-skills  # This skill
     - other-existing-skills
     - new-skill-name  # ← Add here
   ```

2. **Document in agent description:**
   Add a section describing all available skills and when to use each:
   
   ```markdown
   ## Available Skills & When to Use
   
   ### Foundational Skills
   
   **load-flutter-instructions** - Core Flutter/Dart best practices
   - Use when: Starting new feature, unsure about patterns, want consistency
   - Covers: SOLID principles, widget composition, testing, accessibility
   
   **flutter-setup-guide-skill** - Environment setup and configuration
   - Use when: Setting up new dev environment, configuring MCP tools
   - Covers: Local setup, dev containers, MCP tool usage
   
   ### Development Skills
   
   **search-new-flutter-skills** - Discover and integrate new skills
   - Use when: Want to explore emerging tools/practices, expand capabilities
   - Covers: Internet research, skill evaluation, local integration
   
   **[New Skill Name]** - [Clear description]
   - Use when: [Specific scenarios]
   - Covers: [Main topics/areas]
   ```

3. **Update argument-hint:**
   Include mention of new skill in agent's capabilities

4. **Create integration note in agent description:**
   ```markdown
   ### Continuous Learning
   
   The agent regularly searches for and integrates new Flutter skills
   to stay current with ecosystem developments. Use the
   `search-new-flutter-skills` skill to discover emerging best practices
   and development patterns. New skills are automatically documented
   and integrated into the agent's decision-making process.
   ```

---

## Phase 6: Document the Integration

Create a record of newly added skills:

### Update Skills Inventory

In the agent file or a companion document, maintain:

**Recently Added Skills** (Example)
```markdown
| Skill Name | Added Date | Purpose | When to Use |
|-----------|-----------|---------|-----------|
| performance-profiling | 2026-02-22 | DevTools profiling guide | When optimizing performance |
| accessibility-audit | 2026-02-22 | A11y testing strategies | Before release, accessibility concerns |
```

---

## Best Practices for Skill Discovery

### Primary Method: Use Skills CLI First

**Always use the `skills` npm package as your first discovery method:**

1. **Start with skills find command:**
   ```bash
   npx skills find [query]
   ```

2. **Check major repositories:**
   ```bash
   # Vercel Labs official skills
   npx skills add vercel-labs/agent-skills --list
   
   # Community repositories
   npx skills add flutter-community/skills --list
   npx skills add dart-community/skills --list
   ```

3. **Reference the [use-skills-npm-package](../use-skills-npm-package/SKILL.md) skill** for all CLI commands and options

### Secondary Search Sources

**If Skills CLI doesn't find what you need, search:**
- Flutter official documentation and guides
- Dart language documentation
- Community forums (Reddit r/FlutterDev, ItAllWidgets forum)
- Medium, Dev.to Flutter articles
- GitHub Flutter community resources
- YouTube Flutter tutorial channels

**Query Patterns:**
```
"Flutter [topic] guide 2024 2025"
"Dart [pattern] best practices"
"Flutter [tool] integration tutorial"
"Flutter [platform] development guide"
```

**Evaluation Checklist:**
- [ ] Addresses real development challenges?
- [ ] Current and maintained?
- [ ] Actionable and specific?
- [ ] Code examples or patterns included?
- [ ] Complements existing skills?
- [ ] Fills identified gap?

### Red Flags to Avoid

❌ Outdated content (Flutter 1.x or 2.x only)
❌ Overly theoretical without practical application
❌ Directly duplicates existing skills
❌ Controversial or divisive patterns
❌ Unmaintained or abandoned projects
❌ Requires excessive setup overhead

---

## Workflow: Discovering and Adding a New Skill

### Step 1: Use Skills CLI to Search

**First, load the use-skills-npm-package skill** and use it to search:

```bash
# Interactive search
npx skills find

# Search for specific topics
npx skills find flutter
npx skills find supabase
npx skills find testing

# List skills from specific repos
npx skills add vercel-labs/agent-skills --list
```

**Agent Action:** Use Skills CLI to find candidate skills based on developer's request

### Step 2: Supplement with Web Search (if needed)

```
Agent Action: If Skills CLI doesn't return sufficient results, 
             search internet for "Flutter [topic] skill guide 2024 2025"
Returns: Multiple candidate sources including blog posts, GitHub repos, community patterns
```

### Step 3: Evaluate
```
Agent Action: Review top 3-5 sources for quality and relevance
Criteria: Practical? Current? Complements existing skills?
Decision: Select best candidate or multiple complementary skills
```

### Step 4: Present
```
Agent Action: Show developer:
  - Skill title and purpose
  - Source link
  - Key benefits
  - When to use
  - Complexity level

Developer Response: "Create it" or "Skip"
```

### Step 4: Create
```
If approved:
  - Create skill structure in .github/skills/
  - Populate with content
  - Format and validate
  - Verify all links work
```

### Step 6: Integrate
```
Update flutter-coding-agent.md:
  - Add to skills list
  - Document in agent description
  - Include "when to use" guidance
  - Create summary in skills inventory
```

### Step 7: Verify
```
Verify agent awareness:
  - Can reference new skill in decisions
  - Knows when to apply it
  - Updated description reflects new capability
```

---

## Integration with Flutter Coding Agent

The flutter-coding-agent should:

1. **Know all available skills** - Reference latest skills inventory
2. **Understand when to apply each** - Use "when to use" guidance
3. **Recommend skills proactively** - Based on task analysis
4. **Benefit from new additions** - Continuously expand capabilities

### Example Agent Recommendation

> "Based on your task, I recommend using the **performance-profiling** skill to measure baseline metrics before optimization, combined with **load-flutter-instructions** for applying performance best practices."

---

## Resources & References

### Essential: Official Skill Discovery
- **[find-skills](https://github.com/vercel-labs/skills/tree/main/skills/find-skills)** - Official AI-powered skill discovery (from vercel-labs/skills package) ⭐ **LOAD THIS FIRST**
- **[use-skills-npm-package](../use-skills-npm-package/SKILL.md)** - Complete guide to discovering and managing skills using the `skills` CLI
- **Skills npm Package:** https://www.npmjs.com/package/skills
- **Skills Directory:** https://skills.sh/

### Flutter & Dart Documentation
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Language](https://dart.dev/)
- [ItAllWidgets Forum](https://forum.itsallwidgets.com/)
- [Official Dart/Flutter GitHub](https://github.com/dart-lang/)
- [Flutter Community Medium](https://medium.com/flutter-community)
- [Dev.to Flutter Tag](https://dev.to/t/flutter)

---

## Continuous Improvement

This skill itself should evolve:

- Check for skill updates quarterly
- Remove skills that become obsolete
- Merge redundant skills
- Keep skills inventory current
- Gather developer feedback on skill usefulness
