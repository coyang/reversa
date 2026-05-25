<!--
  Template: metricas.html
  Producer: reversa-docs-analyst
  Invoked skill: highcharts-visualizer
  Page ID: metricas
  Reversa category: diagram
  Consumed data: assets/data/metrics.json

  Markers:
  - HEAD_EXTRAS: <script src="assets/vendor/highcharts.js"></script>
                 + <script src="assets/vendor/highcharts-accessibility.js"></script>
                 + <script src="assets/vendor/highcharts-exporting.js"></script>
                 + <script src="assets/vendor/highcharts-treemap.js"></script>
                 + <script src="assets/vendor/highcharts-sankey.js"></script>
                 (all downloaded by the Publisher via vendor-pins.yaml,
                  highcharts@11.4.8)
  - CHART_TREEMAP: container for the LOC treemap
  - CHART_COMPLEXITY: container for the top-20 bars
  - CHART_HISTOGRAM: container for the histogram
  - CHART_SANKEY: container for the dependency sankey
  - SCRIPTS: builds the charts from window.RV_DATA.metrics (no local fetch)
-->

<!-- PAYLOAD_START -->
<section class="reversa-doc-dashboard" data-layout="grid-2x2">
    <article class="reversa-doc-chart">
        <h2>LOC per folder</h2>
        <div id="chart-treemap"><!-- CHART_TREEMAP --></div>
    </article>
    <article class="reversa-doc-chart">
        <h2>Top 20 complexity</h2>
        <div id="chart-complexity"><!-- CHART_COMPLEXITY --></div>
    </article>
    <article class="reversa-doc-chart">
        <h2>Size distribution</h2>
        <div id="chart-histogram"><!-- CHART_HISTOGRAM --></div>
    </article>
    <article class="reversa-doc-chart">
        <h2>Dependency flow</h2>
        <div id="chart-sankey"><!-- CHART_SANKEY --></div>
    </article>
</section>
<!-- PAYLOAD_END -->
