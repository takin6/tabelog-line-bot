// sticky header: https://www.w3schools.com/howto/howto_js_sticky_header.asp
// When the user scrolls the page, execute myFunction
window.onscroll = function() { 
  if ($("#laodMore").length > 0) {
    addOrRemoveSticky();
  }
};

window.onload = function(e) {
  var observer = window.lozad()
  observer.observe();

  authenticated = false
  if (liff._auth == null) {
    if (gon.current_user == null && !document.URL.includes("restaurant_data_sets/new?cache_id=")) {
      document.location.href="/search_restaurants/new";
    } else {
      console.log("liff not detected");
      authenticated = true
    }
  } else {
    authenticated = true
    liff.init(function (data) {
      initializeApp(data);
    });
  }

  initializeSession();
  changeSelectedRestaurantsCountText();
  changeSelectedSendRestaurantsCountText();

  $(".restaurant").hide();
  $(".restaurant").slice(0, 10).show();
  changeTotalHeight(0);
  $("#display-count").text(10)

  // color already selected restarrants
  getValuesFromSession("selectedRestaurantIds").forEach(function(restaurantId) {
    addColorToRestaurant($(`[value=${restaurantId}]`));
  })

  $(".rating-text").each(function() {
    addColorToRatingStars($(this));
  })

  isMobile=false
  if(/(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|ipad|iris|kindle|Android|Silk|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navigator.userAgent) 
      || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navigator.userAgent.substr(0,4))) { 
      isMobile = true;

    if ($(".r-data-set-detail-molecule-content.location").text().length > 14) {
      $(".r-data-set-detail-molecule-content.location").css("font-size", "12px")
    } else if ($(".r-data-set-detail-molecule-content.location").text().length > 11) {
      $(".r-data-set-detail-molecule-content.location").css("font-size", "14px")
    } else {
      $(".r-data-set-detail-molecule-content.location").css("font-size", "16px")
    }

    $('.line-btn-container').hide();
  }

  // if (isMobile) {
  //   if ($(".r-data-set-detail-component").length > 0) {
  //     val = $(".r-data-set-info").height() + $($(".r-data-set-detail-component")[3]).height();
  //     $(".r-data-set-info").height(val);
  //   }
  // } else {
  //   if ($(".r-data-set-detail-component").length > 0) {
  //     // val = $(".r-data-set-info").height() + $($(".r-data-set-detail-component")[3]).height();
  //     val = $(".r-data-set-detail-component.tags").height();
  //     $($(".r-data-set-detail")[1]).height(val+5);
  //   }
  // }

  if (authenticated == true) {
    $(".main").removeClass("is-hide");
    $(".loading").remove();
  }
}

// Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {
    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}

// $(window).on('load resize', function() { 
//   // change right position of user menu content
//   if (window.matchMedia('(min-width:640px)').matches) {
//     $(".user-menu-content").css("right", $(document).width() - ($('.user-menu').offset().left + $('.user-menu').width()));
//   }
// });

$('#selectMessageDestinationModal').on('shown.bs.modal',function(){      //correct here use 'shown.bs.modal' event which comes in bootstrap3
  // $(this).find('iframe').attr('src','http://www.google.com')
  var html = document.getElementsByTagName('html')[0];
  var remSize = parseInt(window.getComputedStyle(html)['fontSize']);

  var dom = $(this).find(".line-it-button");
  dom.outerHeight(2*remSize);
  dom.width(10*remSize);
})

// $(function(){
//   $('[type="submit"]').click(function(){
//     $(this).prop('disabled',true);//ボタンを無効化する
//     $(this).closest('form').submit();//フォームを送信する
//   });
// });

// ----------------- onclick event --------------------------------- //
var create_partial_or_all;
function onClickMakeFavListPartial(e) {
  if (getValuesFromSession('selectedRestaurantIds').length == 0) {
    e.preventDefault();
    e.stopPropagation();
  } else {
    create_partial_or_all = "partial";
  }
}
function onClickMakeFavListAll() {
  create_partial_or_all = "all";
}

function onClickSendToChatUnitMenu(e) {
  // e.preventDefault();
  e.stopPropagation();
  $('[name=message-type]').prop('required', true);
  $("#message-option-menu-user").removeClass("in");
  if ($("#message-option-menu-chat-unit").hasClass("in") == false) {
    $("#message-option-menu-chat-unit").addClass("in");
  }
}
function onClickSendToUserMenu(e) {
  // e.preventDefault();
  e.stopPropagation();
  $('[name=message-type]').prop('required', true);
  $("#message-option-menu-chat-unit").removeClass("in")
  if ($("#message-option-menu-user").hasClass("in") == false) {
    $("#message-option-menu-user").addClass("in");
  }
}
function onClickSendToOtherChatMenu() {
  $('[name=message-type]').prop('required', false);
  $("#message-option-menu-chat-unit").removeClass("in")
  $("#message-option-menu-user").removeClass("in")
}

function onClickRestaurant(e, sessionItemName) {
  if (e.currentTarget.style.backgroundColor != 'rgb(226, 226, 226)') {
    addColorToRestaurant($(e.currentTarget));
    setValuesToSession(sessionItemName, e.currentTarget.value);
  } else {
    unsetColorToRestaurant($(e.currentTarget));
    deleteValuesFromSession(sessionItemName, e.currentTarget.value);
  }

  $(".max-restaurants-alert").css("display", "none");
  changeSelectedRestaurantsCountText();
  changeSelectedSendRestaurantsCountText();
}

function onClickLoadMore(e) {
  e.preventDefault();

  showingRestaurants = $(".restaurant:hidden").slice(0, 10);
  showingRestaurants.slideDown();

  if($(".restaurant:hidden").length == 0) {
    $("#loadMore").text("No Content").addClass("noContent");
    // $("#display-count").text($(".restaurant:visible").length);
  }

  changeTotalHeight(showingRestaurants.length);
  $("#display-count").text($(".restaurant:visible").length);
}

function onClickClearCache() { clearCache(); }

/* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
function onClickUserMenu() {
  $(".user-menu-content").toggle();
}

function onClickRedirectUrl(e) {
  e.preventDefault();
  e.stopPropagation();
  window.open(e.target.href, '_blank');
}

function onClickSendTextButton(e) {
  e.preventDefault();
  e.stopPropagation();
  if ($(".send-rds").css("display") == "none") {
    // debugger;
    $(".send-rds").css("display", "flex");
    $("#loadMore").css("margin-bottom", "100px");
    $(".restaurant").prop("disabled", false);
    $(".send-select-icon").css("display", "unset");
    // color already selected restarrants
    getValuesFromSession("selectedSendRestaurantIds").forEach(function(restaurantId) {
      addColorToRestaurant($(`[value=${restaurantId}]`));
    })
  } else {
    $(".send-rds").css("display", "none");
    $("#loadMore").css("margin-bottom", "0");
    $(".restaurant").prop("disabled", true);
    $(".send-select-icon").css("display", "none");
    $(".restaurant").css("background-color", "#fff")
  }
}

var send_partial_or_all;
function onClickSendPartialButton(e) {
  if (getValuesFromSession('selectedSendRestaurantIds').length == 0) {
    e.preventDefault();
    e.stopPropagation();
  } else if (getValuesFromSession('selectedSendRestaurantIds').length > 15) {
    e.preventDefault();
    e.stopPropagation();
    $(".max-restaurants-alert").css("display", "unset")
  } else {
    send_partial_or_all = "partial";
  }
}
function onClickSendAllButton() {
  send_partial_or_all = "all";
}

// ----------------- ajax event --------------------------------- //
function onSubmitRestaurantDataSet(event) {
  event.preventDefault(); 

  if (create_partial_or_all == "partial") {
    selected_restaurant_ids = getValuesFromSession('selectedRestaurantIds');
  } else {
    selected_restaurant_ids = []
    $(".restaurant").each(function(index, restaurant) {selected_restaurant_ids.push(restaurant.value)})
  }

  $.ajax({
    type: 'POST',
    url: '/api/restaurant_data_sets',
    data: {
      restaurant_data_sets: {
        title: $("#restaurant-data-set-title").val(),
        mongo_custom_restaurants_id: window.location.href.split("cache_id=")[1],
        selected_restaurant_ids: selected_restaurant_ids
      }
    },
    success: function (res, status) {
      clearCache();
      window.location.href = `/restaurant_data_sets/${res.restaurant_data_set_id}/complete`;
      // window.alert('メッセージが送られました！ご確認下さい。');
      // liff.closeWindow();
    },
    error: function (res, status) {
      if (status == 505) {
        window.alert('invalid session: ' + res.status);
      } else {
        // alert(JSON.parse(res.responseText));
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
      }
    },
    complete: function(data) {}
  });
}

function onSubmitSendRestaurantDataSet(event) {
  event.preventDefault();

  destination_type = $('[name=destination]:checked').val();
  if (destination_type == undefined) {
    $(".select-destination-alert").css("display", "unset");
    return
  }

  if (destination_type != "custom_chat") {
    message_type = $('[name=message-type]:checked').val();
    if (message_type == undefined) {
      $(".select-message-type-alert").css("display", "unset");
      return
    }
  }

  if (send_partial_or_all == "partial") {
    selected_restaurant_ids = getValuesFromSession('selectedSendRestaurantIds');
  } else {
    selected_restaurant_ids = []
    $(".restaurant").each(function(index, restaurant) {selected_restaurant_ids.push(restaurant.value)})
  }

  if (destination_type == "custom_chat") {
    send_to_custom_chat(selected_restaurant_ids)
  } else {
    $('[type="submit"]').prop('disabled',true);
    send_to_chat_unit(destination_type, message_type, selected_restaurant_ids)
  }
}

function send_to_custom_chat(selected_restaurant_ids) {
  $.ajax({
    type: 'POST',
    url: '/api/restaurant_data_subsets/create_text',
    data: {
      send_message: {
        restaurant_data_set_id: $('[name=restaurant_data_set_id]').val(),
        selected_restaurant_ids: selected_restaurant_ids
      }
    },
    success: function (res, status) {
      // sessionStorage.setItem("mongo_custom_restaurants", JSON.stringify(res.mongo_custom_restaurants))
      var url = encodeURI('http://line.me/R/msg/text/?' + res.message_text + '&from=line_scheme');
      window.open(url, "_blank")
      // liff.closeWindow();
    },
    error: function (res, status) {
      if (status == 505) {
        window.alert('invalid session: ' + res.status);
      } else {
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
      }
    },
    complete: function(data) {}
  }); 
}

function send_to_chat_unit(destination_type, message_type, selected_restaurant_ids) {
  $.ajax({
    type: 'POST',
    url: '/api/line/send_message',
    timeout: 10000,
    data: {
      send_message: {
        restaurant_data_set_id: $('[name=restaurant_data_set_id]').val(),
        destination_type: destination_type,
        message_type: message_type,
        selected_restaurant_ids: selected_restaurant_ids
      }
    },
    success: function (res, status) {
      // sessionStorage.setItem("mongo_custom_restaurants", JSON.stringify(res.mongo_custom_restaurants))
      clearCache();
      window.location.href = `/restaurant_data_sets/sent_message`;
      // window.alert('メッセージが送られました！ご確認下さい。');
      // liff.closeWindow();
    },
    error: function (res, status) {
      if (status == 505) {
        window.alert('invalid session: ' + res.status);
      } else {
        // alert(JSON.parse(res.responseText));
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
      }
    },
    complete: function(data) {}
  });
}

function onSubmitDeleteRDS(e) {
  event.preventDefault();
  $('[type="submit"]').prop('disabled',true);
  $.ajax({
    type: 'DELETE',
    url: `/api/restaurant_data_sets/${$('[name=restaurant_data_set_id]').val()}`,
    success: function(res, status) {
      clearCache();
      window.location.href = '/restaurant_data_sets/deleted'
    },
    error: function (res, status) {
      if (status == 505) {
        window.alert('invalid session: ' + res.status);
      } else {
        // alert(JSON.parse(res.responseText));
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
      }
    },
    complete: function(data) {}
  })
}


// ----------------- DOM Setter --------------------------------- //
// jquery object
function addColorToRestaurant(element) {
  element.css("background-color", "#e2e2e2");
  element.find(".select-icon").css("color", "green");

  element.find(".send-select-icon").css("color", "green");
}
// jquery object
function unsetColorToRestaurant(element) {
  element.css("background-color", "white");
  element.find(".select-icon").css("color", "gray");

  element.find(".send-select-icon").css("color", "gray");
}
// jquery object
function changeSelectedRestaurantsCountText() {
  var sessionItemName = "selectedRestaurantIds";
  var itemLength = getValuesFromSession(sessionItemName).length;
  $(".selected-restaurants-count").text(itemLength);

  if (itemLength == 0) {
    $($(".make-fav-list")[0]).css("background-color", "silver");
    $($(".make-fav-list")[0]).css("border-color", "silver");
  } else {
    $($(".make-fav-list")[0]).css("background-color", "orange");
    $($(".make-fav-list")[0]).css("border-color", "orange");
  }
}

function changeSelectedSendRestaurantsCountText() {
  var sessionItemName = "selectedSendRestaurantIds";
  var itemLength = getValuesFromSession(sessionItemName).length;
  $(".selected-send-restaurants-count").text(itemLength);

  if (itemLength == 0) {
    $(".send-partial-button").css("background-color", "silver");
    $(".send-partial-button").css("border-color", "silver");
  } else {
    $(".send-partial-button").css("background-color", "orange");
    $(".send-partial-button").css("border-color", "orange");
  }
}

function addColorToRatingStars(element) {
  element.css("width", parseFloat(element.text()) / 5 * 100)
}

function changeTotalHeight(showingRestaurantsLengh) {
  var restaurantsHeight = $(".restaurant").outerHeight(true) * showingRestaurantsLengh;

  if (restaurantsHeight == 0) {
    $(".restaurants").css("height", $(".main").outerHeight(true) + restaurantsHeight + $("#loadMore").outerHeight(true) + 50 );
  } else {
    $(".restaurants").css("height", $(".main").outerHeight(true) + restaurantsHeight - 50);
  }
}

// Add the sticky class to the header when you reach its scroll position. Remove "sticky" when you leave the scroll position
function addOrRemoveSticky() {
  // Get the header
  var header = document.getElementById("header");
  // Get the offset position of the navbar
  var stickyHeader = header.offsetTop;
  if (window.pageYOffset > stickyHeader) {
    header.classList.add("sticky-header");
  } else {
    header.classList.remove("sticky-header");
  }
}

// ----------------- functions for session ---------------------   //
var session = window.sessionStorage;
// list values to store session
var sessionItems = ["selectedRestaurantIds", "selectedSendRestaurantIds"];
// initialize session value if empty
function initializeSession() {
  sessionItems.forEach(function(item) {
    if (getValuesFromSession(item) == null) {
      session.setItem(item, JSON.stringify([]));
    }
  })
}
// session getter
function getValuesFromSession(objName) {
  return parseJson(session.getItem([objName]));
}
// session setter
function setValuesToSession(itemName, value) {
  var old = getValuesFromSession(itemName);
  var newValue = old == undefined ? [value] : old.concat(value);
  session.setItem(itemName, stringify(newValue));
}
// session deleter
function deleteValuesFromSession(itemName, value) {
  var result = getValuesFromSession(itemName);
  result.splice(result.indexOf(value), 1);
  session.setItem(itemName, stringify(result));
}

function clearCache() { session.clear() }

// ------------------- parser ------------------------------
function parseJson(val) {
  return JSON.parse(val);
}

function stringify(val) {
  return JSON.stringify(val);
}
