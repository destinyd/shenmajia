// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.purr
//= require jquery.lightbox-0.5.min
//= require jquery_nested_form
//= require kindeditor
//= require_tree .
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

function form_map_init(){
      var mapOptions = {
        center: new google.maps.LatLng(lat, lon),
        zoom: 12,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      var map = new google.maps.Map(document.getElementById('google_map'), mapOptions);

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
    function show_map_init() {
      var mapOptions = {
        center: new google.maps.LatLng(lat, lon),
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP
      };
      var map = new google.maps.Map(document.getElementById('google_map'), mapOptions);

      var infowindow = new google.maps.InfoWindow();
      var marker = new google.maps.Marker({
        map: map
      });
      marker.setPosition(new google.maps.LatLng(lat, lon));

    }

function change_bill_val(id,name,val){
  $.post(
    '/carts/'+id, name + '=' +val + '&_method=PUT'
    );
}

function change_shop_bill_val(shop_id,id,name,val){
  $.post(
    '/shops/' + shop_id + '/shop_carts/'+id, name + '=' +val + '&_method=PUT'
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
})
