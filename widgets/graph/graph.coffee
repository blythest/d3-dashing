class Dashing.Graph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    console.log(points);
    if points
      points[points.length - 1].y

  onData: (data) ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))

    x = d3.scale.linear().range([
      0
      width
    ])

    y = d3.scale.linear().range([
      height
      0
    ])

    xAxis = d3.svg.axis().scale(x).orient("bottom")
    yAxis = d3.svg.axis().scale(y).orient("left")

    area = d3.svg.area().x((d) ->
      x d.x
    ).y1(height).y0((d) ->
      y d.y
    )
        
    svg = d3.select(@node).append("svg").attr("width", width).attr("height", height)
    points = @get('points')
    d3.json points, (error, points) ->
    points.forEach (d) ->
      d.x = +d.x
      d.y = d.y
      return

    x.domain d3.extent(points, (d) ->
        d.x
      )
    y.domain [
        0
        d3.max(points, (d) ->
          d.y
        )
      ]
    svg.append("path").datum(points).attr("class", "area").attr "d", area
