   google.load('visualization', '1', {'packages': ['geomap']});
   google.setOnLoadCallback(drawMap);

    function drawMap() {
        var query = new google.visualization.Query('malware/top_country.json');
        query.send(handleQueryResponse);
    };

    function handleQueryResponse(response) {
        if (response.isError()) {
            alert('Error in query: ' + response.getMessage() + ' ' + response.getDetailedMessage());
            return;
        }

        var data = response.getDataTable();
        var options = {};
        options['colors'] = [0xFFDAB9, 0xFF0000, 0xDC143C];
		//options['colors'] = [0xFF8747, 0xFFB581, 0xc06000]; //orange colors
        //options['dataMode'] = 'markers';
        options['dataMode'] = 'regions';
        options['width'] = '940';
        options['height'] = '340';
        options['showLegend'] = true;

        var container = document.getElementById('map_canvas');
        var geomap = new google.visualization.GeoMap(container);
        geomap.draw(data, options);
    }


 

