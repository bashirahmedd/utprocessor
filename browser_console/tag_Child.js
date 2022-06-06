var a;
$('.faq__content').find('a').each(function(i, obj) { 
  a += ','; 
  a += $(obj).html();
  //console.log($(obj).html());
});
console.log(a);     