if($(".flash-alert").show()) {
   setTimeout(function(){
     $(".flash-alert").hide("3000")
   }, 12500);
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
