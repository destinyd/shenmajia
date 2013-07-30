function geo_bind_selector(myGeo, selector, lat_selector, lon_selector, e ){
  e = typeof e !== 'undefined' ? e : 'blur';
  $(selector).on(e, function(){
    // 将地址解析结果显示在地图上,并调整地图视野
    myGeo.getPoint($(this).val(), function(point){
      if (point) {
        $(lat_selector).val(point.lat);
        $(lon_selector).val(point.lng);
      }
    });

  })
}

function locate (map, geolocation, lat_selector, lon_selector) {
  var lat = $(lat_selector);
  var lon = $(lon_selector);
  if(lat.val()=='' || lon.val()==''){
    geolocation.getCurrentPosition(function(r){
      if(this.getStatus() == BMAP_STATUS_SUCCESS){
        lat.val(r.point.lat);
        lon.val(r.point.lng);
        map.centerAndZoom(r.point, 15);
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
      $(lat_selector).val(pp.lat);
      $(lon_selector).val(pp.lng);
      map.clearOverlays();
      map.centerAndZoom(pp, 18);
      var myIcon = new BMap.Icon("/assets/map/marker_red_sprite.png", new BMap.Size(39,25));
      map.addOverlay(new BMap.Marker(pp, {icon: myIcon}));

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
    var local = new BMap.LocalSearch(map, { //智能搜索
      onSearchComplete: myFun
    });
    local.search(myValue);
  }

}
