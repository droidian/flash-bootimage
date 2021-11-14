# flash-bootimage - Helper script to flash Android bootimages
# Copyright (C) 2020-2021 Eugenio "g7" Paolantonio <me@medesimo.eu>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of the <organization> nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

PLYMOUTH="$(which plymouth)"

debug() {
	if [ "${DEBUG}" == "yes" ]; then
		echo "D: $@"
	fi
}

info() {
	echo "I: $@"
}

warning() {
	echo "W: $@" >&2
}

error() {
	echo "E: $@" >&2
	exit 1
}

choose_application() {
	for candidate in ${@}; do
		app=$(whereis -b ${candidate} | head -n 1 | awk '{ print $2 }')
		if [ -n "${app}" ]; then
			echo "${app}"
			return 0
		fi
	done

	return 1
}

check_paths() {
	### Search for the existence of every supplied path, and
	### exits if one is not found
	for path in ${@}; do
		[ -e "${path}" ] || error "Unable to find ${path}"
	done
}

plymouth_message() {
	[ -x "${PLYMOUTH}" ] && ${PLYMOUTH} display-message --text="$@" || true
}
