import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
require("jquery")
import "bootstrap"
import "chartkick/chart.js"
Rails.start()
Turbolinks.start()
ActiveStorage.start()
require("./custom")
