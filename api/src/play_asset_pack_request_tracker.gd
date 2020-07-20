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

const _SIGNAL_ID_MIN = 0

var _signal_id_counter : int
var _register_request_mutex : Mutex
var _signal_id_to_request_map : Dictionary

func _init():
	_signal_id_counter = _SIGNAL_ID_MIN
	_signal_id_to_request_map = Dictionary()
	_register_request_mutex = Mutex.new()

func get_current_signal_id() -> int:
	return _signal_id_counter

# registers the request object and returns the signal_id assigned
func register_request(request : PlayAssetPackRequest) -> int:
	# since we read _signal_id_counter at start and increment at end of this function,
	# we need to make it a critical section
	_register_request_mutex.lock()
	var return_signal_id = _signal_id_counter
	_signal_id_to_request_map[_signal_id_counter] = request
	_signal_id_counter += 1
	_register_request_mutex.unlock()
	return return_signal_id

func lookup_request(signal_id : int) -> PlayAssetPackRequest:
	if signal_id in _signal_id_to_request_map:
		return _signal_id_to_request_map[signal_id]
	return null

func unregister_request(signal_id : int) -> void:
	if signal_id in _signal_id_to_request_map:
		_signal_id_to_request_map.erase(signal_id)

