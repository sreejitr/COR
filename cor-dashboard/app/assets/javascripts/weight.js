/* finds the max - min of the elements in the given range of the array*/
function getLocalDelta(i, j) {
    var min = data[i][1];
    var max = data[i][1];
    for(; i<=j; i++) {
        if(data[i][1] < min) {
            min = data[i][1];
        }
        if(data[i][1] > max) {
            max = data[i][1];
        }
    }
    return max - min;
}

function parseData() {
    var regData = new Array();
    var irregData = new Array();

    var regularity = new Array();
    for(var i=0; i<data.length; i++) {
        regularity[i] = true;
    }

    for(var i=0; i<data.length; i++) {
        var prevIdx = (i - timeThreshold > 0) ? i - timeThreshold  : 0;
        var delta = getLocalDelta(prevIdx, i);
        if(delta >= weightThreshold || delta <= -weightThreshold) {
            for(var j=0; j<timeThreshold; j++){
                regularity[i-j-1] = false;
            }
        }
    }

    var isRegular = false;
    for(var i=0; i<regularity.length; i++) {
        if(regularity[i]) {
            if(i==0 || isRegular) {
                regData[i] = data[i];
                irregData[i] = [data[i][0],null];
            } else {
                regData[i] = data[i];
                irregData[i] = data[i];
            }
            isRegular = true;
        } else {
            if(i==0 || !isRegular) {
                regData[i] = [data[i][0],null];
                irregData[i] = data[i];
            } else {
                regData[i] = data[i];
                irregData[i] = data[i];
            }
            isRegular = false;
        }
    }

    return [regData, irregData];
}

function populate_weight_container() {
    var parseOutput = parseData();
    var regData = parseOutput[0];
    var irregData = parseOutput[1];
    $('#weight_container').highcharts({
        chart: {
            type: 'spline'
        },
        title: {
            text: 'Weight'
        },
        xAxis: {
            type: 'datetime',
            dateTimeLabelFormats: { // don't display the dummy year
                month: '%b %e',
                year: '%b'
            }
//            min: Date.UTC(2014, 0, 1)
        },
        yAxis: {
            title: {
                text: 'Weight (lbs)'
            }
        },
        tooltip: {
            formatter: function() {
                return '<b>'+ this.series.name +'</b><br/>'+
                    Highcharts.dateFormat('%b %e', this.x) +': '+ this.y +' lbs';
            }
        },

        series: [{
            name: 'No Weight Change over Last 5 Days',
            color: '#00FF00',
            data:regData
        }, {
            name: 'Weight Change Over Last 5 Days',
            color: '#FF0000',
            lineWidth: 5,
            data:irregData
        }]
    });
}
