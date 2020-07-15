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
extends "res://addons/gut/test.gd"

func test_play_asset_pack_state_valid():
	var test_dict = {
		"name": "assetPack", 
		"status": PlayAssetPackManager.AssetPackStatus.DOWNLOADING, 
		"errorCode": PlayAssetPackManager.AssetPackErrorCode.NO_ERROR,
		"bytesDownloaded": 562,
		"totalBytesToDownload": 1337,
		"transferProgressPercentage": 42
	}
	var test_object = PlayAssetPackState.new(test_dict)
	
	assert_eq(test_object.get_name(), "assetPack")
	assert_eq(test_object.get_status(), PlayAssetPackManager.AssetPackStatus.DOWNLOADING)
	assert_eq(test_object.get_error_code(), PlayAssetPackManager.AssetPackErrorCode.NO_ERROR)
	assert_eq(test_object.get_bytes_downloaded(), 562)
	assert_eq(test_object.get_total_bytes_to_download(), 1337)
	assert_eq(test_object.get_transfer_progress_percentage(), 42)

func test_play_asset_pack_state_deepcopy():
	var test_dict = {
		"name": "assetPack", 
		"status": PlayAssetPackManager.AssetPackStatus.DOWNLOADING, 
		"errorCode": PlayAssetPackManager.AssetPackErrorCode.NO_ERROR,
		"bytesDownloaded": 562,
		"totalBytesToDownload": 1337,
		"transferProgressPercentage": 42
	}
	var test_object = PlayAssetPackState.new(test_dict)
	
	# alter the dictionary value passed to the constructor
	# object created should not be changed since we are doing deepcopy
	test_dict["name"] = "anotherPack"
	test_dict["erro_code"] = PlayAssetPackManager.AssetPackErrorCode.NETWORK_ERROR
	assert_eq(test_object.get_name(), "assetPack")
	assert_eq(test_object.get_status(), PlayAssetPackManager.AssetPackStatus.DOWNLOADING)
	assert_eq(test_object.get_error_code(), PlayAssetPackManager.AssetPackErrorCode.NO_ERROR)
	assert_eq(test_object.get_bytes_downloaded(), 562)
	assert_eq(test_object.get_total_bytes_to_download(), 1337)
	assert_eq(test_object.get_transfer_progress_percentage(), 42)
