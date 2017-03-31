# namemunge
if [ -z "$(type -t namemunge)" ] ; then

# path munge.
namemunge () {
  if ! echo ${!1} | egrep -q "(^|:)$2($|:)" ; then
    if [ -z "${!1}" ] ; then
      eval "$1=$2"
    else
      if [ "$3" == "after" ] ; then
        eval "$1=\$$1:$2"
      else
        eval "$1=$2:\$$1"
      fi
    fi
  fi
  eval "export $1"
}

fi # end namemunge

# nameremove
if [ -z "$(type -t nameremove)" ] ; then

# see http://stackoverflow.com/a/370192/1805420
nameremove () {
  eval "export $1=$(echo -n ${!1} | awk -v RS=: -v ORS=: -v var="$2" '$0 != var' | sed 's/:*$//')"
}

fi # end nameremove

# source_if
if [ -z "$(type -t source_if)" ] ; then

source_if () {
  test -f "$1" && source "$1"
}

fi # end source_if

# vim: set et nu nobomb fenc=utf8 ft=sh ff=unix sw=2 ts=2:
