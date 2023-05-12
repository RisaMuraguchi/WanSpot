// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import 'jquery-ui-dist/jquery-ui';
import "popper.js";
import "bootstrap";
import "../stylesheets/application"
import '@fortawesome/fontawesome-free/js/all'

// 画像プレビューのために追記
// require("@rails/ujs").start()
// require("@rails/activestorage").start()
require("channels")
require('./preview')
require('jquery-ui/ui/widgets/autocomplete');

// 住所の入力自動補完
// import $ from 'jquery';
// import 'jquery-ui/ui/widgets/autocomplete';

// $(document).on('turbolinks:load', function() {

//     function initAutocomplete() {
//       //対応させるテキストボックス
//       var input = document.getElementById('post_address');
//       //プレイスを検索する領域
//       var LatLngFrom = new google.maps.LatLng(35.692195,139.7576653);
//       var LatLngTo   = new google.maps.LatLng(35.696157,139.7525771);
//       var bounds = new google.maps.LatLngBounds(LatLngFrom, LatLngTo);
//   　　//オートコンプリートのオプション
//       var options = {
//           types: ['(regions)'],                      // 検索タイプ
//           bounds: bounds,                            // 範囲優先検索
//           componentRestrictions: {country: 'jp'}     // 日本国内の住所のみ
//       };
//       autocomplete = new google.maps.places.Autocomplete( input, options);
//   }

// 　initAutocomplete(); // initAutocomplete関数を呼び出してオートコンプリートを初期化する

//   $('.address').autocomplete({

//     source: initAutocomplete(),
//     minLength: 2
//   });
// });


Rails.start()
Turbolinks.start()
ActiveStorage.start()
