function cost_form_on_blur(){
  var price = parseFloat($('#cost_unit_price').val());
  var amount = parseFloat($('#cost_amount').val());
  var total = parseFloat($('#cost_money').val());
  var place_name = $('#locatable_name').val();
  var good_name = $('#cost_name').val();
  var good_unit = $('#good_unit').val();
  if(isNaN(price) && amount && total)
  {
    $('#cost_unit_price').val(total / amount);
  }
  if(price && isNaN(amount) && total)
  {
    $('#cost_amount').val(total / price);
  }
  if(price  && amount && isNaN(total))
  {
    $('#cost_money').val(price * amount);
  }

  price = parseFloat($('#cost_unit_price').val());
  amount = parseFloat($('#cost_amount').val());
  total = parseFloat($('#cost_money').val());
  var str_desc = '在' + place_name + '购买' + good_name ;
  if( !isNaN(price) && !isNaN(amount) && !isNaN(total))
  {
    str_desc = str_desc +  '*' +amount.toString() + good_unit + ',花费' + total.toString() + '元'
  }
  $('#cost_desc').val(str_desc);
}

