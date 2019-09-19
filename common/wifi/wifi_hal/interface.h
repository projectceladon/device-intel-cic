/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#pragma once

#include <wifi_hal.h>

#include <stdint.h>
#include <string>

class Netlink;
class NetlinkMessage;

class Interface {
public:
    Interface(Netlink& netlink, const char* name);
    Interface(Interface&& other);

    bool init();

    wifi_error getSupportedFeatureSet(feature_set* set);
    wifi_error getName(char* name, size_t size);
    wifi_error getLinkStats(wifi_request_id requestId,
                            wifi_stats_result_handler handler);
    wifi_error setLinkStats(wifi_link_layer_params params);
    wifi_error setAlertHandler(wifi_request_id id, wifi_alert_handler handler);
    wifi_error resetAlertHandler(wifi_request_id id);
    wifi_error getFirmwareVersion(char* buffer, size_t size);
    wifi_error getDriverVersion(char* buffer, size_t size);
    wifi_error setScanningMacOui(oui scan_oui);
    wifi_error clearLinkStats(u32 requestMask,
                              u32* responseMask,
                              u8 request,
                              u8* response);
    wifi_error getValidChannels(int band,
                                int maxChannels,
                                wifi_channel* channels,
                                int* numChannels);
    wifi_error startLogging(u32 verboseLevel,
                            u32 flags,
                            u32 maxIntervalSec,
                            u32 minDataSize,
                            char* ringName);
    wifi_error setCountryCode(const char* countryCode);
    wifi_error setLogHandler(wifi_request_id id,
                             wifi_ring_buffer_data_handler handler);
    wifi_error getRingBuffersStatus(u32* numRings,
                                    wifi_ring_buffer_status* status);
    wifi_error getLoggerSupportedFeatureSet(unsigned int* support);
    wifi_error getRingData(char* ringName);
    wifi_error configureNdOffload(u8 enable);
    wifi_error startPacketFateMonitoring();
    wifi_error getTxPacketFates(wifi_tx_report* txReportBuffers,
                                size_t numRequestedFates,
                                size_t* numProvidedFates);
    wifi_error getRxPacketFates(wifi_rx_report* rxReportBuffers,
                                size_t numRequestedFates,
                                size_t* numProvidedFates);
    wifi_error getPacketFilterCapabilities(u32* version, u32* maxLength);
    wifi_error getWakeReasonStats(WLAN_DRIVER_WAKE_REASON_CNT* wakeReasonCount);
private:
    Interface(const Interface&) = delete;
    Interface& operator=(const Interface&) = delete;

    void onLinkStatsReply(wifi_request_id requestId,
                          wifi_stats_result_handler handler,
                          const NetlinkMessage& reply);

    Netlink& mNetlink;
    std::string mName;
    uint32_t mInterfaceIndex;
};

