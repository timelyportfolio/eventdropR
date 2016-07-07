HTMLWidgets.widget({

  name: 'eventdrop',

  type: 'output',

  factory: function(el, width, height) {

    var instance = {};

    return {

      drawEventDrop: function(el, instance){

          var x = instance.x;

          // for convenience get d3 selected el
          el = d3.select(el);

          // brute force way to clean out our container element
          //  for dynamic situations, since EventDrops does
          //  not support animated updates
          el.selectAll('*').remove();

          // get height and width
          var width = el.node().getBoundingClientRect().width;
          var height = el.node().getBoundingClientRect().height;

          // get start and end times based on the range of data
          var endTime = d3.max(x.data[x.date || "date"]);
          var startTime = d3.min(x.data[x.date || "date"]);

          // assume data from R data.frame
          var df = HTMLWidgets.dataframeToD3(x.data);
          df = d3.nest()
            .key(function(d){
              return d[x.name || "name"]
            })
            .entries(df)
            .map(function(d){
              // rename to name and data which are the defaults
              //  for EventDrops
              d.name = d.key;
              d.data = d.values;
              // delete these properties since we renamed
              //   probably better way to handle
              delete(d.key);
              delete(d.values);
              return d;
            });

          var color = d3.scale.category20();

          // create chart function
          var eventDropsChart = d3.chart.eventDrops();

          // set defaults which we can override later
          //   by x.options
          eventDropsChart
            //.width(width)
            // margin don't behave the way I expect
            //.margin({top: 40, bottom: 20, left: 75, right: 50})
            .labelsWidth(100)
            .eventLineColor(function (datum, index) {
                return color(index);
            })
            .start(new Date(startTime))
            .end(new Date(endTime))
            .date(function(d){
              return new Date(d[x.date || 'date']);
            });

          // loop through x.options and try to apply them
          //   to our eventDropsChart
          Object.keys(x.options)
            .forEach(function(ky){
              try{
                eventDropsChart[ky](x.options[ky]);
              } catch(e) { }
            })

          // bind data with DOM
          el.datum(df);

          // draw the chart
          eventDropsChart(el);

          // add eventDrops to instance
          instance.eventdrop = eventDropsChart;

      },

      renderValue: function(x) {

        // add our x (data) to instance
        instance.x = x;

        this.drawEventDrop(el, instance);

      },

      resize: function(width, height) {
        // use pull request 82
        //  for resize when ready
        //  https://github.com/marmelab/EventDrops/pull/82
        this.drawEventDrop(el, instance);

      },

      instance: instance

    };
  }
});
