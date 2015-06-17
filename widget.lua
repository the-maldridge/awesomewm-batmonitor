local aweful = require("awful")
local wibox = require("wibox")
local power = require("bat.acpi")

-- Configurable things
local width = 40

local color = '#698f1e'
local color_bg = '#33450f'

local color_low = '#be2a15'
local color_low_bg = '#532a15'

local lowCharge = 10
local show_text = true --reseved for future use

-- End of configuration

local chargeBar = aweful.widget.progressbar()
chargeBar:set_width(width)
chargeBar.step = 1

local function make_stack(w1, w2)
    local ret = wibox.widget.base.make_widget()

    ret.fit = function(self, ...) return w1:fit(...) end
    ret.draw = function(self, wibox, cr, width, height)
        w1:draw(wibox, cr, width, height)
        w2:draw(wibox, cr, width, height)
    end

    update = function() ret:emit_signal("widget::updated") end
    w1:connect_signal("widget::updated", update)
    w2:connect_signal("widget::updated", update)

    return ret
end

local batWidget
local batText = wibox.widget.textbox()

if show_text then
   batText:set_align("center")
   batWidget = wibox.layout.margin(make_stack(chargeBar, batText),0,0,0,0)
else
   batWidget = wibox.layout.margin(chargeBar,0,0,0,0)
end

function chargeBar.setColor(charge)
   if charge <= lowCharge then
      chargeBar:set_color(color_low)
      chargeBar:set_background_color(color_low_bg)
   else
      chargeBar:set_color(color)
      chargeBar:set_background_color(color_bg)
   end
end

local function _scale(charge)
   return charge * 40 / 100
end

local function _update()
   charge = _scale(power())
   if show_text then
      local markup = '<span color="white">'..power()..'%</span>'
      batText:set_markup(markup)
   end
   chargeBar:set_value(charge)
   chargeBar.setColor(charge)
end

-- set timer to reload
updateTimer = timer({timeout=30})
updateTimer:connect_signal('timeout', _update)
updateTimer:start()

-- initialize
_update()
return batWidget
