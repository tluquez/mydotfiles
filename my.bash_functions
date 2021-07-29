# Custom functions
## Extract. Provided to me by Michael Wainberg
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

## a
function a {
[[ $# -lt 1 ]] || [[ $1 == "-h" ]] && {
    echo ""
    echo "description: routine to speed up editing of executable files on bash."
    echo "       usage: a [file_name]";
    echo "       example: a toyfile.sh";
    echo ""
    return 1;
}

FILENAME=$1
if [[ -f "${FILENAME}" ]]; then
  rm ${FILENAME}; vim -c 'startinsert' ${FILENAME}; chmod 755 ${FILENAME}
else
  vim -c 'startinsert' ${FILENAME}; chmod 755 ${FILENAME}
fi
}

## wsummary
function wsummary {
[[ $# -lt 1 ]] || [[ $1 == "-h" ]] && {
    echo ""
    echo "description: produces a summary of the weight of all files matching a glob expansion in the current directory."
    echo "       usage: wsummary [glob_expression_in_double_quotes]";
    echo "       example: wsummary \"*.bam\"";
    echo ""
    return 1;
}

GLOB=$1
find ./ -name "${GLOB}" -ls | awk '{if(min==""){min=max=$7}; if($7>max) {max=$7}; if($7<min) {min=$7}; {sum += $7; n++;}} END {print "mean="sum/n, "n="n, "min="min, "max="max}'
}

## nbytext
function nbytext {
[[ $# -lt 1 ]] || [[ $1 == "-h" ]] && {
    echo ""
    echo "description: outputs the number of files per each extension at provided extension resolution in provided directory."
    echo "       usage: nbytext [directory] [optional_resolution default=1]";
    echo "       example: nbytext \".\" from the last dot to the end";
    echo "       example: nbytext \".\" 2 from the second to last dot to the end";
    echo "       example: nbytext \".\" 3 from the third to last dot to the end";
    echo ""
    return 1;
}

DIR="$1"
EXTENSION="${2:- 1}"
find ${DIR} -maxdepth 1 -type f -printf '%f\n' | rev | cut -d '.' -f 1-${EXTENSION} | rev | sort | uniq -c
}
