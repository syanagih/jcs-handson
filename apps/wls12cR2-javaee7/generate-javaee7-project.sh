#!/bin/sh

# ##################################################
# Maven Java EE 7 WebApp Project Generator
PROGNAME=$(basename $0)
VERSION="1.0.0"
#
# HISTORY:
#
# * 17/09/13 - v1.0.0  - First Creation
#
# ##################################################

function mainScript() {

  # Create maven directory
  if [ ! -d ./maven ]; then
    mkdir maven
  fi

  cd maven
  mvn archetype:generate \
    -DarchetypeGroupId=org.codehaus.mojo.archetypes \
    -DarchetypeArtifactId=webapp-javaee7 \
    -DarchetypeVersion=1.1 \
    -DinteractiveMode=false \
    -DgroupId=${GROUP_ID} \
    -DartifactId=${ARTIFACT_ID} \
    -Dversion=1.0.0-SNAPSHOT \
    -Dpackage=${GROUP_ID} \
    --batch-mode \
    --update-snapshots
}

function usage() {
  cat <<EOF 1>&2
$(basename ${0}) is a tool for ...
Usage:
  $(basename ${0}) -b GROUP_ID -a ARTIFACT_ID

  Options:
      -g, --groupid     Maven Group ID: Used for Java package name
      -a, --artifactid  Maven Artifact ID: Used for Java application name
EOF
}

# Check Arguments
if [ $# -ne 4 ]; then
  usage
  exit 1
fi

# Handle Options
for OPT in "$@"
do
  case "$OPT" in
    '-v'|'--version' )
      echo "$(basename ${0}) ${VERSION}"
      exit 0
      ;;
    '-h'|'--help' )
      usage
      exit 0
      ;;
    '-d'|'--debug' )
      set -x
      ;;
    '-g'|'--groupid' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      GROUP_ID="$2"
      shift 2
      ;;
    '-a'|'--artifactid' )
      if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
        echo "$PROGNAME: option requires an argument -- $1" 1>&2
        exit 1
      fi
      ARTIFACT_ID="$2"
      shift 2
      ;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        param+=( "$1" )
        shift 1
      fi
      ;;
  esac
done



# Create .gitignore
if [ ! -e ./.gitignore ]; then
cat << EOF > .gitignore
maven/${ARTIFACT_ID}/target/
EOF
fi

mainScript
