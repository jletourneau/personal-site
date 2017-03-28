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

tca_colors =
  6: colors.red
  5: colors.orange
  4: colors.yellow
  3: colors.green
  2: colors.blue
  1: colors.pink
  0: colors.gray

Plotly.d3.csv 'https://raw.githubusercontent.com/jletourneau/jletourneau.github.io/master/data/ll72-record-by-opponent-qpct.csv', (err, rows) ->
  console?.log("Loaded data: #{rows.length} rows")
  rows.map (row) ->
    row['W'] = parseInt(row['W'], 10)
    row['L'] = parseInt(row['L'], 10)
    row['T'] = parseInt(row['T'], 10)
    row['Matches'] = parseInt(row['Matches'], 10)
    row['ExpPts'] = ((2 * row['W']) + (1 * row['T'])) / row['Matches']

  exp_pts_formatter = Plotly.d3.format('.3f')
  opp_qpct_formatter = exp_pts_formatter

  vmax = Math.max(window.innerWidth, window.innerHeight)
  sizeref = Math.min(Math.max(21 - (vmax / 50), 1), 11)

  data = '0123456'.split('').map (tca) ->
    dataset = rows.filter (row) -> row['TCA'] == tca
    {} =
      name: "#{tca} TCA"
      mode: 'markers'
      hoverinfo: 'text'
      x: dataset.map (row) -> row['OpponentQPct']
      y: dataset.map (row) -> row['ExpPts']
      text:
        dataset.map (row) ->
          formatted_exp_pts = exp_pts_formatter(row['ExpPts'])
          opp_qpct = opp_qpct_formatter(row['OpponentQPct'])
          "#{row['TCA']} TCA vs. #{opp_qpct} ±.005 QPct:
            <br>
            #{formatted_exp_pts} avg. match points
            <br>
            (#{row['W']} W, #{row['T']} T, #{row['L']} L in #{row['Matches']} matches)"
      marker:
        opacity: 0.6
        sizemode: 'area'
        sizemin: 1.5
        sizeref: sizeref
        color: dataset.map (row) -> tca_colors[row['TCA']]
        size: dataset.map (row) -> Math.pow(row['Matches'], 1.0)

  layout =
    title: document.getElementsByTagName('title')[0].innerHTML
    paper_bgcolor: 'rgba(0, 0, 0, 0)'
    plot_bgcolor: 'rgba(0, 0, 0, 0)'
    hovermode: 'closest'
    margin:
      t: 75
      b: 75
      l: 75
      r: 75
    xaxis:
      title: 'Opponent QPct'
      range: [-0.02, 1.02]
      dtick: 0.1
      dtick: 1 / 10
      tickformat: '.3f'
      gridcolor: 'rgba(0, 0, 0, 0.1)'
      zerolinecolor: 'rgba(0, 0, 0, 0.1)'
    yaxis:
      title: 'Avg. match points'
      range: [-0.02, 2.02]
      dtick: 1 / 4
      tickformat: '.2f'
      gridcolor: 'rgba(0, 0, 0, 0.1)'
      zerolinecolor: 'rgba(0, 0, 0, 0.1)'

  options = {}
  document.getElementById('plot_div').innerHTML = ''
  Plotly.plot('plot_div', data, layout, options)
