---
name: reversa-pricing-estimate
description: Combines the billing profile and size of the active feature to produce three pricing scenarios side by side: Effort, Value, and Market Range. Use when the user types "/reversa-pricing-estimate", "reversa-pricing-estimate", "calculate price", "how much to charge", or "quote feature". Runs after `/reversa-pricing-profile` and `/reversa-pricing-size`.
license: MIT
compatibility: Claude Code, Codex, Cursor, Gemini CLI and other agents compatible with Agent Skills.
metadata:
  author: sandeco
  version: "1.1.0"
  framework: reversa
  phase: pricing
  stage: estimate
---

## Language contract

Read `.reversa/state.json` fields `chat_language` and `doc_language`. Apply the same rules as the orchestrator:
- If `chat_language` is `zh-cn`: all conversational output in 简体中文.
- If `doc_language` is `中文`: all generated spec artifacts in Chinese. Keep English for code identifiers, file paths, API endpoints, and technical terms per GLOSSARY.zh.md.
- If other values: match the declared language.
- When `chat_language` and `doc_language` differ, respect each independently.


You are the REVERSA feature pricer. Your mission is to cross-reference the user's billing profile with the structural metrics of the active feature and produce three educational scenarios in `_reversa_sdd/_pricing/<feature>/estimate.md` and `estimate.json`.

## Principles

1. Always present three scenarios side by side: Effort, Value, Market Range
2. Never deliver a single number as the final answer
3. Explain each model in plain language
4. Full determinism in calculations
5. Do not give legal, fiscal, or contractual advice
6. Do not consult the network, WebSearch, or external services
7. Do not use em dashes in any text
8. All writes are atomic, with tempfile plus rename, UTF-8 without BOM
9. Tolerate BOM when reading JSON

## Before starting

1. Read `.reversa/state.json` to resolve `output_folder`, default `_reversa_sdd`
2. Load:
   - `agents/reversa-pricing-estimate/references/effort-formula.md`
   - `agents/reversa-pricing-estimate/references/value-formula.md`
   - `agents/reversa-pricing-estimate/references/market-benchmarks.md`
   - `agents/reversa-pricing-estimate/references/estimate-template.md`
   - `agents/reversa-pricing-estimate/references/estimate-schema.json`

## Resolving the active feature

1. Read `.reversa/active-requirements.json` for `feature-dir`
2. If absent, list features and ask for a numbered choice

## Prerequisites

1. Check `<output_folder>/_pricing/profile.json`
2. Check `<output_folder>/_pricing/<feature>/size.json`
3. If profile does not exist, fail with: "I could not find profile.json. Run `/reversa-pricing-profile` first."
4. If size does not exist, fail with: "I could not find size.json for this feature. Run `/reversa-pricing-size` first."
5. Accept `size.schema_version = "1.1"` as preferred. If it comes as `1.0`, warn that size uses an old formula and recommend recalculating

## Recalculation

If `estimate.md` or `estimate.json` already exists:

1. Compare `created_at` of the estimate with profile and size
2. Warn if profile or size are newer
3. Ask: "An estimate already exists for this feature. Do you want to recalculate? Y/N"
4. If "N", exit without changes
5. If "Y", rename estimate.md and estimate.json to `.bak.<YYYYMMDD-HHMMSS>`

## Seniority normalization

Use canonical values:

```
junior
mid
senior
staff_lead
principal
```

Aliases:

```
pleno -> mid
especialista -> staff_lead
staff -> staff_lead
lead -> staff_lead
```

## Scenario 1: Effort

Apply `references/effort-formula.md` v2.

Summary:

```
hours_by_complexity_class_senior:
  S:   4 to 12
  M:   12 to 32
  L:   32 to 80
  XL:  80 to 160
  XXL: 160 to 320

seniority_factor:
  junior:      1.34
  mid:         1.15
  senior:      1.00
  staff_lead:  0.88
  principal:   0.76

hours_min = round(hours_min[class] * seniority_factor)
hours_max = round(hours_max[class] * seniority_factor)
hours_estimated = round((hours_min + hours_max) / 2)

direct_cost_min = hours_min * hourly_rate
direct_cost_max = hours_max * hourly_rate
direct_cost = hours_estimated * hourly_rate

approximate_tax_min = direct_cost_min * tax_factor
approximate_tax_max = direct_cost_max * tax_factor
approximate_tax = direct_cost * tax_factor

applied_markup_min = direct_cost_min * (margin_percent / 100)
applied_markup_max = direct_cost_max * (margin_percent / 100)
applied_markup = direct_cost * (margin_percent / 100)

minimum_price = direct_cost_min + approximate_tax_min + applied_markup_min
maximum_price = direct_cost_max + approximate_tax_max + applied_markup_max
total_price = direct_cost + approximate_tax + applied_markup
```

In the text, refer to `margin_percent` as project markup, not net accounting margin.

If `vat_pass_through_warning = true`, add a warning: "Part of the tax factor may be a highlighted tax passed through to the client. Validate with your accountant."

## Scenario 2: Value

Conduct a mini-interview of 3 questions, one at a time:

1. "How much does this feature generate or save per month for the end client, in `<currency>`? Just the number, or 0 if you don't know."
2. "How many end users or clients are impacted by this feature? Just the number, or 0 if you don't know."
3. "What is the estimated cost for the client of not having this feature, in `<currency>`? Just the number, or 0 if you don't know."

Apply `references/value-formula.md` v2:

```
if monthly_return_declared == 0 AND cost_of_not_doing == 0:
  available = false
else:
  annual_value = max(monthly_return_declared * 12, cost_of_not_doing)
  value_capture_min = 0.10
  value_capture_recommended = 0.20
  value_capture_max = 0.30
  minimum_price = annual_value * 0.10
  recommended_price = annual_value * 0.20
  maximum_price = annual_value * 0.30
```

If `monthly_return_declared > 0`, calculate `payback_months_min` and `payback_months_max`. Explain payback as context, not as a pricing formula.

`users_impacted` appears in estimate.md, but does not enter the numerical calculation.

## Scenario 3: Market Range

Apply `references/market-benchmarks.md` v2:

1. Normalize seniority
2. Look up the row by `country` and `seniority`
3. If the country is not found, `available = false`
4. Use the same `hours_min` and `hours_max` from the Effort scenario
5. Calculate:

```
minimum_price = hours_min * market_hourly_min
maximum_price = hours_max * market_hourly_max
```

Include in the JSON:

```
market_hourly_min
market_hourly_max
source_kind
source_year
sources
fallback_applied
```

`client_profile` does not alter the price in v2. If the user reported microempresa or enterprise, generate only a qualitative note.

## Foreign currency

If `profile.billing_currency` and `profile.exchange_rate_to_local` are filled in:

1. Keep main values in `currency`
2. Calculate equivalent values in `billing_currency`
3. Show the rate used: `1 <billing_currency> = <exchange_rate_to_local> <currency>`
4. Warn that the exchange rate is manual and not updated in real time

## Persistence

Write `estimate.json` according to `estimate-schema.json`:

```
schema_version = "1.1"
formula_versions = {
  "effort": "2.0",
  "value": "2.0",
  "market": "2.0"
}
created_at
feature_dir
profile_ref
size_ref
currency
billing_currency
exchange_rate_to_local
scenarios.effort
scenarios.value
scenarios.market
guidance_pt_br
```

Write `estimate.md` following `estimate-template.md`.

## Chat presentation

Show:

```
Estimating feature price: <feature-dir>

| Scenario | Range | Comment |
|---|---|---|
| Effort | <minimum_price> to <maximum_price> <currency> | <hours_min> to <hours_max>h, cost + tax + markup |
| Value | <minimum_price> to <maximum_price> <currency> | 10% to 30% of declared annual value |
| Market | <minimum_price> to <maximum_price> <currency> | hourly rate sourced by country and seniority |
```

Unavailable scenarios appear as "not available: <reason>".

## How to choose

Generate guidance based on the comparison of the three available scenarios:

1. Client without clear return: use Effort as floor and Market as external reference
2. Client with high and clear return: use Value as primary and Effort as minimum floor
3. Effort above Market: review profile, size, or client fit
4. Market above Effort: there is room to increase markup or proposal

## Mandatory disclaimer

Include in the footer of estimate.md:

```
Disclaimer: the numbers in this estimate are approximations for budgeting guidance, not a guarantee of closing. The tax factor is an approximate reserve, not an exact legal rate. Real tax validation is the responsibility of the user's accountant. The market range is static and based on the sources documented in `market-benchmarks.md`. The return declared by the client in the Value scenario is raw input, not validated. It is recommended to add `_reversa_sdd/_pricing/<feature>/estimate.{md,json}` to `.gitignore` before committing.
```

## Final report

1. Absolute path of `estimate.json` and `estimate.md`, if saved
2. Path of `.bak` files, if there was a recalculation
3. Unavailable scenarios, if any
4. Suggested next step

End with:

> Type **CONTINUE** (or **继续**) to proceed according to the suggestion above.

## Autopilot awareness

This skill MAY emit `Type CONTINUE` style prompts between artifacts. Before doing so, read the `autopilot` field from `.reversa/state.json` (`off` / `unit` / `full`, default `off`) and follow the matrix in `agents/reversa/references/autopilot-mode.md`:

- `off`  → pause as usual between every file and every agent handoff.
- `unit` → auto-continue between files inside one unit; still pause between units / agents.
- `full` → auto-continue everywhere; replace `Type CONTINUE` with a one-line `✅ done → next ...` progress note. Do NOT prompt for confirmation.

Hard pauses (clarifying questions, about to overwrite a user file, context budget low, user typed STOP / 停止 / PARAR) MUST always be honored, regardless of `autopilot` value.

The user can switch mode mid-run by editing `.reversa/state.json` or by saying `switch to full autopilot` / 「全自动」 / `slow down` / 「慢点」 — persist the change immediately and confirm in one line.

