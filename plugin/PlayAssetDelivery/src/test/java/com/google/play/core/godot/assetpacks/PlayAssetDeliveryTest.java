/*
 *  	Copyright 2020 Google LLC
 *
 *  	Licensed under the Apache License, Version 2.0 (the "License");
 *  	you may not use this file except in compliance with the License.
 *  	You may obtain a copy of the License at
 *
 *  		https://www.apache.org/licenses/LICENSE-2.0
 *
 *  	Unless required by applicable law or agreed to in writing, software
 *  	distributed under the License is distributed on an "AS IS" BASIS,
 *  	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  	See the License for the specific language governing permissions and
 *  	limitations under the License.
 */

package com.google.play.core.godot.assetpacks;

import static com.google.common.truth.Truth.assertThat;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyListOf;
import static org.mockito.Mockito.when;

import com.google.android.play.core.assetpacks.AssetPackLocation;
import com.google.android.play.core.assetpacks.AssetPackManager;
import com.google.play.core.godot.assetpacks.utils.AssetLocationFromDictionary;
import com.google.play.core.godot.assetpacks.utils.AssetPackLocationFromDictionary;
import com.google.play.core.godot.assetpacks.utils.AssetPackStatesFromDictionary;
import com.google.play.core.godot.assetpacks.utils.AssetPackStatesFromDictionaryTest;
import com.google.play.core.godot.assetpacks.utils.PlayAssetDeliveryUtils;
import java.util.List;
import java.util.Set;
import org.godotengine.godot.Dictionary;
import org.godotengine.godot.Godot;
import org.godotengine.godot.plugin.SignalInfo;
import org.junit.*;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

@RunWith(MockitoJUnitRunner.class)
public class PlayAssetDeliveryTest {

  @Mock Godot godotMock;
  @Mock AssetPackManager assetPackManagerMock;

  private PlayAssetDelivery createPlayAssetDeliveryInstance() {
    return new PlayAssetDelivery(godotMock) {
      @Override
      AssetPackManager getAssetPackManagerInstance(Godot godot) {
        return assetPackManagerMock;
      }
    };
  }

  @Test
  public void getPluginName() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    String actualName = testSubject.getPluginName();
    assertThat(actualName).isEqualTo("PlayAssetDelivery");
  }

  @Test
  public void getPluginMethods() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    List<String> actualList = testSubject.getPluginMethods();
    assertThat(actualList)
        .containsExactly(
            "cancel",
            "fetch",
            "getAssetLocation",
            "getPackLocation",
            "getPackLocations",
            "getPackStates",
            "removePack",
            "showCellularDataConfirmation");
  }

  @Test
  public void getPluginSignals() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    Set<SignalInfo> testSet = testSubject.getPluginSignals();

    SignalInfo assetPackStateUpdateSignal =
        new SignalInfo("assetPackStateUpdateSignal", String.class);
    SignalInfo fetchStateUpdated = new SignalInfo("fetchStateUpdated", String.class, Integer.class);
    SignalInfo fetchSuccess = new SignalInfo("fetchSuccess", String.class, Integer.class);
    SignalInfo fetchError = new SignalInfo("fetchError", String.class, Integer.class);
    SignalInfo getPackStatesSuccess =
        new SignalInfo("getPackStatesSuccess", String.class, Integer.class);
    SignalInfo getPackStatesError =
        new SignalInfo("getPackStatesError", String.class, Integer.class);
    SignalInfo removePackSuccess = new SignalInfo("removePackSuccess", String.class, Integer.class);
    SignalInfo removePackError =
        new SignalInfo("removePackError", String.class, String.class, Integer.class);
    SignalInfo showCellularDataConfirmationSuccess =
        new SignalInfo("showCellularDataConfirmationSuccess", Integer.class, Integer.class);
    SignalInfo showCellularDataConfirmationError =
        new SignalInfo("showCellularDataConfirmationError", String.class, Integer.class);
    assertThat(testSet)
        .containsExactly(
            assetPackStateUpdateSignal,
            fetchStateUpdated,
            fetchSuccess,
            fetchError,
            getPackStatesSuccess,
            getPackStatesError,
            removePackSuccess,
            removePackError,
            showCellularDataConfirmationSuccess,
            showCellularDataConfirmationError);
  }

  @Test
  public void cancel_success() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    String[] testPackNames = {"Test pack 1", "Test pack 2"};
    Dictionary testDict = AssetPackStatesFromDictionaryTest.createDefaultTestDictionary();

    when(assetPackManagerMock.cancel(anyListOf(String.class)))
        .thenReturn(new AssetPackStatesFromDictionary(testDict));

    Dictionary resultDict = testSubject.cancel(testPackNames);
    assertThat(resultDict).isEqualTo(testDict);
  }

  @Test
  public void getAssetLocation_exist() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    Dictionary testDict =
        PlayAssetDeliveryUtils.constructAssetLocationDictionary(0, "~/Documents/", 256);

    when(assetPackManagerMock.getAssetLocation(any(String.class), any(String.class)))
        .thenReturn(new AssetLocationFromDictionary(testDict));

    Dictionary resultDict = testSubject.getAssetLocation("packName", "assetPath");
    assertThat(resultDict).isEqualTo(testDict);
  }

  @Test
  public void getAssetLocation_not_exist() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    Dictionary testDict = new Dictionary();

    when(assetPackManagerMock.getAssetLocation(any(String.class), any(String.class)))
        .thenReturn(null);

    Dictionary resultDict = testSubject.getAssetLocation("packName", "assetPath");
    assertThat(resultDict).isEqualTo(testDict);
  }

  @Test
  public void getPackLocation_exist() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    Dictionary testDict =
        PlayAssetDeliveryUtils.constructAssetPackLocationDictionary(
            "~/Documents/assetsPath/", 0, "~/Documents/path/");

    when(assetPackManagerMock.getPackLocation(any(String.class)))
        .thenReturn(new AssetPackLocationFromDictionary(testDict));

    Dictionary resultDict = testSubject.getPackLocation("packName");
    assertThat(resultDict).isEqualTo(testDict);
  }

  @Test
  public void getPackLocation_not_exist() {
    PlayAssetDelivery testSubject = createPlayAssetDeliveryInstance();
    Dictionary testDict = new Dictionary();

    when(assetPackManagerMock.getPackLocation(any(String.class))).thenReturn(null);

    Dictionary resultDict = testSubject.getPackLocation("packName");
    assertThat(resultDict).isEqualTo(testDict);
  }

  @Test
  public void getPackLocations_exist() {

  }

  @Test
  public void getPackLocations_not_exist() {

  }
}
