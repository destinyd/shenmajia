// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require bootstrap
// require jquery.purr
//= require humane
//= require jquery.lightbox-0.5.min
// require cocoon
// require rails.validations
// require rails.validations.simple_form
// require jquery.autocomplete
// require jquery.smart_autocomplete
//= require_tree .
humane.timeout = 5000;
humane.alter = humane.spawn({ addnCls: 'humane-libnotify-info', clickToClose: true, waitForMove: true})
humane.success = humane.spawn({ addnCls: 'humane-boldlight-success'})
humane.error = humane.spawn({ addnCls: 'humane-boldlight-error'})

function show_and_hide(show,hide){
  $(hide).hide();
  $(show).show();
  return false;
}
function ajaxForm(formdom,action){
      if(action == "get")
        formdom.submit(function () {
          $.get(this.action, $(this).serialize(), null, 'script');
          return false;
        });
      else
        formdom.submit(function () {
          $.post(this.action, $(this).serialize(), null, 'script');
          return false;
        });

}
function send_review(selector){
  $(selector).submit();
  $(selector + ' select').attr('disable',true);
}

function get_attrs(id){
  $.getJSON('/goods/'+id+'/attrs', function(data) {
    var items = [];
    $.each(data, function(key, val) {
        items.push('<li id="attr_' + key + '" title="查看更多'+key+'信息"><a href="/goods/' + id + '/attrs/' + key +'" data-remote="true">' + key +'</a>:' + val + '</li>');
    });
    $('#attrs').html(items.join(''));
    $('#a_attrs').attr('onclick','');
    $('#a_attrs').click(function(){
      show_and_hide('.product_attrs','.goods_div')
    });
  });
}

function remove_fields(link) {
    $(link).prev("input[type=hidden]").value = "1";
    $(link).parent().hide();
}
function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).up().insert({
      before: content.replace(regexp, new_id)
    });
}
function toggle_cheap_price(obj){
  if($(obj).attr('checked'))
  {
    $('#div_original_price').show();
  }
  else
  {
    $('#div_original_price').hide();
    $('#original_price').val('');
  }
}
function onchange_type_id(obj){
  var val = parseInt($(obj).val());
  if(val > 1)// && val < 11)
  {
    $('#span_is_cheap_price').hide();
    $('#div_original_price').hide();
    $('#is_cheap_price').attr('checked',false)
    //$('#original_price').val('');
  }
  else
  {
    $('#span_is_cheap_price').show();
  }
}
function price_on_blur(){
  var price = parseFloat($('#price_price').val());
  var amount = parseFloat($('#price_amount').val());
  var total = parseFloat($('#price_total').val());
  if(isNaN(price) && amount && total)
  {
    $('#price_price').val(total / amount);
  }
  if(price && isNaN(amount) && total)
  {
    $('#price_amount').val(total / price);
  }
  if(price  && amount && isNaN(total))
  {
    $('#price_total').val(price * amount);
  }
}

markers = [];
markers_hash = {};
InfoWindows = [];
map = null;
function form_map_init(){
      var mapOptions = {
        center: new google.maps.LatLng(lat, lon),
        zoom: 12,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      map = new google.maps.Map(document.getElementById('google_map'), mapOptions);

      var input = document.getElementById('form_address');
      if(input){
        var autocomplete = new google.maps.places.Autocomplete(input);

        autocomplete.bindTo('bounds', map);
      }

      var infowindow = new google.maps.InfoWindow();
      var marker = new google.maps.Marker({
        map: map
          
      });
      //var geocoder;
      //geocoder = new google.maps.Geocoder();
      google.maps.event.addDomListener(map, 'click', 
      function(a){
        marker.setPosition(a.latLng);
        $('#form_lat').val(a.latLng.lat());
        $('#form_lon').val(a.latLng.lng());
        //geocoder.geocode({'latLng': a.latLng}, function(results, status) {
        //  if (status == google.maps.GeocoderStatus.OK) {
        //    if (results[1]) {
        //      $('#form_address').val(results[1].formatted_address)
        //    }
        //  }
        //});
      });

      if(input){
        google.maps.event.addListener(autocomplete, 'place_changed', function() {
          infowindow.close();
          place = autocomplete.getPlace();
          aaa = place;
          if (place.geometry.viewport) {
            map.fitBounds(place.geometry.viewport);
          } else {
            map.setCenter(place.geometry.location);
            map.setZoom(17);  // Why 17? Because it looks good.
          }
          marker.setPosition(place.geometry.location);
          $('#form_lat').val(place.geometry.location.lat());
          $('#form_lon').val(place.geometry.location.lng());

          var address = '';
          if (place.address_components) {
            address = [
              (place.address_components[0] &&
               place.address_components[0].short_name || ''),
              (place.address_components[1] &&
               place.address_components[1].short_name || ''),
              (place.address_components[2] &&
               place.address_components[2].short_name || '')].join(' ');
          }

          infowindow.setContent('<div><b>' + place.name + '</b><br>' + address);
          infowindow.open(map, marker);
        });
      }
}

function form_map_init_marker(){
      var infowindow = new google.maps.InfoWindow();
      var marker = new google.maps.Marker({
        map: map
      });
      marker.setPosition(new google.maps.LatLng(lat, lon));
      
}
    function show_map_init() {
      var mapOptions = {
        center: pos,
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      var map = new google.maps.Map(document.getElementById('google_map'), mapOptions);

      var infowindow = new google.maps.InfoWindow();
      var marker = new google.maps.Marker({
        map: map
      });
      marker.setPosition(pos);

    }

    function show_map_init() {
      var mapOptions = {
        center: pos,
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      var map = new google.maps.Map(document.getElementById('google_map'), mapOptions);

      var infowindow = new google.maps.InfoWindow();
      var marker = new google.maps.Marker({
        map: map
      });
      marker.setPosition(pos);

    }

function index_map_init() {

  var mapOptions = {
    center: poses[0]['pos'],
    zoom: 14,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById('google_map'), mapOptions);

}

function put_markers_with_word(){
  $.each(poses,function(i,pos){
    var contentString = '<h1>' + pos['title'] + '</h1><a href="/places/' + pos['id'] +'" target="_blank">查看详情</a>';
    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });
    var str = String.fromCharCode('a'.charCodeAt() + i);
    InfoWindows.push(infowindow);
    var marker =  new google.maps.Marker({
      position: pos['pos'],
        map: map,
        title: pos['title'],
        icon: '/images/google/' + str +'.png',
        animation: google.maps.Animation.DROP
    });
    google.maps.event.addListener(marker, 'click', function() {
      $.each(InfoWindows,function(i,win){
        win.close(map);
      }
      );
      infowindow.open(map,marker);
    });
    markers.push(marker);
  }
  );
}

function clear_markers(markers,new_markers){
  var is_has;
  $.each(markers,function(i,m){
    is_has = false;
    $.each(new_markers,function(j,nm)
    {
      if(m.getPosition() == nm.getPosition())
      {
        is_has = true;
      }
    });
    if(!is_has){
      m.setMap(null);
    }
  });
}

function add_markers(markers,new_markers){
  var is_has;
  $.each(new_markers,function(i,nm){
    is_has = false;
    $.each(markers,function(j,m)
    {
      if(m.getPosition() == nm.getPosition())
      {
        is_has = true;
      }
    });
    if(!is_has)
    {
      nm.setMap(map);
    }
  });
}


function put_markers(){
  var new_markers = [];
  $.each(poses,function(i,pos){
    if(markers_hash[pos['id']])
    {
      new_markers.push(markers_hash[pos['id']]);
    }
    else{
      var contentString = '<h1>' + pos['title'] + '</h1>'+ 
    '<p><a href="/places/' + pos['id'] +'" target="_blank">查看详情</a><p>'+
    '<p><a href="/places/' + pos['id'] +'/bills/new"><span class="c3">在此地记账</span></a><p>';
      var infowindow = new google.maps.InfoWindow({
          content: contentString
      });
      var str = String.fromCharCode('a'.charCodeAt() + i);
      InfoWindows.push(infowindow);
      var marker =  new google.maps.Marker({
        position: pos['pos'],
          //map: map,
          title: pos['title'],
          animation: google.maps.Animation.DROP
      });
      google.maps.event.addListener(marker, 'click', function() {
        $.each(InfoWindows,function(i,win){
          win.close(map);
        }
        );
        infowindow.open(map,marker);
      });
      markers_hash[pos['id']] = marker;
      new_markers.push(marker);
    }
  }
  );
  if(markers.length > 0)
  {
    clear_markers(markers,new_markers);
  }
  add_markers(markers,new_markers);
  markers = new_markers;
}
// Sets the map on all markers in the array.
function setAllMap(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}

// Removes the overlays from the map, but keeps them in the array.
function clearOverlays() {
  setAllMap(null);
  markers = [];
}


function change_bill_val(place_id,id,name,val){
  $.post(
    '/places/' + place_id + '/carts/'+id, name + '=' +val + '&_method=PUT'
    );
}

function change_order_val(id,name,val){
  var p = {'_method':'PUT'};
  p[name] = val;
  $.post(
    '/shop_carts/'+id, 
    p
  );
}
$.fn.extend({
  'form_wait':function(){
    $(this).find("input[type=submit]").attr('disabled',true);//.val('请等待')
    $('#loading').show();
  },
  'form_ready':function(){
    $(this).find("input[type=submit]").attr('disabled',false);
    $('#loading').hide();
  }
});
$.fn.spin = function(opts) {
  this.each(function() {
    var $this = $(this),
        data = $this.data();

    if (data.spinner) {
      data.spinner.stop();
      delete data.spinner;
    }
    if (opts !== false) {
      data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
    }
  });
  return this;
};
$.fn.ajax_paginate = function() {
  var pagination_a = $(this).find('.pagination a');
  pagination_a.attr('data-remote', 'true');
  pagination_a.bind('ajax:beforeSend',function(){$('#loading').show()}).bind('ajax:complete',function(){$('#loading').hide()});
}
$(function(){
  ajaxForm($('#new_comment'));
  $('#loading').spin();
  $('body').UItoTop();
})
