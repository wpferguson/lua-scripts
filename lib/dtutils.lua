local dtutils = {}

dtutils.libdoc = {
  Name = [[dtutils]],
  Synopsis = [[A Darktable lua utilities library]],
  Usage = [[local du = require "lib/dtutils"]],
  Description = [[dtutils provides a common library of functions used to build
    lua scripts. There are also sublibraries that provide more functions.]],
  Return_Value = [[du - library - the library of functions]],
  Limitations = [[]],
  Example = [[]],
  See_Also = [[dtutils.debug(3), dtutils.file(3), dtutils.log(3), dtutils.string(3)]],
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
  Copyright = [[Copyright (C) 2016 Bill Ferguson <wpferguson@gmail.com>.
    Copyright (C) 2016 Tobias Jakobs]],
  functions = {}
}

local dt = require "darktable"

local log = require "lib/dtutils.log"

local gettext = dt.gettext

-- Tell gettext where to find the .mo file translating messages for a particular domain
gettext.bindtextdomain("scripts",dt.configuration.config_dir.."/lua/locale/")

local function _(msgid)
    return gettext.dgettext("scripts", msgid)
end


dtutils.libdoc.functions["check_min_api_version"] = {
  Name = [[check_min_api_version]],
  Synopsis = [[check the minimum required api version against the current api version]],
  Usage = [[local du = require "lib/dtutils"

    local result = du.check_min_api_version(min_api, script_name)
      min_api - string - the api version that the application was written for (example: "5.0.0")
      script_name - string - the name of the script]],
  Description = [[check_min_api_version compares the minimum api required for the appllication to
    run against the current api version. The minimum api version is typically the api version that 
    was current when the application was created. If the minimum api version is not met, then an 
    error message is printed saying the script_name failed to load, then an error is thrown causing the
    program to stop executing. 

    This function is intended to replace darktable.configuration.check_version(). The application code
    won't have to be updated each time the api changes because this only checks the minimum version required.]],
  Return_Value = [[result - true if the minimum api version is available, false if not.]],
  Limitations = [[When using the default handler on a script being executed from the luarc file, the error thrown
    will stop the luarc file from executing any remaining statements. This limitation does not apply to script_manger.]],
  Example = [[check_min_api_version("5.0.0") does nothing if the api is greater or equal to 5.0.0 otherwise an
    error message is printed and an error is thrown stopping execution of the script.]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils.check_min_api_version(min_api, script_name)
  local current_api = dt.configuration.api_version_string
  if min_api > current_api then
    dt.print_error(_("This application is written for lua api version ") .. min_api .. _(" or later."))
    dt.print_error(_("The current lua api version is ") .. current_api)
    dt.print(_("ERROR: ") .. script_name .. _(" failed to load. Lua API version ") .. min_api .. _(" or later required."))
    error(_("Minimum API ") .. min_api .. _(" not met for ") .. script_name .. ".", 0)
  end
end

dtutils.libdoc.functions["split"] = {
  Name = [[split]],
  Synopsis = [[split a string on a specified separator]],
  Usage = [[local du = require "lib/dtutils"

    local result = du.split(str, pat)
      str - string - the string to split
      pat - string - the pattern to split on]],
  Description = [[split separates a string into a table of strings.  The strings are separated at each
    occurrence of the supplied pattern. The pattern may be any pattern as described in the lua docs.
    Each match of the pattern is consumed and not returned.]],
  Return_Value = [[result - a table of strings on success, or an empty table on error]],
  Limitations = [[]],
  Example = [[split("/a/long/path/name/to/a/file.txt", "/") would return a table like
      {a, "long", "path", "name", "to", a, "file.txt"}]],
  See_Also = [[]],
  Reference = [[http://lua-users.org/wiki/SplitJoin]],
  License = [[]],
  Copyright = [[]],
}

function dtutils.split(str, pat)
   local t = {}
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
        table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

dtutils.libdoc.functions["join"] = {
  Name = [[join]],
  Synopsis = [[join a table of strings with a specified separator]],
  Usage = [[local du = require "lib/dtutils"

    local result = du.join(tabl, pat)
      tabl - a table of strings
      pat - a separator]],
  Description = [[join assembles a table of strings into a string with the specified pattern 
    in between each string]],
  Return_Value = [[result - string - the joined string on success, or an empty string on failure]],
  Limitations = [[]],
  Example = [[join({a, "long", "path", "name", "to", a, "file.txt"}, " ") would return the string
      "a long path name to a file.txt"]],
  See_Also = [[]],
  Reference = [[http://lua-users.org/wiki/SplitJoin]],
  License = [[]],
  Copyright = [[]],
}

function dtutils.join(tabl, pat)
  returnstr = ""
  for i,str in pairs(tabl) do
    returnstr = returnstr .. str .. pat
  end
  return string.sub(returnstr, 1, -(pat:len() + 1))
end

--[[
  NAME
    prequire - a protected lua require

  SYNOPSIS
    local du = require "lib/dtutils"

    local result = du.prequire(req_name)
      req_name - the filename of the lua code to load without the ".lua" filetype

  DESCRIPTION
    prequire is a protected require that can survive an error in the code being loaded without
    bringing down the calling routine.

  RETURN VALUE
    result - the code or true on success, otherwise an error message

  EXAMPLE
    prequire("lib/dtutils.file") which would load lib/dtutils/file.lua

]]

dtutils.libdoc.functions["prequire"] = {
  Name = [[prequire]],
  Synopsis = [[a protected lua require]],
  Usage = [[local du = require "lib/dtutils"

    local status, lib = du.prequire(req_name)
      req_name - the filename of the lua code to load without the ".lua" filetype]],
  Description = [[prequire is a protected require that can survive an error in the code being loaded without
    bringing down the calling routine.]],
  Return_Value = [[status - boolean - true on success
    lib - if status is true, then the code, otherwise an error message]],
  Limitations = [[]],
  Example = [[local status, lib = prequire("lib/dtutils.file") which would load lib/dtutils/file.lua which 
    would return a status of true and the reference to the library in lib.]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils.prequire(req_name)
  local status, lib = pcall(require, req_name)
  if status then
    log.msg(log.info, _("Loaded ") .. req_name)
  else
    log.msg(log.info, _("Error loading ") .. req_name)
  end
  return status, lib
end

dtutils.libdoc.functions["spairs"] = {
  Name = [[spairs]],
  Synopsis = [[an iterator that provides sorted pairs from a table]],
  Usage = [[local du = require "lib/dtutils"

    for key, value in du.spairs(t, order) do
      t - table - table of key, value pairs
      order - function - an optional function to sort the pairs
                         if none is supplied, table.sort() is used]],
  Description = [[spairs is an iterator that returns key, value pairs from a table in sorted
    order.  The sorting order is the result of table.sort() if no function is 
    supplied, otherwise sorting is done as specified in the function.]],
  Return_Value = [[]],
  Limitations = [[]],
  Example = [[HighScore = { Robin = 8, Jon = 10, Max = 11 }

    -- basic usage, just sort by the keys
    for k,v in spairs(HighScore) do
      print(k,v)
    end
    --> Jon     10
    --> Max     11
    --> Robin   8

    -- this uses an custom sorting function ordering by score descending
    for k,v in spairs(HighScore, function(t,a,b) return t[b] < t[a] end) do
      print(k,v)
    end
    --> Max     11
    --> Jon     10
    --> Robin   8]],
  See_Also = [[]],
  Reference = [[Code copied from http://stackoverflow.com/questions/15706270/sort-a-table-in-lua]],
  License = [[]],
  Copyright = [[]],
}

-- Sort a table
function dtutils.spairs(_table, order) -- Code copied from http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
  -- collect the keys
  local keys = {}
  for _key in pairs(_table) do keys[#keys + 1] = _key end

  -- if order function given, sort by it by passing the table and keys a, b,
  -- otherwise just sort the keys 
  if order then
    table.sort(keys, function(a,b) return order(_table, a, b) end)
  else
    table.sort(keys)
  end

  -- return the iterator function
  local i = 0
  return function()
    i = i + 1
    if keys[i] then
      return keys[i], _table[keys[i]]
    end
  end
end

dtutils.libdoc.functions["check_os"] = {
  Name = [[check_os]],
  Synopsis = [[check that the operating system is supported]],
  Usage = [[local du = require "lib/dtutils"

    local result = du.check_os(operating_systems)
      operating_systems - a table of operating system names such as {"windows","linux","macos","unix"}]],
  Description = [[check_os checks a supplied table of operating systems against the operating system the
    script is running on and returns true if the OS is in the list, otherwise false]],
  Return_Value = [[result - boolean - true if the operating system is supported, false if not.]],
  Limitations = [[]],
  Example = [[local du = require "lib/dtutils"
              if du.check_os({"windows"}) then
                -- run the script
              else
                dt.print("Script <script name> only runs on windows")
                return
              end]],
  See_Also = [[]],
  Reference = [[]],
  License = [[]],
  Copyright = [[]],
}

function dtutils.check_os(operating_systems)
  for _,os in pairs(operating_systems) do
    if dt.configuration.running_os == os then
      return true
    end
  end
  return false
end

return dtutils
