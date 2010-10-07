<?php

///////////////////////////////////////////////////////////////////////
// Copyright 2007, Wiebe Cazemier
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
///////////////////////////////////////////////////////////////////////


define('GREEN_BEGIN', "\033[01;32m");
define('YELLOW_BEGIN', "\033[01;33m");
define('RED_BEGIN', "\033[01;31m");
define('COLOR_END', "\033[00m");

function echo_green($text)
{
  echo GREEN_BEGIN . "$text" . COLOR_END . "\n";
}

function echo_yellow($text)
{
  echo YELLOW_BEGIN . "$text" . COLOR_END . "\n";
}

function die_red($text)
{
  die(RED_BEGIN . "$text" . COLOR_END . "\n");
}


?>
