$(function(){
  $('.ajax_paginate').ajax_paginate();
})

var search_page = 1;
var search_timeout = null;
function good_query_onkeyup(){
  clear_search();
  init_search_page();
  search_timeout = setTimeout(function(){search_goods(1)},1000);
}

function start_search_goods(){
  init_search_page();
  search_goods(1);
  return false;
}

function search_goods(page){
  $('#results').html('读取中...');
  var query = $('#good_query').val();
  var children = '';
  var child = '';
  var has_next = false;
  $.getJSON('/goods/search.json?q='+query + '&page=' + page.toString(), function(data){
    try{
      has_next = data['has_next'];
      if(data['results'].length > 0){
        $.each(data['results'],function(key,hash){
          h = hash;
          child = '<div class="good"><a href="javascript:void(0)" onclick="add_good(\''+ hash._id +'\',\'' + hash.name + '\')">' + hash.name + '(' + hash.norm + '/' + hash.unit + ') ' + hash.barcode + '</a><div class="pull-right"><button class="btn btn-primary" onclick="add_good(\''+ hash._id +'\',\'' + hash.name + '\')">选择</button></div></div><div class="clearfix"></div>';
        children += child;
        });
      }
      else{
        children = '找不到相关商品。';
      }
    }catch(ex){
        children = '找不到相关商品。';
    }
    $('#results').html(children);
    render_search_paginate(search_page, has_next);
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
  var html = '<tr id="' + id + '" class="goods_selected"><td class="image"><input id="bill_bill_prices_attributes_' + t + '_image" name="bill[bill_prices_attributes][' + t + '][image]" type="file" /></td>  <td class="name"><input id="bill_bill_prices_attributes_' + t + '_name" name="bill[bill_prices_attributes][' + t + '][name]" value="' + name + '" disabled="disabled" size="30" type="text" /><input id="bill_bill_prices_attributes_' + t + '_good_id" name="bill[bill_prices_attributes][' + t + '][good_id]" type="hidden" value="' + id + '" /></td><td class="price"><input id="bill_bill_prices_attributes_' + t + '_price_value" name="bill[bill_prices_attributes][' + t + '][price_value]" size="30" type="text" /></td><td class="amount"> <input id="bill_bill_prices_attributes_' + t + '_amount" name="bill[bill_prices_attributes][' + t + '][amount]" size="30" type="text" value="1.0" /></td><td class="total"></td><td><input id="bill_bill_prices_attributes_' + t + '__destroy" name="bill[bill_prices_attributes][' + t + '][_destroy]" type="hidden" /><a href="#'+ id + '" onclick="remove_good(\'' + id + '\')">X</a></td></tr>';
  if($('#tbody ' + id).length == 0){
    $('#tbody').prepend(html);
    $('#good_query').val('');
    $('#results').html('');
    $('#modalGoodSearch').modal('hide')
  }
  else{
    alter('你已添加此商品。');
  }
}

function remove_good (id) {
  $('#' + id).remove();
  delete goods[id];
  goods_total(goods);
}

function bind_new_good (btn_selector) {
  $(btn_selector).click(function(){
    $('#modalNewGood').modal('show');
  })
}

function format_number(pnumber,decimals){
  if (isNaN(pnumber)) { return 0};
  if (pnumber=='') { return 0};

  var snum = new String(pnumber);
  var sec = snum.split('.');
  var whole = parseFloat(sec[0]);
  var result = '';

  if(sec.length > 1){
    var dec = new String(sec[1]);
    dec = String(parseFloat(sec[1])/Math.pow(10,(dec.length - decimals)));
    dec = String(whole + Math.round(parseFloat(dec))/Math.pow(10,decimals));
    var dot = dec.indexOf('.');
    if(dot == -1){
      dec += '.';
      dot = dec.indexOf('.');
    }
    while(dec.length <= dot + decimals) { dec += '0'; }
    result = dec;
  } else{
    var dot;
    var dec = new String(whole);
    dec += '.';
    dot = dec.indexOf('.');    
    while(dec.length <= dot + decimals) { dec += '0'; }
    result = dec;
  }  
  return result;
}

function goods_total (goods) {
  all_total = 0.0;
  $.each(goods,function(key,val){
    all_total += val;
  })
  var str_all_total = format_number(all_total, 2);
  $('#origin_total').html(str_all_total);
  $('#bill_total,#bill_cost').val(str_all_total);
}

function render_search_paginate(page, has_next){
  var paginate = $('#results_paginate');
  var prev = paginate.find('.previous');
  var next = paginate.find('.next');
  console.log(page > 1);
  (page > 1) ? prev.show() : prev.hide();
  has_next ? next.show() : next.hide();
  $('#results_paginate').show();
}

function  render_search_prev_page(){
  clear_search();
  if(search_page < 1)
    search_page = 1
  else
    search_page -= 1;
  search_goods(search_page);
}

function  render_search_next_page(){
  clear_search();
  if(search_page < 1)
    search_page = 1;
  search_page += 1;
  search_goods(search_page);
}

function init_search_page(){
  search_page = 1;
}
