colors =
  gray: '#4D4D4D'
  blue: '#5DA5DA'
  orange: '#FAA43A'
  green: '#60BD68'
  pink: '#F17CB0'
  brown: '#B2912F'
  purple: '#B276B2'
  yellow: '#DECF3F'
  red: '#F15854'

level_colors =
  A: colors.red
  B: colors.orange
  C: colors.yellow
  D: colors.green
  E: colors.blue
  R: colors.pink

level_domains = [
  [0.025, 0.175],
  [0.185, 0.335],
  [0.345, 0.495],
  [0.505, 0.655],
  [0.665, 0.815],
  [0.825, 0.975],
]
boxplot_domains = [
  [0.025, 0.035],
  [0.185, 0.195],
  [0.345, 0.355],
  [0.505, 0.515],
  [0.665, 0.675],
  [0.825, 0.835],
]

filter_prefix = (field, prefix) ->
  (row) -> (row[field].indexOf(prefix) == 0)
filter_max = (field, n) ->
  (row) -> (row[field] <= n)

unpack = (rows, key) ->
  rows.map((row) -> row[key])
unpack_multi = (rows, keys) ->
  rows.map((row) -> (row[key] for key in keys))

fuzz = (values, scale=0.5) ->
  values.map((n) -> (n - (scale * Math.random()) + (scale / 2)))
join_2d = (aoa, joiner='<br>') ->
  aoa.map((a) -> a.join(joiner))

Plotly.d3.csv 'https://raw.githubusercontent.com/jletourneau/jletourneau.github.io/master/data/ll72-players.csv', (err, rows) ->
  console?.log("Loaded data: #{rows.length} rows")

  config =
    x_field: 'DE'
    x_label: 'Defensive efficiency'
    y_field: 'TCA'
    y_label: 'Total correct answers'
    text_fields: ['Player', 'Rundle']

  data = []

  'ABCDER'.split('').map (level, index) ->
    players = rows.filter(filter_prefix('Rundle', level))

    data.push
      name: level
      mode: 'markers'
      x: unpack(players, config.x_field)
      y: fuzz(unpack(players, config.y_field), 0.4)
      text: join_2d(unpack_multi(players, config.text_fields))
      marker:
        size: 3
        opacity: 0.5
        color: level_colors[level]
      xaxis: "x#{index + 1}"
      yaxis: 'y2'

    data.push
      type: 'box'
      showlegend: false
      x: players.map(() -> 0.5)
      y: unpack(players, config.y_field)
      hoverinfo: 'y'
      marker:
        size: 3
        opacity: 0.8
        color: level_colors[level]
      line:
        width: 1
      whiskerwidth: 1
      boxpoints: 'suspectedoutliers'
      xaxis: "x#{index + 7}"
      yaxis: 'y1'

  layout =
    title: 'Total correct answers vs. defensive efficiency by level, LL72'
    paper_bgcolor: 'rgba(0, 0, 0, 0)'
    plot_bgcolor: 'rgba(0, 0, 0, 0)'
    hovermode: 'closest'
    boxmode: 'group'
    boxgap: 0.1
    showlegend: false
    margin:
      t: 80
      b: 80
      l: 40
      r: 0

    # yaxis1: box plots
    yaxis1:
      domain: [0, 1]
      range: [0, 150]
      hoverformat: '.0f'
      tick0: 0
      dtick: 10
      mirror: false
      linecolor: 'rgba(0, 0, 0, 0)'
      gridcolor: 'rgba(0, 0, 0, 0)'
      zerolinecolor: 'rgba(0, 0, 0, 0)'
      linewidth: 0
      gridwidth: 0
      zerolinewidth: 0
      showticklabels: false

    # yaxis2: scatter plots
    yaxis2:
      title: "#{config.y_label} (all levels)"
      domain: [0, 1]
      range: [0, 150]
      hoverformat: '.0f'
      tick0: 0
      dtick: 10
      mirror: 'all'
      linecolor: 'rgba(0, 0, 0, 0.15)'
      gridcolor: 'rgba(0, 0, 0, 0.05)'
      zerolinecolor: 'rgba(0, 0, 0, 0.1)'
      linewidth: 1
      gridwidth: 1
      zerolinewidth: 1

  for i in [0..5]

    # x1-x6: scatter plots
    layout["xaxis#{i + 1}"] =
      title: "#{config.x_label} (#{('ABCDER')[i]})"
      domain: level_domains[i]
      range: [0.2, 1.0]
      hoverformat: '.3f'
      tickmode: 'array'
      tickvals: [0.2, 0.4, 0.6, 0.8]
      ticktext: ['', '.400', '.600', '.800']
      mirror: 'all'
      linecolor: 'rgba(0, 0, 0, 0.15)'
      gridcolor: 'rgba(0, 0, 0, 0.05)'
      zerolinecolor: 'rgba(0, 0, 0, 0.1)'
      linewidth: 1
      gridwidth: 1
      zerolinewidth: 1

    # x7-x12: box plots
    layout["xaxis#{i + 7}"] =
      domain: boxplot_domains[i]
      range: [0, 1]
      mirror: false
      linecolor: 'rgba(0, 0, 0, 0)'
      gridcolor: 'rgba(0, 0, 0, 0)'
      zerolinecolor: 'rgba(0, 0, 0, 0)'
      linewidth: 0
      gridwidth: 0
      zerolinewidth: 0
      showticklabels: false

  options = {}
  document.getElementById('plot_div').innerHTML = ''
  Plotly.plot('plot_div', data, layout, options)
