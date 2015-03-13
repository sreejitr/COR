function populate_sodium_container() {
    console.log(data);
    $('#sodium_container').highcharts({
        chart: {
            type: 'spline'
        },
        title: {
            text: 'Sodium'
        },
        subtitle: {
            text: ''
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
                text: 'Sodium Intake'
            },
            plotBands: [{
                from: 0.5,
                to: 1.5,
                color: 'rgba(0, 255, 0, .4)',
                label: {
                    text: 'Normal',
                    style: {
                        color: '#606060'
                    }
                }
            }, {
                from: 1.5,
                to: 2.5,
                color: 'rgba(255, 255, 0, .4)',
                label: {
                    text: 'Above Normal',
                    style: {
                        color: '#606060'
                    }
                }
            }, {
                from: 2.5,
                to: 4,
                color: 'rgba(255, 0, 0, .4)',
                label: {
                    text: 'High',
                    style: {
                        color: '#606060'
                    }
                }
            }],
            min: 0.5,
            max: 3.5
        },
        tooltip: {
            formatter: function() {
                switch(this.y)
                {
                case 1:
                    return '<b>'+ this.series.name +'</b><br/>'+
                            Highcharts.dateFormat('%b %e', this.x) +': '+ 'Low';
                case 2:
                    return '<b>'+ this.series.name +'</b><br/>'+
                            Highcharts.dateFormat('%b %e', this.x) +': '+ 'Medium';
                case 3:
                    return '<b>'+ this.series.name +'</b><br/>'+
                            Highcharts.dateFormat('%b %e', this.x) +': '+ 'High';
                default:
                    return "Value not 1, 2, or 3, like it's supposed to be";
                }

            }
        },

        series: [{
            name: 'Reported Sodium Intake',
            // Define the data points. All series have a dummy year
            // of 1970/71 in order to be compared on the same x axis. Note
            // that in JavaScript, months start at 0 for January, 1 for February etc.
            data:data
        }]
    });
}

