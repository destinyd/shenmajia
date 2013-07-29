$(function(){
  $('.ajax_paginate').ajax_paginate();
})

var search_timeout = null;
function good_query_onkeyup(){
  $('#results').html('读取中...');
  clear_search();
  search_timeout = setTimeout(function(){search_goods()},1000);
}

function search_goods(){
  var query = $('#good_query').val();
  var children = '';
  var child = '';
  $.getJSON('/goods/search.json?q='+query, function(data){
    if(data.length > 0){
      $.each(data,function(key,hash){
        h = hash;
        child = '<div class="good"><h4><a href="javascript:void(0)" onclick="add_good(\''+ hash._id +'\',\'' + hash.name + '\')">' + hash.name + '(' + hash.unit + ')</a></h4>';
      children += child;
      });
    }
    else{
      children = '找不到相关商品。';
    }
    $('#results').html(children);
  });
}

function clear_search(){
  if(search_timeout != null){
    clearTimeout(search_timeout);
    search_timeout = null;
  }
}

function add_good(id,name){
  var t = Number(new Date());
  var html = '<tr id="good_' + id + '" class="goods_selected"><td class="image"><input id="bill_bill_prices_attributes_' + t + '_image" name="bill[bill_prices_attributes][' + t + '][image]" type="file" /></td>  <td class="name"><input id="bill_bill_prices_attributes_' + t + '_name" name="bill[bill_prices_attributes][' + t + '][name]" value="' + name + '" disabled="disabled" size="30" type="text" /><input id="bill_bill_prices_attributes_' + t + '_good_id" name="bill[bill_prices_attributes][' + t + '][good_id]" type="hidden" value="' + id + '" /></td><td class="price"><input id="bill_bill_prices_attributes_' + t + '_price_value" name="bill[bill_prices_attributes][' + t + '][price_value]" size="30" type="text" /></td><td class="amount"> <input id="bill_bill_prices_attributes_' + t + '_amount" name="bill[bill_prices_attributes][' + t + '][amount]" size="30" type="text" value="1.0" /></td><td class="total"></td><td><input id="bill_bill_prices_attributes_' + t + '__destroy" name="bill[bill_prices_attributes][' + t + '][_destroy]" type="hidden" /><a href="#" class="remove_fields dynamic">X</a></td></tr>';
  if($('#tbody good_' + id).length == 0){
    $('#tbody').prepend(html);
    $('#good_query').val('');
    $('#results').html('');
    $('#goodModal').modal('hide')
  }
  else{
    alter('你已添加此商品。');
  }
}

function bind_new_good (btn_selector) {
  $(btn_selector).click(function(){
    $('#modalNewGood').modal('show');
  })
}
