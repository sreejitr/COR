function populate_heart_rate_container() {
    var defaultCeiling = heartrateHigh * 4 / 3;
    var ceiling = Math.max(defaultCeiling, heartrateReading);

    $('#heart_rate_container').highcharts({
        chart: {
        },
        title: {
            text: 'Heart Rate'
        },
        xAxis: {
            categories: ['Heart Rate']
        },
        yAxis: {
            title: {
                text: "Heart Rate (bpm)"
            }
        },
        tooltip: {
            formatter: function() {
                var s;
                if (this.percentage) { // the bar chart
                    s = false;
                } else {
                    s = ''+
                        this.x + ': '+ this.y + ' bpm';
                }
                return s;
            }
        },
        labels: {
            align: "center",
            items: [{
                html: "Variability: "+variability,
                style: {
                    left: '10px',
                    top: '100px',
                    color: 'black',
                    fontSize: '10pt',
                }
            }]
        },
        plotOptions: {
            column: {
                stacking: 'normal',                
                dataLabels: {
                    enabled: true,
                    align: 'left',
                    formatter: function() {
                        return this.series.name;
                    }
                }
            }
        },
        series: [{
            type: 'column',
            name: 'High',
            color: '#F78181',
            data: [ceiling - heartrateHigh]
        }, {
            type: 'column',
            name: 'Normal',
            color: '#2EFE9A',
            data: [heartrateHigh - heartrateLow]
        }, {
            type: 'column',
            name: 'Low',
            color: '#FFFF99',
            data: [heartrateLow]
        }, {
            type: 'spline',
            name: 'Reading at ',// + Date(timestamp).toString(),
            data: [heartrateReading],
            lineWidth: 0,
            marker: {
                radius: 10,
                fillColor: '#9EA6A6',
                lineWidth: 2,
                lineColor: 'black'

            }
        }]
    });
}


