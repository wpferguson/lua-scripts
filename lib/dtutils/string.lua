local dtutils_string = {}

local dt = require "darktable"
local du = require "lib/dtutils"
local log = require "lib/dtutils.log"

local DEFAULT_LOG_LEVEL = log.error

dtutils_string.log_level = DEFAULT_LOG_LEVEL

dtutils_string.libdoc = {
  Name = [[dtutils.string]],
  Synopsis = [[a library of string utilities for use in darktable lua scripts]],
  Usage = [[local ds = require "lib/dtutils.string"]],
  Description = [[This library contains string manipulation routines to aid in building
    darktable lua scripts.]],
  Return_Value = [[du - library - the darktable lua string library]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.]],
  Copyright = [[Copyright (c) 2016 Bill Ferguson <wpferguson@gmail.com>]],
  functions = {}
}

dtutils_string.libdoc.functions["strip_accents"] = {
  Name = [[strip_accents]],
  Synopsis = [[strip accents from characters]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.strip_accents(str)
      str - string - the string with characters that need accents removed]],
  Description = [[strip_accents removes accents from accented characters returning the 
    unaccented character.]],
  Return_Value = [[result - string - the string containing unaccented characters]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[Copied from https://forums.coronalabs.com/topic/43048-remove-special-characters-from-string/]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.strip_accents( str )
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  local tableAccents = {}
    tableAccents["à"] = "a"
    tableAccents["á"] = "a"
    tableAccents["â"] = "a"
    tableAccents["ã"] = "a"
    tableAccents["ä"] = "a"
    tableAccents["ç"] = "c"
    tableAccents["è"] = "e"
    tableAccents["é"] = "e"
    tableAccents["ê"] = "e"
    tableAccents["ë"] = "e"
    tableAccents["ì"] = "i"
    tableAccents["í"] = "i"
    tableAccents["î"] = "i"
    tableAccents["ï"] = "i"
    tableAccents["ñ"] = "n"
    tableAccents["ò"] = "o"
    tableAccents["ó"] = "o"
    tableAccents["ô"] = "o"
    tableAccents["õ"] = "o"
    tableAccents["ö"] = "o"
    tableAccents["ù"] = "u"
    tableAccents["ú"] = "u"
    tableAccents["û"] = "u"
    tableAccents["ü"] = "u"
    tableAccents["ý"] = "y"
    tableAccents["ÿ"] = "y"
    tableAccents["À"] = "A"
    tableAccents["Á"] = "A"
    tableAccents["Â"] = "A"
    tableAccents["Ã"] = "A"
    tableAccents["Ä"] = "A"
    tableAccents["Ç"] = "C"
    tableAccents["È"] = "E"
    tableAccents["É"] = "E"
    tableAccents["Ê"] = "E"
    tableAccents["Ë"] = "E"
    tableAccents["Ì"] = "I"
    tableAccents["Í"] = "I"
    tableAccents["Î"] = "I"
    tableAccents["Ï"] = "I"
    tableAccents["Ñ"] = "N"
    tableAccents["Ò"] = "O"
    tableAccents["Ó"] = "O"
    tableAccents["Ô"] = "O"
    tableAccents["Õ"] = "O"
    tableAccents["Ö"] = "O"
    tableAccents["Ù"] = "U"
    tableAccents["Ú"] = "U"
    tableAccents["Û"] = "U"
    tableAccents["Ü"] = "U"
    tableAccents["Ý"] = "Y"
        
  local normalizedString = ""

  for strChar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
    if tableAccents[strChar] ~= nil then
      normalizedString = normalizedString..tableAccents[strChar]
    else
      normalizedString = normalizedString..strChar
    end
  end
        
  log.log_level(old_log_level)
  return normalizedString
 
end

dtutils_string.libdoc.functions["escape_xml_characters"] = {
  Name = [[escape_xml_characters]],
  Synopsis = [[escape characters for xml documents]],
  Usage = [[local ds = require "lib/dtutils.string"
    
    local result = ds.escape_xml_characters(str)
      str - string - the string that needs escaped]],
  Description = [[escape_xml_characters provides the escape sequences for
    "&", '"', "'", "<", and ">" with the corresponding "&amp;",
    "&quot;", "&apos;", "&lt;", and "&gt;".]],
  Return_Value = [[result - string - the string containing escapes for the xml characters]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[https://stackoverflow.com/questions/1091945/what-characters-do-i-need-to-escape-in-xml-documents]],
  License = [[]],
  Copyright = [[]],
}

-- Keep &amp; first, otherwise it will double escape other characters
function dtutils_string.escape_xml_characters( str )
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)

  str = string.gsub(str,"&", "&amp;")
  str = string.gsub(str,"\"", "&quot;")
  str = string.gsub(str,"'", "&apos;")
  str = string.gsub(str,"<", "&lt;")
  str = string.gsub(str,">", "&gt;")

  log.log_level(old_log_level)
  return str
end

dtutils_string.libdoc.functions["urlencode"] = {
  Name = [[urlencode]],
  Synopsis = [[encode a string in a websage manner]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.urlencode(str)
      str - string - the string that needs to be made websafe]],
  Description = [[urlencode converts a string into a websafe version suitable for
    use in a web browser.]],
  Return_Value = [[result - string - a websafe string]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[https://forums.coronalabs.com/topic/43048-remove-special-characters-from-string/]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.urlencode(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])", function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  log.log_level(old_log_level)
  return str
end


dtutils_string.libdoc.functions["is_not_sanitized"] = {
  Name = [[is_not_sanitized]],
  Synopsis = [[Check if a string has been sanitized]],
  Usage = [[local ds = require "lib/dtutils.string"
    local result = ds.is_not_sanitized(str)
      str - string - the string that needs to be made safe]],
  Description = [[is_not_sanitized checks a string to see if it
    has been made safe use passing as an argument in a system command.]],
  Return_Value = [[result - boolean - true if the string is not sanitized otherwise false]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

local function _is_not_sanitized_posix(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  -- A sanitized string must be quoted.
  if not string.match(str, "^'.*'$") then
    log.log_level(old_log_level)
    return true
   -- A quoted string containing no quote characters within is sanitized.
  elseif string.match(str, "^'[^']*'$") then
    log.log_level(old_log_level)
    return false
  end
   
  -- Any quote characters within a sanitized string must be properly
  -- escaped.
  local quotesStripped = string.sub(str, 2, -2)
  local escapedQuotesRemoved = string.gsub(quotesStripped, "'\\''", "")
  if string.find(escapedQuotesRemoved, "'") then
    log.log_level(old_log_level)
    return true
  else
    log.log_level(old_log_level)
    return false
  end
end

local function _is_not_sanitized_windows(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  if not string.match(str, "^\".*\"$") then
    log.log_level(old_log_level)
    return true
  else
    log.log_level(old_log_level)
    return false
  end
end

function dtutils_string.is_not_sanitized(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  if dt.configuration.running_os == "windows" then
    log.log_level(old_log_level)
    return _is_not_sanitized_windows(str)
  else
    log.log_level(old_log_level)
    return _is_not_sanitized_posix(str)
  end
end

dtutils_string.libdoc.functions["sanitize"] = {
  Name = [[sanitize]],
  Synopsis = [[surround a string in quotes making it safe to pass as an argument]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.sanitize(str)
      str - string - the string that needs to be made safe]],
  Description = [[sanitize converts a string into a version suitable for
    use passing as an argument in a system command.]],
  Return_Value = [[result - string - a websafe string]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

local function _sanitize_posix(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  if _is_not_sanitized_posix(str) then
    log.log_level(old_log_level)
    return "'" .. string.gsub(str, "'", "'\\''") .. "'"
  else
    log.log_level(old_log_level)
    return str
  end
end

local function _sanitize_windows(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  if _is_not_sanitized_windows(str) then
    log.log_level(old_log_level)
    return "\"" .. string.gsub(str, "\"", "\"^\"\"") .. "\""
  else
    log.log_level(old_log_level)
    return str
  end
end

function dtutils_string.sanitize(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  if dt.configuration.running_os == "windows" then
    log.log_level(old_log_level)
    return _sanitize_windows(str)
  else
    log.log_level(old_log_level)
    return _sanitize_posix(str)
  end
end

dtutils_string.libdoc.functions["sanitize_lua"] = {
  Name = [[sanitize_lua]],
  Synopsis = [[escape lua 'magic' characters from a pattern string]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.sanitize_lua(str)
      str - string - the string that needs to be made safe]],
  Description = [[sanitize_lua escapes lua 'magic' characters so that
    a string may  be used in lua string/patten matching.]],
  Return_Value = [[result - string - a lua pattern safe string]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.sanitize_lua(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  str = string.gsub(str, "%%", "%%%%")
  str = string.gsub(str, "%-", "%%-")
  str = string.gsub(str, "%(", "%%(")
  str = string.gsub(str, "%)", "%%)")
  str = string.gsub(str, "+", "%%+")
  log.log_level(old_log_level)
  return str
end

dtutils_string.libdoc.functions["split_filepath"] = {
  Name = [[split_filepath]],
  Synopsis = [[split a filepath into parts]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.split_filepath(filepath)
      filepath - string - path and filename]],
  Description = [[split_filepath splits a filepath into the path, filename, basename and filetype and puts
    that in a table]],
  Return_Value = [[result - table - a table containing the path, filename, basename, and filetype]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.split_filepath(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
 -- strip out single quotes from quoted pathnames
  str = string.gsub(str, "'", "")
  str = string.gsub(str, '"', '')
  local result = {}
  -- Thank you Tobias Jakobs for the awesome regular expression, which I tweaked a little
  result["path"], result["filename"], result["basename"], result["filetype"] = string.match(str, "(.-)(([^\\/]-)%.?([^%.\\/]*))$")
  if result["basename"] == "" and result["filetype"]:len() > 1 then
    result["basename"] = result["filetype"]
    result["filetype"] = ""
  end
  log.log_level(old_log_level)
  return result
end

dtutils_string.libdoc.functions["get_path"] = {
  Name = [[get_path]],
  Synopsis = [[get the path from a file path]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.get_path(filepath)
      filepath - string - path and filename]],
  Description = [[get_path strips the filename and filetype from a path and returns the path]],
  Return_Value = [[result - string - the path]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.get_path(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  local parts = dtutils_string.split_filepath(str)
  log.log_level(old_log_level)
  return parts["path"]
end

dtutils_string.libdoc.functions["get_filename"] = {
  Name = [[get_filename]],
  Synopsis = [[get the filename and extension from a file path]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.get_filename(filepath)
      filepath - string - path and filename]],
  Description = [[get_filename strips the path from a filepath and returns the filename]],
  Return_Value = [[result - string - the file name and type]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.get_filename(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  local parts = dtutils_string.split_filepath(str)
  log.log_level(old_log_level)
  return parts["filename"]
end

dtutils_string.libdoc.functions["get_basename"] = {
  Name = [[get_basename]],
  Synopsis = [[get the filename without the path or extension]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.get_basename(filepath)
      filepath - string - path and filename]],
  Description = [[get_basename returns the name of the file without the path or filetype
]],
  Return_Value = [[result - string - the basename of the file]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.get_basename(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  local parts = dtutils_string.split_filepath(str)
  log.log_level(old_log_level)
  return parts["basename"]
end

dtutils_string.libdoc.functions["get_filetype"] = {
  Name = [[get_filetype]],
  Synopsis = [[get the filetype from a filename]],
  Usage = [[local ds = require "lib/dtutils.string"

    local result = ds.get_filetype(filepath)
      filepath - string - path and filename]],
  Description = [[get_filetype returns the filetype from the supplied filepath]],
  Return_Value = [[result - string - the filetype]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.get_filetype(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  local parts = dtutils_string.split_filepath(str)
  log.log_level(old_log_level)
  return parts["filetype"]
end

local substitutes = {}

-- - - - - - - - - - - - - - - - - - - - - - - -
-- C O N S T A N T S
-- - - - - - - - - - - - - - - - - - - - - - - -

local PLACEHOLDERS = {"ROLL.NAME", 
                      "FILE.FOLDER", 
                      "FILE.NAME",
                      "FILE.EXTENSION", 
                      "ID", 
                      "VERSION", 
                      "VERSION.IF.MULTI",    -- Not Implemented
                      "VERSION.NAME",
                      "DARKTABLE.VERSION",
                      "DARKTABLE.NAME",      -- Not Implemented
                      "SEQUENCE",
                      "WIDTH.SENSOR",
                      "HEIGHT.SENSOR",
                      "WIDTH.RAW",
                      "HEIGHT.RAW",
                      "WIDTH.CROP",
                      "HEIGHT.CROP",
                      "WIDTH.EXPORT",
                      "HEIGHT.EXPORT",
                      "WIDTH.MAX",           -- Not Implemented
                      "HEIGHT.MAX",          -- Not Implemented
                      "YEAR", 
                      "MONTH", 
                      "DAY", 
                      "HOUR", 
                      "MINUTE", 
                      "SECOND", 
                      "MSEC",
                      "EXIF.YEAR", 
                      "EXIF.MONTH", 
                      "EXIF.DAY",
                      "EXIF.HOUR", 
                      "EXIF.MINUTE", 
                      "EXIF.SECOND", 
                      "EXIF.MSEC",
                      "EXIF.DATE.REGIONAL",  -- Not Implemented
                      "EXIF.TIME.REGIONAL",  -- Not Implemented
                      "EXIF.ISO",
                      "EXIF.EXPOSURE",
                      "EXIF.EXPOSURE.BIAS",
                      "EXIF.APERTURE",
                      "EXIF.FOCAL.LENGTH",
                      "EXIF.FOCUS.DISTANCE",
                      "LONGITUDE",
                      "LATITUDE",
                      "ALTITUDE",
                      "STARS", 
                      "RATING.ICONS",        -- Not Implemented
                      "LABELS",
                      "LABELS.ICONS",        -- Not Implemented 
                      "MAKER", 
                      "MODEL", 
                      "TITLE",
                      "DESCRIPTION",
                      "CREATOR", 
                      "PUBLISHER", 
                      "RIGHTS", 
                      "TAGS",                -- Not Implemented
                      "CATEGORY",            -- Not Implemented
                      "SIDECAR.TXT",         -- Not Implemented
                      "FOLDER.PICTURES",
                      "FOLDER.HOME", 
                      "FOLDER.DESKTOP",
                      "OPENCL.ACTIVATED",    -- Not Implemented
                      "USERNAME",
                      "NL",
                      "JOBCODE"              -- Not Implemented
}

local PS = dt.configuration.running_os == "windows" and  "\\"  or  "/"
local USER = os.getenv("USERNAME")
local HOME =  dt.configuration.running_os == "windows" and  os.getenv("HOMEPATH") or os.getenv("HOME")
local PICTURES = HOME .. PS .. (dt.configuration.running_os == "windows" and "My Pictures" or "Pictures")
local DESKTOP = HOME .. PS .. "Desktop"

local function get_colorlabels(image)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  local colorlabels = {}
  if image.red then table.insert(colorlabels, "red") end
  if image.yellow then table.insert(colorlabels, "yellow") end
  if image.green then table.insert(colorlabels, "green") end
  if image.blue then table.insert(colorlabels, "blue") end
  if image.purple then table.insert(colorlabels, "purple") end
  local labels = #colorlabels == 1 and colorlabels[1] or du.join(colorlabels, ",")
  log.log_level(old_log_level)
  return labels 
end

dtutils_string.libdoc.functions["build_substitution_list"] = {
  Name = [[build_substitution_list]],
  Synopsis = [[build a list of variable substitutions]],
  Usage = [[local ds = require "lib/dtutils.string"
    ds.build_substitution_list(image, sequence, [username], [pic_folder], [home], [desktop])
      image - dt_lua_image_t - the image being processed
      sequence - integer - the sequence number of the image
      [username] - string - optional - user name.  Will be determined if not supplied
      [pic_folder] - string - optional - pictures folder name.  Will be determined if not supplied
      [home] - string - optional - home directory.  Will be determined if not supplied
      [desktop] - string - optional - desktop directory.  Will be determined if not supplied]],
  Description = [[build_substitution_list populates variables with values from the arguments
    and determined from the system and darktable.]],
  Return_Value = [[]],
  Limitations = [[If the value for a variable can not be determined, or if it is not supported,
    then an empty string is used for the value.]],
  Example = [[]],
  See_Also = [[https://docs.darktable.org/usermanual/4.2/en/special-topics/variables/]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.build_substition_list(image, sequence, username, pic_folder, home, desktop)
  -- build the argument substitution list from each image

  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)

  local is_api_9_1 = true
  if dt.configuration.api_version_string < "9.1.0" then
    is_api_9_1 = false 
  end

  local datetime = os.date("*t")
  local user_name = username or USER
  local pictures_folder = pic_folder or PICTURES
  local home_folder = home or HOME
  log.msg(log.info, "home is " .. tostring(home) .. " and HOME is " .. tostring(HOME) .. " and home_folder is " .. tostring(home_folder))
  local desktop_folder = desktop or DESKTOP

  local labels = get_colorlabels(image)
  log.msg(log.info, "image date time taken is " .. image.exif_datetime_taken)
  local eyear, emon, eday, ehour, emin, esec, emsec
  if dt.preferences.read("darktable", "lighttable/ui/milliseconds", "bool") and is_api_9_1 then
    eyear, emon, eday, ehour, emin, esec, emsec = 
      string.match(image.exif_datetime_taken, "(%d+):(%d+):(%d+) (%d+):(%d+):(%d+)%.(%d+)$")
  else
    emsec = "0"
    eyear, emon, eday, ehour, emin, esec = 
      string.match(image.exif_datetime_taken, "(%d+):(%d+):(%d+) (%d+):(%d+):(%d+)$")
  end
  local replacements = {image.film,                            -- ROLL.NAME
                        image.path,                            -- FILE.FOLDER
                        image.filename,                        -- FILE.NAME
                        dtutils_string.get_filetype(image.filename),-- FILE.EXTENSION
                        image.id,                              -- ID
                        image.duplicate_index,                 -- VERSION
                        "",                                    -- VERSION.IF_MULTI
                        image.version_name,                    -- VERSION.NAME
                        dt.configuration.version,              -- DARKTABLE.VERSION
                        "",                                    -- DARKTABLE.NAME
                        sequence,                              -- SEQUENCE
                        image.width,                           -- WIDTH.SENSOR
                        image.height,                          -- HEIGHT.SENSOR
                        is_api_9_1 and image.p_width or "",    -- WIDTH.RAW
                        is_api_9_1 and image.p_height or "",   -- HEIGHT.RAW
                        is_api_9_1 and image.final_width or "", -- WIDTH.CROP
                        is_api_9_1 and image.final_height or "", -- HEIGHT.CROP
                        is_api_9_1 and image.final_width or "",  -- WIDTH.EXPORT
                        is_api_9_1 and image.final_height or "", -- HEIGHT.EXPORT
                        "",                                    -- WIDTH.MAX
                        "",                                    -- HEIGHT.MAX
                        string.format("%4d", datetime.year),   -- YEAR
                        string.format("%02d", datetime.month), -- MONTH
                        string.format("%02d", datetime.day),   -- DAY
                        string.format("%02d", datetime.hour),  -- HOUR
                        string.format("%02d", datetime.min),   -- MINUTE
                        string.format("%02d", datetime.sec),   -- SECOND
                        "",                                    -- MSEC
                        eyear,                                 -- EXIF.YEAR
                        emon,                                  -- EXIF.MONTH
                        eday,                                  -- EXIF.DAY
                        ehour,                                 -- EXIF.HOUR
                        emin,                                  -- EXIF.MINUTE
                        esec,                                  -- EXIF.SECOND
                        emsec,                                 -- EXIF.MSEC
                        "",                                    -- EXIF.DATE.REGIONAL
                        "",                                    -- EXIF.TIME.REGIONAL
                        string.format("%d", image.exif_iso),   -- EXIF.ISO
                        string.format("1/%.0f", 1./image.exif_exposure), -- EXIF.EXPOSURE
                        image.exif_exposure_bias,              -- EXIF.EXPOSURE.BIAS
                        string.format("%.01f", image.exif_aperture), -- EXIF.APERTURE
                        string.format("%.0f", image.exif_focal_length), -- EXIF.FOCAL.LENGTH
                        image.exif_focus_distance,             -- EXIF.FOCUS.DISTANCE
                        image.longitude or "",                 -- LONGITUDE
                        image.latitude or "",                  -- LATITUDE
                        image.elevation or "",                 -- ALTITUDE
                        image.rating,                          -- STARS
                        "",                                    -- RATING.ICONS
                        labels,                                -- LABELS
                        "",                                    -- LABELS.ICONS
                        image.exif_maker,                      -- MAKER
                        image.exif_model,                      -- MODEL
                        image.title,                           -- TITLE
                        image.description,                     -- DESCRIPTION
                        image.creator,                         -- CREATOR
                        image.publisher,                       -- PUBLISHER
                        image.rights,                          -- RIGHTS
                        "",                                    -- TAGS
                        "",                                    -- CATEGORYn
                        "",                                    -- SIDECAR.TXT
                        pictures_folder,                       -- FOLDER.PICTURES
                        home_folder,                           -- FOLDER.HOME
                        desktop_folder,                        -- FOLDER.DESKTOP
                        "",                                    -- OPENCL.ACTIVATED
                        user_name,                             -- USERNAME
                        "\n",                                  -- NL
                        ""                                     -- JOBCODE
  }

  for i = 1, #PLACEHOLDERS, 1 do 
    substitutes[PLACEHOLDERS[i]] = replacements[i] 
    log.msg(log.info, "setting " .. PLACEHOLDERS[i] .. " to " .. tostring(replacements[i]))
  end
  log.log_level(old_log_level)
end

local function check_legacy_vars(var_name)
  local var = var_name
  if string.match(var, "_") then
    var = string.gsub(var, "_", ".")
  end
  if string.match(var, "^HOME$") then var = "FOLDER.HOME" end
  if string.match(var, "^PICTURES.FOLDER$") then var = "FOLDER.PICTURES" end
  if string.match(var, "^DESKTOP$") then var = "FOLDER.DESKTOP" end
  return var 
end

local function treat(var_string)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  local ret_val = ""
  -- remove the var from the string
  local var = string.match(var_string, "[%a%._]+")
  var = check_legacy_vars(var)
  log.msg(log.info, "var_string is " .. tostring(var_string) .. " and var is " .. tostring(var))
  ret_val = substitutes[var]
  if not ret_val then
    log.msg(log.error, "variable " .. var .. " is not an allowed variable, returning empty value")
    log.log_level(old_log_level)
    return ""
  end
  local args = string.gsub(var_string, var, "")
  log.msg(log.info, "args is " .. tostring(args))
  if string.len(args) > 0 then
    if string.match(args, '^%^%^') then
      ret_val = string.upper(ret_val)
    elseif string.match(args, "^%^") then
      ret_val = string.gsub(ret_val, "^%a", string.upper, 1)
    elseif string.match(args, "^,,") then
      ret_val = string.lower(ret_val)
    elseif string.match(args, "^,") then
      ret_val = string.gsub(ret_val, "^%a", string.lower, 1)
    elseif string.match(args, "^:%-?%d+:%-?%d+") then
      local soffset, slen = string.match(args, ":(%-?%d+):(%-?%d+)")
      log.msg(log.info, "soffset is " .. soffset .. " and slen is " .. slen)
      if tonumber(soffset) >= 0 then
        soffset = soffset + 1
      end
      log.msg(log.info, "soffset is " .. soffset .. " and slen is " .. slen)
      if tonumber(soffset) < 0 and tonumber(slen) < 0 then
        local temp = soffset
        soffset = slen 
        slen = temp 
      end
      log.msg(log.info, "soffset is " .. soffset .. " and slen is " .. slen)
      ret_val = string.sub(ret_val, soffset, slen)
      log.msg(log.info, "ret_val is " .. ret_val)
    elseif string.match(args, "^:%-?%d+") then
      local soffset= string.match(args, ":(%-?%d+)")
      if tonumber(soffset) >= 0 then
        soffset = soffset + 1
      end
      ret_val = string.sub(ret_val, soffset, -1)
    elseif string.match(args, "^-%$%(.-%)") then
      local replacement = string.match(args, "-%$%(([%a%._]+)%)")
      replacement = check_legacy_vars(replacement)
      if string.len(ret_val) == 0 then
        ret_val = substitutes[replacement]
      end
    elseif string.match(args, "^-.+$") then
      local replacement = string.match(args, "-(.+)$")
      if string.len(ret_val) == 0 then
        ret_val = replacement
      end
    elseif string.match(args, "^+.+") then
      local replacement = string.match(args, "+(.+)")
      if string.len(ret_val) > 0 then
        ret_val = replacement
      end
    elseif string.match(args, "^#.+") then
      local pattern = string.match(args, "#(.+)")
      log.msg(log.info, "pattern to remove is " .. tostring(pattern))
      ret_val = string.gsub(ret_val, "^" .. dtutils_string.sanitize_lua(pattern), "")
    elseif string.match(args, "^%%.+") then
      local pattern = string.match(args, "%%(.+)")
      ret_val = string.gsub(ret_val, pattern .. "$", "")
    elseif string.match(args, "^//.-/.+") then
      local pattern, replacement = string.match(args, "//(.-)/(.+)")
      ret_val = string.gsub(ret_val, pattern, replacement)
     elseif string.match(args, "^/#.+/.+") then
      local pattern, replacement = string.match(args, "/#(.+)/(.+)")
      ret_val = string.gsub(ret_val, "^" .. pattern, replacement, 1)
    elseif string.match(args, "^/%%.-/.+") then
      local pattern, replacement = string.match(args, "/%%(.-)/(.+)")
      ret_val = string.gsub(ret_val, pattern .. "$", replacement)
   elseif string.match(args, "^/.-/.+") then
      log.msg(log.info, "took replacement branch")
      local pattern, replacement = string.match(args, "/(.-)/(.+)")
      ret_val = string.gsub(ret_val, pattern, replacement, 1)
    end
  end
  log.log_level(old_log_level)
  return ret_val
end

dtutils_string.libdoc.functions["substitute_list"] = {
  Name = [[substitute_list]],
  Synopsis = [[Replace variables in a string with their computed values]],
  Usage = [[local ds = require "lib/dtutils.string"
    local result = ds.substitute_list(str)
      str - string - the string containing the variables to be substituted for]],
  Description = [[substitute_list replaces the variables in the supplied string with
    values computed in build_substitution_list().]],
  Return_Value = [[result - string - the input string with values substituted for the variables]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.substitute_list(str)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  -- replace the substitution variables in a string
  for match in string.gmatch(str, "%$%(.-%)?%)") do
    local var = string.match(match, "%$%((.-%)?)%)")
    local treated_var = treat(var)
    log.msg(log.info, "var is " .. var .. " and treated var is " .. tostring(treated_var))
    str = string.gsub(str, "%$%(".. dtutils_string.sanitize_lua(var) .."%)", tostring(treated_var))
    log.msg(log.info, "str after replacement is " .. str)
  end
  log.log_level(old_log_level)
  return str
end

dtutils_string.libdoc.functions["clear_substitute_list"] = {
  Name = [[clear_substitute_list]],
  Synopsis = [[Clear the computed list of variable substitution values]],
  Usage = [[local ds = require "lib/dtutils.string"
    ds.clear_substitute_list()]],
  Description = [[clear_substitute_list resets the list of variable replacement values]],
  Return_Value = [[]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.clear_substitute_list()
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  for i = 1, #PLACEHOLDERS, 1 do 
    substitutes[PLACEHOLDERS[i]] = nil 
  end
  log.log_level(old_log_level)
end

dtutils_string.libdoc.functions["substitute"] = {
  Name = [[substitute]],
  Synopsis = [[Check if a string has been sanitized]],
  Usage = [[local ds = require "lib/dtutils.string"
    ds.substitute(image, sequence, [username], [pic_folder], [home], [desktop])
      image - dt_lua_image_t - the image being processed
      sequence - integer - the sequence number of the image
      [username] - string - optional - user name.  Will be determined if not supplied
      [pic_folder] - string - optional - pictures folder name.  Will be determined if not supplied
      [home] - string - optional - home directory.  Will be determined if not supplied
      [desktop] - string - optional - desktop directory.  Will be determined if not supplied]],
  Description = [[substitute initializes the substitution list by calling clear_substitute_list(),
    then builds the substitutions by calling build_substitution_list() and finally does the 
    substitution by calling substitute_list(), then returns the result string.]],
  Return_Value = [[result - string - the input string with values substituted for the variables]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils_string.substitute(image, sequence, variable_string, username, pic_folder, home, desktop)
  local old_log_level = log.log_level()
  log.log_level(dtutils_string.log_level)
  dtutils_string.clear_substitute_list()
  dtutils_string.build_substition_list(image, sequence, username, pic_folder, home, desktop)  
  local str = dtutils_string.substitute_list(variable_string)
  log.log_level(old_log_level)
  return str
end



return dtutils_string
