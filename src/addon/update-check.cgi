#!/bin/tclsh
# Update-Check CGI fuer HB-AddOn — wird von der OpenCCU-WebUI ueber
# "Update: /addons/hb-addon/update-check.cgi" im info-Block aufgerufen.
# Liefert die VERSION-Datei vom main-Branch des GitHub-Repos als plain text;
# bei ?cmd=download Redirect zur Releases-Seite.

set checkURL    "https://raw.githubusercontent.com/maxx3105/HB-AddOn/main/src/addon/VERSION"
set downloadURL "https://github.com/maxx3105/HB-AddOn/releases/latest"

catch {
  set input $env(QUERY_STRING)
  set pairs [split $input &]
  foreach pair $pairs {
    if {0 != [regexp "^(\[^=]*)=(.*)$" $pair dummy varname val]} {
      set $varname $val
    }
  }
}

if { [info exists cmd ] && $cmd == "download"} {
  puts -nonewline "Content-Type: text/html; charset=utf-8\r\n\r\n"
  puts -nonewline "<html><head><meta http-equiv='refresh' content='0; url=$downloadURL' /></head><body></body></html>"
} else {
  puts -nonewline "Content-Type: text/plain; charset=utf-8\r\n\r\n"
  catch {
    set newversion [ exec /usr/bin/wget -qO- --no-check-certificate $checkURL ]
  }
  if { [info exists newversion] } {
    puts $newversion
  } else {
    puts "n/a"
  }
}
