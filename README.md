# Map-Marker

Google map marker cluster region plugin used to display location marker cluster on google map..

**A Region plugin for Oracle Application Express**

This plugin allows you to display address marker on google map using marker cluster. 

![Preview.png](https://raw.githubusercontent.com/apex-plugins/Map-Marker/master/Source/Preview.png)

## DEMO ##

[https://apps.zerointegration.com/demo/f?p=apexplugins:mapmarker](https://apps.zerointegration.com/demo/f?p=apexplugins:mapmarker)

## PRE-REQUISITES ##

* You need a [Google Maps API Key](https://developers.google.com/maps/documentation/javascript/get-api-key#get-an-api-key)

## INSTALLATION ##

1. Download the [latest release](https://github.com/apex-plugins/Map-Marker/releases/latest)
2. Install the plugin to your application - **region_type_plugin_com_zerointegration_mapmarker.sql**
3. Supply your **Google API Key** (Component Settings)
4. Add a region to the page and use below SQL Query format to get data.

SELECT LATITUDE, LONGITUDE, ADDRESS FROM TABLE

For more info, refer to the [WIKI](https://github.com/apex-plugins/Map-Marker/wiki).
