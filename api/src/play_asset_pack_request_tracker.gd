# ##############################################################################
#
#	Copyright 2020 Google LLC
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#		https://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
#
# ##############################################################################
#
# The PlayAssetPackRequestTracker class generates unique signal_id integers and
# keeps a mapping of signal_id to Request objects. This signal_id is used as an
# identifier and passed to the Android plugin. Eventually the Android plugin will
# emit signals along with this signal_id. In this way we can know which signal 
# emitted from the plugin corresponds to which Request object
#
# ##############################################################################
class_name PlayAssetPackRequestTracker
extends Object

const _SIGNAL_ID_MAX = 9223372036854775807
const _SIGNAL_ID_MIN = 0

var _signal_id_counter : int
var _signal_id_to_request_map : Dictionary

func _init():
	# On first request's registration, _signal_id_counter should be incremented to _SIGNAL_ID_MIN
	_signal_id_counter = _SIGNAL_ID_MIN - 1
	_signal_id_to_request_map = Dictionary()

func get_current_signal_id() -> int:
	return _signal_id_counter

func _increment_to_next_available_signal_id():
	# increment _signal_id_counter to the next available value not registered in 
	# _signal_id_to_request_map
	_increment_signal_id()
	while _signal_id_counter in _signal_id_to_request_map:
		_increment_signal_id()

func _increment_signal_id() -> void:
	# increment _signal_id_counter while avoid integer overflow by wrapping around to 
	# _SIGNAL_ID_MIN
	if _signal_id_counter == _SIGNAL_ID_MAX:
		_signal_id_counter = _SIGNAL_ID_MIN - 1
	_signal_id_counter += 1

# registers the request object and returns the signal_id assigned
func register_request(request : PlayAssetPackRequest) -> int:
	_increment_to_next_available_signal_id()
	_signal_id_to_request_map[_signal_id_counter] = request
	return _signal_id_counter

func lookup_request(signal_id : int) -> PlayAssetPackRequest:
	if signal_id in _signal_id_to_request_map:
		return _signal_id_to_request_map[signal_id]
	return null

func unregister_request(signal_id : int) -> void:
	if signal_id in _signal_id_to_request_map:
		_signal_id_to_request_map.erase(signal_id)
