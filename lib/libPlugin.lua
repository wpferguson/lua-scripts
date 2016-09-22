libPlugin = {}

local dt = require "darktable"

require "lib/dtutils"

-- put the plugin_manager widgets here to prevent namespace pollution

libPlugin.placeholder = dt.new_widget("separator"){}

-- format options container

libPlugin.jpeg_slider = dt.new_widget("slider"){
  label = "quality",
  sensitive = true,
  soft_min = 5,      -- The soft minimum value for the slider, the slider can't go beyond this point
  soft_max = 100,     -- The soft maximum value for the slider, the slider can't go beyond this point
  hard_min = 5,       -- The hard minimum value for the slider, the user can't manually enter a value beyond this point
  hard_max = 100,    -- The hard maximum value for the slider, the user can't manually enter a value beyond this point
  value = 90          -- The current value of the slider
}

libPlugin.png_bit_depth = dt.new_widget("combobox"){
  label = "bit depth",
  value = 1, 8, 16,
}

libPlugin.tif_bit_depth = dt.new_widget("combobox"){
  label = "bit depth",
  value = 1, 8, 16, 32,
}

libPlugin.tif_compression = dt.new_widget("combobox"){
  label = "compression",
  value = 1, "uncompressed", "deflate", "deflate with predictor", "deflate with predictor (float)",
}

libPlugin.tif_widget = dt.new_widget("box"){
  orientation = "vertical",
  libPlugin.tif_bit_depth,
  libPlugin.tif_compression,
}

libPlugin.format_combobox = dt.new_widget("combobox"){
  label = "file format",
  value = 1, "JPEG (8-bit)", "PNG (8/16-bit)", "TIFF (8/16/32-bit)",
  changed_callback = function(self)
    print("value is " .. self.value)
    if string.match(self.value, "JPEG") then
      -- set visible widget to non visible
      -- set jpeg_slider to visible
      print("took JPEG")
      libPlugin.format[4] = nil
      libPlugin.format[4] = libPlugin.jpeg_slider
    elseif string.match(self.value, "PNG") then
      print("took PNG")
      libPlugin.format[4] = nil
      libPlugin.format[4] = libPlugin.png_bit_depth

      -- set png option to true
    elseif string.match(self.value, "TIFF") then
      print("took TIFF")
      libPlugin.format[4] = nil
      libPlugin.format[4] = libPlugin.tif_widget
      -- set tiff option to true
    end
  end
}


libPlugin.format = dt.new_widget("box"){
  orientation = "vertical",
  dt.new_widget("label"){ label = "Format Options" },
  dt.new_widget("separator"){},
  libPlugin.format_combobox,
  libPlugin.jpeg_slider,
}

libPlugin.height = dt.new_widget("entry"){
  tooltip = "height",
  text = "0",
}

libPlugin.height_box = dt.new_widget("box"){    -- TODO: refresh processor combobox

  orientation = "horizontal",
  dt.new_widget("label"){ label = "Height" },
  libPlugin.height,
}

libPlugin.width = dt.new_widget("entry"){
  tooltip = "width",
  text = "0",
}

libPlugin.width_box = dt.new_widget("box"){
  orientation = "horizontal",
  dt.new_widget("label"){ label = "Width " },
  libPlugin.width,
}

libPlugin.upscale = dt.new_widget("combobox"){
  label = "upscale",
  value = 1, "no", "yes",
}

libPlugin.global = dt.new_widget("box"){
  orientation = "vertical",
  dt.new_widget("label"){ label = "Global Options" },
  dt.new_widget("separator"){},
  dt.new_widget("label"){ label = "Max Size" },
  libPlugin.height_box,
  libPlugin.width_box,
  libPlugin.upscale,
}

-- execute button

libPlugin.button = dt.new_widget("button"){
  label = "Process",
  clicked_callback = function (_)
    -- get the gui parameters
    local export_format = libPlugin.format_combobox.value
    -- build the image table
    local img_table, cnt = libPlugin.build_image_table(dt.gui.action_images, export_format)
    print("image count is ", cnt)
    -- export the images
    local success = libPlugin.do_export(img_table, export_format, libPlugin.height.text, libPlugin.width.text, libPlugin.upscale.value)
    -- call the processor
    print(processor_cmds[libPlugin.processor_combobox.value])
    dtutils.tellme("",processor_cmds)
    processor_cmds[libPlugin.processor_combobox.value](img_table, plugins[libPlugin.processor_combobox.value])
  end
}

function libPlugin.register_processor_lib(name_table)
  print("name_table is ", #name_table)
  libPlugin.processor_combobox = dt.new_widget("combobox"){
    label = "processor",
    value = 1, table.unpack(name_table),
    changed_callback = function(self)
      dtutils.pop(libPlugin.processor)
      dtutils.push(libPlugin.processor, name_table[self.value])
    end
  }

  -- processor container

  libPlugin.processor = dt.new_widget("box"){
    orientation = "vertical",
    dt.new_widget("label"){ label = "Processor" },
    dt.new_widget("separator"){},
    libPlugin.processor_combobox,
    libPlugin.placeholder,
  }

  -- stick it all in a container and then register it
  dt.register_lib(
    "Processor",     -- Module name
    "External Processing",     -- name
    true,                -- expandable
    false,               -- resetable
    {[dt.gui.views.lighttable] = {"DT_UI_CONTAINER_PANEL_RIGHT_CENTER", 100}},   -- containers
    dt.new_widget("box") -- widget
    {
      orientation = "vertical",
      libPlugin.processor,
      libPlugin.format,
      libPlugin.global,
      libPlugin.button,
    },
    nil,-- view_enter
    nil -- view_leave
  )
end

function libPlugin.create_data_dir(dir)
  if not dtutils.checkIfFileExists(dir) then
    os.execute("mkdir -p '" .. dir .. "'")
  end
end

function libPlugin.add_plugin_widget(req_name, plugin_state)
  local button_text = ""
  if plugin_state then
    button_text = "Deactivate " .. req_name.DtPluginName
  else
    button_text = "Activate " .. req_name.DtPluginName
  end
  plugin_widgets[plugin_widget_cnt] = dt.new_widget("button")
  {
    label = button_text,
    tooltip = libPlugin.get_plugin_doc(req_name),
    clicked_callback = function (self)
      -- split the label into action and target
      local action, target = string.match(self.label, "(.-) (.+)")
      local i = plugins[target]
      -- load the script if it's not loaded
      if action == "Activate" then
        dt.preferences.write("plugin_manager", i.DtPluginPreference, "bool", true)
        dt.print_error("Loading " .. target)
        libPlugin.activate_plugin(i)
        self.label = "Deactivate " .. target
      else
        dt.preferences.write("plugin_manager", i.DtPluginPreference, "bool", false)
        -- ideally we would call a deactivate method provided by the script
        dt.print(target .. " will not be active when darktable is restarted")
        libPlugin.deactivate_plugin(i)
        self.label = "Activate " .. target
      end
    end
  }
  plugin_widget_cnt = plugin_widget_cnt + 1
end

-- get the script documentation, with some assumptions
function libPlugin.get_plugin_doc(plugin)
  local description = ""
  for _,section in pairs(plugin.DtPluginDoc.Sections) do
    description = description .. string.upper(section) .. "\n"
    description = description .. "\t" .. plugin.DtPluginDoc[section] .. "\n"
  end
  if description:len() == 0 then
    description = "No description available"
  end
  return description
end

function libPlugin.activate_plugin(plugin_data)
  local i = plugin_data
  if i.DtPluginIsA.processor then
    print("in activate plugin adding processor")
    -- add it to the processors table 
    -- add the associated processor widget or placeholder if not
    processors[i.DtPluginName] = i.DtPluginProcessorWidget and i.DtPluginProcessorWidget or libPlugin.placeholder
    print(i.DtPluginActivate.DtPluginRegisterProcessor)
    processor_cmds[i.DtPluginName] = dtutils.prequire(dtutils.chop_filetype(i.DtPluginActivate.DtPluginRegisterProcessor))
    print(processor_cmds[i.DtPluginName])
    print(type(processor_cmds))
    dtutils.tellme("",processor_cmds)
    processor_names[#processor_names + 1] = i.DtPluginName
    table.sort(processor_names)
    -- TODO: refresh processor combobox
    if #processor_names == 1 then
      print("took ==1 branch")
      if not pmstartup then
        libPlugin.register_processor_lib(processor_names)
      end
    else
      print("took push branch")
      print("processor_names count was ", #processor_names)
      for k,v in ipairs(processor_names) do
        print(k,v)
      end
      dtutils.push(libPlugin.processor_combobox, i.DtPluginName)
    end
  end
  if i.DtPluginIsA.shortcut then
    libPlugin.start_plugin(i.DtPluginActivate.DtPluginRegisterShortcut)
  end
  if i.DtPluginIsA.action then
    libPlugin.start_plugin(i.DtPluginActivate.DtPluginRegisterAction)
  end
  if i.DtPluginIsA.storage then
    libPlugin.start_plugin(i.DtPluginActivate.DtPluginRegisterStorage)
  end
  if i.DtPluginIsA.lib then
    libPlugin.start_plugin(i.DtPluginActivate.DtPluginRegisterLib)
  end
end

function libPlugin.deactivate_plugin(plugin_data)
  local i = plugin_data

  if i.DtPluginIsA.processor then
    -- set the plugin name to nil to remove it 
    processors[i.DtPluginName] = nil
    processor_cmds[i.DtPluginName] = nil
    for k,v in ipairs(processor_names) do
      if v == i.DtPluginName then
        table.remove(processor_names, k)
        libPlugin.processor_combobox[k] = nil
        break
      end
    end
    table.sort(processor_names)
    -- TODO: refresh processor combobox
  end
  if i.DtPluginIsA.shortcut then
    libPlugin.stop_plugin(i.DtPluginDeactivate.DtPluginUnregisterShortcut)
  end
  if i.DtPluginIsA.action then
    libPlugin.stop_plugin(i.DtPluginDeactivate.DtPluginUnregisterAction)
  end
  if i.DtPluginIsA.storage then
    libPlugin.stop_plugin(i.DtPluginDeactivate.DtPluginUnregisterStorage)
  end
  if i.DtPluginIsA.lib then
    libPlugin.stop_plugin(i.DtPluginDeactivate.DtPluginUnregisterLib)
  end
end

function libPlugin.start_plugin(method)
  if method then
    prequire(dtutils.chop_filetype(method))
  end
end

function libPlugin.stop_plugin(method)
  if method then
    prequire(dtutils.chop_filetype(method))
  end
end

function libPlugin.check_api_version(ver_table)
  local dtversion = tostring(dt.configuration.api_version_major) .. "." ..
                    tostring(dt.configuration.api_version_minor) .. "." ..
                    tostring(dt.configuration.api_version_patch)
  local match = nil
  for _,ver in pairs(ver_table) do
    if ver == dtversion then
      match = true
    end
  end
  return match
end

-- build the image table
function libPlugin.build_image_table(images, ff)
  local image_table = {}
  local file_extension = ""
  local tmp_dir = dt.configuration.tmp_dir .. "/"
  local cnt = 0

  if string.match(ff, "JPEG") then
    file_extension = ".jpg"
  elseif string.match(ff, "PNG") then
    file_extension = ".png"
  elseif string.match(ff, "TIFF") then
    file_extension = ".tif"
  end

  for _,img in ipairs(images) do
    image_table[img] = tmp_dir .. dtutils.get_basename(img.filename) .. file_extension
    cnt = cnt + 1
  end

  return image_table, cnt
end

-- export the images

function libPlugin.do_export(img_tbl, ff, height, width, upscale)
  local exporter = nil
  local upsize = false

  -- get the export format parameters
  if string.match(ff, "JPEG") then
    exporter = dt.new_format("jpeg")
    dtutils.tellme("",exporter)
    print(type(exporter))
    exporter.quality = math.floor(dtutils.fixSliderFloat(libPlugin.jpeg_slider.value))
  elseif string.match(ff, "PNG") then
    exporter = dt.new_format("png")
    exporter.bit_depth = libPlugin.png_bit_depth.value
  elseif string.match(ff, "TIFF") then
    exporter = dt.new_format("tiff")
    exporter.bit_depth = libPlugin.tif_bit_depth.value
  end
  exporter.max_height = tonumber(height)
  exporter.max_width = tonumber(width)
  upsize = upscale == "yes" and true or false
  -- export the images
  for img,export in pairs(img_tbl) do
    print(type(img))
    exporter.write_image(exporter, img, export, upsize)
  end
  -- return success, or not
  return true
end

return libPlugin