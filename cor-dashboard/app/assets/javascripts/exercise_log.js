function populate_exercise_log_container () {
    $('#exercise_log_container').highcharts({
            chart: {
                type: 'column'
            },
            title: {
                text: 'Active Minutes as reported by FitBit'
            },
            xAxis: {
                categories: days
               
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Active Minutes'
                },
                stackLabels: {
                    enabled: true,
                    style: {
                        fontWeight: 'bold',
                        color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
                    }
                }
            },
            legend: {
                align: 'right',
                x: -70,
                verticalAlign: 'top',
                y: 20,
                floating: true,
                backgroundColor: (Highcharts.theme && Highcharts.theme.legendBackgroundColorSolid) || 'white',
                borderColor: '#CCC',
                borderWidth: 1,
                shadow: false
            },
            tooltip: {
                formatter: function() {
                    return '<b>'+ this.x +'</b><br/>'+
                        this.series.name +': '+ this.y +'<br/>'+
                        'Total: '+ this.point.stackTotal;
                }
            },
            plotOptions: {
                column: {
                    stacking: 'normal',
                    dataLabels: {
                        enabled: true,
                        color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white',
                        style: {
                            textShadow: '0 0 3px black, 0 0 3px black'
                        }
                    }
                }
            },
            series: [{
                name: 'Very Active',
                data: very

            }, {
                name: 'Fairly Active',
                data: fairly
                
            }, {
                name: 'Lightly Active',
                data: lightly
            }, {
                name: 'Sedentary',
                data: sed
            }]
        });
}
    
