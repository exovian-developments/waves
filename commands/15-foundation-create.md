# Command: `/waves:foundation-create [product-name]`

**Status:** ✅ DESIGNED

---

## Overview

**Purpose:** Generate a product foundation document by compacting feasibility analysis outputs into validated facts, enriched problem statements, re-classified capabilities, and financial benchmarks. Bridges the gap between raw feasibility research and product blueprint design.

**Schema:** `ai_files/schemas/product_foundation_schema.json`

**Input:** `ai_files/feasibility.json` (required)

**Output:** `ai_files/foundation.json`

**Parameters:** `[product-name]` (optional — if not provided, inferred from feasibility)

**Key Features:** Feasibility compaction, problem enrichment with evidence, capability re-classification (revenue-impact → operational criticality), Monte Carlo & Bayesian summary extraction, SWOT synthesis, vision & mission drafting, blueprint readiness gate

---

## Flow Derivations

| Flow | Condition | Description |
|------|-----------|-------------|
| **Flow A** | Feasibility file found with complete data | Full compaction: extract, enrich, synthesize, validate readiness |
| **Flow B** | Feasibility file found with partial data | Partial compaction: extract what exists, mark gaps, assess readiness with warnings |

---

**═══════════════════════════════════════════════════════════════════**
**STEP -1: Prerequisites Check**
**═══════════════════════════════════════════════════════════════════**

0. MAIN AGENT: Check if `ai_files/user_pref.json` exists

1. IF NOT EXISTS → EXIT with message:
   ```
   ⚠️ Missing configuration!

   Please run first:
   /waves:project-init

   This command requires user preferences to be configured.
   ```

2. IF EXISTS:
   - Extract `preferred_language` for all user interactions
   - Continue to STEP 0

---

**═══════════════════════════════════════════════════════════════════**
**STEP 0: Locate Feasibility Analysis**
**═══════════════════════════════════════════════════════════════════**

3. MAIN AGENT: Check if `ai_files/feasibility.json` exists

4. IF NOT EXISTS:
   ```
   ⚠️ No feasibility analysis found!

   A feasibility analysis is required to generate the product foundation.
   The foundation compacts feasibility research into validated facts.

   Run first:
   /waves:feasibility-analyze [product-name]

   Then return here.
   ```
   → **EXIT COMMAND**

5. IF EXISTS:
   - Read `ai_files/feasibility.json` completely into memory
   - Store as `feasibility` object
   - Extract `meta.analysis_name` as product name (if parameter not provided)

8. Check if `ai_files/foundation.json` already exists:
   - IF EXISTS: Warn user:
     ```
     ⚠️ A product foundation already exists:
     ai_files/foundation.json

     Product: [existing.meta.product_name]
     Source: [existing.meta.source_feasibility]

     Options:
     1. Overwrite with new foundation from [selected feasibility]
     2. Cancel

     Choose:
     ```
   - IF "2" → EXIT

---

**═══════════════════════════════════════════════════════════════════**
**STEP 1: Extract & Enrich Problem Statement**
**═══════════════════════════════════════════════════════════════════**

9. MAIN AGENT: Extract and enrich the problem from feasibility:

   **Sources to merge:**
   - `feasibility.idea_profile.problem_statement` (pain, reality, unsolved)
   - `feasibility.buyer_personas[].pain_points` (evidence from personas)
   - `feasibility.market_analysis.tam/sam/som` (market scale)
   - `feasibility.market_analysis.competitors[].gap` (why unsolved)
   - `feasibility.market_analysis.market_gap` (opportunity)
   - `feasibility.bayesian_analysis.posterior_beliefs.market_exists` (confidence)

   **Enrichment logic:**
   - `pain`: Merge problem_statement.pain + most common pain_points from buyer_personas. Make specific, observable, backed by persona evidence.
   - `reality`: Merge problem_statement.reality + TAM/SAM/SOM data + Bayesian posterior for market_exists. Include frequency, impact, scale.
   - `unsolved`: Merge problem_statement.unsolved + competitor gaps + market_gap. Identify specific failures of existing solutions.
   - `evidence_strength`: Derive from bayesian evidence quality:
     - No posteriors or very low → "anecdotal"
     - Low posteriors with some data → "observed"
     - Moderate posteriors with market data → "measured"
     - High posteriors or pre-sales → "validated"

10. Present enriched problem to user (in preferred_language):
    ```
    📋 PROBLEM STATEMENT (enriched from feasibility)

    🔴 PAIN:
    [enriched pain paragraph]

    📊 REALITY:
    [enriched reality paragraph with data]

    ❓ UNSOLVED:
    [enriched unsolved paragraph with competitor analysis]

    Evidence strength: [level] — [explanation]

    Does this accurately capture the problem? (Yes / Refine / Skip)
    ```

11. IF "Refine" → Ask user for corrections, apply, re-present
12. IF "Skip" → Copy feasibility problem_statement as-is (no enrichment)

---

**═══════════════════════════════════════════════════════════════════**
**STEP 2: Compact Target Users from Buyer Personas**
**═══════════════════════════════════════════════════════════════════**

13. MAIN AGENT: Transform each `feasibility.buyer_personas[]` into a target user:

    **Transformation:**
    - `persona_source` ← buyer_persona.name
    - `description` ← Synthesize from: occupation + pain_points + current_solution + decision_triggers. Write as narrative: "That person, with that problem"
    - `willingness_to_pay` ← buyer_persona.willingness_to_pay
    - `primary_acquisition_channel` ← buyer_persona.acquisition_channel

14. Present target users:
    ```
    👥 TARGET USERS (from buyer personas)

    1. [persona_source]
       [narrative description]
       Willingness to pay: [amount/conditions]
       Channel: [acquisition channel]

    2. [persona_source]
       [narrative description]
       ...

    Confirm these users? (Yes / Add more / Remove one / Refine)
    ```

15. Handle user modifications if any.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 3: Compact Competitive Landscape**
**═══════════════════════════════════════════════════════════════════**

16. MAIN AGENT: Extract from `feasibility.market_analysis`:
    - `market_size`: TAM, SAM, SOM with sources
    - `competitors`: Top 3-5 with name, positioning, pricing, gap
    - `market_gap_summary`: From market_gap field
    - `unfair_advantages`: From market_analysis.unfair_advantages + idea_profile.founder_advantage

17. Present competitive landscape:
    ```
    🏆 COMPETITIVE LANDSCAPE

    Market: [TAM] → [SAM] → [SOM]

    Competitors:
    ┌──────────┬──────────────────────┬────────────────────────┐
    │ Name     │ Positioning          │ Gap to exploit         │
    ├──────────┼──────────────────────┼────────────────────────┤
    │ [comp1]  │ [positioning]        │ [gap]                  │
    └──────────┴──────────────────────┴────────────────────────┘

    Market gap: [summary]
    Unfair advantages: [list]

    Accurate? (Yes / Refine)
    ```

18. Handle user modifications if any.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 4: Compact Revenue Model**
**═══════════════════════════════════════════════════════════════════**

19. MAIN AGENT: Extract from `feasibility.revenue_model`:
    - `model_type`: marketplace, subscription, hybrid, etc.
    - `revenue_streams[]`: name, description, pricing, unit_economics, revenue_share_percent
    - `pricing_tiers[]`: if applicable
    - `flywheel`: how streams reinforce each other

20. Cross-reference revenue streams with essential capabilities:
    - For each stream, identify which capabilities from `feasibility.essential_capabilities_draft` enable it
    - Store as `capabilities_required` per stream

21. Present revenue model summary to user.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 5: Compact Financial Benchmarks**
**═══════════════════════════════════════════════════════════════════**

22. MAIN AGENT: This is the CRITICAL compaction — thousands of simulations into decision-relevant numbers.

    **Extract from feasibility:**
    - `revenue_targets`: survival_monthly, intermediate_monthly, comfortable_monthly, timeline_months
    - Best scenario from `revenue_projections[]`:
      - `monte_carlo_summary`: scenario_name, n_simulations, P(survival@6mo), P(comfortable@12mo), median MRR at 6/12mo, top sensitivity variables
      - `bayesian_summary`: market_exists, can_reach_customers, can_achieve_profitability, highest_risk
    - `cost_structure`: From user_resources.financial_capacity — fixed costs, runway, investment
    - `kill_criteria`: From winning scenario's kill_criteria

23. Present financial benchmarks:
    ```
    💰 FINANCIAL BENCHMARKS

    Revenue targets:
    • Survival: $[X]/mo | Comfortable: $[Y]/mo | Timeline: [Z] months

    Monte Carlo ([scenario_name], [N] simulations):
    • P(survival @ 6mo): [X]%
    • P(comfortable @ 12mo): [Y]%
    • Median MRR @ 6mo: $[X] | @ 12mo: $[Y]

    Top sensitivity variables:
    1. [variable] — [actionable insight]
    2. [variable] — [actionable insight]

    Bayesian posteriors:
    • Market exists: [X]%
    • Can reach customers: [Y]%
    • Can achieve profitability: [Z]%
    • Highest risk: [description]

    Runway: [N] months | Monthly burn: $[X]

    Kill criteria:
    • [criterion 1] → [action]
    • [criterion 2] → [action]

    These benchmarks will guide blueprint scope. Accurate? (Yes / Refine)
    ```

---

**═══════════════════════════════════════════════════════════════════**
**STEP 6: Synthesize SWOT Analysis**
**═══════════════════════════════════════════════════════════════════**

24. MAIN AGENT: SWOT does NOT exist in the feasibility — it is SYNTHESIZED here from multiple sections:

    **Synthesis sources:**
    - **Strengths**: founder_advantage + unfair_advantages + user_resources.skills (high relevance)
    - **Weaknesses**: user_resources.constraints + low bayesian posteriors + high-impact sensitivity variables hard to control
    - **Opportunities**: market_gap + proactive_suggestions.positioning_angles + partnership_opportunities + why_now timing
    - **Threats**: competitors with small gaps + kill_criteria triggers + critical_assumptions that could fail

25. Present SWOT:
    ```
    📊 SWOT ANALYSIS (synthesized from feasibility)

    ✅ STRENGTHS:           ⚠️ WEAKNESSES:
    • [strength 1]          • [weakness 1]
    • [strength 2]          • [weakness 2]

    🚀 OPPORTUNITIES:       🔴 THREATS:
    • [opportunity 1]       • [threat 1]
    • [opportunity 2]       • [threat 2]

    Accurate? (Yes / Refine)
    ```

---

**═══════════════════════════════════════════════════════════════════**
**STEP 7: Re-classify Essential Capabilities**
**═══════════════════════════════════════════════════════════════════**

26. MAIN AGENT: This is a KEY transformation — re-classifying from revenue-impact (feasibility's view) to operational criticality (blueprint's view).

    **Source:** `feasibility.essential_capabilities_draft.core_capabilities[]`

    **Re-classification logic:**
    - `revenue_blocking` → Candidate for `essential`. Apply test: "Without this, can the product exist?" If yes despite blocking revenue → `important`. If no → `essential`.
    - `revenue_enabling` → Candidate for `important`. Apply test: "Does it hurt to operate without?" If product BREAKS → move to `essential`.
    - `usage_expansion` → Candidate for `desired`. Apply test: "Nice to have, or does it significantly strengthen essential?" If strengthens → `important`.

    **For each capability:**
    - Rewrite content in "The user can [action]" format
    - Assign CAP-001, CAP-002, etc.
    - Map which revenue_streams it enables
    - Identify depends_on relationships
    - Preserve build_effort_days
    - Tag feasibility_source for traceability

27. Present re-classified capabilities:
    ```
    🎯 ESSENTIAL CAPABILITIES (re-classified)

    ESSENTIAL (product fails without these):
    ┌───────────┬────────────────────────────────┬─────────────────┬────────────┐
    │ ID        │ Capability                     │ Revenue streams │ Source     │
    ├───────────┼────────────────────────────────┼─────────────────┼────────────┤
    │ CAP-001   │ The user can [action]           │ [streams]       │ blocking   │
    │ CAP-002   │ The user can [action]           │ [streams]       │ blocking   │
    └───────────┴────────────────────────────────┴─────────────────┴────────────┘

    IMPORTANT (hurts without, but product works):
    │ CAP-005   │ The user can [action]           │ [streams]       │ enabling   │

    DESIRED (nice to have):
    │ CAP-008   │ The user can [action]           │ [streams]       │ expansion  │

    Agree with classification? (Yes / Reclassify one / Add / Remove)
    ```

28. Handle user modifications. Iterate until confirmed.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 8: Expand Essential Flows**
**═══════════════════════════════════════════════════════════════════**

29. MAIN AGENT: Expand from `feasibility.essential_capabilities_draft.essential_flows_draft[]`:

    **For each flow:**
    - Keep flow_name, description from feasibility
    - ADD entry_point: Where/how the user enters this flow
    - ADD termination: What marks the flow as complete
    - Map capability_refs to new CAP-XXX IDs
    - Preserve revenue_connection

30. Present expanded flows:
    ```
    🔄 ESSENTIAL FLOWS (expanded)

    Flow 1: [flow_name]
    ├─ Entry: [entry_point]
    ├─ End: [termination]
    ├─ Capabilities: [CAP-001, CAP-003]
    └─ Revenue: [connection]

    [Additional flows...]

    Complete? (Yes / Add flow / Modify / Remove)
    ```

31. Handle user modifications.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 9: Extract Timeline Constraints**
**═══════════════════════════════════════════════════════════════════**

32. MAIN AGENT: Extract from feasibility:
    - `time_to_mvp_weeks` from essential_capabilities_draft
    - `time_to_first_revenue_weeks` from essential_capabilities_draft
    - `available_hours_weekly` from user_resources.time_weekly_hours
    - `runway_deadline`: Calculate from created_at + runway_months

33. Perform scope feasibility check:
    - Sum build_effort_days across essential capabilities
    - Calculate weeks needed at available_hours_weekly
    - Compare against time_to_mvp_weeks and runway
    - Generate assessment: FEASIBLE / TIGHT / INFEASIBLE

34. Present assessment to user with recommendation if scope needs trimming.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 10: Collect Proactive Insights & Remaining Unknowns**
**═══════════════════════════════════════════════════════════════════**

35. MAIN AGENT: Extract proactive_insights from `feasibility.proactive_suggestions`:
    - positioning_recommendation (best positioning_angle)
    - differentiation_ideas (capability_ideas with impact/complexity)
    - marketing_strategies (with effort and ROI)
    - partnership_opportunities

36. Extract remaining_unknowns from:
    - `feasibility.next_steps.remaining_unknowns`
    - `feasibility.bayesian_analysis.next_evidence_to_gather`
    - Any low-confidence areas identified during compaction

37. Present both sections. No mandatory user checkpoint — informational only.

---

**═══════════════════════════════════════════════════════════════════**
**STEP 11: Blueprint Readiness Gate**
**═══════════════════════════════════════════════════════════════════**

38. MAIN AGENT: Evaluate blueprint readiness:

    **Ready = true when ALL of:**
    - validated_problem has evidence_strength ≥ "observed"
    - At least 1 target user with willingness_to_pay
    - At least 1 essential capability identified
    - feasibility_confidence ≥ "medium"
    - Monte Carlo ran with ≥ 1000 simulations
    - Bayesian market_exists posterior ≥ 0.5

    **Ready = false when ANY of:**
    - evidence_strength = "anecdotal"
    - No essential capabilities
    - feasibility_confidence = "low"
    - market_exists posterior < 0.5

39. Present readiness assessment:
    ```
    🚦 BLUEPRINT READINESS GATE

    [✅ READY | ⚠️ NOT READY]

    Checklist:
    ✅ Problem validated (evidence: [level])
    ✅ Target users with willingness to pay
    ✅ [N] essential capabilities identified
    [✅|❌] Feasibility confidence: [level]
    [✅|❌] Monte Carlo: [N] simulations
    [✅|❌] Market exists: [X]% posterior

    [If not ready:]
    Blocking issues:
    • [issue 1]
    • [issue 2]

    Recommended: [action to resolve]

    [If ready:]
    Next step: /waves:blueprint-create
    ```

---

**═══════════════════════════════════════════════════════════════════**
**STEP 12: Generate & Save Foundation**
**═══════════════════════════════════════════════════════════════════**

40. MAIN AGENT: Build complete foundation JSON following `product_foundation_schema.json`:
    - `meta`: product_name, foundation_version "1.0", timestamps, source_feasibility, confidence, iteration_count
    - All sections from Steps 1-11

41. Validate against `ai_files/schemas/product_foundation_schema.json`

42. Write to `ai_files/foundation.json`

---

**═══════════════════════════════════════════════════════════════════**
**STEP 13: Post-Creation Summary**
**═══════════════════════════════════════════════════════════════════**

43. MAIN AGENT (in preferred_language):
    ```
    ✅ Product Foundation created!

    📁 File: ai_files/foundation.json

    📊 Summary:
    • Product: [name]
    • Source: [feasibility file]
    • Evidence strength: [level]
    • Essential capabilities: [N]
    • Essential flows: [N]
    • Financial benchmarks: Monte Carlo [N] sims, Bayesian [N] beliefs
    • SWOT: [N] strengths, [N] weaknesses, [N] opportunities, [N] threats
    • Blueprint readiness: [READY / NOT READY]

    🎯 Next step:
    [If ready:]
      /waves:blueprint-create
      The blueprint will use this foundation as its primary input.

    [If not ready:]
      Address blocking issues, then re-run:
      /waves:foundation-create [product-name]
    ```

---

**═══════════════════════════════════════════════════════════════════**
**SUBAGENTS**
**═══════════════════════════════════════════════════════════════════**

This command does NOT use subagents. All steps (extraction, enrichment, synthesis, re-classification, readiness assessment) are executed directly by the main agent to preserve full context from the feasibility analysis and ensure consistent cross-referencing between sections.

---

**Status:** ✅ DESIGNED
