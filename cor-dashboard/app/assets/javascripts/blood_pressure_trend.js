function populate_blood_pressure_trend_container() {
    console.log(systolicReading);
    $('#blood_pressure_trend_container').highcharts({
        chart: {
            type: 'spline'
        },
        title: {
            text: 'Blood Pressure'
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%e. %b',
                year: '%b'
            },
            title: {
                text: 'Date'
            }
        },
        yAxis: {
            title: {
                text: 'Blood Pressure (mm Hg)'
            },
            min: 0
        },
        tooltip: {
            headerFormat: '<b>{series.name}</b><br>',
            pointFormat: '{point.x:%e. %b}: {point.y:.2f} m'
        },

        series: [{
            name: 'Systolic',
            // Define the data points. All series have a dummy year
            // of 1970/71 in order to be compared on the same x axis. Note
            // that in JavaScript, months start at 0 for January, 1 for February etc.
            data: systolicReading
        }, {
            name: 'Diastolic',
            data: diastolicReading
        }]
    });
}


