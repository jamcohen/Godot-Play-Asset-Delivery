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
# Class that creates a fake PlayAssetDelivery Android plugin, mocking the 
# behaviour of the Java API. Provides helper functions that allow us to configure
# returned object and side effects of PlayAssetDelivery plugin calls.
#
# ##############################################################################
class_name FakeAndroidPlugin
extends Object

var _asset_pack_location_store : Dictionary

func _init():
	_asset_pack_location_store = Dictionary()

func add_asset_pack_location(_pack_name : String, _asset_pack_location_dict : Dictionary):
	_asset_pack_location_store[_pack_name] = _asset_pack_location_dict

func remove_asset_pack_location(_pack_name : String):
	_asset_pack_location_store.erase(_pack_name)

func clear_asset_pack_location_store():
	_asset_pack_location_store.clear()

func getPackLocation(_pack_name : String):
	if _pack_name in _asset_pack_location_store:
		return _asset_pack_location_store[_pack_name]
	return null
