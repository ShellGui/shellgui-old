;(function($){
    
    $.fn.multiChart = function(options){
        var data = options;
        var chartContainer = $(this).attr('id');
        var containerId = '#' + chartContainer;
        var chartType = options.chartType || '';
        $(containerId).empty();
        if (data.hasOwnProperty('isMultiChart')){
            var index = 1;
            for(var i in data.data){
                var item = data.data[i];
                var width = item.width || '100%';
                var subId = chartContainer + index++;
                $(containerId).append("<div id='" + subId + "' style='float:left;width:" + width + "'></div>"); 
                $('#' + subId).createChart({chartType: chartType, dataFormat: 1, categories: item.data.categories, series : item.data.series, chartOptions: item.data.chartOptions});
            }
        }
        else{
            $(containerId).createChart(data);
        }
    }

    $.fn.createChart = function(options){
        
       //默认配置
        var defaults = {
            title: '',                              //图表标题,备用
            width: '100%',                          //图表宽度
            height: 300,                            //图表高度
            showLabel: true,                        //是否显示标签
            showMarker: true,                       //是否显示点
            chartType: 'area',                      //图表类型
            dataFormat: 1,                          //数据类型，1：整数，2：浮点数  3：百分比，仅在后面追加百分号  4：时间格式 HH:MM:SS 5：百分比，显示时会乘上100  6：不处理，保留原有格式 7: 当是整数时 format为整数，小数就显示浮点 modified by dorsywang
            labelFormat: 0,                         //指定标签显示的格式，0: 不显示，1: 显示Y值， 2：自动计算百分比并显示
            categories: [],                         //X轴数据
            series:[],                              //Y轴数列
            yMin: null,                             //Y轴最小值
            yMax: null,                             //Y轴最大值
            xAxisLabelStep: 0,                      //X轴标签间隔
            xAxisTickInterval: 0,                   //X轴刻度间隔
//            useDefaultStyle: true,                  //是否使用默认highchart主题样式
            enableZoom: true,
            autoStep: true,                         //自动计算步长
            showPlotLine: false,                    //是否显示中位线 
            enableLegend: true,                     //是否显示图例
            autoYAxisInterval: true,                //自动计算Y轴间隔
            maxYAxisIntervalCount: 3,               //Y轴最大刻度数 
            theme: '',                              //图表样式主题
            cssNoData: 'nodata',                    //无数据时样式名
            isCompareSeries: false,                 //判断两个数列是否为对比数列
            autoxAxisDataType: false,               //是否自动识别X轴数据类型，比如日期类型，以别进行相关个性化设置
            chartOptions:{                          //hichCharts的配置
                chart: {},
                title: {},
                xAxis: {
                    categories: '',
                    labels: {}
                },
                yAxis: {
                    min: 0
                },
                plotOptions: {
                    pie: {},
                    series: {
                        dataLabels: {}
                    }
                },
                legend:{},
                tooltip:{}
            }
        };

        var minY = maxY = 0;                        //标识Y坐标最大最小值
        var hasData = false;                        //判断是否有数据

        options = $.extend(true, defaults, options);

        //图表样式主题
        setChartTheme(options.theme);

        $(this).css('height', options.height);
//        $(this).css('width', options.width);

        var cOptions = options.chartOptions;
        var defaultChartType = {'area': 'area', 'line': 'line', 'pie': 'pie', 'bar': 'bar', 'spline': 'spline', 'column': 'column' }[options.chartType] || 'area';
        cOptions.chart.type = cOptions.chart.type || defaultChartType;
        (typeof options.title == 'object') ? cOptions.title = options.title :  cOptions.title.text = options.title;
        cOptions.legend.enabled = options.enableLegend;

        //转换符合highcharts格式的数列对象，同时判断是否有数据
        cOptions.series = toHighChartSeries(options.series);

        //如无数据，设置无数据样式并退出
        if (!hasData){
            $(this).addClass(options.cssNoData);
            $(this).html('<H4>' + cOptions.title.text + '</H4>');
            return;
        }
        $(this).removeClass(options.cssNoData);

        (!options.categories) && (cOptions.chart.type = 'pie');         //如options.categories为空，默认为饼图
        
        //设置X轴数据，
        if (options.categories && cOptions.chart.type != 'pie'){
            var isDateTime = false;
            var maxLen = 0;                 //类别名的最大长度，用于自动计算x轴步长
            var index = 0;

            for(var i in options.categories){
                var cate = options.categories[i].toString();
                maxLen < cate.length && (maxLen = cate.length);
                
                //根据数组第一个值来判断X轴类型
                if (index == 0){
                    var strDate = options.categories[i].toString();
                    isDateTime = isValidDate(strDate);              
                    index++;
                }
            }
            
            //智能识别日期类型
            options.autoxAxisDataType && isDateTime && (cOptions.xAxis.type = 'datetime');

            if (cOptions.xAxis.type !== 'datetime'){

                cOptions.xAxis.categories = toHighChartCategories(options.categories);

                //智能判断x轴的标签步长
                var labelWidth = maxLen * 6 + 50;           //每个标签所占的宽度
                if (options.autoStep){
                    var interval = cOptions.xAxis.tickInterval || 1;
                    cOptions.xAxis.labels.step = Math.ceil(cOptions.xAxis.categories.length / ($(this).css('width').replace(/[^\d\.]/g,'') / labelWidth) / interval);
                }
            }
            else{
                //如果是日期格式，设置X轴线性数据，以便使用zoom功能，且间隔为一天
                var oneDay = 24 * 3600 * 1000;
                cOptions.plotOptions.series.pointStart = startDate;
                cOptions.plotOptions.series.pointInterval = oneDay;
                cOptions.xAxis.maxZoom = 7 * oneDay;
                cOptions.xAxis.labels = cOptions.xAxis.labels || {};
                cOptions.xAxis.labels.formatter = cOptions.xAxis.labels.formatter || function(){
                        var d = new Date(this.value);
                        var result = isNaN(d) ? this.value : /*d.getFullYear() + '-' +*/ (d.getMonth() + 1) + '-' + d.getDate();
                        return result;
                };       
                
                cOptions.xAxis.tickInterval = oneDay;
                var labelWidth = 60;
                cOptions.xAxis.labels.step = Math.ceil(options.categories.length / ($(this).css('width').replace(/[^\d\.]/g,'') / labelWidth));
            }
            
            if (options.xAxisLabelStep > 0){
                cOptions.xAxis.labels.step = options.xAxisLabelStep;
            }
        }

        var mainYAxis = getMainYAxis();
        mainYAxis.dataFormat = mainYAxis.dataFormat || options.dataFormat;
        //Y轴最大、最小值
        if (options.yMin != null && options.yMax != null){
            minY = options.yMin;
            maxY = options.yMax;
            mainYAxis.min = options.yMin;
            mainYAxis.max = options.yMax;
        }

        //调整Y轴数据格式
        mainYAxis.labels = mainYAxis.labels || {};

        //处理百分比格式
        if (mainYAxis.dataFormat == 3){
            cOptions.tooltip.valueSuffix = '%';
        }
        if (cOptions.tooltip.valueSuffix){
            mainYAxis.labels.formatter = function(){
                var value = (mainYAxis.dataFormat == 5)?  Highcharts.numberFormat(this.value * 100, 0) : this.value;
                return value + cOptions.tooltip.valueSuffix;
            };
        }
        if (mainYAxis.dataFormat == 4){
            //转成时分秒格式H:mm:ss
            mainYAxis.labels.formatter = function(){
                return formatValue(mainYAxis.dataFormat, this.value);
            };
        }
                    
        if (options.labelFormat == 0){
            cOptions.plotOptions.series.dataLabels.enabled = false;
        }else{
            cOptions.plotOptions.series.dataLabels.enabled = true;
            cOptions.plotOptions.series.dataLabels.formatter = cOptions.plotOptions.series.dataLabels.formatter || function(){
                
                return formatValue(mainYAxis.dataFormat, this.y);
            }       
        }
        switch(options.labelFormat){
            case 0:
                cOptions.plotOptions.series.dataLabels.enabled = false;
                break;
            case 1:
                cOptions.plotOptions.series.dataLabels.formatter = cOptions.plotOptions.series.dataLabels.formatter || function(){
                    return formatValue(mainYAxis.dataFormat, this.y);
                }
                break;
            case 2:
                cOptions.plotOptions.series.dataLabels.formatter = cOptions.plotOptions.series.dataLabels.formatter || function(){
                    return Highcharts.numberFormat(this.percentage, 2) + '%';
                }
                break;
            default:
                cOptions.plotOptions.series.dataLabels.enabled = false;
                break;
        }

        options.showPlotLine && drawPlotLine();
        options.autoYAxisInterval && autoYAxisInterval();

        //自定义tooltip
        cOptions.tooltip = cOptions.tooltip || {};
        if (cOptions.chart.type != 'pie'){
            cOptions.tooltip.formatter = function(){
                var yName = mainYAxis.name ? ' (' + mainYAxis.name + ')' : '';          //显示自定义的Y轴名称
                var xName = isDateTime ? toDateDesc(this.x) : this.x;
                var s = '<div style="padding:5px;"><b>' + xName + yName + '</b></div><table style="width: 150px">';                
                $.each(this.points, function(i, point) {
                    var value = formatValue(mainYAxis.dataFormat, point.y);
                    var suffix = cOptions.tooltip.valueSuffix || '';
                    var title =  point.series.name;
                    if (options.isCompareSeries){
                        var subTitle = point.key;
                        if (isValidDate(point.key)){
                            //var d = new Date(point.key);
                            var d = convertToDate(point.key);
                            subTitle = (d.getMonth() + 1) + '-' + d.getDate();
                        }

                        title += ' (' + subTitle + ')';
                    }
                    s += '<tr><td style="padding: 2px 5px" >' + title + ' </td>' 
                       + '<td style="text-align: right;padding-left:15px">' + value + suffix + ' </td></tr>';
                });           
                s += '</table>';
                return s;
            };
        }else{
            //饼图tooltip默认显示百分比
            cOptions.tooltip.shared = false;
            cOptions.tooltip.useHTML= false;
            cOptions.tooltip.formatter =  cOptions.tooltip.formatter || function() {
                return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage * 100) / 100 +' %'; 
            };
        }   

        cOptions.chart.renderTo = $(this).attr('id');
        var chart = new Highcharts.Chart(cOptions);

        //设置highcharts主题，如参数theme为空，则加载默认配置，目前仅支持'wechat'主题
        function setChartTheme(theme){
            //highchart默认配置
            var defOptions = {
                title: {
                    margin: 20,
                    y: 20
                },
                colors: ['#49C9C3', '#FFBF3E', '#9DD30D', '#DA7D2A', '#39B54A', '#1CC4F5', '#1C95BD', '#5674B9', '#8560A8', '#9999FF'],
    //            colors: ['#1bd0dc', '#f9b700', '#eb6100', '#009944','#eb6877'],
                lang: {                                
                    //设置highcharts的全局常量的中文值，如月份、星期、按钮文字等
                    months: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
                    shortMonths: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
                    weekdays: ['星期天', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
                    resetZoom: '查看全图',
                    resetZoomTitle: '查看全图',
                    downloadPNG: '下载PNG',
                    downloadJPEG: '下载JPEG',
                    downloadPDF: '下载PDF',
                    downloadSVG: '下载SVG',
                    exportButtonTitle: '导出成图片',
                    printButtonTitle: '打印图表', 
                    loading: '数据加载中，请稍候...'            
                },
                chart: {
                    borderWidth: 0,
    //                marginBottom: 65,
    //                marginTop: 50,
      //              marginRight: 20, 
    //                zoomType: 'x',
                    selectionMarkerFill : 'rgba(122, 201, 67, 0.25)',
                    style:{
                        fontFamily: 'Tahoma, "microsoft yahei", 微软雅黑, 宋体;'
                    },
                    resetZoomButton: {
                        theme: {
                            fill: 'white',
                            stroke: 'silver',
                            r: 0,
                            states: {
                                hover: {
                                    fill: '#41739D',
                                    style: {
                                        color: 'white'
                                    }
                                }
                            }
                        }
                    }
                },
                xAxis: {
                    startOnTick: false,
                    lineColor: '#6a7791',
                    lineWidth: 1,
    //                minorTickinterval: 1,
                    tickPixelInterval: 150,
                    tickmarkPlacement: 'on',
                    showLastLabel: true,
                    endOnTick: true
                },
                yAxis: {
                    title: {
                        text: ''       
                    },
                    min: 0,
                    gridLineColor: '#eae9e9',
                    showFirstLabel: false
                },
                plotOptions: {
                    pie: {
                        allowPointSelect: true,
                        innerSize: '45%',
                        cursor: 'pointer',
                        dataLabels: {
                            enabled: false,
                            color: '#000000',
                            connectorColor: '#000000'
                        }
                    },
                    series: {
                        pointPalcement: 'on',
                        fillOpacity: 0.1,
                        shadow: false,
                        dataLabels: {
                            enabled: true 
                        },
                        marker: {
                            enabled: true,
                            radius: 4,
                            fillColor: null,
                            lineWidth: 2,
                            lineColor: '#FFFFFF',
                            states: {
                                hover: {
                                    enabled: true
                                }
                            }
                        }
                    }             
                },
                legend: {
                    borderWidth: 0,
    //                y: 5,
                    verticalAlign: 'bottom',
        //            floating: true,
                    maxHeight: 57 
//                    symbolWidth: 12 
    //                align: 'left'
                },
                tooltip: {                
                    borderColor: '#666',
                    borderWidth: 1,
                    borderRadius: 2,
                    backgroundColor: 'rgba(255, 255, 255, 0.7)',
                    useHTML: true,
                    crosshairs: {
                        color: '#7ac943',
                        dashStyle: 'shortdot'
                    },
                    shared: true
                },
                credits: {
                    enabled: false,
                    href: 'http://ta.qq.com',
                    text: 'ta.qq.com',
                    position: {
                        align: 'right',
                        x: -10,
                        verticalAlign: 'bottom',
                        y: 0
                    }     
                }             
            }

            if (theme == 'wechat'){
                //微信公众平台样式
                var wechatOptions = {
                    colors: ['#7FAEDF', '#7FB887', '#EBCB6B', '#BB7FB2','#DA7D2A'],
                    //colors: ['#478ED7','#4CA458','#EDB638','#5A4B96','#DA7D2A'],
                    chart: {
                        backgroundColor: '#fff'
                    },
                plotOptions: {
                    series: {
                        fillOpacity: 0.1
                    }             
                },
                    xAxis: {
                        lineColor: '#8D8988',
                        lineWidth: 2
                    },
                    yAxis: {
                        gridLineColor: '#D1D1D1'
                    },
                    tooltip: {                
                        borderColor: '#3C3C3C',
                        backgroundColor: '#525254',
                        style: {
                            color: '#FFFFFF'
                        }
                    },
                    legend:{
                        symbolWidth: 12 
                    }
                };

                defOptions = $.extend(true, defOptions, wechatOptions);
            }
            
            Highcharts.setOptions(defOptions);
        }

        //格式化数据
        function formatValue(dataFormat, value){

            dataFormat = parseInt(dataFormat);
            switch(dataFormat){
                case 1:
                    value =  Highcharts.numberFormat(value, 0);
                    break;
                case 2:
                    value =  Highcharts.numberFormat(value, 2);
                    break;
                case 3:
                    value =  Highcharts.numberFormat(value, 2);
                    break;
                case 4:
                    var toTimeDesc = function(t){
                        var h = parseInt(t / 3600);
                        var m = '00' + parseInt((t % 3600) / 60);
                        var s = '00' + parseInt(t % 3600 % 60);
                        m = m.substr(m.length - 2, 2);
                        s = s.substr(s.length - 2, 2);

                        return h + ':' + m + ':' + s;
                    };

                    value = toTimeDesc(value);                      //处理时间格式为时分秒格式H:mm:ss
                    break;
                case 5:
                    value =  Highcharts.numberFormat(value * 100, 2);
                    break;

                case 7:
                    if(value >= 1 || value <= -1){
                        value = Highcharts.numberFormat(value, 0);
                    }else{
                        value = Highcharts.numberFormat(value, 2);
                    }
                    break;
                case 8:
                    if (value >= 1024 && value < 1024*1024) {
                        value = (value/1024).toFixed(2)+'MB';
                    }else if (value > 1024*1024) {
                        value = (value/(1024*1024)).toFixed(2)+'GB';
                    }else {
                        value = value + 'KB';
                    }
                    break;
            }

            return value;
        }

        /*
         * 自动计算Y轴间距,算法如下:
         * 1. 计算平均间距, (maxY - minY) / 最大刻度数, 
         * 2. 规范化平均间距, 1). 当间距是100量级,规范化为10, 50, 100
         *                    2). 间距规范化为, 100, 200, ... 900, (1000量级)
         *                                      1000, 2000, ... 9000 (1W量级)
         */
        function autoYAxisInterval(){
            
            //当用户点击图例隐藏某一数列时，会导致Y轴重画（即会重新调整Y轴范围），由于无法响应该事件，因此暂时屏蔽本功能
            return;
            
            if (maxY == 0){
                mainYAxis.max = 100;   //如果所有数据为0，则固定Y轴最大为100
                return;
            }
            //堆叠图不处理自动间距
            if (cOptions.chart.type == 'column' && cOptions.plotOptions.column && cOptions.plotOptions.column.stacking){
                return;
            }

            var interval = parseInt((maxY - minY) / options.maxYAxisIntervalCount);
            var yAxis = mainYAxis;
            var maxVal = 10;

            while (interval > maxVal){
                maxVal *= 10;
            }

            if (maxVal >= 1000){
                for(var i = 1; i <= 10; i++){
                    if (interval < i * maxVal / 10){
                        interval = parseInt((i - 1) * maxVal / 10);
                        break;
                    }
                }
            }else{
                //如果间距是100量级,规范化为10, 50, 100
                if (interval < maxVal * 1 / 4){
                    interval = maxVal / 10;
                }else if (interval < maxVal * 3 / 4){
                    interval = maxVal / 2;
                }else{
                    interval = maxVal;
                }
            }


            yAxis.allowDecimals = false;
            yAxis.tickInterval = interval;
        }

    function isNotPieChart(){
        return cOptions.chart.type !== 'pie';
    }

    function isDate(obj){
        var d = new Date(obj);
        return !isNaN(d);
    }

    function isValidDate(strDate)   
    {   
        var sDate = strDate.replace(/(^\s+|\s+$)/g,''); //去两边空格;   
        if(sDate==''){
            return false;   
        }

        var s = sDate.replace(/[\d]{4,4}[\-/]{1}[\d]{1,2}[\-/]{1}[\d]{1,2}/g, '');   
        if (s == '')    
        {   
            var t=new Date(sDate.replace(/\-/g,'/'));   
            var ar = sDate.split(/[-/:]/);   
            if(ar[0] == t.getFullYear() && ar[1] == t.getMonth() + 1 && ar[2] == t.getDate())   
            {   
                return true;   
            }   
        }   

        return false;   
    }

        function convertToDate(strDate)
        {
            var sDate = strDate.replace(/(^\s+|\s+$)/g,''); //去两边空格;
            if(sDate==''){
                return null;
            }

            var s = sDate.replace(/[\d]{4,4}[\-/]{1}[\d]{1,2}[\-/]{1}[\d]{1,2}/g, '');
            if (s == '')
            {
                var t=new Date(sDate.replace(/\-/g,'/'));
                var ar = sDate.split(/[-/:]/);
                if(ar[0] == t.getFullYear() && ar[1] == t.getMonth() + 1 && ar[2] == t.getDate())
                {
                    return t;
                }
            }

            return null;
        }

    function toDateDesc(obj){
        var d = new Date(obj);
        var result = isNaN(d) ? obj : d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
        return result;
    }
    
    //取主Y轴，当有多个Y轴时，取第一个为主轴
    function getMainYAxis(){
        return $.isArray(cOptions.yAxis)? cOptions.yAxis[0]: cOptions.yAxis;
    }

    //转换成highcharts可以识别的categories
    function toHighChartCategories(categories){
        var hcCagetories = [];
        for(var c in categories){
           hcCagetories.push(categories[c]); 
        }

        return hcCagetories;
    }

    //转换成highcharts可以识别的数列
    function toHighChartSeries(series){
        var hcSeries = [];
        var hcSer;

        if ($.isArray(series)){
            for(var i in series){
                var ser = series[i];
                hcSer = toSeriesItem(ser);
                hcSeries.push(hcSer);
            }
        }
        else{
            hcSer = toSeriesItem(series);
            hcSeries.push(hcSer);
        }

        return hcSeries;
    }

    //转换一个数列
    function toSeriesItem(ser){
        if (!ser){
            return {name: ' ', data: []};
        }
        var hcSer = {
            name: ser.name || '',
            data: []
        };
        hcSer = $.extend(true, hcSer, ser);
        hcSer.data = [];
        
        var serData = ser.data || [];
        var hcData = [];

        var counter = 0;
        var sumY = 0;
        for (var j in serData){
            var point = serData[j];
            var hcPoint;
//            if (point > 0){
                hcPoint = point;
 /*           }
            else{
                hcPoint = {
                    name: point.name || '',
                    y: point.y || point[0] || null,
                    color: point.color || null
                };
            } 
*/
            isNotPieChart() && (hcPoint.marker = hcPoint.marker || {}, typeof(hcPoint.marker.enabled) == 'undefined' && (hcPoint.marker.enabled = false));
            hcPoint.y != null && (hasData = true, counter++, maxY = maxY > hcPoint.y? maxY : hcPoint.y, sumY += hcPoint.y);
            hcData.push(hcPoint);
        }

        for(var i in hcData){
            var point = hcData[i];
            if (point.y != null){
                isNotPieChart() && (point.marker.enabled = counter <= 7);
                point.percentage = Math.round(parseFloat(point.y * 10000) / sumY) / 100;
            }
        }

        hcSer.data = hcData;
        hcSer.showInLegend = cOptions.legend.enabled;
        return hcSer;
    }

    //画出中位线
    function drawPlotLine(){

        if (minY >= maxY){
            return;
        }

        midY = (maxY - minY) / 2;
        mainYAxis.plotLines = [{dashStyle: 'longdashdot', color: 'red', width: 1, value: midY, label:{text:'中位线'}}];
    } 

    };

})(jQuery);

