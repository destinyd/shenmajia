function geo_bind_selector(myGeo, selector, lat_selector, lon_selector, e ){
  e = typeof e !== 'undefined' ? e : 'blur';
  $(selector).on(e, function(){
    // 将地址解析结果显示在地图上,并调整地图视野
    myGeo.getPoint($(this).val(), function(point){
      set_bill_location(point, lat_selector, lon_selector);
    });

  })
}

function locate (map, geolocation, lat_selector, lon_selector, btn_selector, tab_selector) {
  var lat = $(lat_selector);
  var lon = $(lon_selector);
  if(lat.val()=='' || lon.val()==''){
    geolocation.getCurrentPosition(function(r){
      if(this.getStatus() == BMAP_STATUS_SUCCESS){
        lat.val(r.point.lat);
        lon.val(r.point.lng);
        map.centerAndZoom(r.point, 15);
        map.clearOverlays();
        set_bill_marker(map, r.point, lat_selector, lon_selector);
        enable_bill_next_btn(btn_selector, tab_selector);
      }
    },{enableHighAccuracy: true})
  }
}

function suggestion_bind_selector (map, text_id, lat_selector, lon_selector, btn_selector, tab_selector) {
  var ac = new BMap.Autocomplete(    //建立一个自动完成的对象
      {"input" : text_id
        ,"location" : map
      });

  ac.addEventListener("onhighlight", function(e) {  //鼠标放在下拉列表上的事件
    var _value = e.fromitem.value;
    var value = "";
    if (e.fromitem.index > -1) {
      value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
    }    

    value = "";
    if (e.toitem.index > -1) {
      _value = e.toitem.value;
      value = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;
    }    
  });


  var myValue;
  ac.addEventListener("onconfirm", function(e) {    //鼠标点击下拉列表后的事件
    var _value = e.item.value;
    myValue = _value.province +  _value.city +  _value.district +  _value.street +  _value.business;

    setPlace();
  });

  function setPlace(){
    function myFun(){
      var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
      set_bill_location(pp, lat_selector, lon_selector);
      map.clearOverlays();
      map.centerAndZoom(pp, 18);
      set_bill_marker(map, pp, lat_selector, lon_selector);

      enable_bill_next_btn(btn_selector, tab_selector);

    }
    var local = new BMap.LocalSearch(map, { //智能搜索
      onSearchComplete: myFun
    });
    local.search(myValue);
  }

}

function enable_bill_next_btn (btn_selector, tab_selector) {
  if(typeof btn_selector !== 'undefined' && typeof tab_selector !== 'undefined'){
    var btn = $(btn_selector);
    var tab = $(tab_selector);
    btn.removeClass('btn-info').addClass('btn-primary');
    btn.html('下一步');
    tab.attr('href','#tab2');
    tab.attr('data-toggle','tab');
    tab.parent().removeClass('disabled');
    btn.click(function(){
      tab.click();
      return false;
    })
    btn.attr('disabled', false);
  }
}

function set_bill_marker (map, point, lat_selector, lon_selector) {
  var myIcon = new BMap.Icon("/assets/map/marker_red_sprite.png", new BMap.Size(39,25));
  var marker = new BMap.Marker(point, {icon: myIcon, enableDragging: true});
  marker.addEventListener("dragend", function showInfo(){
   var cp = marker.getPosition();
   set_bill_location(cp, lat_selector, lon_selector);
  });
  map.addOverlay(marker);
}

function set_bill_location (point, lat_selector, lon_selector) {
  if(point){
    $(lat_selector).val(point.lat);
    $(lon_selector).val(point.lng);
  }
}
