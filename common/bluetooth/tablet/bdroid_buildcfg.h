/*
 * Copyright (C) 2012 The Android Open Source Project
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

#ifndef _BDROID_BUILDCFG_H
#define _BDROID_BUILDCFG_H

#define BTM_DEF_LOCAL_NAME "cel-bluetooth"
// Bluetooth Low Power Mode is supported on BT4.0
#define HCILP_INCLUDED                 FALSE

/* Default class of device
* {SERVICE_CLASS, MAJOR_CLASS, MINOR_CLASS}
*
* SERVICE_CLASS:0x1A (Bit17 -Networking,Bit19 - Capturing,Bit20 -Object Transfer)
* MAJOR_CLASS:0x01 - COMPUTER
* MINOR_CLASS:0x1C - TABLET
*/


#define BTA_DM_COD {0x1A, 0x01, 0x1C}

#define PRELOAD_MAX_RETRY_ATTEMPTS 1

#define PRELOAD_START_TIMEOUT_MS 3500

#define BLE_VND_INCLUDED TRUE

#define BTM_SSR_INCLUDED FALSE

#endif
