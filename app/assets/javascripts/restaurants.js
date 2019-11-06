// sticky header: https://www.w3schools.com/howto/howto_js_sticky_header.asp
// When the user scrolls the page, execute myFunction
window.onscroll = function() { addOrRemoveSticky() };
// Get the header
var header = document.getElementById("header");
// Get the offset position of the navbar
var stickyHeader = header.offsetTop;
// Add the sticky class to the header when you reach its scroll position. Remove "sticky" when you leave the scroll position
function addOrRemoveSticky() {
  if (window.pageYOffset > stickyHeader) {
    header.classList.add("sticky-header");
  } else {
    header.classList.remove("sticky-header");
  }
}

$(document).ready(function(){
  $(".restaurant").hide();
  $(".restaurant").slice(0, 10).show();
  changeTotalHeight(0);
  $("#display-count").text(10)

  $("#loadMore").on("click", function(e){
    e.preventDefault();

    showingRestaurants = $(".restaurant:hidden").slice(0, 10);
    showingRestaurants.slideDown();

    if($(".restaurant:hidden").length == 0) {
      $("#loadMore").text("No Content").addClass("noContent");
      // $("#display-count").text($(".restaurant:visible").length);
    }

    changeTotalHeight(showingRestaurants.length);
    $("#display-count").text($(".restaurant:visible").length);
  });
  
})

window.onload = function() {
  initializeSession();
  changeSelectedRestaurantsCountText();

  // color already selected restarrants
  getValuesFromSession("selectedRestaurantIds").forEach(function(restaurantId) {
    addColorToRestaurant($(`[value=${restaurantId}]`));
  })

  $(".rating-text").each(function() {
    addColorToRatingStars($(this));
  })

  $(".main").removeClass("is-hide");
  $(".loading").remove();
}

function onClickRestaurant(e) {
  var sessionItemName = "selectedRestaurantIds";

  if (e.currentTarget.style.backgroundColor != 'rgb(226, 226, 226)') {
    addColorToRestaurant($(e.currentTarget));
    setValuesToSession(sessionItemName, e.currentTarget.value);
  } else {
    unsetColorToRestaurant($(e.currentTarget));
    deleteValuesFromSession(sessionItemName, e.currentTarget.value);
  }

  changeSelectedRestaurantsCountText();
}

function onClickClearCache() { clearCache(); }

function changeTotalHeight(showingRestaurantsLengh) {
  var restaurantsHeight = $(".restaurant").outerHeight(true) * showingRestaurantsLengh;

  if (restaurantsHeight == 0) {
    $(".restaurants").css("height", $(".main").outerHeight(true) + restaurantsHeight + $("#loadMore").outerHeight(true) );
  } else {
    $(".restaurants").css("height", $(".main").outerHeight(true) + restaurantsHeight - 50);
  }
}

function onSubmitRestaurantDataSet(event) {
  event.preventDefault(); 
  debugger;
  $.ajax({
    type: 'POST',
    url: '/api/restaurant_data_sets',
    data: {
      restaurant_data_sets: {
        mongo_custom_restaurants_id: window.location.href.split("cache_id=")[1],
        selected_restaurant_ids: getValuesFromSession('selectedRestaurantIds')
      }
    },
    success: function (res, status) {
      // sessionStorage.setItem("mongo_custom_restaurants", JSON.stringify(res.mongo_custom_restaurants))
      clearCache();
      window.location.href = `/restaurants/${JSON.parse(res.responseText)['restaurant_data_set_id']}/complete`;
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

// ----------------- DOM Setter --------------------------------- //
// jquery object
function addColorToRestaurant(element) {
  element.css("background-color", "#e2e2e2");
  element.find(".select-icon").css("color", "green");
}
// jquery object
function unsetColorToRestaurant(element) {
  element.css("background-color", "white");
  element.find(".select-icon").css("color", "gray");
}
// jquery object
function changeSelectedRestaurantsCountText() {
  var sessionItemName = "selectedRestaurantIds";
  $(".selected-restaurants-count").text(getValuesFromSession(sessionItemName).length);
}

function addColorToRatingStars(element) {
  element.css("width", parseFloat(element.text()) / 5 * 100)
}

// ----------------- functions for session ---------------------   //
var session = window.sessionStorage;
// list values to store session
var sessionItems = ["selectedRestaurantIds"];
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
