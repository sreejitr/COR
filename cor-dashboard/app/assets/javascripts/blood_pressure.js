function populate_blood_pressure_container() {
    var defaultCeiling = Math.max(systolicHigh * 4 / 3, diastolicHigh * 4 / 3);
    var ceiling = Math.max(defaultCeiling, systolicReading, diastolicReading);

    $('#blood_pressure_container').highcharts({
        chart: {
        },
        title: {
            text: 'Blood Pressure'
        },
        xAxis: {
            categories: ['Systolic', 'Diastolic']
        },
        yAxis: {
            title: {
                text: "Blood Pressure (mm Hg)"
            }
        },
        tooltip: {
            formatter: function() {
                var s;
                if (this.percentage) { // the bar chart
                    s = false;
                } else {
                    s = ''+
                        this.x + ': '+ this.y + ' mm Hg';
                }
                return s;
            }
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
            data: [ceiling - systolicHigh, ceiling - diastolicHigh]
        }, {
            type: 'column',
            name: 'Normal',
            color: '#2EFE9A',
            data: [systolicHigh - systolicLow, diastolicHigh - diastolicLow]
        }, {
            type: 'column',
            name: 'Low',
            color: '#FFFF99',
            data: [systolicLow, diastolicLow]
        }, {
            type: 'spline',
            name: 'Reading at ',// + Date(timestamp).toString(),
            data: [systolicReading, diastolicReading],
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

