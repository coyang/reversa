# Error Handling -- Highcharts Visualizer

## Insufficient or Empty Data

**Symptom:** Chart renders empty or with "No data to display" message.

**Action:** Configure `noData` module or verify data before creating the chart:
```javascript
// Include: modules/no-data-to-display.js
lang: { noData: 'No data available to display' },
noData: { style: { fontWeight: 'bold', fontSize: '16px', color: '#666' } }
```

Notify the user:
> "The provided data appears to be empty or was not processed correctly. Could you verify?"

## Incompatible Data Format

**Symptom:** Console error or chart with NaN/undefined values.

**Action:** Validate data with `scripts/parse_data.py` before embedding. The script automatically converts
numeric strings ("1,234.56" -> 1234.56) and dates in multiple formats.

## CDN Module Fails to Load

**Symptom:** "Highcharts is not defined" error or chart type not recognized.

**Action:** Verify script order. The core `highcharts.js` must come first, then modules.
For Stock/Maps/Gantt, use the respective main script (highstock.js, highmaps.js, highcharts-gantt.js)
**instead of** highcharts.js, not alongside it.

Correct order:
```html
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/highcharts-more.js"></script>
<script src="https://code.highcharts.com/modules/solid-gauge.js"></script>
<script src="https://code.highcharts.com/modules/exporting.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
```

## Non-responsive Chart

**Symptom:** Chart does not resize with the window, or gets cut off.

**Action:** Do not set fixed `chart.width`. Use a container with responsive CSS.
Ensure `chart.reflow` is not disabled.

```javascript
chart: {
    // Do NOT set fixed width/height
    // Let Highcharts adapt to the container
    reflow: true
}
```

## Slow Performance with Large Data

**Symptom:** Chart lagging or taking long to render with >10,000 points.

**Action:**
1. Include `modules/boost.js`
2. Set `boostThreshold: 5000` on the series
3. Disable animations: `plotOptions: { series: { animation: false } }`
4. Disable markers: `marker: { enabled: false }`
5. Consider aggregating data (downsampling) via `scripts/analyze_data.py`

## Tooltips with Incorrect Values

**Symptom:** Tooltip shows "undefined" or wrong format.

**Action:** Verify that data is in the correct format for the chart type.
Use a custom `tooltip.formatter` for full control over the format.

## Unreadable Colors

**Symptom:** Series or labels with insufficient contrast.

**Action:** Use `Highcharts.getOptions().colors` to check the active palette.
For dark mode, ensure labels/grid/ticks have light colors.
The accessibility module warns about contrast issues.

## CSV with Different Encoding (UTF-8 BOM, Latin1)

**Symptom:** Special characters (accents) appear as "" or garbled text.

**Action:** `scripts/parse_data.py` attempts to detect encoding automatically.
If it fails, force encoding:
```bash
python scripts/parse_data.py data.csv --encoding latin1
```

## Excel File with Multiple Sheets

**Symptom:** Extracted data is from the wrong sheet.

**Action:**
```bash
python scripts/parse_data.py data.xlsx --sheet "Sheet2"
```
