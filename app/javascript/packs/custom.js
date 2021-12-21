if($(".flash-alert").show()) {
   setTimeout(function(){
     $(".flash-alert").hide("3000")
   }, 4000);
}

$(".add-category-fs").hide();
$(".link-to-add-fields").hide();
$(".add-category-toggle").on("click", () => {
  $(".add-category-fs").toggle("2000")
  $(".category-existed").toggle("1000")
  $(".category-name").val("")
});

$(".remove-fields").on("click", () => {
  $(".add-category-fs").hide("2000")
  $(".category-existed").show("1000")
  $(".category-name").val("")
})

$(".search-product-form").hide("2000");
$(".search-product").on("click", () => {
  $(".search-product-form").toggle("2000");
})
