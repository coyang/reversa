# Effort scenario formula (effort-formula.md)

**Formula version:** 2.0

Documents the deterministic calculation that the `reversa-pricing-estimate` agent applies for the Effort scenario. The v2 formula removes the old linear score-to-hours conversion and uses hour ranges per T-shirt size, with a seniority factor inspired by the personnel capability multipliers of COCOMO II.

## Source and criterion

COCOMO II is a parametric effort estimation model that uses size, product, platform, personnel and project attributes. For Reversa's UX, using the full model would be too complex. v2 uses only the defensible idea of personnel capability multipliers, keeping simple hour ranges per class.

Main reference:

- Barry Boehm et al., *Software Cost Estimation with COCOMO II*, Prentice Hall, 2000
- Carnegie Mellon SEI, overview of software cost estimation and COCOMO II: https://insights.sei.cmu.edu/blog/software-cost-estimation-explained/

## Step 1: base hour range for senior

```
hours_by_complexity_class_senior:
  S:   4 to 12 hours
  M:   12 to 32 hours
  L:   32 to 80 hours
  XL:  80 to 160 hours
  XXL: 160 to 320 hours, with mandatory recommendation to break down scope
```

These ranges are a Reversa heuristic, based on T-shirt sizing. They are more honest than a linear constant because software estimation has real uncertainty.

## Step 2: seniority factor

```
seniority_factor:
  junior:      1.34
  mid:         1.15
  senior:      1.00
  staff_lead:  0.88
  principal:   0.76
```

Accepted aliases for compatibility:

```
mid-level -> mid
specialist -> staff_lead
staff -> staff_lead
lead -> staff_lead
```

## Step 3: estimated hours

```
hours_min = round(hours_min[complexity_class] * seniority_factor)
hours_max = round(hours_max[complexity_class] * seniority_factor)
hours_estimated = round((hours_min + hours_max) / 2)
```

The `hours_estimated` field is the midpoint for compatibility and summary. The range `hours_min` to `hours_max` must be displayed in estimate.md.

## Step 4: direct cost

```
direct_cost_min = hours_min * profile.hourly_rate
direct_cost_max = hours_max * profile.hourly_rate
direct_cost = hours_estimated * profile.hourly_rate
```

## Step 5: approximate tax

```
approximate_tax_min = direct_cost_min * profile.tax_factor
approximate_tax_max = direct_cost_max * profile.tax_factor
approximate_tax = direct_cost * profile.tax_factor
```

When `profile.tax_regime == "other"` or `tax_factor = 0`, the tax is not computed and estimate.md must display an explicit warning.

If the profile indicates that the factor includes VAT, IVA or tax listed separately on the invoice, estimate.md must warn that this amount may be passed on to the client and does not necessarily reduce margin.

## Step 6: project markup

The historical field `margin_percent` must be treated as **project markup over direct cost**, not as accounting net margin.

```
markup_min = direct_cost_min * (profile.margin_percent / 100)
markup_max = direct_cost_max * (profile.margin_percent / 100)
applied_markup = direct_cost * (profile.margin_percent / 100)
```

## Step 7: total price

```
minimum_price = round_currency(direct_cost_min + approximate_tax_min + markup_min)
maximum_price = round_currency(direct_cost_max + approximate_tax_max + markup_max)
total_price = round_currency(direct_cost + approximate_tax + applied_markup)
```

`total_price` is the midpoint of the range and exists for compatibility. estimate.md must highlight `minimum_price` to `maximum_price`.

## Example

```
profile:
  country = BR, currency = BRL, seniority = senior
  hourly_rate = 100.00, margin_percent = 35, tax_factor = 0.15

size:
  complexity_class = L

hours_by_complexity_class_senior[L] = 32 to 80
seniority_factor[senior] = 1.00
hours_min = 32
hours_max = 80
hours_estimated = 56

direct_cost_min = 3200.00
direct_cost_max = 8000.00
tax_min = 480.00
tax_max = 1200.00
markup_min = 1120.00
markup_max = 2800.00

minimum_price = 4800.00 BRL
maximum_price = 12000.00 BRL
total_price = 8400.00 BRL
```

## Conversion to billing currency

When `profile.billing_currency` and `profile.exchange_rate_to_local` are filled in:

```
billing_value = round_currency(local_value / exchange_rate_to_local)
```

estimate.md must print the rate used:

```
1 <billing_currency> = <exchange_rate_to_local> <currency>
```

## Limits

1. The formula does not mix team seniorities
2. XXL is still calculable, but must generate a strong recommendation to break down scope
3. The hour range is a heuristic, not a delivery promise
4. `size_score` does not enter the hour calculation
