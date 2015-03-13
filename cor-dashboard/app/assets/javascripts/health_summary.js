function populate_health_summary_container() {
    console.log("graph")
    console.log(weight)
    console.log(heartRate)
    console.log(bloodOxygen)
    console.log(bloodPressure)
    console.log(sodium)

    $('#health_summary_container').highcharts({

        chart: {
            type: 'bubble',
            zoomType: 'xy'
        },

        title: {
            text: 'Health Summary'
        },
        yAxis: {
            gridLineWidth: 0,
            minorGridLineWidth: 0,
            labels: {
                enabled: false
            },
            title: {
                text: null
            },
            plotBands: [{
                from: 0,
                to: 2,
                color: 'rgba(255, 0, 0, .3)'
            }, {
                from: 2,
                to: 4,
                color: 'rgba(0, 255, 0, .3)'
            }, {
                from: 4,
                to: 6,
                color: 'rgba(255, 0, 0, .3)'
            }],
            min: 0,
            max: 6


        },
        xAxis: {
            categories:['Weight', 'Heart Rate', 'Blood Oxygen', 'Blood Pressure', 'Sodium'],

        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.x +'</b>';
            }
        },
        series: [{
            showInLegend: false,
            //data: [['Weight',3, 0], ['Heart Rate',2.4, 0], ['Blood Oxygen',4, 0], ['Blood Pressure',3.6, 0], ['Sodium',3, 0]],
            data:   [['Weight', weight, 0], ['Heart Rate', heartRate, 0], ['Blood Oxygen', bloodOxygen, 0], ['Blood Pressure', bloodPressure, 0], ['Sodium', sodium, 0]],                    
            color: "#0147FA"
        }]

    });

}