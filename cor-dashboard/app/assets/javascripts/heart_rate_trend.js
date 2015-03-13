function populate_heart_rate_trend_container() {
    $('#heart_rate_trend_container').highcharts({
        chart: {
            type: 'spline'
        },
        title: {
            text: 'Heart Rate'
        },
        subtitle: {
            text: 'Irregular time data in Highcharts JS'
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%b %e',
                year: '%b'
            }
        },
        yAxis: {
            title: {
                text: 'Heart Rate (bpm)'
            },
            plotBands: [{
                from: 0,
                to: thresholdLow,
                color: 'rgba(255, 0, 0, .4)',
                label: {
                    text: 'Low',
                    style: {
                        color: '#606060'
                    }
                }
            }, {
                from: thresholdLow,
                to: thresholdHigh,
                color: 'rgba(0, 255, 0, .4)',
                label: {
                    text: 'Normal',
                    style: {
                        color: '#606060'
                    }
                }
            }, {
                from: thresholdHigh,
                to: 300,
                color: 'rgba(255, 0, 0, .4)',
                label: {
                    text: 'High',
                    style: {
                        color: '#606060'
                    }
                }
            }],
            min: 0,
            max: 300
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    Highcharts.dateFormat('%b %e', this.x) +': '+ this.y +' bpm';
            }
        },

        series: [{
            name: 'Heart Rate',
            // Define the data points. All series have a dummy year
            // of 1970/71 in order to be compared on the same x axis. Note
            // that in JavaScript, months start at 0 for January, 1 for February etc.
            data:data
        }]
    });
}


