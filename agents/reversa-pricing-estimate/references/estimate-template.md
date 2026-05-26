# estimate.md template

This is the Markdown template that the `reversa-pricing-estimate` agent uses to generate `_reversa_sdd/_pricing/<feature>/estimate.md`. Replace all `<placeholders>` with real values. Keep the fixed structure.

```markdown
# Price Estimate

**Feature:** `<feature_dir_relative>`
**Generated at:** <created_at_local_readable>
**Calculation versions:** Effort v<effort_formula_version>, Value v<value_formula_version>, Market v<market_table_version>

**Consumed prerequisites:**
- Profile: `<output_folder>/_pricing/profile.json`
- Size: `<output_folder>/_pricing/<feature>/size.json` (class `<complexity_class>`, auxiliary score `<size_score>`)

## Overview

| Scenario | Range | Comment |
|---|---|---|
| **Effort** | <effort_str> | <horas_min> to <horas_max>h, cost + tax + markup |
| **Value** | <value_str> | 10% to 30% of declared annual value |
| **Market Range** | <market_str> | hourly rate sourced by country and seniority |

## Effort Scenario

**What it is:** price calculated from probable hours, hourly rate, approximate tax reserve, and project markup. It is the defensible floor so as not to subsidize the client.

**When to use it:** always as a sanity check. Charging below Effort means taking a loss or reducing project profit too much.

| Item | Value |
|---|---|
| Complexity class | <complexity_class> |
| Seniority | <seniority> |
| Seniority factor | <seniority_factor> |
| Estimated hours | <horas_min> to <horas_max> h |
| Midpoint | <horas_estimadas> h |
| Hourly rate | <hourly_rate> <currency>/h |
| Direct cost | <custo_direto_min> to <custo_direto_max> <currency> |
| Approximate tax reserve | <imposto_aproximado_min> to <imposto_aproximado_max> <currency> |
| Project markup (<margin_percent>%) | <markup_aplicado_min> to <markup_aplicado_max> <currency> |
| **Effort Range** | **<preco_minimo> to <preco_maximo> <currency>** |
| Midpoint | <preco_total> <currency> |

<vat_warning_if_applicable>
<billing_currency_block_if_applicable>

## Value Scenario

**What it is:** price based on part of the annual economic value that the feature generates or protects for the client. Reversa uses 10% to 30% capture of the declared annual value.

**When to use it:** when the client can declare return, savings or cost of not doing.

<if value.available>

| Item | Value |
|---|---|
| Declared monthly return | <monthly_return_declared> <currency> |
| Users impacted | <users_impacted> |
| Cost of not doing | <cost_of_not_doing> <currency> |
| Annual value used | <annual_value> <currency> |
| Capture applied | 10% to 30% |
| Recommended price | <preco_recomendado> <currency> |
| **Value Range** | **<preco_minimo> to <preco_maximo> <currency>** |
| Approximate payback | <payback_str> |

<billing_currency_block_if_applicable>

<if NOT value.available>

> **Value scenario not available:** <unavailable_reason>

</if>

## Market Range Scenario

**What it is:** range derived from hourly benchmark by country and seniority, multiplied by the same hour range from the Effort scenario.

**When to use it:** as an external reference. v2 does not multiply by client profile because there is no reliable public dataset for it.

<if market.available>

| Item | Value |
|---|---|
| Country / Seniority | <country_name> / <seniority> |
| Model / Client profile | <pricing_model> / <client_profile> |
| Complexity | <complexity_class> |
| Market hourly rate | <market_hourly_min> to <market_hourly_max> <currency>/h |
| Source kind | <source_kind> |
| Reference year | <source_year> |
| Sources | <sources> |
| **Market Range** | **<preco_minimo_mercado> to <preco_maximo_mercado> <currency>** |

<if fallback applied>

> Fallback applied: <reason>

</if>

<billing_currency_block_if_applicable>

<if NOT market.available>

> **Market scenario not available:** <unavailable_reason>

</if>

## How to choose between the three

<guidance_pt_br_based_on_the_scenarios>

General heuristic:

1. Client with no clear return: use Effort as floor and Market as external reference
2. Client with high and clear return: prefer Value, with Effort only as a minimum floor
3. Effort above Market: review profile, size or client fit
4. Market above Effort: there is room to raise markup or improve the proposal

## Disclaimer

The numbers in this estimate are approximations for budgeting guidance, not a guarantee of closing a sale. The tax factor is an approximate reserve, not an exact legal rate. Real tax validation is the responsibility of the user's accountant. The market range is static and based on the sources documented in `market-benchmarks.md`. The return declared by the client in the Value scenario is raw input, not validated. It is recommended to add `_reversa_sdd/_pricing/<feature>/estimate.{md,json}` to `.gitignore` before committing.
```

## Billing currency

When `profile.billing_currency` is filled in, each scenario gets an extra row:

```markdown
| In <billing_currency> | <valor_billing> <billing_currency> (rate: 1 <billing_currency> = <exchange_rate_to_local> <currency>) |
```

## Short comments

| Scenario | Short comment |
|---|---|
| Effort | `<horas_min> to <horas_max>h, cost + tax + markup` |
| Value | `10% to 30% of declared annual value` or `Not available` |
| Market | `hourly rate sourced by country and seniority` or `Not available` |
