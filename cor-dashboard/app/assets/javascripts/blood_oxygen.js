function populate_blood_oxygen_container() {
    $('#blood_oxygen_container').highcharts({
        chart: {
            type: 'spline'
        },
        title: {
            text: 'Blood Oxygen'
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
                text: 'Blood Oxygen (%)'
            },
            plotBands: [{
                from: 60,
                to: threshold,
                color: 'rgba(255, 0, 0, .4)',
                label: {
                    text: 'Below Normal',
                    style: {
                        color: '#606060'
                    }
                }
            }, {
                from: threshold,
                to: 100,
                color: 'rgba(0, 255, 0, .4)',
                label: {
                    text: 'Normal',
                    style: {
                        color: '#606060'
                    }
                }
            }],
            min: 60,
            max: 100
        },
        tooltip: {
            formatter: function() {
                    return '<b>'+ this.series.name +'</b><br/>'+
                    Highcharts.dateFormat('%b %e', this.x) +': '+ this.y +' %';
            }
        },

        series: [{
            name: 'Blood Oxygen',
            // Define the data points. All series have a dummy year
            // of 1970/71 in order to be compared on the same x axis. Note
            // that in JavaScript, months start at 0 for January, 1 for February etc.
            data:data
        }]
    });
}

