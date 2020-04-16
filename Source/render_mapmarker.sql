/*
 * 0integration Map Marker
 * Plug-in Type: Region
 * Summary: Google map marker cluster region plugin used to display location marker cluster on google map.
 *
 * ^^^ Contact information ^^^
 * Developed by 0integration
 * http://www.zerointegration.com
 * apex@zerointegration.com
 *
 * ^^^ License ^^^
 * Licensed Under: GNU General Public License, version 3 (GPL-3.0) -
http://www.opensource.org/licenses/gpl-3.0.html
 *
 * @author Kartik Patel - kartik.patel@zerointegration.com
 */
 
FUNCTION RENDER_MAPMARKER 
   (p_region IN APEX_PLUGIN.t_region
    ,p_plugin IN APEX_PLUGIN.t_plugin
    ,p_is_printer_friendly IN BOOLEAN
    ) RETURN APEX_PLUGIN.t_region_render_result IS

    SUBTYPE plugin_attr is VARCHAR2(32767);
    
    l_result APEX_PLUGIN.t_region_render_result;
    l_column_value_list  APEX_PLUGIN_UTIL.t_column_value_list;
    
    l_region VARCHAR2(100);
    
    V_MAP_WIDTH NUMBER;
    V_MAP_HEIGHT NUMBER;
    V_DYNAMIC_WIDTH VARCHAR2(10);
    V_NO_DATA VARCHAR2(1000);
    V_API_KEY P_PLUGIN.ATTRIBUTE_01%TYPE;
    
    l_lat    NUMBER;
    l_lng    NUMBER;
    l_info   varchar2(500);
    V_LOC_DATA CLOB;
    l_script varchar2(500);
    
BEGIN
    -- Debug information (if app is being run in debug mode)
    IF apex_application.g_debug THEN
      APEX_PLUGIN_UTIL.debug_region
          (p_plugin => p_plugin
          ,p_region => p_region
          ,p_is_printer_friendly => p_is_printer_friendly);
    END IF;

    -- Application Plugin Attributes
    V_API_KEY := P_PLUGIN.ATTRIBUTE_01;
    
    -- Component Plugin Attributes
    V_DYNAMIC_WIDTH := P_REGION.ATTRIBUTE_01;
    V_MAP_WIDTH := P_REGION.ATTRIBUTE_02;
    V_MAP_HEIGHT := P_REGION.ATTRIBUTE_03;
    
    V_NO_DATA := P_REGION.NO_DATA_FOUND_MESSAGE;
    
    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => '//maps.googleapis.com/maps/api/js?key=' || V_API_KEY,
                            P_DIRECTORY => NULL,P_VERSION => NULL,P_SKIP_EXTENSION => TRUE);
                            
    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => 'markerclusterer', P_DIRECTORY => P_PLUGIN.FILE_PREFIX,P_VERSION => NULL,P_SKIP_EXTENSION => FALSE);
  
    APEX_JAVASCRIPT.ADD_LIBRARY(P_NAME => 'com.zerointegration.marker',P_DIRECTORY => P_PLUGIN.FILE_PREFIX,P_VERSION => NULL ,P_SKIP_EXTENSION => FALSE);
    
    l_region := CASE WHEN p_region.static_id IS NOT NULL
                          THEN p_region.static_id
                          ELSE 'R'||p_region.id END;
                          
    /*sys.htp.p('V_MAP_WIDTH='||V_MAP_WIDTH);
    sys.htp.p('V_MAP_HEIGHT='||V_MAP_HEIGHT);
    sys.htp.p('V_DYNAMIC_WIDTH='||V_DYNAMIC_WIDTH);
    sys.htp.p('V_API_KEY='||V_API_KEY);*/
    
    IF p_region.source IS NOT NULL THEN
      null;
    END IF;
    
    l_column_value_list := APEX_PLUGIN_UTIL.get_data
        (p_sql_statement  => p_region.source
        ,p_min_columns    => 3
        ,p_max_columns    => 3
        ,p_component_name => p_region.name
        ,p_max_rows       => p_region.fetched_rows);
        
    APEX_JSON.initialize_clob_output;
    APEX_JSON.open_object;
    APEX_JSON.open_array('loc');
    
    FOR i IN 1..l_column_value_list(1).count LOOP
      l_lat := TO_NUMBER(l_column_value_list(1)(i));
      l_lng := TO_NUMBER(l_column_value_list(2)(i));
      l_info:= l_column_value_list(3)(i);
      APEX_JSON.open_object;
      APEX_JSON.write('lat', l_lat);
      APEX_JSON.write('lng', l_lng);
      APEX_JSON.write('info', l_info);
      APEX_JSON.close_object;
    END LOOP;
    
    APEX_JSON.close_array;
    APEX_JSON.close_object;
    V_LOC_DATA := APEX_JSON.get_clob_output;
    APEX_JSON.free_output;
    
    l_script := '<script>var regionId = '''||l_region||''';</script>';
    sys.htp.p(l_script);
    sys.htp.p('<div id="map-canvas-'||l_region||'" style="width:'
                       || CASE WHEN V_DYNAMIC_WIDTH='Y' THEN '100%;' ELSE V_MAP_WIDTH|| 'px;' END ||' height:'
                       || V_MAP_HEIGHT
                       || 'px;"> </div>');
                       
    sys.htp.p('<div class="map-data-'||l_region||'" style="display: none;">'||V_LOC_DATA||'</div>');
    sys.htp.p('<div class="no-data-found-'||l_region||'" style="display: none;">'||V_NO_DATA||'</div>');
    
    RETURN l_result;
    
END RENDER_MAPMARKER;