window.onload = function (e) {
  if (liff._auth == null) {
    console.log("liff not detected");
    $(".loading").remove()
    $(".main").removeClass("is-hide");
  } else {
    liff.init(function (data) {
      initializeApp(data);
    });
  }
};

// Close the dropdown menu if the user clicks outside of it
window.onclick = function(event) {
  $("#location-choices").toggle(false);
}

/* When the user clicks on the button, 
toggle between hiding and showing the dropdown content */
function onClickUserMenu() {
  $(".user-menu-content").toggle();
}

document.addEventListener('keydown', function (event) {
  if (event.which == 13) {
    event.preventDefault();
  }
}, false);

var lowerBudget = document.getElementById('lower-budget'); var upperBudget = document.getElementById('upper-budget');
var inputLocation = document.getElementById('location'); 
var inputMealGenre = document.getElementById('meal-genre'); 
var inputMealType = document.getElementById("meal-type");
var inputLowerBudget = document.getElementById("lower-budget");
var inputUpperBudget = document.getElementById("upper-budget");
var decidedLocation;

function onInputLocation(e) {
  decidedLocation = "";
  inputLocation.setCustomValidity("場所を正しく入力してください");
  getSuggetWords();
  if (e.currentTarget.value.length > 1 && $(".location-choice-list").length > 0 && decidedLocation == "") {
    $("#location-choices").toggle(true)
  } else {
    $("#location-choices").toggle(false)
  }
}

function onClickLocationChoice(e) {
  // idにする
  var userChoice = e.currentTarget.innerText
  decidedLocation = userChoice;
  inputLocation.value = userChoice;
  inputLocation.setCustomValidity("");
}

function onChangeBudget() {
  validateBudget();
}

function onInputMealGenre() {
  var genres = document.getElementById("genres");
  var budgetArrow = document.getElementById("budget-arrow");
  genres.style.display = "none";
  budgetArrow.style.top = "45%";
}

function onClickMealGenre() {
  $(".meal-genre-form-group").addClass("input-not-empty");
}

function onChangeMealGenre(event) {
  $(".meal-genre-form-group").addClass("input-not-empty");
}

function onResetSearchRestaurant() {
  $(".form-group").removeClass("input-not-empty")
  $(".search-restaurant-form")[0].reset()
}

function onSubmitSearchRestaurant(event) {
  event.preventDefault(); 

  $.ajax({
    type: 'POST',
    url: '/api/custom_restaurants',
    data: {
      line_liff: {
        location: decidedLocation.trim(),
        meal_type: inputMealType.value,
        genre: {
          custom_input: ["指定なし", ""].includes(inputMealGenre.value) ? undefined : inputMealGenre.value,
          master_genres: transformMasterGenresToParam()
        },
        budget: {
          lower: inputLowerBudget.value,
          upper: inputUpperBudget.value
        }
      }
    },
    success: function (res, status) {
      // sessionStorage.setItem("mongo_custom_restaurants", JSON.stringify(res.mongo_custom_restaurants))
      window.location.href = `/restaurant_data_sets/new?cache_id=${res.mongo_custom_restaurants.cache_id}`;
      // window.alert('メッセージが送られました！ご確認下さい。');
      // liff.closeWindow();
    },
    error: function (res, status) {
      if (status == 505) {
        window.alert('invalid session: ' + res.status);
        liff.closeWindow();
      } else {
        // alert(JSON.parse(res.responseText));
        window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
      }
    },
    complete: function(data) {}
  });

  // $.ajax({
  //   type: 'POST',
  //   url: '/api/line/callback_liff',
  //   data: {
  //     line_liff: {
  //       location: decidedLocation.trim(),
  //       meal_type: inputMealType.value,
  //       genre: {
  //         custom_input: ["指定なし", ""].includes(inputMealGenre.value) ? undefined : inputMealGenre.value,
  //         master_genres: transformMasterGenresToParam()
  //       },
  //       budget: {
  //         lower: inputLowerBudget.value,
  //         upper: inputUpperBudget.value
  //       }
  //     }
  //   },
  //   success: function (res, status) {
  //     window.alert('メッセージが送られました！ご確認下さい。');
  //     liff.closeWindow();
  //   },
  //   error: function (res, status) {
  //     if (status == 505) {
  //       window.alert('invalid session: ' + res.status);
  //       liff.closeWindow();
  //     } else {
  //       // alert(JSON.parse(res.responseText));
  //       window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus:" + res.status);
  //     }
  //   },
  //   complete: function(data) {}
  // });
}

function transformMasterGenresToParam() {
  result = [];

  selectedGenreButtons = $(".genre-button.selected");
  if (selectedGenreButtons.length > 22) {
    result.push("指定なし")
  } else {
    for (var i=0; i<selectedGenreButtons.length; i++) {
      result.push(selectedGenreButtons[i].textContent);
    }
  }

  if (result.length == 0 && inputMealGenre.value == "") {
    result.push("指定なし");
  }

  return result;
}

function validateBudget() {
  var inputLowerBudgetValue = inputLowerBudget.value;
  var inputUpperBudgetValue = inputUpperBudget.value;
  var lowerBudgetValue = parseInt(inputLowerBudgetValue); var upperBudgetValue = parseInt(inputUpperBudgetValue)

  if (lowerBudgetValue == 0 || upperBudgetValue == 0) {
    inputLowerBudget.setCustomValidity("");
    inputUpperBudget.setCustomValidity("");
    return;
  };

  if (lowerBudgetValue >= upperBudgetValue) {
    inputLowerBudget.setCustomValidity("予算を正しく入力してください");
    inputUpperBudget.setCustomValidity("予算を正しく入力してください");
    return;
  };

  inputLowerBudget.setCustomValidity("");
  inputUpperBudget.setCustomValidity("");
}

var timeout = null
function getSuggetWords() {
  clearTimeout(timeout);
  // 2文字以上入力された場合にサジェストワードを取得
  if (inputLocation.value.length > 1) {
　　// setTimeoutを使ってapiが呼ばれるまでに時間を置く
    timeout = setTimeout(function () {
      $.ajax({
        type: 'GET',
        url: '/api/stations/suggests?query='+inputLocation.value,
        success: function (res, status) {
          var result = res.stations;
          updateSuggestWords(result);
        },
        error: function (res) {
          window.alert(JSON.parse(res.responseText)["errors"] + "\nstatus: " + res.status);
          liff.closeWindow();
        },
        complete: function(data) {}
      });
    }, 300);
  }
}

function updateSuggestWords(result) {
  if (result.length > 0) {
    const dropdownMenu = document.querySelector("#location-choices");

    let stationList = "";
    result.forEach(station_json => {
      stationList += `<li class="location-choice-element" id=${station_json["id"]} onclick="onClickLocationChoice(event)"><a href="#">${station_json["name"]}</a></li>`
    });

    const html = `<ul class="location-choice-list">${stationList}</ul>`;

    dropdownMenu.innerHTML = html;
    displaySuggestList();
  }
}

function displaySuggestList() {
  /* When the user clicks on the button, 
  toggle between hiding and showing the dropdown content */
  $("#location-choices").toggle(true)
}

function onClickGenreBar() {
  var genres = document.getElementById("genres");
  var budgetArrow = document.getElementById("budget-arrow");
  genres.style.display === "block" ? closeGenreBar() : openGenreBar();
}

var genres = document.getElementById("genres");
var budgetArrow = document.getElementById("budget-arrow");
function openGenreBar() {
  genres.style.display = "block";
  if (window.matchMedia('(min-width:640px)').matches) {
    budgetArrow.style.top = "35%"
  } else {
    budgetArrow.style.top = "26%";
  }
}

function closeGenreBar() {
  genres.style.display = "none";
  budgetArrow.style.top = "45%"
}

var genreSelectCount = 0;
var genreButtons = $(".genre-button");

function onClickMealGenreElement(e) {
  e.preventDefault();

  var genreSelectionText = $("#genre-selection-text");
  var genreButton = $("#"+e.currentTarget.id);

  if (e.currentTarget.id == "指定なし") {
    if (genreButton.hasClass("selected")) {
      genreButtons.removeClass("selected");
      enableInputMealGenre();
      genreSelectCount = 0;
    } else {
      genreButtons.addClass("selected");
      genreSelectCount = genreButtons.length - 1;
      disableInputMealGenre();
    }
  } else {
    if (genreButton.hasClass("selected")) {
      genreButton.removeClass("selected");
      genreSelectCount -= 1;
      if ($("#指定なし").hasClass("selected")) {
        $("#指定なし").removeClass("selected");
        enableInputMealGenre();
      }
    } else {
      genreButton.addClass("selected");
      genreSelectCount += 1;
      if (genreSelectCount == 22) {
        $("#指定なし").addClass("selected");
        disableInputMealGenre();
      }
    }
  }

  $(".meal-genre-form-group").addClass("input-not-empty");
  genreSelectionText.text(genreSelectCount + " 個選択");
}

function disableInputMealGenre() {
  inputMealGenre.value = "指定なし";
  inputMealGenre.disabled = true
}

function enableInputMealGenre() {
  inputMealGenre.value = "";
  inputMealGenre.disabled = false
}



// function fillCacheToForm(returnedSearchHistory) {
//   $(".form-group").addClass("input-not-empty");

//   var formElements = ["location", "meal-type", "lower-budget", "upper-budget"]
//   formElements.map(function( element ) {
//     $("#"+element)[0].value = returnedSearchHistory[element.replace("-", "_")]
//   });

//   decidedLocation = returnedSearchHistory["location"]

//   $("#meal-genre")[0].value = returnedSearchHistory["custom_meal_genre"];

//   var returned_master_genres = returnedSearchHistory["master_genres"]

//   if (returned_master_genres == null) {
//     if (returnedSearchHistory["custom_meal_genre"] == null) {
//       genreButtons.addClass("selected");
//       genreSelectCount = 22;
//       disableInputMealGenre();
//       openGenreBar();
//     }
//   } else {
//     returned_master_genres.forEach(function(master_genre) {
//       $("#"+master_genre["id"]).addClass("selected");
//       genreSelectCount += 1;
//     });
//     openGenreBar();
//   }

//   $(".meal-genre-form-group").addClass("input-not-empty");
//   $("#genre-selection-text").text(genreSelectCount + " 個選択");
// }


