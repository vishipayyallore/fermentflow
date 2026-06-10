# S.M.A.R.T. Prompt Framework for GitHub Copilot Coding Agents

**Artificial Neural Networks Edition** — Framework for creating high-quality coding agent instructions aligned with neural network implementation best practices and educational standards.

---

## 🎯 **The S.M.A.R.T. Framework**

Use this framework to create highly effective coding agent instructions:

```text
S - Specific Role Definition (ML Engineer, Neural Network Specialist, Optimization Specialist, etc.)
M - Mission-Critical Requirements (What must be accomplished with measurable outcomes)
A - Audience-Aware Communication (Team expertise level, mathematical maturity, domain context)
R - Response Format Control (Code structure, training patterns, documentation style)
T - Task-Oriented Constraints (Technology stack, implementation patterns, forbidden actions)
```

---

## 🏛️ **ANN System Alignment**

When creating prompts, consider:

- **Topic Area**: Is this about foundations (perceptron, MLP), training (backprop, optimizers), regularization, or a specific architecture (CNN, RNN, attention)?
- **Use Case Context**: What task type (architecture exploration, training loop, evaluation, ablation)?
- **Implementation Approach**: From-scratch (NumPy) for learning intent, or framework reference comparison?
- **Template Reusability**: Can this prompt be templated for reuse across similar topics?

## 🏗️ **Advanced Problem Statement Template**

Use this enhanced template for coding agent tasks:

```markdown
## ROLE DEFINITION

You are a [Specific Role] specializing in [Technology Stack] with expertise in [Domain Areas]

## MISSION

[Clear, specific objective with measurable outcomes]

## CONTEXT

[Brief overview of current situation and progress made]

## CURRENT STATUS

- **Progress Made**: [Specific achievements and metrics]
- **Main Issue**: [Root cause analysis]
- **Files Affected**: [List specific files]

## REMAINING WORK

### 1. [Priority Task Name] (Priority N)

- **Problem**: [Specific technical issue]
- **Current Error**: [Exact error messages]
- **Solution Approach**: [Concrete implementation steps]
- **Files to Modify**: [Specific file paths]

## TECHNICAL CONSTRAINTS

- **🚨 CRITICAL**: [Non-negotiable requirements]
- **Framework**: [Technology stack requirements]
- **Dependencies**: [Package/version constraints]

## RESPONSE FORMAT REQUIREMENTS

- [Specific code structure expectations]
- [Documentation requirements]
- [Testing requirements]
- [Mathematical correctness verification]

## WHAT NOT TO DO

- ❌ [Explicit forbidden actions with reasoning]

## WHAT TO DO

- ✅ [Explicit required actions with priority]

## SUCCESS CRITERIA

[Measurable outcomes with acceptance criteria]

## QUALITY STANDARDS

- [Code quality requirements]
- [Mathematical correctness expectations]
- [Performance considerations]
- [Educational value standards]
```

## 🎭 **Role-Based Specialization Examples**

### **For Network Foundations Implementation:**

```markdown
ROLE: You are a Neural Network Engineer specializing in implementing perceptrons and multi-layer perceptrons from scratch, with strong focus on mathematical foundations and educational code quality

EXPERTISE FOCUS: Forward pass, activation functions, loss functions, vectorized NumPy implementations, clear documentation

OUTPUT REQUIREMENTS: Educational Python code with comprehensive error handling, unit tests where they help understanding, and clear documentation

MANDATORY VALIDATION:
- ✅ `pytest tests/` succeeds with 0 failures (if tests are present)
- ✅ Implementation matches theoretical forward-pass derivation
- ✅ Code runs without errors on small example data
- ✅ Mathematical correctness verified
```

### **For Backpropagation and Optimization:**

```markdown
ROLE: You are a Neural Network Specialist focusing on training mechanics — backpropagation, gradient-based optimization, and learning dynamics

EXPERTISE FOCUS: Chain rule derivations, vector/matrix calculus, SGD and modern optimizers (Momentum, Adam), learning-rate scheduling

OUTPUT REQUIREMENTS: From-scratch backprop implementation, optimizer comparison, training curves, documentation of update rules

MANDATORY VALIDATION:
- ✅ Backprop gradients match a numerical check
- ✅ Code follows PEP 8 standards
- ✅ Optimizer update rules are documented with the maths
- ✅ Training curves are reproducible with a fixed seed
```

### **For Regularization and Generalization:**

```markdown
ROLE: You are a Neural Network Specialist focusing on regularization, generalization, and evaluation

EXPERTISE FOCUS:
- Dropout, weight decay, batch normalization, early stopping
- Train / validation / test split discipline
- Bias-variance trade-off in deep networks
- Diagnostic plots (loss curves, learning curves)

OUTPUT REQUIREMENTS:
- From-scratch or clearly labelled framework implementations
- Clear documentation of when each regularizer helps
- Visual diagnostics for over/under-fitting
- Reproducible experiments

MANDATORY VALIDATION:
- ✅ Each regularizer is demonstrated on a small example
- ✅ Code is well-documented with rationale
- ✅ Visualizations support the claims
- ✅ Experiments are reproducible
```

### **For Architecture-Specific Topics (e.g. CNN, RNN, attention):**

```markdown
ROLE: You are a Neural Network Specialist for the [chosen architecture]

EXPERTISE FOCUS:
- Inductive biases of the architecture
- Forward and backward derivations for the key operations
- Minimal from-scratch implementation alongside a framework reference
- Common pitfalls and debugging patterns

OUTPUT REQUIREMENTS:
- Clear architecture diagrams (ASCII or Mermaid)
- Minimal end-to-end example
- Training and evaluation on a small dataset
- Documentation including theory and intuition

MANDATORY VALIDATION:
- ✅ Architecture matches a published reference
- ✅ Small example trains successfully
- ✅ Documentation explains the inductive bias clearly
- ✅ Code demonstrates the architecture's key idea
```

## 🚨 **Critical Constraint Guidelines**

### **Framework/Package Versions:**

```markdown
- 🚨 CRITICAL: Use Python 3.12+ ONLY — DO NOT downgrade
- 🚨 CRITICAL: Use NumPy, SciPy, Pandas latest stable versions — DO NOT downgrade
- ✅ Framework usage (PyTorch / TensorFlow) is fine for reference comparison; clearly label it
- ❌ DO NOT modify pyproject.toml to downgrade packages
```

### **File Modification Boundaries:**

```markdown
- ❌ DO NOT modify [specific files]
- ✅ ONLY modify [allowed areas]
```

### **Build Requirements:**

```markdown
When implementing topics, use: uv sync && uv run jupyter notebook
Ensure all code follows project standards (PEP 8 for Python)
Where the learning intent is clear, implement from scratch (frameworks acceptable for reference comparison)
```

## ✅ **Effective Instruction Patterns**

### **DO — Be Specific and Explicit:**

- ✅ "Implement a single-layer perceptron from scratch using NumPy with a manual weight-update loop"
- ✅ "Add a from-scratch MLP with two hidden layers and ReLU activations; verify gradients numerically"
- ✅ "Fix the cross-entropy loss derivation in `losses.py` — confirm gradient matches a numerical check"

### **DON'T — Be Vague:**

- ❌ "Fix the network"
- ❌ "Make it train"
- ❌ "Update the code"

## 📝 **Constraint Language Examples**

### **Strong Constraint Language That Works:**

```markdown
🚨 ABSOLUTELY DO NOT use a framework's built-in optimizer when the learning intent is to derive SGD from scratch.

The following packages MUST remain at their current versions:
- numpy: Latest stable version
- scipy: Latest stable version
- pandas: Latest stable version

CRITICAL: Where the learning intent is from-scratch, implement using only NumPy for numerical operations.
```

### **Weak Language That Doesn't Work:**

```markdown
Please try to maintain Python 3.12+ compatibility
Prefer keeping current package versions
```

## 🎯 **Advanced Prompt Design Patterns**

### **Multi-Layered Prompt Architecture:**

```markdown
SYSTEM LAYER:
You are a [Specialist Role] with expertise in [Technology Stack] and [Domain Expertise].

CONTEXT LAYER:
[Project context, current situation, learning objectives]

TASK LAYER:
[Specific implementation task with clear deliverables]

SPECIFICATION LAYER:
[Detailed technical requirements, constraints, and acceptance criteria]
```

### **Conditional Logic for Complex Scenarios:**

```markdown
LOGIC FRAMEWORK:
IF topic == "perceptron_or_mlp_foundations":
THEN approach: Implement from scratch with explicit weight matrices and activation
AND include: Forward pass + simple loss + manual gradient + update

ELIF topic == "training_mechanics":
THEN approach: Derive backprop on paper, then implement vectorised
AND include: Numerical gradient check; small training run

ELIF topic == "architecture_specific":
THEN approach: Minimal from-scratch alongside a framework reference
AND include: Architecture diagram; small example dataset; training curves
```

## 📊 **Output Format Control**

### **For Implementation Tasks:**

```markdown
OUTPUT REQUIREMENTS:
- From-scratch implementation with clear forward / backward separation
- Type hints for Python
- Docstrings explaining inputs, outputs, and the mathematical role of each tensor
- Consistent code style following project conventions (PEP 8)
- Educational examples demonstrating usage
- Mathematical correctness verification (numerical gradient check where applicable)
```

### **For Workflow Tasks:**

```markdown
OUTPUT REQUIREMENTS:
- Data loading pipelines with proper batching
- Training loops with reproducible seeds and clear logging
- Evaluation on held-out data
- Visualization of training curves
- Documentation with best practices
```

## 🎯 **Success Indicators**

### **Agent is working correctly when:**

- ✅ It acknowledges constraints explicitly
- ✅ It asks clarifying questions about mathematical derivations
- ✅ It maintains the from-scratch intent where stated
- ✅ It focuses on correctness, not just "it trains"
- ✅ It provides detailed progress updates
- ✅ It includes proper mathematical documentation

### **Agent needs restart when:**

- ❌ It silently switches to a framework when the intent was from-scratch
- ❌ It ignores mathematical correctness requirements
- ❌ It ignores explicit constraints
- ❌ It modifies forbidden files
- ❌ It takes an overly broad approach to a small task

## 🔄 **Agent Restart Protocol**

### **When to restart the coding agent:**

- Agent silently uses framework implementations when learning intent was from-scratch
- Agent breaks mathematical correctness
- Agent modifies forbidden files
- Agent ignores explicit constraints
- Agent takes the wrong implementation approach

### **How to restart:**

1. Close the current pull request
2. Create a new pull request with more explicit constraints
3. Include specific examples of what went wrong
4. Add stronger constraint language

## 🏗️ **ANN Implementation Patterns**

When implementing topics, apply these patterns:

### **Pattern: From-Scratch Implementation**

```markdown
IMPLEMENTATION PATTERN: From-Scratch Neural-Network Component

REQUIREMENTS:
- Core logic implemented from first principles
- Use NumPy / SciPy for numerical operations only
- Mathematical foundations clearly documented
- Proper initialization and training loop
- Educational examples demonstrating usage

QUALITY GATES:
✅ Implementation matches theoretical derivation
✅ No framework abstractions hide the learning point
✅ Mathematical correctness verified (numerical gradient check if applicable)
✅ Code is well-documented with theory
✅ Small example trains successfully
```

### **Pattern: Architecture Evaluation**

```markdown
EVALUATION PATTERN: Network Comparison

CHARACTERISTICS:
- Side-by-side comparison of architectures or hyperparameters
- Reproducible training runs (fixed seeds)
- Comparison with a reference implementation
- Performance and stability notes
- Visualization of training curves

IMPLEMENTATION REQUIREMENTS:
- Train on a small standard dataset
- Compare results with theoretical expectations
- Visualize behaviour (loss, accuracy, gradient norms, etc.)
- Document trade-offs
- Include edge case discussion (e.g. dying ReLU, vanishing gradients)

QUALITY GATES:
✅ Training runs are reproducible
✅ Comparison is fair (same data, same evaluation)
✅ Results are visually clear
✅ Edge cases are discussed
✅ Conclusions are supported by the data
```

## 📋 **Universal PR Success Template**

Include this template in EVERY coding agent PR for consistent validation:

```markdown
## 🎯 MANDATORY SUCCESS CRITERIA (NON-NEGOTIABLE)

### Implementation Requirements
```powershell
# MUST PASS: tests where they exist
python -m pytest tests/ -v
# Expected Result: "passed" with 0 failures
```

### Code Quality Requirements

```powershell
# MUST PASS: Code quality checks
flake8 src/
# Expected Result: No errors
```

### Mathematical Correctness

```powershell
# MUST VERIFY: Implementation matches theoretical foundations
# Review derivations in docstrings
# Verify gradients, update rules, loss functions
```

## 📋 FINAL CHECKLIST

Before marking this PR ready for review:

- [ ] ✅ Tests pass with 0 failures (where they exist)
- [ ] ✅ Code quality checks pass
- [ ] ✅ Implementation honours the from-scratch intent where stated
- [ ] ✅ Mathematical correctness verified
- [ ] ✅ All original issues resolved completely
- [ ] ✅ Documentation includes mathematical foundations
- [ ] ✅ Educational examples provided

**CRITICAL**: Do not mark this PR as ready for review until ALL validations pass successfully.
```

## 🚀 **Artificial Neural Networks-Specific S.M.A.R.T. Example**

```markdown
ROLE: You are a Neural Network Engineer specializing in implementing perceptrons and multi-layer perceptrons from scratch with strong mathematical foundations and educational code quality

MISSION: Implement a 2-layer MLP from scratch in the Artificial Neural Networks repository — a personal learning workspace for understanding networks from first principles using Python, NumPy, and educational best practices

AUDIENCE: A returning learner (Swamy) with expertise in:
- Python programming and NumPy
- Basic linear algebra and calculus
- Conceptual ML background
- Algorithm implementation patterns

RESPONSE FORMAT:
- From-scratch implementation with clear forward and backward steps
- Type hints and comprehensive docstrings
- A small training example with a fixed seed
- Educational documentation with mathematical foundations
- No framework usage for the core implementation (frameworks acceptable as a labelled comparison)

TASK CONSTRAINTS:
- 🚨 CRITICAL: Implement from scratch using only NumPy for numerical operations
- 🚨 CRITICAL: Verify gradients with a numerical check
- Architecture: Layer class → Forward → Backward → Update step → Training loop
- Quality Standards: Zero test failures, mathematical correctness, PEP 8 compliance
- Technology Stack: Python 3.12+, NumPy, SciPy, Pandas, Matplotlib
```

## 📚 **Best Practices Summary**

1. **Be Specific**: Define exact roles, technologies, and constraints
2. **Set Clear Boundaries**: Use strong constraint language
3. **Define Success**: Include measurable outcomes and validation steps
4. **Control Output**: Specify exactly what format and quality you expect
5. **Plan for Failure**: Include restart protocols and troubleshooting
6. **Validate Everything**: Always include build and test requirements
7. **Document Thoroughly**: Ensure all decisions and constraints are recorded
8. **Align with Educational Goals**: Reference from-scratch implementation principles
9. **Enable Learning**: Include mathematical foundations and theory
10. **Progressive Complexity**: Scale scope to learning objectives

---

## ⚡ **Quick Reference Checklist**

Use this checklist before submitting any coding agent task:

### **Role Definition**

- [ ] Specific role/expertise clearly stated
- [ ] Technology stack and frameworks identified
- [ ] Expected audience knowledge level documented
- [ ] Domain context provided

### **Task Clarity**

- [ ] Mission and objectives clearly defined
- [ ] Success criteria are measurable
- [ ] Scope is appropriately sized
- [ ] Priority and sequencing defined

### **Technical Requirements**

- [ ] Framework and version constraints specified
- [ ] Implementation patterns identified (from-scratch vs framework-reference)
- [ ] Dependencies listed explicitly
- [ ] Mathematical foundations documented

### **Constraints & Boundaries**

- [ ] Forbidden actions explicitly listed (❌)
- [ ] Required actions explicitly listed (✅)
- [ ] File modification boundaries defined
- [ ] Implementation decision constraints included

### **Quality & Validation**

- [ ] Code quality standards specified (PEP 8)
- [ ] Build/test requirements included
- [ ] Mathematical correctness expectations defined
- [ ] Educational value considerations addressed

### **Implementation Specifics**

- [ ] From-scratch intent (or labelled framework reference) specified
- [ ] Mathematical foundations documented
- [ ] Evaluation approach included
- [ ] Educational examples required

### **Output Expectations**

- [ ] Code format and style specified
- [ ] Documentation requirements defined
- [ ] Testing approach specified
- [ ] Mathematical correctness verification included

---

## 📋 **FINAL VALIDATION CHECKLIST**

Before submitting ANY coding agent PR or task completion:

- [ ] ✅ All technical constraints acknowledged
- [ ] ✅ Success criteria clearly measurable
- [ ] ✅ Tests pass without errors/failures (where they exist)
- [ ] ✅ Code quality checks pass
- [ ] ✅ No forbidden files modified
- [ ] ✅ From-scratch implementation principles applied correctly
- [ ] ✅ Mathematical correctness verified
- [ ] ✅ Documentation is complete and accurate
- [ ] ✅ Code review readiness criteria met

---

## 🎓 **ANN System Integration**

Align your coding agent tasks with Artificial Neural Networks best practices:

### **For Implementation Development:**

- Focus on from-scratch implementation using NumPy where the learning intent is clear
- Demonstrate proper mathematical foundations
- Include forward / backward / loss / update structure explicitly
- Show proper initialization, normalization, and seed control

### **For Workflow Development:**

- Use proper data loading and batching
- Implement reproducible training loops
- Include simple hyperparameter exploration
- Demonstrate proper model evaluation on held-out data

### **For Educational Content Creation:**

- Create clear topic explanations (architecture, math, intuition)
- Document mathematical foundations
- Include visualizations and small examples
- Provide learning objectives and outcomes

This framework ensures consistent, high-quality results from GitHub Copilot coding agents while preventing common issues and maintaining educational standards aligned with neural network implementation best practices and the from-scratch intent of this repository.
